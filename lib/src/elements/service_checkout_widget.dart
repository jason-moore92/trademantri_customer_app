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

class ServiceCheckoutWidget extends StatefulWidget {
  final OrderModel? orderModel;
  final ServiceOrderModel? serviceOrderModel;
  final bool? isEditble;
  final Function? callback;

  ServiceCheckoutWidget({
    @required this.orderModel,
    @required this.serviceOrderModel,
    this.isEditble,
    @required this.callback,
  });

  @override
  _ServiceCheckoutWidgetState createState() => _ServiceCheckoutWidgetState();
}

class _ServiceCheckoutWidgetState extends State<ServiceCheckoutWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  bool? isEditable;
  ServiceModel? _serviceModel;

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
      padding: EdgeInsets.symmetric(horizontal: widthDp * 0, vertical: heightDp * 5),
      child: _serviceWidget(),
    );
  }

  Widget _serviceWidget() {
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

    _serviceModel = widget.serviceOrderModel!.serviceModel;

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${_serviceModel!.name}",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // SizedBox(height: heightDp * 5),
                          Row(
                            children: [
                              Expanded(
                                child: _serviceModel!.provided == null
                                    ? SizedBox()
                                    : Text(
                                        "${_serviceModel!.provided}",
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
        "Service",
        style: TextStyle(fontSize: fontSp * 12, color: Colors.blue),
      ),
    );
  }

  Widget _addButtonPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _addMoreServiceButton(),
        SizedBox(width: widthDp * 5),
        _priceWidget(),
      ],
    );
  }

  Widget _addMoreServiceButton() {
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

                int selectedCount = widget.serviceOrderModel!.orderQuantity!.toInt();
                widget.serviceOrderModel!.orderQuantity = selectedCount - 1;

                _cartProvider!.setCartData(
                  storeModel: widget.orderModel!.storeModel,
                  userId: AuthProvider.of(context).authState.userModel!.id,
                  storeId: widget.orderModel!.storeModel!.id,
                  objectData: _serviceModel!.toJson(),
                  category: "services",
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
                        color: !isEditable! || widget.serviceOrderModel!.orderQuantity == 0
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
            numFormat.format(widget.serviceOrderModel!.couponQuantity!),
            style: TextStyle(fontSize: fontSp * 14, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                if (!isEditable!) return;
                if (widget.orderModel!.category == AppConfig.orderCategories["bargain"] ||
                    widget.orderModel!.category == AppConfig.orderCategories["reverse_auction"]) return;

                int selectedCount = widget.serviceOrderModel!.orderQuantity!.toInt();
                widget.serviceOrderModel!.orderQuantity = selectedCount + 1;

                _cartProvider!.setCartData(
                  storeModel: widget.orderModel!.storeModel,
                  userId: AuthProvider.of(context).authState.userModel!.id,
                  storeId: widget.orderModel!.storeModel!.id,
                  objectData: _serviceModel!.toJson(),
                  category: "services",
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
    return widget.serviceOrderModel!.promocodeDiscount == 0 && widget.serviceOrderModel!.couponDiscount == 0
        ? Text(
            "₹ ${numFormat.format(widget.serviceOrderModel!.orderPrice! * widget.serviceOrderModel!.couponQuantity!)}",
            style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "₹ ${numFormat.format((widget.serviceOrderModel!.orderPrice! - widget.serviceOrderModel!.promocodeDiscount! - widget.serviceOrderModel!.couponDiscount!) * widget.serviceOrderModel!.couponQuantity!)}",
                    style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text(
                "₹ ${numFormat.format(widget.serviceOrderModel!.orderPrice! * widget.serviceOrderModel!.couponQuantity!)} ",
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
