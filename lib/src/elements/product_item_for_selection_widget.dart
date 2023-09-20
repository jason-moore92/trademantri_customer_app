import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/CartProvider/cart_provider.dart';
import 'package:trapp/src/providers/index.dart';

import 'keicy_avatar_image.dart';

class ProductItemForSelectionWidget extends StatefulWidget {
  final ProductModel? productModel;
  final EdgeInsetsGeometry? padding;
  final bool? isLoading;
  final bool? isSelected;
  final bool showBargainAvailable;

  ProductItemForSelectionWidget({
    @required this.productModel,
    this.padding,
    this.isSelected = false,
    this.isLoading = true,
    this.showBargainAvailable = true,
  });

  @override
  _ProductItemForSelectionWidgetState createState() => _ProductItemForSelectionWidgetState();
}

class _ProductItemForSelectionWidgetState extends State<ProductItemForSelectionWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
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
      padding: widget.padding ?? EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
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
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "price asfasdf",
                  style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: heightDp * 5),
              Container(
                color: Colors.white,
                child: Text(
                  "price asff",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _productWidget() {
    List<dynamic> cartData = (_cartProvider!.cartState.cartData![widget.productModel!.storeId] == null ||
            _cartProvider!.cartState.cartData![widget.productModel!.storeId]["products"] == null)
        ? []
        : _cartProvider!.cartState.cartData![widget.productModel!.storeId]["products"];

    isAdded = false;
    selectedCount = 0;
    for (var i = 0; i < cartData.length; i++) {
      if (cartData[i]["data"]["_id"] == widget.productModel!.id) {
        isAdded = true;
        selectedCount = cartData[i]["orderQuantity"];
        break;
      }
    }

    return Row(
      children: [
        Stack(
          children: [
            KeicyAvatarImage(
              url: (widget.productModel!.images!.isEmpty) ? "" : widget.productModel!.images![0],
              width: widthDp * 80,
              height: widthDp * 80,
              imageFile: widget.productModel!.imageFile,
              backColor: Colors.grey.withOpacity(0.4),
            ),
            widget.productModel!.isAvailable != null && !widget.productModel!.isAvailable!
                ? Image.asset("img/unavailable.png", width: widthDp * 60, fit: BoxFit.fitWidth)
                : SizedBox(),
            widget.isSelected!
                ? Positioned(
                    child: Image.asset("img/check_icon.png", width: heightDp * 30, height: heightDp * 30, fit: BoxFit.cover),
                  )
                : SizedBox(),
          ],
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
                            "${widget.productModel!.name}",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.productModel!.description != "")
                            Column(
                              children: [
                                SizedBox(height: heightDp * 5),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${widget.productModel!.description}",
                                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          SizedBox(height: heightDp * 5),
                          // _categoryButton()
                          widget.productModel!.showPriceToUsers != null && !widget.productModel!.showPriceToUsers!
                              ? _disablePriceDiaplayWidget()
                              : widget.productModel!.price != null
                                  ? _priceWidget()
                                  : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightDp * 5),
              Wrap(
                spacing: widthDp * 10,
                runSpacing: heightDp * 5,
                children: [
                  (widget.productModel!.bargainAvailable != null && widget.productModel!.bargainAvailable! && widget.showBargainAvailable)
                      ? _availableBargainWidget()
                      : SizedBox(),
                  widget.productModel!.acceptBulkOrder != null && widget.productModel!.acceptBulkOrder! ? _availableBulkOrder() : SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ],
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
        widget.productModel!.discount == null || widget.productModel!.discount == 0
            ? Text(
                "₹ ${numFormat.format(double.parse(widget.productModel!.price.toString()))}",
                style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "₹ ${numFormat.format(double.parse(widget.productModel!.price.toString()) - double.parse(widget.productModel!.discount.toString()))}",
                        style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: widthDp * 10),
                      Text(
                        "₹ ${numFormat.format(double.parse(widget.productModel!.price.toString()))}",
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
                  SizedBox(height: heightDp * 5),
                  Text(
                    "Saved ₹ ${numFormat.format(double.parse(widget.productModel!.discount.toString()))}",
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
}
