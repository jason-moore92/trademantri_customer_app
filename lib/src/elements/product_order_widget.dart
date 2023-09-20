import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/helpers/price_functions.dart';

import 'keicy_avatar_image.dart';

class ProductOrderWidget extends StatefulWidget {
  final Map<String, dynamic>? productData;
  final Map<String, dynamic>? orderData;

  ProductOrderWidget({
    @required this.productData,
    @required this.orderData,
  });

  @override
  _ProductOrderWidgetState createState() => _ProductOrderWidgetState();
}

class _ProductOrderWidgetState extends State<ProductOrderWidget> {
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
    if (widget.productData!["images"].runtimeType.toString() == "String") {
      widget.productData!["images"] = json.decode(widget.productData!["images"]);
    }

    return Row(
      children: [
        KeicyAvatarImage(
          url: (widget.productData!["images"] == null || widget.productData!["images"].isEmpty) ? "" : widget.productData!["images"][0],
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
                            "${widget.productData!["name"]}",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          widget.productData!["description"] == null
                              ? SizedBox()
                              : Column(
                                  children: [
                                    SizedBox(height: heightDp * 3),
                                    Text(
                                      "${widget.productData!["description"]}",
                                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                          SizedBox(height: heightDp * 3),
                          Row(
                            mainAxisAlignment: widget.productData!["quantity"] == null || widget.productData!["quantityType"] == null
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.spaceBetween,
                            children: [
                              widget.productData!["quantity"] == null || widget.productData!["quantityType"] == null
                                  ? SizedBox()
                                  : Text(
                                      "${widget.productData!["quantity"]} ${widget.productData!["quantityType"]}",
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
        "Product",
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
                  "${widget.productData!["orderQuantity"]}",
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
      var priceResult = PriceFunctions.getPriceDataForProduct(orderData: widget.orderData!, data: widget.productData!);
      widget.productData!.addAll(priceResult);
    }

    double price = widget.productData!["price"] != null ? double.parse(widget.productData!["price"].toString()) : 0;
    double discount = widget.productData!["discount"] != null ? double.parse(widget.productData!["discount"].toString()) : 0;
    double promocodeDiscount =
        widget.productData!["promocodeDiscount"] != null ? double.parse(widget.productData!["promocodeDiscount"].toString()) : 0;
    double taxPrice = widget.productData!["taxPrice"] != null ? double.parse(widget.productData!["taxPrice"].toString()) : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.productData!["price"] == null
            ? Text(
                "Not set price",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.red, fontWeight: FontWeight.w500),
              )
            : widget.productData!["promocodeDiscount"] == 0 || widget.productData!["promocodeDiscount"] == null
                ? Text(
                    "₹ ${numFormat.format((price - discount) * widget.productData!["orderQuantity"])}",
                    style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹ ${numFormat.format((price - discount - promocodeDiscount) * widget.productData!["orderQuantity"])}",
                        style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: widthDp * 3),
                      Text(
                        "₹ ${numFormat.format((price - discount) * widget.productData!["orderQuantity"])}",
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
        widget.productData!["taxPrice"] == null || widget.productData!["taxPrice"] == 0
            ? SizedBox()
            : Column(
                children: [
                  SizedBox(height: heightDp * 3),
                  Text(
                    "Tax: ₹ ${numFormat.format(taxPrice * widget.productData!["orderQuantity"])}",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                  ),
                ],
              ),
      ],
    );
  }
}
