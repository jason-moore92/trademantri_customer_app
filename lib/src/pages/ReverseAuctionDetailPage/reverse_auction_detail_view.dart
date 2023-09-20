import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/qrcode_widget.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/encrypt.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/CheckOutPage/checkout_page.dart';
import 'package:trapp/src/pages/ReverseAuctionStoreList/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class ReverseAuctionDetailView extends StatefulWidget {
  ReverseAuctionDetailView({
    Key? key,
    this.reverseAuctionData,
  }) : super(key: key);

  Map<String, dynamic>? reverseAuctionData;

  @override
  _ReverseAuctionDetailViewState createState() => _ReverseAuctionDetailViewState();
}

class _ReverseAuctionDetailViewState extends State<ReverseAuctionDetailView> {
  /// Responsive design variables
  double deviceWidth = 0;
  double appbarHeight = 0;
  double bottomBarHeight = 0;
  double deviceHeight = 0;
  double fontSp = 0;
  double widthDp = 0;
  double heightDp = 0;
  double statusbarHeight = 0;
  List<String> storeIdList = [];
  ///////////////////////////////

  AuthProvider? _authProvider;
  KeicyProgressDialog? _keicyProgressDialog;
  Map<String, dynamic>? _reverseAuctionData;
  ReverseAuctionProvider? _reverseAuctionProvider;

  String _reverseAuctionStatus = "";
  List<dynamic> _storeData = [];
  String? _updatedOrderStatus;

  @override
  void dispose() {
    super.dispose();
  }

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

