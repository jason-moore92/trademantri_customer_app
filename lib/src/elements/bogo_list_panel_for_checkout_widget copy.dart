import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/product_checkout_widget.dart';
import 'package:trapp/src/elements/service_checkout_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/models/store_model.dart';
import 'package:trapp/src/pages/StorePage/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class BOGOListPanelForCheckoutWidget extends StatefulWidget {
  final OrderModel? orderModel;

  BOGOListPanelForCheckoutWidget({@required this.orderModel});

  @override
  _CartListPanelForCheckoutWidgetState createState() => _CartListPanelForCheckoutWidgetState();
}

class _CartListPanelForCheckoutWidgetState extends State<BOGOListPanelForCheckoutWidget> {
  /// Responsive design variables
  double? deviceWidth;
  double? deviceHeight;
  double? statusbarHeight;
  double? bottomBarHeight;
  double? appbarHeight;
  double? widthDp;
  double? heightDp;
  double? heightDp1;
  double? fontSp;
  ///////////////////////////////

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
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////
  }

  @override
  Widget build(BuildContext context) {
    String str = "Buy ${widget.orderModel!.coupon!.discountData!["customerBogo"]["buy"]["quantity"]} "
        "Get ${widget.orderModel!.coupon!.discountData!["customerBogo"]["get"]["quantity"]} ";

    if (widget.orderModel!.coupon!.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[0]["value"]) {
      str += "Free";
    } else if (widget.orderModel!.coupon!.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[1]["value"]) {
      str += "${widget.orderModel!.coupon!.discountData!["customerBogo"]["get"]["percentValue"]}% OFF";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp! * 15),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: heightDp! * 10),
            child: Text(
              str,
              style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
            ),
          ),
          Column(
            children: List.generate(widget.orderModel!.bogoProducts!.length, (index) {
              ProductOrderModel productOrderModel = widget.orderModel!.bogoProducts![index];
              return Column(
                children: [
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ProductCheckoutWidget(
                    orderModel: widget.orderModel,
                    productOrderModel: productOrderModel,
                    isEditble: false,
                    callback: null,
                  ),
                ],
              );
            }),
          ),
          Column(
            children: List.generate(widget.orderModel!.bogoServices!.length, (index) {
              ServiceOrderModel serviceOrderModel = widget.orderModel!.bogoServices![index];
              return Column(
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  ServiceCheckoutWidget(
                    orderModel: widget.orderModel,
                    serviceOrderModel: serviceOrderModel,
                    isEditble: false,
                    callback: null,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
