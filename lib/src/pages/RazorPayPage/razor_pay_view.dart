import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert';
import 'package:trapp/environment.dart';

class RazorPayView extends StatefulWidget {
  final OrderModel? orderModel;

  RazorPayView({
    Key? key,
    this.orderModel,
  }) : super(key: key);

  @override
  _RazorPayViewState createState() => _RazorPayViewState();
}

class _RazorPayViewState extends State<RazorPayView> {
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

  KeicyProgressDialog? _keicyProgressDialog;

  Razorpay? _razorpay;

  bool _isSuccess = false;
  String? updatedStatus;

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

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      getData();
    });
  }

  Map<String, dynamic> razorPayOptions = {};

  getData() async {
    Map<String, dynamic>? response = await OrderProvider.of(context).paymentDetails(
      provider: "razorpay",
      orderId: widget.orderModel!.id,
      storeId: widget.orderModel!.storeId,
    );

    if (response == null) {
      return;
    }

    razorPayOptions = response["razorPayOptions"];
    setState(() {});
  }

  void _openCheckout() async {
    // try {
    _razorpay!.open(razorPayOptions);
    // } catch (e) {
    //   debugPrint(e.toString());
    // }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // var key = utf8.encode(Environment.razorPayKeySecret);
    // var bytes = utf8.encode("${response.orderId}|${response.paymentId}");

    // Hmac hmacSha256 = Hmac(sha256, key);
    // Digest digest = hmacSha256.convert(bytes);
    // if (digest.toString() == response.signature) {
    _orderPaidCallback(response);
    // } else {
    //   ErrorDialog.show(
    //     context,
    //     widthDp: widthDp,
    //     heightDp: heightDp,
    //     fontSp: fontSp,
    //     isTryButton: false,
    //     text: "Signature failed",
    //     callBack: null,
    //   );
    // }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    String message = response.message == null ? "Something was wrong" : response.message!;
    Map<String, dynamic> errorData = {};

    if (message.characters.startsWith("{".characters)) {
      errorData = jsonDecode(message);
      if (errorData.containsKey("error")) {
        errorData = errorData["error"];
      }
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        isTryButton: false,
        text: errorData["description"],
        callBack: null,
      );

      return;
    }

    ErrorDialog.show(
      context,
      widthDp: widthDp,
      heightDp: heightDp,
      fontSp: fontSp,
      isTryButton: false,
      text: message,
      callBack: null,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    SuccessDialog.show(
      context,
      heightDp: heightDp,
      fontSp: fontSp,
      text: "SUCCESS: " + response.walletName!,
    );
  }

  void _orderPaidCallback(PaymentSuccessResponse response) async {
    await _keicyProgressDialog!.show();

    OrderModel orderModel = OrderModel.copy(widget.orderModel!);
    orderModel.paymentApiData!["orderId"] = razorPayOptions["order_id"];
    orderModel.paymentApiData!["provider"] = "razorpay"; //TODO can be changed if we keep two success urls.
    orderModel.paymentApiData!["paymentId"] = response.paymentId;
    orderModel.paymentApiData!["signature"] = response.signature;

    var result = await OrderProvider.of(context).updateOrderData(
      orderModel: orderModel,
      status: AppConfig.orderStatusData[3]["id"],
      changedStatus: true,
      signature: response.signature ?? "",
    );
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      setState(() {
        updatedStatus = AppConfig.orderStatusData[3]["id"];
        _isSuccess = true;
      });
      PaymentSuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        paymentId: response.paymentId,
        orderId: widget.orderModel!.orderId,
        toPay: widget.orderModel!.paymentDetail!.toPay!.toString(),
        callback: () {
          Navigator.of(context).pop(updatedStatus);
        },
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        isTryButton: false,
        text: "Something was wrong",
        callBack: null,
      );
    }
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
            Navigator.of(context).pop(updatedStatus);
          },
        ),
        title: Text("Razor Pay Detail", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
        elevation: 0,
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order ID: ",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    Text(
                      "${widget.orderModel!.orderId}",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Merchant/Company name :",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    Text(
                      "TradeMantri",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: heightDp * 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Customer Name:",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    Text(
                      "${AuthProvider.of(context).authState.userModel!.firstName} "
                      "${AuthProvider.of(context).authState.userModel!.lastName}",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                AuthProvider.of(context).authState.userModel!.verified!
                    ? Column(
                        children: [
                          SizedBox(height: heightDp * 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Customer Email :",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                              Text(
                                "${AuthProvider.of(context).authState.userModel!.email} ",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      )
                    : SizedBox(),
                AuthProvider.of(context).authState.userModel!.phoneVerified!
                    ? Column(
                        children: [
                          SizedBox(height: heightDp * 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Customer PhoneNumber :",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                              Text(
                                "${AuthProvider.of(context).authState.userModel!.mobile} ",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      )
                    : SizedBox(),
                SizedBox(height: heightDp * 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "To Pay",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    Text(
                      // "₹ ${widget.orderModel!.paymentDetail!.toPay}",
                      "₹ ${widget.orderModel!.paymentDetail!.toPay! - (widget.orderModel!.redeemRewardData!["redeemRewardValue"] ?? 0) - (widget.orderModel!.redeemRewardData!["tradeRedeemRewardValue"] ?? 0)}",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            ),
          ),
          if (_isSuccess)
            SizedBox()
          else
            Padding(
              padding: EdgeInsets.all(heightDp * 20),
              child: Center(
                child: KeicyRaisedButton(
                  width: widthDp * 150,
                  height: heightDp * 35,
                  color: razorPayOptions.isNotEmpty ? config.Colors().mainColor(1) : config.Colors().mainColor(0.3),
                  borderRadius: heightDp * 6,
                  child: Text("Pay", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
                  onPressed: razorPayOptions.isNotEmpty ? _openCheckout : null,
                ),
              ),
            ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay!.clear();
    super.dispose();
  }
}
