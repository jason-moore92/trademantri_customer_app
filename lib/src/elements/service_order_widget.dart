import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/helpers/price_functions.dart';

import 'keicy_avatar_image.dart';

class ServiceOrderWidget extends StatefulWidget {
  final Map<String, dynamic>? serviceData;
  final Map<String, dynamic>? orderData;

  ServiceOrderWidget({
    @required this.serviceData,
    @required this.orderData,
  });

  @override
  _ServiceOrderWidgetState createState() => _ServiceOrderWidgetState();
}

class _ServiceOrderWidgetState extends State<ServiceOrderWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  var numFormat = NumberFormat.currency(symbol: "", name: "");

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 0, vertical: heightDp * 5),
      child: _productWidget(),
    );
  }

  Widget _productWidget() {
    if (widget.serviceData!["images"].runtimeType.toString() == "String") {
      widget.serviceData!["images"] = json.decode(widget.serviceData!["images"]);
    }

    return Row(
      children: [
        KeicyAvatarImage(
          url: (widget.serviceData!["images"] == null || widget.serviceData!["images"].isEmpty) ? "" : widget.serviceData!["images"][0],
          width: widthDp * 80,
          height: widthDp * 80,
          backColor: Colors.grey.withOpacity(0.4),
        ),
        SizedBox(width: widthDp * 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.serviceData!["name"]}",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.serviceData!["description"] == null)
                            SizedBox()
                          else
                            Column(
                              children: [
                                SizedBox(height: heightDp * 3),
                                Text(
                                  "${widget.serviceData!["description"]}",
                                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          SizedBox(height: heightDp * 3),
                          Row(
                            mainAxisAlignment: widget.serviceData!["provided"] == null ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
                            children: [
                              widget.serviceData!["provided"] == null
                                  ? SizedBox()
                                  : Text(
                                      "${widget.serviceData!["provided"] ?? ""}",
                                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                                    ),
                              _categoryButton(),
                            ],
                          ),
                          SizedBox(height: heightDp * 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _priceWidget(),
                              _countButton(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(heightDp * 20),
        border: Border.all(color: Colors.blue),
      ),
      child: Text(
        "Service",
        style: TextStyle(fontSize: fontSp * 12, color: Colors.blue),
      ),
    );
  }

  Widget _countButton() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 2),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
            alignment: Alignment.center,
            child: Row(
              children: [
                Text(
                  "Quantity:  ",
                  style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                ),
                Text(
                  "${widget.serviceData!["orderQuantity"]}",
                  style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceWidget() {
    if (widget.orderData!["promocode"] != null &&
        widget.orderData!["promocode"].isNotEmpty &&
        widget.orderData!["promocode"]["promocodeType"].toString().contains("INR")) {
      PriceFunctions.calculateINRPromocodeForOrder(orderData: widget.orderData!);
      var priceResult = PriceFunctions.getPriceDataForProduct(orderData: widget.orderData!, data: widget.serviceData!);
      widget.serviceData!.addAll(priceResult);
    }

    double price = widget.serviceData!["price"] != null ? double.parse(widget.serviceData!["price"].toString()) : 0;
    double discount = widget.serviceData!["discount"] != null ? double.parse(widget.serviceData!["discount"].toString()) : 0;
    double promocodeDiscount =
        widget.serviceData!["promocodeDiscount"] != null ? double.parse(widget.serviceData!["promocodeDiscount"].toString()) : 0;
    double taxPrice = widget.serviceData!["taxPrice"] != null ? double.parse(widget.serviceData!["taxPrice"].toString()) : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.serviceData!["price"] == null
            ? Text(
                "Not set price",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.red, fontWeight: FontWeight.w500),
              )
            : widget.serviceData!["promocodeDiscount"] == 0 || widget.serviceData!["promocodeDiscount"] == null
                ? Text(
                    "₹ ${numFormat.format((price - discount) * widget.serviceData!["orderQuantity"])}",
                    style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹ ${numFormat.format((price - discount - promocodeDiscount) * widget.serviceData!["orderQuantity"])}",
                        style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: widthDp * 3),
                      Text(
                        "₹ ${numFormat.format((price - discount) * widget.serviceData!["orderQuantity"])}",
                        style: TextStyle(
                          fontSize: fontSp * 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 2,
                        ),
                      ),
                    ],
                  ),
        widget.serviceData!["taxPrice"] == null || widget.serviceData!["taxPrice"] == 0
            ? SizedBox()
            : Column(
                children: [
                  SizedBox(height: heightDp * 3),
                  Text(
                    "Tax: ₹ ${numFormat.format(taxPrice * widget.serviceData!["orderQuantity"])}",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                  ),
                ],
              ),
      ],
    );
  }
}
