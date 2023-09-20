import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/elements/keicy_checkbox.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/product_item_for_selection_widget.dart';
import 'package:trapp/src/elements/service_item_for_selection_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/PaymentPage/payment_page.dart';

class PaymentLinkDetailView extends StatefulWidget {
  final Map<String, dynamic>? paymentLinkData;

  PaymentLinkDetailView({Key? key, this.paymentLinkData}) : super(key: key);

  @override
  _PaymentLinkDetailViewState createState() => _PaymentLinkDetailViewState();
}

class _PaymentLinkDetailViewState extends State<PaymentLinkDetailView> with SingleTickerProviderStateMixin {
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

  var numFormat = NumberFormat.currency(symbol: "", name: "");

  Map<String, dynamic>? _paymentLinkData;
  bool _isUpdated = false;

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

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    _isUpdated = false;

    _paymentLinkData = json.decode(json.encode(widget.paymentLinkData));

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalItems = 0;
    double totalPrice = 0;

    for (var i = 0; i < _paymentLinkData!["products"].length; i++) {
      totalItems += _paymentLinkData!["products"][i]["orderQuantity"];
      totalPrice += double.parse(_paymentLinkData!["products"][i]["price"].toString()) -
          (_paymentLinkData!["products"][i]["discount"] != null && _paymentLinkData!["products"][i]["discount"] != ""
              ? double.parse(_paymentLinkData!["products"][i]["discount"].toString())
              : 0);
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_isUpdated);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop(_isUpdated);
            },
          ),
          centerTitle: true,
          title: Text(
            "Payment Link Details",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
          elevation: 0,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return false;
          },
          child: SingleChildScrollView(
            child: Container(
              width: deviceWidth,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
              child: Column(
                children: [
                  ///
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 8),
                    decoration: BoxDecoration(
                      // color: config.Colors().mainColor(1),
                      color: _paymentLinkData!["paymentData"]["status"].toString().toLowerCase() == "paid" ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(heightDp * 6),
                    ),
                    child: Text(
                      _paymentLinkData!["paymentData"]["status"].toString().toLowerCase() == "paid" ? "Paid" : "Not Paid",
                      // StringHelper.getUpperCaseString(_paymentLinkData!["paymentData"]["status"].toString()),
                      style: TextStyle(
                        fontSize: fontSp * 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  ///
                  SizedBox(height: heightDp * 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Payment ID : ",
                          style: TextStyle(
                            fontSize: fontSp * 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "${_paymentLinkData!["paymentData"]["id"]}",
                          style: TextStyle(
                            fontSize: fontSp * 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///
                  SizedBox(height: heightDp * 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Store : ",
                          style: TextStyle(
                            fontSize: fontSp * 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "${_paymentLinkData!["store"]["name"]}",
                          style: TextStyle(
                            fontSize: fontSp * 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///
                  SizedBox(height: heightDp * 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Store Email : ",
                          style: TextStyle(
                            fontSize: fontSp * 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "${_paymentLinkData!["store"]["email"]}",
                          style: TextStyle(
                            fontSize: fontSp * 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///
                  SizedBox(height: heightDp * 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Store Phone : ",
                          style: TextStyle(
                            fontSize: fontSp * 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "${_paymentLinkData!["store"]["mobile"]}",
                          style: TextStyle(
                            fontSize: fontSp * 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///
                  SizedBox(height: heightDp * 20),
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),

                  ///
                  SizedBox(height: heightDp * 20),
                  Row(
                    children: [
                      Text(
                        "Products & Services",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: heightDp * 20),
                  Column(
                    children: List.generate(
                      _paymentLinkData!["products"].length,
                      (index) {
                        return ProductItemForSelectionWidget(
                          productModel: ProductModel.fromJson(_paymentLinkData!["products"][index]),
                          isLoading: _paymentLinkData!["products"][index].isEmpty,
                        );
                      },
                    ),
                  ),
                  Column(
                    children: List.generate(
                      _paymentLinkData!["services"].length,
                      (index) {
                        return ServiceItemForSelectionWidget(
                          serviceModel: ServiceModel.fromJson(_paymentLinkData!["services"][index]),
                          isLoading: _paymentLinkData!["services"][index].isEmpty,
                        );
                      },
                    ),
                  ),

                  ///
                  SizedBox(height: heightDp * 20),
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  SizedBox(height: heightDp * 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KeicyCheckBox(
                        iconSize: heightDp * 25,
                        label: "Reminder Enable",
                        iconColor: config.Colors().mainColor(1),
                        value: _paymentLinkData!["paymentData"]["reminder_enable"],
                        readOnly: true,
                        labelSpacing: widthDp * 5,
                        labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      ),
                    ],
                  ),

                  ///
                  SizedBox(height: heightDp * 20),
                  Row(
                    children: [
                      KeicyCheckBox(
                        iconSize: heightDp * 25,
                        label: "Accept Partial",
                        iconColor: config.Colors().mainColor(1),
                        value: _paymentLinkData!["paymentData"]["accept_partial"],
                        readOnly: true,
                        labelSpacing: widthDp * 5,
                        labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      ),
                      SizedBox(width: widthDp * 15),
                      _paymentLinkData!["paymentData"]["accept_partial"]
                          ? Expanded(
                              child: Text(
                                "${_paymentLinkData!["paymentData"]["first_min_partial_amount"]}",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),

                  ///
                  if (_paymentLinkData!["paymentData"]["description"] != null && _paymentLinkData!["paymentData"]["description"] != "")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: heightDp * 20),
                        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                        SizedBox(height: heightDp * 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description : ",
                              style: TextStyle(
                                fontSize: fontSp * 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: heightDp * 5),
                            Text(
                              "${_paymentLinkData!["paymentData"]["description"]}",
                              style: TextStyle(
                                fontSize: fontSp * 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  ///
                  if (_paymentLinkData!["paymentData"]["notes"] != null && _paymentLinkData!["paymentData"]["notes"].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: heightDp * 20),
                        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                        SizedBox(height: heightDp * 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${_paymentLinkData!["paymentData"]["notes"].keys.first} : ",
                              style: TextStyle(
                                fontSize: fontSp * 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: heightDp * 5),
                            Text(
                              "${_paymentLinkData!["paymentData"]["notes"].values.first}",
                              style: TextStyle(
                                fontSize: fontSp * 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  ///
                  SizedBox(height: heightDp * 20),
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  SizedBox(height: heightDp * 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Total Items: ",
                          style: TextStyle(
                            fontSize: fontSp * 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          numFormat.format(totalItems),
                          style: TextStyle(
                            fontSize: fontSp * 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: heightDp * 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Total Price: ",
                          style: TextStyle(
                            fontSize: fontSp * 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          numFormat.format(_paymentLinkData!["paymentData"]["amount"] / 100),
                          style: TextStyle(
                            fontSize: fontSp * 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (_paymentLinkData!["paymentData"]["status"].toString().toLowerCase() != "paid")
                    Column(
                      children: [
                        SizedBox(height: heightDp * 20),
                        KeicyRaisedButton(
                          width: widthDp * 150,
                          height: heightDp * 35,
                          color: config.Colors().mainColor(1),
                          borderRadius: heightDp * 6,
                          child: Text(
                            "Pay Now",
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                          ),
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => PaymentPage(
                                  paymentLink: _paymentLinkData!["paymentData"]["short_url"],
                                ),
                              ),
                            );
                            await _keicyProgressDialog!.show();

                            var result = await PaymentLinkApiProvider.getPaymentData(
                              id: _paymentLinkData!["paymentData"]["id"],
                              paymentLinkId: _paymentLinkData!["_id"],
                              status: _paymentLinkData!["paymentData"]["status"],
                            );
                            await _keicyProgressDialog!.hide();

                            if (result["success"]) {
                              _paymentLinkData!["paymentData"] = result["data"];
                            }

                            if (_paymentLinkData!["paymentData"]["status"] == "paid") {
                              _isUpdated = true;
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    ),

                  SizedBox(height: heightDp * 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