    _reverseAuctionProvider = ReverseAuctionProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _reverseAuctionData = json.decode(json.encode(widget.reverseAuctionData));
  }

  void _cancelHandler() async {
    Map<String, dynamic> newReverseAuctionData = json.decode(json.encode(_reverseAuctionData));

    await _keicyProgressDialog!.show();
    var result = await _reverseAuctionProvider!.updateReverseAuctionData(
      reverseAuctionData: newReverseAuctionData,
      status: AppConfig.reverseAuctionStatusData[3]["id"],
      storeName: "Store Name 1",
      userName: "${AuthProvider.of(context).authState.userModel!.firstName} ${AuthProvider.of(context).authState.userModel!.lastName}",
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      newReverseAuctionData["status"] = AppConfig.reverseAuctionStatusData[3]["id"];
      _updatedOrderStatus = AppConfig.reverseAuctionStatusData[3]["id"];
      _reverseAuctionData = newReverseAuctionData;
      setState(() {});
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "This Auction was cancelled",
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _cancelHandler();
        },
      );
    }
  }

  void _acceptHandler(double storeBiddingPrice, Map<String, dynamic> storeData) async {
    Map<String, dynamic> newReverseAuctionData = json.decode(json.encode(_reverseAuctionData));

    newReverseAuctionData["offerPrice"] = storeBiddingPrice;

    OrderModel orderModel = OrderModel.fromJson(newReverseAuctionData);
    orderModel.storeModel = StoreModel.fromJson(storeData);
    orderModel.category = AppConfig.orderCategories["reverse_auction"];
    if (orderModel.products!.isNotEmpty) {
      orderModel.products!.first.orderPrice = storeBiddingPrice;
    }
    if (orderModel.services!.isNotEmpty) {
      orderModel.services!.first.orderPrice = storeBiddingPrice;
    }

    var result1 = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => CheckoutPage(orderModel: orderModel),
      ),
    );

    if (result1 != null && result1) {
      newReverseAuctionData["acceptedStoreId"] = storeData["_id"];
      var result = await _reverseAuctionProvider!.updateReverseAuctionData(
        reverseAuctionData: newReverseAuctionData,
        status: AppConfig.reverseAuctionStatusData[4]["id"],
        storeName: storeData["name"],
        userName: "${_authProvider!.authState.userModel!.firstName} ${_authProvider!.authState.userModel!.lastName}",
      );
      if (result["success"]) {
        newReverseAuctionData["status"] = AppConfig.reverseAuctionStatusData[4]["id"];
        _updatedOrderStatus = AppConfig.reverseAuctionStatusData[4]["id"];
        _reverseAuctionData = newReverseAuctionData;
        setState(() {});
        SuccessDialog.show(
          context,
          heightDp: heightDp,
          fontSp: fontSp,
          text: "This Auction was accepted",
        );
      } else {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: result["message"],
          callBack: () {
            _cancelHandler();
          },
        );
      }
    }
  }

  void _changeEndDateHandler(Map<String, dynamic> newReverseAuctionData) async {
    await _keicyProgressDialog!.show();
    var result = await _reverseAuctionProvider!.updateReverseAuctionData(
      reverseAuctionData: newReverseAuctionData,
      status: "change_end_date",
      storeName: "Store Name 1",
      userName: "${AuthProvider.of(context).authState.userModel!.firstName} ${AuthProvider.of(context).authState.userModel!.lastName}",
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      newReverseAuctionData["status"] = newReverseAuctionData["status"];
      _updatedOrderStatus = newReverseAuctionData["status"];
      _reverseAuctionData = newReverseAuctionData;
      setState(() {});
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "End date was changed",
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _cancelHandler();
        },
      );
    }
  }

  Widget _mainPanel() {
    for (var i = 0; i < AppConfig.reverseAuctionStatusData.length; i++) {
      if (AppConfig.reverseAuctionStatusData[i]["id"] == _reverseAuctionData!["status"]) {
        _reverseAuctionStatus = AppConfig.reverseAuctionStatusData[i]["name"];
        break;
      }
    }
    if ((DateTime.tryParse(_reverseAuctionData!['biddingEndDateTime'])!.toLocal()).isBefore(DateTime.now())) {
      _reverseAuctionStatus = "Auction ended";
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Column(
                children: [
                  ///
                  Text(
                    "${_reverseAuctionData!["reverseAuctionId"]}",
                    style: TextStyle(fontSize: fontSp * 21, color: Colors.black),
                  ),

                  ///
                  SizedBox(height: heightDp * 5),
                  QrCodeWidget(
                    code: Encrypt.encryptString(
                      "ReverseAuction_${_reverseAuctionData!["reverseAuctionId"]}"
                      "_UserId-${_reverseAuctionData!["userId"]}",
                    ),
                    size: heightDp * 150,
                  ),

                  ///
                  Divider(height: heightDp * 20, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  CartListPanel(reverseAuctionData: _reverseAuctionData),

                  ///
                  Divider(height: 20, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  _offerPanel(),

                  Divider(height: 20, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                ],
              ),
            ),
            _storeListPanel(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Column(
                children: [
                  if (_reverseAuctionStatus == AppConfig.reverseAuctionStatusData[1]["name"] ||
                      _reverseAuctionStatus == AppConfig.reverseAuctionStatusData[2]["name"])
                    Column(
                      children: [
                        SizedBox(height: heightDp * 20),
                        _placeBidButtonGrop(),
                      ],
                    )
                  else
                    SizedBox(),
                  SizedBox(height: heightDp * 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _offerPanel() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Auction Status:",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Text(
              _reverseAuctionStatus,
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(height: heightDp * 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Auction Start Date:",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Text(
              KeicyDateTime.convertDateTimeToDateString(
                dateTime: DateTime.tryParse(_reverseAuctionData!['biddingStartDateTime']),
                formats: 'Y-m-d h:i A',
                isUTC: false,
              ),
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(height: heightDp * 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Auction End Date:",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Text(
              KeicyDateTime.convertDateTimeToDateString(
                dateTime: DateTime.tryParse(_reverseAuctionData!['biddingEndDateTime']),
                formats: 'Y-m-d h:i A',
                isUTC: false,
              ),
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(height: heightDp * 20),
        Text(
          "User Offer Price Per Quantity",
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: heightDp * 5),
        Text(
          "₹ ${_reverseAuctionData!["biddingPrice"]}",
          style: TextStyle(fontSize: fontSp * 35, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: heightDp * 20),
        Row(
          children: [
            Text(
              "Message:",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "${_reverseAuctionData!["messages"][0]["text"]}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        SizedBox(height: heightDp * 5),
      ],
    );
  }

  Widget _storeListPanel() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Seller Bidding List",
                style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              ),
              _storeData.isEmpty
                  ? SizedBox()
                  : KeicyRaisedButton(
                      width: widthDp * 100,
                      height: heightDp * 35,
                      color: config.Colors().mainColor(1),
                      borderRadius: heightDp * 8,
                      child: Text("Show All", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
                      onPressed: () async {
                        var result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => ReverseAuctionStoreListPage(
                              reverseAuctionData: _reverseAuctionData,
                              reverseAuctionId: _reverseAuctionData!["_id"],
                              storeIdList: storeIdList.join(","),
                              acceptHandler: _acceptHandler,
                            ),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            _reverseAuctionData!["status"] = result;
                            _updatedOrderStatus = result;
                          });
                        }
                      },
                    ),
            ],
          ),
        ),
        SizedBox(height: heightDp * 10),
        _storeData.isEmpty
            ? Padding(
                padding: EdgeInsets.all(heightDp * 20),
                child: Text("No Bidding Store", style: TextStyle(fontSize: fontSp * 16)),
              )
            : Column(
                children: List.generate(_storeData.length, (index) {
                  return StorePanel(
                    storeData: _storeData[index],
                    acceptHandler: _acceptHandler,
                    status: _reverseAuctionData!["status"],
                    loadingStatus: false,
                  );
                }),
              ),
      ],
    );
  }

  Widget _placeBidButtonGrop() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            KeicyRaisedButton(
              width: widthDp * 140,
              height: heightDp * 35,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 6,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Change End Date",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                _selectPickupDateTimeHandler("biddingEnd");
              },
            ),
            KeicyRaisedButton(
              width: widthDp * 140,
              height: heightDp * 35,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 6,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                NormalAskDialog.show(
                  context,
                  title: "Reverse Auction Cancel",
                  content: "Do you want to cancel this reverse aucton?",
                  callback: _cancelHandler,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  void _selectPickupDateTimeHandler(String type) async {
    Map<String, dynamic> newReverseAuctionData = json.decode(json.encode(_reverseAuctionData));

    DateTime? selecteDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3, 1).subtract(Duration(days: 1)),
      selectableDayPredicate: (date) {
        if (date.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) return false;
        if (date.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day))) return false;
        return true;
      },
    );
    if (selecteDate == null) return;

    TimeOfDay? time = await showCustomTimePicker(
      context: context,
      onFailValidation: (context) => FlutterLogs.logWarn(
        "reverse_auction_detail_view",
        "_selectPickupDateTimeHandler",
        "Unavailable selection",
      ),
      initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
    );

    if (time == null) return;
    selecteDate = selecteDate.add(Duration(hours: time.hour, minutes: time.minute));
    setState(() {
      if (!selecteDate!.isUtc) selecteDate = selecteDate!.toUtc();

      if (type == "biddingStart") {
        newReverseAuctionData["biddingStartDateTime"] = selecteDate!.toUtc().toIso8601String();
      } else if (type == "biddingEnd") {
        newReverseAuctionData["biddingEndDateTime"] = selecteDate!.toUtc().toIso8601String();
      }
      _changeEndDateHandler(newReverseAuctionData);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_reverseAuctionData!["storeBiddingPriceList"] != null) {
      _reverseAuctionData!["storeBiddingPriceList"].forEach((key, value) {
        storeIdList.add(key);
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
          onPressed: () {
            Navigator.of(context).pop(_updatedOrderStatus);
          },
        ),
        centerTitle: true,
        title: Text("Reverse Auction Detail", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
        elevation: 0,
      ),
      body: StreamBuilder<dynamic>(
        stream: Stream.fromFuture(
          ReverseAuctionApiProvider.getAuctionStoreData(
            reverseAuctionId: _reverseAuctionData!["_id"],
            storeIdList: storeIdList.join(","),
            page: 1,
            limit: 3,
          ),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CupertinoActivityIndicator());

          if (!snapshot.data["success"]) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(widthDp * 20),
                child: Text(
                  snapshot.data["message"],
                  style: TextStyle(fontSize: fontSp * 16),
                ),
              ),
            );
          }

          _storeData = [];

          if (snapshot.data["data"] != null) {
            for (var i = 0; i < snapshot.data["data"]["docs"].length; i++) {
              _storeData.add(snapshot.data["data"]["docs"][i]["store"]);

              _storeData[i]["biddingDate"] = snapshot.data["data"]["docs"][i]["createdAt"];
              _storeData[i]["storeBiddingPrice"] = double.parse(snapshot.data["data"]["docs"][i]["offerPrice"]);
              _storeData[i]["storeBiddingMessage"] = snapshot.data["data"]["docs"][i]["message"];
            }
          }

          return Container(
            width: deviceWidth,
            height: deviceHeight,
            child: _mainPanel(),
          );
        },
      ),
    );
  }
}
