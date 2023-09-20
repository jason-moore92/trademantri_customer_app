import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:printing/printing.dart';
import 'package:share/share.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/ask_payment_mode.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';

import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/order_status_steps_widget.dart';
import 'package:trapp/src/elements/payment_detail_panel.dart';
import 'package:trapp/src/elements/print_widget.dart';
import 'package:trapp/src/elements/qrcode_widget.dart';
import 'package:trapp/src/elements/store_info_panel.dart';

import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/encrypt.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/models/order_model.dart';
import 'package:trapp/src/pages/CheckOutPage/index.dart';
import 'package:trapp/src/pages/RazorPayPage/index.dart';
import 'package:trapp/src/pages/UPIPayPage/index.dart';

import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/keicy_checkbox.dart';
import 'package:url_launcher/url_launcher.dart';

import 'index.dart';

class OrderDetailView extends StatefulWidget {
  final OrderModel? orderModel;
  final String? scratchStatus;

  OrderDetailView({
    Key? key,
    this.orderModel,
    this.scratchStatus,
  }) : super(key: key);

  @override
  _OrderDetailViewState createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
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
  OrderProvider? _orderProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  String? updatedOrderStatus;

  OrderModel? _orderModel;

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
    _orderProvider = OrderProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _orderModel = OrderModel.copy(widget.orderModel!);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      // if (_orderModel!.status == AppConfig.orderStatusData.last["id"] &&
      //     widget.scratchStatus == "scratch_card_create" &&
      //     widget.orderModel.scratchCard != null &&
      //     widget.orderModel.scratchCard.isNotEmpty &&
      //     widget.orderModel.scratchCard[0].status == "not_scratched") {
      //   ScratchCardDialog.show(
      //     context,
      //     scratchCardData: _orderModel!.scratchCard[0],
      //     callback: _scratchCardHadler,
      //   );
      // }
    });
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
        title: Text("Order Details", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
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
    String orderStatus = "";
    for (var i = 0; i < AppConfig.orderStatusData.length; i++) {
      if (_orderModel!.status == AppConfig.orderStatusData[i]["id"]) {
        orderStatus = AppConfig.orderStatusData[i]["name"];
        break;
      }
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
              child: Text(
                "${_orderModel!.orderId}",
                style: TextStyle(fontSize: fontSp * 23, color: Colors.black),
              ),
            ),

            ///
            SizedBox(height: heightDp * 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: QrCodeWidget(
                code: Encrypt.encryptString(
                  "Order_${_orderModel!.orderId}_StoreId-${_orderModel!.storeModel!.id}_UserId-${_orderModel!.userModel!.id}",
                ),
                size: heightDp * 150,
              ),
            ),

            ///
            SizedBox(height: heightDp * 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (await canLaunch(_orderModel!.invoicePdfUrl!)) {
                        await launch(
                          _orderModel!.invoicePdfUrl!,
                          forceSafariVC: false,
                          forceWebView: false,
                        );
                      } else {
                        throw 'Could not launch ${_orderModel!.invoicePdfUrl}';
                      }
                    },
                    child: Image.asset("img/pdf-icon.png", width: heightDp * 40, height: heightDp * 40, fit: BoxFit.cover),
                  ),
                  SizedBox(width: widthDp * 30),
                  GestureDetector(
                    onTap: () {
                      Share.share(_orderModel!.invoicePdfUrl!);
                    },
                    child: Image.asset(
                      "img/share-icon.png",
                      width: heightDp * 40,
                      height: heightDp * 40,
                      fit: BoxFit.cover,
                      color: config.Colors().mainColor(1),
                    ),
                  ),
                  SizedBox(width: widthDp * 30),
                  PrintWidget(
                    path: _orderModel!.invoicePdfUrl,
                    size: heightDp * 50,
                    color: config.Colors().mainColor(1),
                  ),
                  if (_orderModel!.status == AppConfig.orderStatusData.last["id"] &&
                      _orderModel!.scratchCard != null &&
                      _orderModel!.scratchCard!.isNotEmpty &&
                      _orderModel!.scratchCard![0]["status"] == "not_scratched")
                    Row(
                      children: [
                        SizedBox(width: widthDp * 30),
                        KeicyRaisedButton(
                          width: widthDp * 130,
                          height: heightDp * 40,
                          borderRadius: heightDp * 8,
                          color: config.Colors().mainColor(1),
                          child: Text("Scratch Card", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
                          onPressed: () async {
                            await ScratchCardDialog.show(
                              context,
                              scratchCardId: _orderModel!.scratchCard![0]["_id"],
                              callback: (Map<String, dynamic> scratchCardData) {
                                _orderModel!.scratchCard![0] = scratchCardData;
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),

            if (_orderModel!.orderHistorySteps!.isNotEmpty || _orderModel!.orderFutureSteps!.isNotEmpty)
              Column(
                children: [
                  SizedBox(height: heightDp * 15),
                  OrderStatusStepsWidget(orderModel: _orderModel),
                ],
              ),

            ///
            SizedBox(height: heightDp * 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: StoreInfoPanel(storeModel: _orderModel!.storeModel),
            ),

            ///
            SizedBox(height: heightDp * 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: CartListPanel(orderModel: _orderModel),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
            ),

            SizedBox(height: heightDp * 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ordered date: ",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    KeicyDateTime.convertDateTimeToDateString(
                      dateTime: _orderModel!.createdAt!,
                      formats: "Y-m-d H:i",
                      isUTC: false,
                    ),
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                ],
              ),
            ),

            SizedBox(height: heightDp * 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
            ),
            SizedBox(height: heightDp * 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Updated date: ",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    KeicyDateTime.convertDateTimeToDateString(
                      dateTime: _orderModel!.updatedAt!,
                      formats: "Y-m-d H:i",
                      isUTC: false,
                    ),
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                ],
              ),
            ),

            SizedBox(height: heightDp * 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
            ),

            ///
            if (_orderModel!.instructions != "")
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Column(
                  children: [
                    SizedBox(height: heightDp * 10),
                    Container(
                      width: deviceWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.event_note, size: heightDp * 25, color: Colors.black.withOpacity(0.7)),
                              SizedBox(width: widthDp * 10),
                              Text(
                                "Instruction",
                                style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(height: heightDp * 5),
                          Text(
                            _orderModel!.instructions!,
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: heightDp * 10),
                    Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ],
                ),
              ),

            ///
            if (_orderModel!.promocode != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Column(
                  children: [
                    SizedBox(height: heightDp * 10),
                    Container(
                      width: deviceWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Promo code: ",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            _orderModel!.promocode!.promocodeCode!,
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: heightDp * 10),
                    Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ],
                ),
              ),

            ///
            SizedBox(height: heightDp * 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order Status: ",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    orderStatus,
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            if (_orderModel!.reasonForCancelOrReject != "" &&
                (_orderModel!.status == AppConfig.orderStatusData[7]["id"] || _orderModel!.status == AppConfig.orderStatusData[8]["id"]))
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Column(
                  children: [
                    SizedBox(height: heightDp * 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _orderModel!.status == AppConfig.orderStatusData[7]["id"] ? "Cancel Reason:" : "Reject Reason: ",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: widthDp * 10),
                        Expanded(
                          child: Text(
                            "${_orderModel!.reasonForCancelOrReject}",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            SizedBox(height: heightDp * 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
            ),

            ///
            if (_orderModel!.products!.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Column(
                  children: [
                    SizedBox(height: heightDp * 10),
                    Container(
                      width: deviceWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order Type: ",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            _orderModel!.orderType!,
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: heightDp * 10),
                    Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ],
                ),
              ),

            ///
            _orderModel!.products == null ||
                    _orderModel!.products!.isEmpty ||
                    _orderModel!.orderType != "Pickup" ||
                    _orderModel!.pickupDateTime == null
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                    child: Column(
                      children: [
                        SizedBox(height: heightDp * 10),
                        Container(
                          width: deviceWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Pickup Date:",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                KeicyDateTime.convertDateTimeToDateString(
                                  dateTime: _orderModel!.pickupDateTime,
                                  formats: 'Y-m-d',
                                  isUTC: false,
                                ),
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: heightDp * 10),
                        Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                      ],
                    ),
                  ),

            ///
            _orderModel!.products == null ||
                    _orderModel!.products!.isEmpty ||
                    _orderModel!.orderType != "Delivery" ||
                    _orderModel!.deliveryAddress == null
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                    child: Column(
                      children: [
                        SizedBox(height: heightDp * 10),
                        Container(
                          width: deviceWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delivery Address:",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: heightDp * 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${_orderModel!.deliveryAddress!.addressType}",
                                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(width: widthDp * 10),
                                      Text(
                                        "${(_orderModel!.deliveryAddress!.distance! / 1000).toStringAsFixed(3)} Km",
                                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: heightDp * 5),
                                  if (_orderModel!.deliveryAddress!.building != "")
                                    Column(
                                      children: [
                                        Text(
                                          "${_orderModel!.deliveryAddress!.building}",
                                          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: heightDp * 5),
                                      ],
                                    ),
                                  Text(
                                    "${_orderModel!.deliveryAddress!.address!.address}",
                                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: heightDp * 10),
                                  KeicyCheckBox(
                                    iconSize: heightDp * 25,
                                    iconColor: Color(0xFF00D18F),
                                    labelSpacing: widthDp * 20,
                                    label: "No Contact Delivery",
                                    labelStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                                    value: _orderModel!.noContactDelivery!,
                                    readOnly: true,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: heightDp * 10),
                        Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                      ],
                    ),
                  ),

            ///
            if (_orderModel!.services!.isEmpty && _orderModel!.serviceDateTime != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Column(
                  children: [
                    SizedBox(height: heightDp * 10),
                    Container(
                      width: deviceWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Service Date:",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            KeicyDateTime.convertDateTimeToDateString(
                              dateTime: _orderModel!.serviceDateTime,
                              formats: 'Y-m-d h:i A',
                              isUTC: false,
                            ),
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: heightDp * 10),
                    Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ],
                ),
              ),

            //////
            SizedBox(height: heightDp * 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: PaymentDetailPanel(orderModel: _orderModel, padding: EdgeInsets.zero),
            ),

            ///
            SizedBox(height: heightDp * 10),
            if (AppConfig.orderStatusData[1]["id"] == _orderModel!.status)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: _placeOrderActionButtonGroup(),
              )
            else if (AppConfig.orderStatusData[2]["id"] == _orderModel!.status)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: _acceptOrderActionButtonGroup(),
              )
            else if (AppConfig.orderStatusData[4]["id"] == _orderModel!.status || AppConfig.orderStatusData[5]["id"] == _orderModel!.status)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: _otherButtonGroup(),
              )
            else if (AppConfig.orderStatusData[9]["id"] == _orderModel!.status)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: _completedButtonGroup(),
              ),

            ///
            SizedBox(height: heightDp * 20),
          ],
        ),
      ),
    );
  }

  Widget _placeOrderActionButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        KeicyRaisedButton(
          width: widthDp * 130,
          height: heightDp * 30,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Cancel Order",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: () {
            _cancelCallback(_orderModel);
          },
        ),
      ],
    );
  }

  Widget _acceptOrderActionButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (!_orderModel!.payAtStore! && !_orderModel!.cashOnDelivery! && !_orderModel!.payStatus!)
          KeicyRaisedButton(
            width: widthDp * 130,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              "Pay Order",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
            ),
            onPressed: () {
              _payCallback(_orderModel);
            },
          ),
        KeicyRaisedButton(
          width: widthDp * 130,
          height: heightDp * 30,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Cancel Order",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: () {
            _cancelCallback(_orderModel);
          },
        ),
      ],
    );
  }

  Widget _otherButtonGroup() {
    return (!_orderModel!.payStatus! && (!_orderModel!.payAtStore! && !_orderModel!.cashOnDelivery!))
        ? KeicyRaisedButton(
            width: widthDp * 130,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              "Pay Order",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
            ),
            onPressed: () {
              _payCallback(_orderModel);
            },
          )
        : SizedBox();
  }

  Widget _completedButtonGroup() {
    return KeicyRaisedButton(
      width: widthDp * 130,
      height: heightDp * 35,
      color: config.Colors().mainColor(1),
      borderRadius: heightDp * 8,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
      child: Text(
        "Repeat Order",
        style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
      ),
      onPressed: _repeateOrderHandler,
    );
  }

  void _cancelCallback(OrderModel? orderModel) {
    ReasonDialog.show(
      context,
      tilte: "Order Cancel",
      content: "Do you want to cancel this order?",
      callback: (reason) async {
        await _keicyProgressDialog!.show();

        OrderModel newOrderModel = OrderModel.copy(orderModel!);
        newOrderModel.reasonForCancelOrReject = reason;

        var result = await _orderProvider!.updateOrderData(
          orderModel: newOrderModel,
          status: AppConfig.orderStatusData[7]["id"],
          changedStatus: false,
        );
        await _keicyProgressDialog!.hide();

        if (result["success"]) {
          _orderModel = OrderModel.fromJson(result["data"]);
          _orderModel!.userModel = widget.orderModel!.userModel;
          _orderModel!.storeModel = widget.orderModel!.storeModel;

          _orderModel!.status = AppConfig.orderStatusData[7]["id"];
          updatedOrderStatus = AppConfig.orderStatusData[7]["id"];
          setState(() {});
          SuccessDialog.show(
            context,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "The order is cancelled",
          );
        } else {
          ErrorDialog.show(
            context,
            widthDp: widthDp,
            heightDp: heightDp,
            fontSp: fontSp,
            text: result["message"],
            callBack: () {
              _cancelCallback(orderModel);
            },
          );
        }
      },
    );
  }

  void _payCallback(OrderModel? orderModel) async {
    String? selectedPaymentMethod = await AskPaymentMode.show(context: context);

    if (selectedPaymentMethod == null) {
      return;
    }

    if (selectedPaymentMethod == "razorpay") {
      var result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => RazorPayPage(orderModel: orderModel),
        ),
      );

      if (result != null) {
        orderModel!.status = result;
        _orderModel = OrderModel.copy(orderModel);
        _orderModel!.userModel = widget.orderModel!.userModel;
        _orderModel!.storeModel = widget.orderModel!.storeModel;

        _orderModel!.status = AppConfig.orderStatusData[3]["id"];
        updatedOrderStatus = AppConfig.orderStatusData[3]["id"];
        setState(() {});
      }
    }

    if (selectedPaymentMethod == "icici_upi") {
      var result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => UPIPayPage(orderModel: orderModel),
        ),
      );

      if (result != null) {
        orderModel!.status = result;
        _orderModel = OrderModel.copy(orderModel);
        _orderModel!.userModel = widget.orderModel!.userModel;
        _orderModel!.storeModel = widget.orderModel!.storeModel;

        _orderModel!.status = AppConfig.orderStatusData[3]["id"];
        updatedOrderStatus = AppConfig.orderStatusData[3]["id"];
        setState(() {});
      }
    }
  }

  void _repeateOrderHandler() async {
    List<dynamic> products = [];
    List<dynamic> services = [];

    await _keicyProgressDialog!.show();
    bool isChanged = false;
    for (var i = 0; i < _orderModel!.products!.length; i++) {
      var result = await ProductApiProvider.getProduct(id: _orderModel!.products![i].productModel!.id);
      if (result["success"] && result["data"]["listonline"].toString() == "true" && result["data"]["isAvailable"].toString() == "true") {
        ProductModel productModel = ProductModel.fromJson(result["data"]);
        products.add({
          "orderQuantity": _orderModel!.products![i].orderQuantity,
          "data": result["data"],
        });
        if (productModel.price != _orderModel!.products![i].productModel!.price ||
            productModel.discount != _orderModel!.products![i].productModel!.discount) {
          isChanged = true;
        }
      } else {
        isChanged = true;
      }
    }
    for (var i = 0; i < _orderModel!.services!.length; i++) {
      var result = await ServiceApiProvider.getService(id: _orderModel!.services![i].serviceModel!.id);
      if (result["success"] && result["data"]["listonline"].toString() == "true" && result["data"]["isAvailable"].toString() == "true") {
        ServiceModel serviceModel = ServiceModel.fromJson(result["data"]);
        services.add({
          "orderQuantity": _orderModel!.services![i].orderQuantity,
          "data": result["data"],
        });
        if (serviceModel.price != _orderModel!.services![i].serviceModel!.price ||
            serviceModel.discount != _orderModel!.services![i].serviceModel!.discount) {
          isChanged = true;
        }
      } else {
        isChanged = true;
      }
    }
    await _keicyProgressDialog!.hide();

    if (products.isEmpty && services.isEmpty) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "All the products and services in your previous order are not available in the store. You won’t be able to repeat this order.",
      );
      return;
    }

    OrderModel orderModel = OrderModel.fromJson({
      "products": products,
      "services": services,
      "category": AppConfig.orderCategories["cart"],
      "store": _orderModel!.storeModel,
    });

    if (isChanged) {
      NormalAskDialog.show(
        context,
        title: "Repeat Order",
        content:
            "The availability and the prices of the products and services are updated based on latest available from the store. Please check.\n\nDo you want to repeat this order?",
        callback: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => CheckoutPage(orderModel: orderModel),
            ),
          );
        },
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => CheckoutPage(orderModel: orderModel),
        ),
      );
    }
  }
}
