import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/feedback_dialog.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/OrderDetailNewPage/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/pages/RazorPayPage/index.dart';
import 'package:trapp/src/providers/AuthProvider/auth_provider.dart';

import 'index.dart';

class OrderConfirmationView extends StatefulWidget {
  final OrderModel? orderModel;

  OrderConfirmationView({
    Key? key,
    this.orderModel,
  }) : super(key: key);

  @override
  _OrderConfirmationViewState createState() => _OrderConfirmationViewState();
}

class _OrderConfirmationViewState extends State<OrderConfirmationView> with SingleTickerProviderStateMixin {
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
  ///

  AuthProvider? _authProvider;
  KeicyProgressDialog? _keicyProgressDialog;

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
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    checkAndOpenFeedback();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (widget.orderModel!.status == AppConfig.orderStatusData[2]["id"] &&
          (!widget.orderModel!.payAtStore! && !widget.orderModel!.cashOnDelivery!) &&
          (widget.orderModel!.category == AppConfig.orderCategories["bargain"] ||
              widget.orderModel!.category == AppConfig.orderCategories["reverse_auction"])) {
        Future.delayed(
          Duration(seconds: 3),
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => RazorPayPage(orderModel: widget.orderModel),
              ),
            );
          },
        );
      }
    });
  }

  String prefKey = "on_device_orders";
  checkAndOpenFeedback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> orders = prefs.getStringList(prefKey) ?? [];

    await prefs.setStringList(prefKey, [...orders, widget.orderModel!.orderId!]);

    FlutterLogs.logInfo(
      "order_confirmation_view",
      "feedbackModel",
      _authProvider!.authState.feedbackModel.toString(),
    );
    if (_authProvider!.authState.feedbackModel != null && _authProvider!.authState.feedbackModel!.id != null) {
      return;
    }

    orders = prefs.getStringList(prefKey) ?? [];

    if (orders.length <= 10) {
      await FeedbackDialog.show(
        context,
        ratingValue: _authProvider!.authState.feedbackModel!.ratingValue!,
        feedbackText: _authProvider!.authState.feedbackModel!.feedbackText!,
        callback: _updateFeedback,
      );
    }
  }

  void _updateFeedback(double ratingValue, String feedbackText) async {
    FeedbackModel feedbackModel = FeedbackModel.copy(_authProvider!.authState.feedbackModel!);
    feedbackModel.userId = _authProvider!.authState.userModel!.id;
    feedbackModel.ratingValue = ratingValue;
    feedbackModel.feedbackText = feedbackText;

    await _keicyProgressDialog!.show();

    _authProvider!.setAuthState(
      _authProvider!.authState.update(
        progressState: 1,
        callback: () {
          _updateFeedback(ratingValue, feedbackText);
        },
      ),
      isNotifiable: false,
    );

    if (feedbackModel.id != null) {
      _authProvider!.updateFeedback(feedbackModel: feedbackModel);
    } else {
      _authProvider!.createFeedback(feedbackModel: feedbackModel);
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
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 30),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("img/order_success.png", width: deviceWidth * 0.8, fit: BoxFit.fitWidth),
                          SizedBox(height: heightDp * 30),
                          Text(
                            OrderConfirmationPageString.thanksOrderString.toUpperCase(),
                            style: TextStyle(fontSize: fontSp * 28, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: heightDp * 16),
                          Text(
                            "Order ID: ${widget.orderModel!.orderId}",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: heightDp * 25),
                        ],
                      ),
                    ),
                    if (widget.orderModel!.status == AppConfig.orderStatusData[1]["id"])
                      Text(
                        "*Payment can be made once you receive the notification when the store accepts your order.",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    if (widget.orderModel!.status == AppConfig.orderStatusData[1]["id"]) SizedBox(height: heightDp * 40),
                  ],
                ),
              ),
              Text(
                OrderConfirmationPageString.description,
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: heightDp * 40),
              KeicyRaisedButton(
                width: widthDp * 200,
                height: heightDp * 40,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 6,
                child: Text(
                  OrderConfirmationPageString.viewOrderDetailButton,
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => OrderDetailNewPage(orderModel: widget.orderModel!),
                    ),
                  );
                },
              ),
              SizedBox(height: heightDp * 20),
            ],
          ),
        ),
      ),
    );
  }
}
