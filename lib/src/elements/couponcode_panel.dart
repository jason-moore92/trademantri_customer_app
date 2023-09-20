import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/coupon_widget.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/CouponListPage/index.dart';

class CouponPanel extends StatefulWidget {
  final OrderModel? orderModel;
  final Function? refreshCallback;

  CouponPanel({
    @required this.orderModel,
    @required this.refreshCallback,
  });

  @override
  _PromocodePanelState createState() => _PromocodePanelState();
}

class _PromocodePanelState extends State<CouponPanel> {
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

  List<dynamic> _productCategories = [];
  List<dynamic> _serviceCategories = [];
  List<dynamic> _productIds = [];
  List<dynamic> _serviceIds = [];

  String message = "";

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
  }

  void _couponHandler() {
    _productCategories = [];
    _serviceCategories = [];
    for (var i = 0; i < widget.orderModel!.products!.length; i++) {
      _productCategories.add(widget.orderModel!.products![i].productModel!.category);
      _productIds.add(widget.orderModel!.products![i].productModel!.id);
    }

    for (var i = 0; i < widget.orderModel!.services!.length; i++) {
      _serviceCategories.add(widget.orderModel!.services![i].serviceModel!.category);
      _serviceIds.add(widget.orderModel!.services![i].serviceModel!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    _couponHandler();

    message = "";

    if (widget.orderModel!.couponVaidate != null && widget.orderModel!.coupon != null && message == "") {
      message = CouponModel.checkAppliedFor(
        orderModel: widget.orderModel,
        couponModel: widget.orderModel!.coupon,
      )["message"];
    }

    if (widget.orderModel!.couponVaidate != null && widget.orderModel!.coupon != null && (message == "" || message == "ALL")) {
      message = CouponModel.checkCouponMinRequests(
        orderModel: widget.orderModel,
        couponModel: widget.orderModel!.coupon,
      );
    }

    if (widget.orderModel!.couponVaidate != null && widget.orderModel!.coupon != null && message == "") {
      message = CouponModel.checkBOGO(
        orderModel: widget.orderModel,
        couponModel: widget.orderModel!.coupon,
      );
    }

    if (message != "") {
      widget.orderModel!.couponVaidate = false;
    } else {
      widget.orderModel!.couponVaidate = true;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Add available coupons",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
              ),
              KeicyRaisedButton(
                width: widthDp * 100,
                height: heightDp * 35,
                borderRadius: heightDp * 6,
                color: config.Colors().mainColor(1),
                child: Text(
                  widget.orderModel!.coupon != null ? "Change" : "Add",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
                onPressed: () async {
                  var result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => CouponListPage(
                        storeModel: widget.orderModel!.storeModel,
                        selectedCoupon: widget.orderModel!.coupon,
                        orderModel: widget.orderModel,
                        productCategories: _productCategories,
                        serviceCategories: _serviceCategories,
                        productIds: _productIds,
                        serviceIds: _serviceIds,
                        isForOrder: true,
                      ),
                    ),
                  );
                  if (result != null) {
                    widget.orderModel!.couponVaidate = null;
                    widget.orderModel!.coupon = CouponModel.fromJson(result);
                    widget.refreshCallback!();
                  }
                },
              ),
            ],
          ),
          if (widget.orderModel!.coupon != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset("img/coupons.png", width: heightDp * 40, height: heightDp * 40),
                    SizedBox(width: widthDp * 20),
                    Text(
                      "1 Coupon applied",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Coupon Code : ${widget.orderModel!.coupon!.discountCode}",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.orderModel!.coupon = null;
                        widget.orderModel!.couponVaidate = null;
                        widget.refreshCallback!();
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                        child: Icon(Icons.close, size: heightDp * 25, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 5),
                if (message != "")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: heightDp * 5),
                      Text(
                        message + "\nAdd more applicable products/services or remove the applied coupon from the order",
                        style: TextStyle(fontSize: fontSp * 12, color: Colors.red, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
