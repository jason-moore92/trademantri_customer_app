import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/qrcode_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'dart:convert';
import 'package:trapp/environment.dart';
import 'package:upi_pay/upi_pay.dart';

class UPIPayView extends StatefulWidget {
  final OrderModel? orderModel;
  final String? tab;

  UPIPayView({
    Key? key,
    this.orderModel,
    this.tab,
  }) : super(key: key);

  @override
  _UPIPayViewState createState() => _UPIPayViewState();
}

class _UPIPayViewState extends State<UPIPayView> {
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

  String? updatedStatus;

  List<Map<String, dynamic>> tabs = [
    {
      "name": "Apps",
      "value": "apps",
    },
    {
      "name": "QRCode",
      "value": "qr_code",
    },
  ];

  String selectedTab = "apps";

  String? intent;

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
    if (widget.tab != null) {
      selectedTab = widget.tab!;
    } else {
      selectedTab = tabs[0]["value"];
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      getData();
    });
  }

  getData() async {
    Map<String, dynamic>? response = await OrderProvider.of(context).paymentDetails(
      provider: "icici_upi",
      orderId: widget.orderModel!.id,
      storeId: widget.orderModel!.storeId,
    );

    if (response == null) {
      return;
    }

    intent = response["intent"];
    setState(() {});
  }

  Map<String, dynamic> parseIntent(String intent) {
    Uri parsedUrl = Uri.parse(intent);
    Map<String, String> data = parsedUrl.queryParameters;
    return data;
  }

  _initiateTransaction(ApplicationMeta app) async {
    if (Environment.envName != "production") {
      Fluttertoast.showToast(msg: "UPI method will not working in QA as of now.");
      return;
    }

    Map<String, dynamic> upiOptions = parseIntent(intent!);

    final UpiTransactionResponse response = await UpiPay.initiateTransaction(
      amount: upiOptions["am"],
      app: app.upiApplication,
      receiverName: upiOptions["pn"],
      receiverUpiAddress: upiOptions["pa"],
      transactionRef: upiOptions["tr"],
      transactionNote: upiOptions["tn"],
      url: upiOptions["url"],
    );
    FlutterLogs.logInfo(
      "upi_pay_view",
      "_initiateTransaction",
      response.toString(),
    );
    _orderPaidCallback(response);
  }

  void _orderPaidCallback(UpiTransactionResponse response) async {
    if (response.status != UpiTransactionStatus.success) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        isTryButton: false,
        text: "UPI Response Status: ${response.status} and Code: ${response.responseCode}",
        callBack: null,
      );
      return;
    }

    await _keicyProgressDialog!.show();

    Map<String, dynamic> upiOptions = parseIntent(intent!);

    var result = await OrderProvider.of(context).payment(
      upiResponse: {},
      provider: "icici_upi",
      orderId: widget.orderModel!.id,
      storeId: widget.orderModel!.storeId,
    );
    await _keicyProgressDialog!.hide();

    if (result == null) {
      return;
    }

    if (result["success"]) {
      setState(() {
        updatedStatus = AppConfig.orderStatusData[3]["id"];
      });
      PaymentSuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        paymentId: response.txnId,
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
        text: result["message"],
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
        title: Text("Pay with UPI", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
        elevation: 0,
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            Row(
              children: tabs
                  .map(
                    (e) => tabButton(e),
                  )
                  .toList(),
            ),
            if (selectedTab == "apps")
              Expanded(
                child: FutureBuilder<List<ApplicationMeta>>(
                  future: UpiPay.getInstalledUpiApplications(
                    statusType: UpiApplicationDiscoveryAppStatusType.all,
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text("Loading . . ."),
                      );
                    }
                    List<ApplicationMeta>? appMetaList = snapshot.data;
                    if (appMetaList == null) {
                      return Center(
                        child: Text("No upi apps installed."),
                      );
                    }
                    if (appMetaList.length == 0) {
                      return Center(
                        child: Text("No upi apps installed."),
                      );
                    }
                    return ListView.builder(
                      itemCount: appMetaList.length,
                      itemBuilder: (context, index) {
                        ApplicationMeta app = appMetaList[index];

                        return ListTile(
                          leading: app.iconImage(48),
                          title: Text(app.upiApplication.getAppName()),
                          onTap: () {
                            _initiateTransaction(app);
                          },
                          subtitle: Text(app.upiApplication.discoveryCustomScheme!),
                        );
                      },
                    );
                  },
                ),
              ),
            if (selectedTab == "qr_code")
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (intent == null)
                      Center(
                        child: Text("Loading. . . "),
                      ),
                    if (intent != null) ...[
                      QrImage(
                        data: intent!,
                        version: QrVersions.auto,
                        size: 250,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        "Scan this QR code with any payment app.",
                        style: TextStyle(fontSize: fontSp * 18),
                      )
                    ]
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget tabButton(Map<String, dynamic> tab) {
    return Expanded(
      child: Center(
        child: KeicyRaisedButton(
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          color: selectedTab == tab["value"] ? config.Colors().mainColor(1) : Colors.white,
          width: widthDp * 130,
          height: heightDp * 30,
          borderColor: config.Colors().mainColor(1),
          borderWidth: 2.0,
          child: Text(
            tab["name"],
            style: TextStyle(
              fontSize: fontSp * 14,
              color: selectedTab == tab["value"] ? Colors.white : config.Colors().mainColor(1),
            ),
          ),
          onPressed: () {
            selectedTab = tab["value"];
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
