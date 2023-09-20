import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/helpers/price_functions.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/CartProvider/cart_provider.dart';
import 'package:trapp/src/providers/index.dart';

class ProductCheckoutWidget extends StatefulWidget {
  final OrderModel? orderModel;
  final ProductOrderModel? productOrderModel;
  final bool? isEditble;
  final Function? callback;

  ProductCheckoutWidget({
    @required this.orderModel,
    @required this.productOrderModel,
    this.isEditble,
    @required this.callback,
  });

  @override
  _ProductCheckoutWidgetState createState() => _ProductCheckoutWidgetState();
}

class _ProductCheckoutWidgetState extends State<ProductCheckoutWidget> {
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

  bool? isEditable;
  ProductModel? _productModel;

  CartProvider? _cartProvider;

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

    _cartProvider = CartProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 0, vertical: heightDp * 5),
      child: _productWidget(),
    );
  }

  Widget _productWidget() {
    if (widget.isEditble == null) {
      if (widget.orderModel!.category == AppConfig.orderCategories["bargain"] ||
          widget.orderModel!.category == AppConfig.orderCategories["reverse_auction"]) {
        isEditable = false;
      } else {
        isEditable = true;
      }
    } else {
      isEditable = widget.isEditble;
    }

    _productModel = widget.productOrderModel!.productModel;

    return Row(
      children: [
        Icon(Icons.star, size: heightDp * 20, color: config.Colors().mainColor(1)),
        SizedBox(width: widthDp * 5),
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
                            "${_productModel!.name}",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: heightDp * 5),
                          Row(
                            children: [
                              Expanded(
                                child: _productModel!.quantity == null || _productModel!.quantityType == null
                                    ? SizedBox()
                                    : Text(
                                        "${_productModel!.quantity} ${_productModel!.quantityType}",
                                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                      ),
                              ),
                              _categoryButton(),
                              SizedBox(width: widthDp * 5),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: _addButtonPanel(),
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
      padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 2),
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

  Widget _addButtonPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _addMoreProductButton(),
        SizedBox(width: widthDp * 5),
        _priceWidget(),
      ],
    );
  }

  Widget _addMoreProductButton() {
    return Container(
      width: widthDp * 80,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                if (!isEditable!) return;
                if (widget.orderModel!.category == AppConfig.orderCategories["bargain"] ||
                    widget.orderModel!.category == AppConfig.orderCategories["reverse_auction"]) return;

                int selectedCount = widget.productOrderModel!.orderQuantity!.toInt();
                widget.productOrderModel!.orderQuantity = selectedCount - 1;

                _cartProvider!.setCartData(
                  storeModel: widget.orderModel!.storeModel,
                  userId: AuthProvider.of(context).authState.userModel!.id,
                  storeId: widget.orderModel!.storeModel!.id,
                  objectData: _productModel!.toJson(),
                  category: "products",
                  orderQuantity: selectedCount - 1,
                  lastDeviceToken: AuthProvider.of(context).authState.userModel!.fcmToken,
                );

                widget.callback!();
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: widthDp * 5),
                    Icon(Icons.remove,
                        color: !isEditable! || widget.productOrderModel!.orderQuantity == 0
                            ? Colors.grey.withOpacity(0.4)
                            : config.Colors().mainColor(1),
                        size: heightDp * 20),
                    SizedBox(width: widthDp * 5),
                  ],
                ),
              ),
            ),
          ),
          Text(
            numFormat.format(widget.productOrderModel!.couponQuantity!),
            style: TextStyle(fontSize: fontSp * 14, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                if (!isEditable!) return;
                if (widget.orderModel!.category == AppConfig.orderCategories["bargain"] ||
                    widget.orderModel!.category == AppConfig.orderCategories["reverse_auction"]) return;

                int selectedCount = widget.productOrderModel!.orderQuantity!.toInt();
                widget.productOrderModel!.orderQuantity = selectedCount + 1;

                _cartProvider!.setCartData(
                  storeModel: widget.orderModel!.storeModel,
                  userId: AuthProvider.of(context).authState.userModel!.id,
                  storeId: widget.orderModel!.storeModel!.id,
                  objectData: _productModel!.toJson(),
                  category: "products",
                  orderQuantity: selectedCount + 1,
                  lastDeviceToken: AuthProvider.of(context).authState.userModel!.fcmToken,
                );
                widget.callback!();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: widthDp * 5),
                    Icon(Icons.add, color: !isEditable! ? Colors.grey.withOpacity(0.4) : config.Colors().mainColor(1), size: heightDp * 20),
                    SizedBox(width: widthDp * 5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceWidget() {
    return widget.productOrderModel!.promocodeDiscount == 0 && widget.productOrderModel!.couponDiscount == 0
        ? Text(
            "₹ ${numFormat.format(widget.productOrderModel!.orderPrice! * widget.productOrderModel!.couponQuantity!)}",
            style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "₹ ${numFormat.format((widget.productOrderModel!.orderPrice! - widget.productOrderModel!.promocodeDiscount! - widget.productOrderModel!.couponDiscount!) * widget.productOrderModel!.couponQuantity!)}",
                    style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text(
                "₹ ${numFormat.format(widget.productOrderModel!.orderPrice! * widget.productOrderModel!.couponQuantity!)} ",
                style: TextStyle(
                  fontSize: fontSp * 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 2,
                ),
              ),
            ],
          );
  }
}
