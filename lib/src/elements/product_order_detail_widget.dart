import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/models/index.dart';

import 'keicy_avatar_image.dart';

class ProductOrderDetailWidget extends StatefulWidget {
  final ProductOrderModel? productOrderModel;

  ProductOrderDetailWidget({@required this.productOrderModel});

  @override
  _ProductOrderDetailWidgetState createState() => _ProductOrderDetailWidgetState();
}

class _ProductOrderDetailWidgetState extends State<ProductOrderDetailWidget> {
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
    return Row(
      children: [
        KeicyAvatarImage(
          url: (widget.productOrderModel!.productModel!.images!.isEmpty) ? "" : widget.productOrderModel!.productModel!.images![0],
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
                            "${widget.productOrderModel!.productModel!.name}",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.productOrderModel!.productModel!.description != "")
                            Column(
                              children: [
                                SizedBox(height: heightDp * 3),
                                Text(
                                  "${widget.productOrderModel!.productModel!.description}",
                                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          SizedBox(height: heightDp * 3),
                          Row(
                            mainAxisAlignment: widget.productOrderModel!.productModel!.quantity == null ||
                                    widget.productOrderModel!.productModel!.quantityType == null
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.spaceBetween,
                            children: [
                              if (widget.productOrderModel!.productModel!.quantity == null ||
                                  widget.productOrderModel!.productModel!.quantityType == null)
                                Text(
                                  "${widget.productOrderModel!.productModel!.quantity} ${widget.productOrderModel!.productModel!.quantityType}",
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
                  "${widget.productOrderModel!.couponQuantity}",
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.productOrderModel!.productModel!.price == 0
            ? Text(
                "Not set price",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.red, fontWeight: FontWeight.w500),
              )
            : widget.productOrderModel!.promocodeDiscount == 0 && widget.productOrderModel!.couponDiscount == 0
                ? Text(
                    "₹ ${numFormat.format(widget.productOrderModel!.orderPrice! * widget.productOrderModel!.couponQuantity!)}",
                    style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "₹ ${numFormat.format(
                          (widget.productOrderModel!.orderPrice! -
                                  widget.productOrderModel!.couponDiscount! -
                                  widget.productOrderModel!.promocodeDiscount!) *
                              widget.productOrderModel!.couponQuantity!,
                        )}",
                        style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: widthDp * 3),
                      Text(
                        "₹ ${numFormat.format(widget.productOrderModel!.orderPrice! * widget.productOrderModel!.couponQuantity!)}",
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
        if (widget.productOrderModel!.taxPercentage != 0)
          Column(
            children: [
              SizedBox(height: heightDp * 3),
              Text(
                "Tax: ₹ ${numFormat.format(widget.productOrderModel!.taxPriceAfterDiscount! * widget.productOrderModel!.couponQuantity!)}",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
              ),
            ],
          ),
      ],
    );
  }
}
