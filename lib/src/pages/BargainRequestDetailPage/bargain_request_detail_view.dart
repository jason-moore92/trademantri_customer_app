import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';

import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/qrcode_widget.dart';
import 'package:trapp/src/elements/store_info_panel.dart';

import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/encrypt.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/CheckOutPage/checkout_page.dart';

import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class BargainRequestDetailView extends StatefulWidget {
  final BargainRequestModel? bargainRequestModel;

  BargainRequestDetailView({Key? key, this.bargainRequestModel}) : super(key: key);

  @override
  _BargainRequestDetailViewState createState() => _BargainRequestDetailViewState();
}

class _BargainRequestDetailViewState extends State<BargainRequestDetailView> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  AuthProvider? _authProvider;
  BargainRequestProvider? _bargainRequestProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  String? updatedOrderStatus;

  BargainRequestModel? bargainRequestModel;

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    _authProvider = AuthProvider.of(context);
    _bargainRequestProvider = BargainRequestProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    bargainRequestModel = BargainRequestModel.copy(widget.bargainRequestModel!);

    if (bargainRequestModel!.storeModel!.settings == null) {
      bargainRequestModel!.storeModel!.settings = AppConfig.initialSettings;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
          onPressed: () {
            Navigator.of(context).pop(updatedOrderStatus);
          },
        ),
        title: Text("Bargain Detail", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
        elevation: 0,
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: _mainPanel(),
      ),
    );
  }

  Widget _mainPanel() {
    double originPrice = 0;

    if (widget.bargainRequestModel!.products!.isNotEmpty && widget.bargainRequestModel!.products![0].productModel!.price != null) {
      originPrice = widget.bargainRequestModel!.products![0].productModel!.price! - widget.bargainRequestModel!.products![0].productModel!.discount!;
    } else if (widget.bargainRequestModel!.services!.isNotEmpty && widget.bargainRequestModel!.services![0].serviceModel!.price != null) {
      originPrice = widget.bargainRequestModel!.services![0].serviceModel!.price! - widget.bargainRequestModel!.services![0].serviceModel!.discount!;
    }

    String bargainRequestStatus = "";
    if (bargainRequestModel!.status != bargainRequestModel!.subStatus) {
      for (var i = 0; i < AppConfig.bargainSubStatusData.length; i++) {
        if (AppConfig.bargainSubStatusData[i]["id"] == bargainRequestModel!.subStatus) {
          bargainRequestStatus = AppConfig.bargainSubStatusData[i]["name"];
          break;
        }
      }
    } else {
      for (var i = 0; i < AppConfig.bargainRequestStatusData.length; i++) {
        if (AppConfig.bargainRequestStatusData[i]["id"] == bargainRequestModel!.status) {
          bargainRequestStatus = AppConfig.bargainRequestStatusData[i]["name"];
          break;
        }
      }
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
          child: Column(
            children: [
              Text(
                "${bargainRequestModel!.bargainRequestId}",
                style: TextStyle(fontSize: fontSp * 23, color: Colors.black),
              ),

              ///
              SizedBox(height: heightDp * 5),
              QrCodeWidget(
                code: Encrypt.encryptString(
                  "BargainRequest_${bargainRequestModel!.bargainRequestId}"
                  "_StoreId-${bargainRequestModel!.storeModel!.id}"
                  "_UserId-${_authProvider!.authState.userModel!.id}",
                ),
                size: heightDp * 150,
              ),

              SizedBox(height: heightDp * 15),
              StoreInfoPanel(storeModel: bargainRequestModel!.storeModel),

              ///
              SizedBox(height: heightDp * 15),
              CartListPanel(bargainRequestModel: bargainRequestModel),
              Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),

              ///
              SizedBox(height: heightDp * 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bargain Request Status:   ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    bargainRequestStatus,
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              SizedBox(height: heightDp * 15),
              Text("Offer Price Per Quantity", style: TextStyle(fontSize: fontSp * 26, color: Colors.black)),
              SizedBox(height: heightDp * 10),
              Text(
                "₹ ${bargainRequestModel!.offerPrice}",
                style: TextStyle(fontSize: fontSp * 33, color: Colors.black),
              ),
              SizedBox(height: heightDp * 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("original Price", style: TextStyle(fontSize: fontSp * 20, color: Colors.black)),
                      SizedBox(height: heightDp * 5),
                      Text(
                        originPrice == 0 ? "" : "₹ $originPrice",
                        style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Redution Price", style: TextStyle(fontSize: fontSp * 20, color: Colors.black)),
                      SizedBox(height: heightDp * 5),
                      Text(
                        originPrice == 0 ? "" : "₹ ${originPrice - bargainRequestModel!.offerPrice!}",
                        style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),

              ///
              SizedBox(height: heightDp * 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bargain Date:  ", style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500)),
                  Text(
                    KeicyDateTime.convertDateTimeToDateString(
                      dateTime: bargainRequestModel!.bargainDateTime,
                      formats: 'Y-m-d h:i A',
                      isUTC: false,
                    ),
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                ],
              ),

              ///
              SizedBox(height: heightDp * 20),
              if (AppConfig.bargainRequestStatusData[1]["id"] == bargainRequestModel!.status)
                _userOfferButtonGroup()
              else if (AppConfig.bargainRequestStatusData[2]["id"] == bargainRequestModel!.status)
                _storeOfferButtonGroup()
              else if (AppConfig.bargainRequestStatusData[3]["id"] == bargainRequestModel!.status)
                _acceptStatusButtonGroup()
              else
                SizedBox(),

              ///
              SizedBox(height: heightDp * 10),
              Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),

              ///
              SizedBox(height: heightDp * 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Messages", style: TextStyle(fontSize: fontSp * 20, color: Colors.black)),
                  if (bargainRequestModel!.status == AppConfig.bargainRequestStatusData[3]["id"] ||
                      bargainRequestModel!.status == AppConfig.bargainRequestStatusData[4]["id"] ||
                      bargainRequestModel!.status == AppConfig.bargainRequestStatusData[5]["id"] ||
                      bargainRequestModel!.status == AppConfig.bargainRequestStatusData[6]["id"])
                    SizedBox()
                  else
                    KeicyRaisedButton(
                      width: widthDp * 120,
                      height: heightDp * 35,
                      color: config.Colors().mainColor(1),
                      borderRadius: heightDp * 6,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                      child: Text("New message", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
                      onPressed: () {
                        NewMessageDialog.show(
                          context,
                          widthDp: widthDp,
                          heightDp: heightDp,
                          fontSp: fontSp,
                          callBack: (messsage) {
                            _newMessageCallback(BargainRequestModel.copy(bargainRequestModel!), messsage);
                          },
                        );
                      },
                    ),
                ],
              ),
              SizedBox(height: heightDp * 20),
              Column(
                children: List.generate(bargainRequestModel!.messages!.length, (index) {
                  return Row(
                    mainAxisAlignment: bargainRequestModel!.messages![index]["senderId"] == _authProvider!.authState.userModel!.id
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: bargainRequestModel!.messages![index]["senderId"] == _authProvider!.authState.userModel!.id
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: widthDp * 150),
                            margin: EdgeInsets.symmetric(vertical: heightDp * 7),
                            padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                            decoration: BoxDecoration(
                              color: bargainRequestModel!.messages![index]["senderId"] == _authProvider!.authState.userModel!.id
                                  ? config.Colors().mainColor(0.4)
                                  : Colors.grey.withOpacity(0.4),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  bargainRequestModel!.messages![index]["senderId"] == _authProvider!.authState.userModel!.id ? 0 : heightDp * 6,
                                ),
                                topRight: Radius.circular(
                                  bargainRequestModel!.messages![index]["senderId"] != _authProvider!.authState.userModel!.id ? 0 : heightDp * 6,
                                ),
                                bottomLeft: Radius.circular(heightDp * 6),
                                bottomRight: Radius.circular(heightDp * 6),
                              ),
                            ),
                            child: Text(
                              bargainRequestModel!.messages![index]["text"],
                              style: TextStyle(fontSize: fontSp * 17, color: Colors.black),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }),
              ),

              ///
              SizedBox(height: heightDp * 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userOfferButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        KeicyRaisedButton(
          width: widthDp * 135,
          height: heightDp * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: () {
            NormalAskDialog.show(
              context,
              title: "BargainRequest Cancel",
              content: "Do you want to cancel this bargain request?",
              callback: () async {
                _cancelCallback(BargainRequestModel.copy(bargainRequestModel!));
              },
            );
          },
        ),
      ],
    );
  }

  Widget _storeOfferButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        KeicyRaisedButton(
          width: widthDp * 130,
          height: heightDp * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Offer Counter",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: () async {
            await CounterDialog.show(
              context,
              bargainRequestModel: BargainRequestModel.copy(bargainRequestModel!),
              storeModel: bargainRequestModel!.storeModel,
              widthDp: widthDp,
              heightDp: heightDp,
              fontSp: fontSp,
              callBack: (BargainRequestModel? bargainRequestModel) {
                _counterOfferCallback(bargainRequestModel);
              },
            );
          },
        ),
        KeicyRaisedButton(
          width: widthDp * 110,
          height: heightDp * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Complete",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: () {
            NormalAskDialog.show(
              context,
              title: "BargainRequest complete",
              content: "Do you want to complete this bargain request?",
              callback: () async {
                _completeCallback(BargainRequestModel.copy(bargainRequestModel!));
              },
            );
          },
        ),
        KeicyRaisedButton(
          width: widthDp * 110,
          height: heightDp * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: () {
            NormalAskDialog.show(
              context,
              title: "BargainRequest Cancel",
              content: "Do you want to cancel this bargain request?",
              callback: () async {
                _cancelCallback(BargainRequestModel.copy(bargainRequestModel!));
              },
            );
          },
        ),
      ],
    );
  }

  Widget _acceptStatusButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        KeicyRaisedButton(
          width: widthDp * 135,
          height: heightDp * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Complete",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: () {
            NormalAskDialog.show(
              context,
              title: "BargainRequest complete",
              content: "Do you want to complete this bargain request?",
              callback: () async {
                _completeCallback(BargainRequestModel.copy(bargainRequestModel!));
              },
            );
          },
        ),
        KeicyRaisedButton(
          width: widthDp * 135,
          height: heightDp * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: () {
            NormalAskDialog.show(
              context,
              title: "BargainRequest Cancel",
              content: "Do you want to cancel this bargain request?",
              callback: () async {
                _cancelCallback(BargainRequestModel.copy(bargainRequestModel!));
              },
            );
          },
        ),
      ],
    );
  }

  void _counterOfferCallback(BargainRequestModel? bargainRequestModel) async {
    bargainRequestModel!.history!.add({
      "title": AppConfig.bargainHistoryData["user_counter_offer"]["title"],
      "text": AppConfig.bargainHistoryData["user_counter_offer"]["text"],
      "bargainType": AppConfig.bargainRequestStatusData[1]["id"],
      "date": DateTime.now().toUtc().toIso8601String(),
      "initialPrice": bargainRequestModel.history!.first["initialPrice"],
      "offerPrice": bargainRequestModel.offerPrice,
    });

    await _keicyProgressDialog!.show();
    bargainRequestModel.userModel = _authProvider!.authState.userModel;
    List<dynamic> tmp = [];
    for (var i = 0; i < bargainRequestModel.userOfferPriceList!.length; i++) {
      tmp.add(bargainRequestModel.userOfferPriceList![i]);
    }
    tmp.add(bargainRequestModel.offerPrice);
    bargainRequestModel.userOfferPriceList = tmp;
    var result = await _bargainRequestProvider!.updateBargainRequestData(
      bargainRequestModel: bargainRequestModel,
      status: AppConfig.bargainRequestStatusData[1]["id"],
      subStatus: AppConfig.bargainSubStatusData[1]["id"],
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      bargainRequestModel.status = AppConfig.bargainRequestStatusData[1]["id"];
      bargainRequestModel.subStatus = AppConfig.bargainSubStatusData[1]["id"];
      updatedOrderStatus = AppConfig.bargainRequestStatusData[1]["id"];
      bargainRequestModel = bargainRequestModel;
      setState(() {});
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "This BargainRequest is countered offer",
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _counterOfferCallback(bargainRequestModel);
        },
      );
    }
  }

  void _newMessageCallback(BargainRequestModel? bargainRequestModel, String newMessage) async {
    bargainRequestModel!.messages!.add({
      "text": newMessage,
      "senderId": bargainRequestModel.userModel!.id,
      "date": DateTime.now().toUtc().toIso8601String(),
    });

    await _keicyProgressDialog!.show();
    bargainRequestModel.userModel = _authProvider!.authState.userModel;
    var result = await _bargainRequestProvider!.updateBargainRequestData(
      bargainRequestModel: bargainRequestModel,
      status: "customer_new_message",
      subStatus: "customer_new_message",
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      bargainRequestModel = bargainRequestModel;
      setState(() {});
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _newMessageCallback(bargainRequestModel, newMessage);
        },
      );
    }
  }

  void _cancelCallback(BargainRequestModel? bargainRequestModel) async {
    bargainRequestModel!.history!.add({
      "title": AppConfig.bargainHistoryData["cancelled"]["title"],
      "text": AppConfig.bargainHistoryData["cancelled"]["text"],
      "bargainType": AppConfig.bargainRequestStatusData[6]["id"],
      "date": DateTime.now().toUtc().toIso8601String(),
      "initialPrice": bargainRequestModel.history!.first["initialPrice"],
      "offerPrice": bargainRequestModel.offerPrice,
    });

    await _keicyProgressDialog!.show();
    bargainRequestModel.userModel = _authProvider!.authState.userModel;
    var result = await _bargainRequestProvider!.updateBargainRequestData(
      bargainRequestModel: bargainRequestModel,
      status: AppConfig.bargainRequestStatusData[6]["id"],
      subStatus: AppConfig.bargainRequestStatusData[6]["id"],
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      bargainRequestModel.status = AppConfig.bargainRequestStatusData[6]["id"];
      bargainRequestModel.subStatus = AppConfig.bargainRequestStatusData[6]["id"];
      updatedOrderStatus = AppConfig.bargainRequestStatusData[6]["id"];
      bargainRequestModel = bargainRequestModel;
      setState(() {});
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "This BargainRequest is cancelled",
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _cancelCallback(bargainRequestModel);
        },
      );
    }
  }

  void _completeCallback(BargainRequestModel? bargainRequestModel) async {
    OrderModel orderModel = OrderModel.fromJson(bargainRequestModel!.toJson());
    orderModel.storeModel = bargainRequestModel.storeModel;
    orderModel.category = AppConfig.orderCategories["bargain"];

    if (orderModel.products!.isNotEmpty) {
      orderModel.products!.first.orderPrice = bargainRequestModel.offerPrice;
    }
    if (orderModel.services!.isNotEmpty) {
      orderModel.services!.first.orderPrice = bargainRequestModel.offerPrice;
    }

    var result1 = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => CheckoutPage(orderModel: orderModel),
      ),
    );

    if (result1 != null && result1) {
      bargainRequestModel.history!.add({
        "title": AppConfig.bargainHistoryData["completed"]["title"],
        "text": AppConfig.bargainHistoryData["completed"]["text"],
        "bargainType": AppConfig.bargainRequestStatusData[4]["id"],
        "date": DateTime.now().toUtc().toIso8601String(),
        "initialPrice": bargainRequestModel.history!.first["initialPrice"],
        "offerPrice": bargainRequestModel.offerPrice,
      });

      await _keicyProgressDialog!.show();
      bargainRequestModel.userModel = _authProvider!.authState.userModel;
      var result = await _bargainRequestProvider!.updateBargainRequestData(
        bargainRequestModel: bargainRequestModel,
        status: AppConfig.bargainRequestStatusData[4]["id"],
        subStatus: AppConfig.bargainRequestStatusData[4]["id"],
      );
      await _keicyProgressDialog!.hide();
      if (result["success"]) {
        bargainRequestModel.status = AppConfig.bargainRequestStatusData[4]["id"];
        bargainRequestModel.subStatus = AppConfig.bargainRequestStatusData[4]["id"];
        updatedOrderStatus = AppConfig.bargainRequestStatusData[4]["id"];
        bargainRequestModel = bargainRequestModel;
        setState(() {});
        SuccessDialog.show(
          context,
          heightDp: heightDp,
          fontSp: fontSp,
          text: "This BargainRequest is completed",
        );
      } else {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: result["message"],
          callBack: () {
            _completeCallback(bargainRequestModel);
          },
        );
      }
    }
  }
}
