import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/providers/CartProvider/cart_provider.dart';
import 'package:trapp/src/providers/index.dart';
import 'keicy_avatar_image.dart';

class ProductForCartsWidget extends StatefulWidget {
  final Map<String, dynamic>? productData;
  final Map<String, dynamic>? storeData;
  final bool? isLoading;
  final Function? tapCallback;

  ProductForCartsWidget({
    @required this.productData,
    @required this.storeData,
    this.isLoading = true,
    this.tapCallback,
  });

  @override
  _ProductForCartsWidgetState createState() => _ProductForCartsWidgetState();
}

class _ProductForCartsWidgetState extends State<ProductForCartsWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  bool? isAdded;
  int? selectedCount;

  CartProvider? _cartProvider;

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
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    _cartProvider = CartProvider.of(context);

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
      child: widget.isLoading! ? _shimmerWidget() : _productWidget(),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.isLoading!,
      period: Duration(milliseconds: 1000),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: widthDp * 80,
                height: widthDp * 80,
                color: Colors.white,
              ),
              SizedBox(width: widthDp * 15),
              Container(
                height: widthDp * 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "product name",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "10 unites",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "price",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: widthDp * 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(heightDp * 20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "ADD",
                    style: TextStyle(fontSize: fontSp * 14, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _productWidget() {
    List<dynamic> cartData = (_cartProvider!.cartState.cartData![widget.productData!["storeId"]] == null ||
            _cartProvider!.cartState.cartData![widget.productData!["storeId"]]["products"] == null)
        ? []
        : _cartProvider!.cartState.cartData![widget.productData!["storeId"]]["products"];

    isAdded = false;
    selectedCount = 0;
    for (var i = 0; i < cartData.length; i++) {
      if (cartData[i]["data"]["_id"] == widget.productData!["_id"]) {
        isAdded = true;
        selectedCount = cartData[i]["orderQuantity"];
        break;
      }
    }

    if (widget.productData!["images"].runtimeType.toString() == "String") {
      widget.productData!["images"] = json.decode(widget.productData!["images"]);
    }

    if (widget.productData!["isAvailable"].runtimeType.toString() == "String") {
      widget.productData!["isAvailable"] = widget.productData!["isAvailable"] == "true" ? true : false;
    }

    if (widget.productData!["showPriceToUsers"].runtimeType.toString() == "String") {
      widget.productData!["showPriceToUsers"] = widget.productData!["showPriceToUsers"] == "true" ? true : false;
    }

    if (widget.productData!["showPriceToUsers"].runtimeType.toString() == "String") {
      widget.productData!["showPriceToUsers"] = widget.productData!["showPriceToUsers"] == "true" ? true : false;
    }

    return GestureDetector(
      onTap: () {
        if (widget.tapCallback != null) widget.tapCallback!();
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Stack(
              children: [
                KeicyAvatarImage(
                  url: (widget.productData!["images"] == null || widget.productData!["images"].isEmpty) ? "" : widget.productData!["images"][0],
                  width: widthDp * 80,
                  height: widthDp * 80,
                  backColor: Colors.grey.withOpacity(0.4),
                ),
                !widget.productData!["isAvailable"] ? Image.asset("img/unavailable.png", width: widthDp * 60, fit: BoxFit.fitWidth) : SizedBox(),
              ],
            ),
            SizedBox(width: widthDp * 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${widget.productData!["name"]}",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: widthDp * 5),
                      _categoryButton(),
                    ],
                  ),
                  if (widget.productData!["description"] == null)
                    SizedBox()
                  else
                    Column(
                      children: [
                        SizedBox(height: heightDp * 3),
                        Text(
                          "${widget.productData!["description"]}",
                          style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  SizedBox(height: heightDp * 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.productData!["quantity"] == null || widget.productData!["quantityType"] == null
                          ? SizedBox()
                          : Text(
                              "${widget.productData!["quantity"]} ${widget.productData!["quantityType"]}",
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                            ),
                      _countButton(),
                    ],
                  ),
                  // widget.type == "cart" ? _categoryButton() : SizedBox(),
                  SizedBox(width: widthDp * 8),
                  SizedBox(height: heightDp * 5),
                  !widget.productData!["showPriceToUsers"] ? _disablePriceDiaplayWidget() : _priceWidget(),
                  SizedBox(height: heightDp * 5),
                  Wrap(
                    spacing: widthDp * 10,
                    runSpacing: heightDp * 5,
                    children: [
                      widget.productData!["bargainAvailable"] ? _availableBargainWidget() : SizedBox(),
                      widget.productData!["acceptBulkOrder"] ? _availableBulkOrder() : SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 3),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 3),
            // decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
            alignment: Alignment.center,
            child: Row(
              children: [
                Text(
                  "Quantity:  ",
                  style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                ),
                Text(
                  "$selectedCount",
                  style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _disablePriceDiaplayWidget() {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: widthDp * 5,
            right: widthDp * 2,
            bottom: heightDp * 5,
            top: heightDp * 5,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFF8C888),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(heightDp * 4),
              bottomLeft: Radius.circular(heightDp * 4),
            ),
          ),
          child: Icon(Icons.remove_moderator, size: widthDp * 12, color: Colors.black),
        ),
        Container(
          padding: EdgeInsets.only(
            left: widthDp * 2,
            right: widthDp * 5,
            bottom: heightDp * 5,
            top: heightDp * 5,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFF8C888),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(heightDp * 4),
              bottomRight: Radius.circular(heightDp * 4),
            ),
          ),
          child: Text(
            "Price Disabled By Store Owner",
            style: TextStyle(fontSize: fontSp * 10, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _priceWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.productData!["discount"] == null || widget.productData!["discount"] == 0
            ? Text(
                "₹ ${numFormat.format(double.parse(widget.productData!["price"].toString()))}",
                style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "₹ ${numFormat.format(double.parse(widget.productData!["price"].toString()) - double.parse(widget.productData!["discount"].toString()))}",
                        style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: widthDp * 10),
                      Text(
                        "₹ ${numFormat.format(double.parse(widget.productData!["price"].toString()))}",
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
                  Text(
                    "Saved ₹ ${numFormat.format(double.parse(widget.productData!["discount"].toString()))}",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
        Text(
          "* Inclusive of all taxes",
          style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
        ),
      ],
    );
  }

  Widget _availableBargainWidget() {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: widthDp * 5,
            right: widthDp * 2,
            bottom: heightDp * 5,
            top: heightDp * 5,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFE7F16E),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(heightDp * 4),
              bottomLeft: Radius.circular(heightDp * 4),
            ),
          ),
          child: Icon(Icons.star, size: widthDp * 12, color: Colors.black),
        ),
        Container(
          padding: EdgeInsets.only(
            left: widthDp * 2,
            right: widthDp * 5,
            bottom: heightDp * 5,
            top: heightDp * 5,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFE7F16E),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(heightDp * 4),
              bottomRight: Radius.circular(heightDp * 4),
            ),
          ),
          child: Text(
            "Bargain Available",
            style: TextStyle(fontSize: fontSp * 10, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _availableBulkOrder() {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: widthDp * 5,
            right: widthDp * 2,
            bottom: heightDp * 5,
            top: heightDp * 5,
          ),
          decoration: BoxDecoration(
            color: Color(0xFF6EF174),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(heightDp * 4),
              bottomLeft: Radius.circular(heightDp * 4),
            ),
          ),
          child: Icon(Icons.star, size: widthDp * 12, color: Colors.black),
        ),
        Container(
          padding: EdgeInsets.only(
            left: widthDp * 2,
            right: widthDp * 5,
            bottom: heightDp * 5,
            top: heightDp * 5,
          ),
          decoration: BoxDecoration(
            color: Color(0xFF6EF174),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(heightDp * 4),
              bottomRight: Radius.circular(heightDp * 4),
            ),
          ),
          child: Text(
            "Bulk Order Available",
            style: TextStyle(fontSize: fontSp * 10, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
