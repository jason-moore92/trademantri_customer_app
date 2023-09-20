import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/product_order_detail_widget.dart';
import 'package:trapp/src/elements/product_order_widget.dart';
import 'package:trapp/src/elements/service_order_detail_widget.dart';
import 'package:trapp/src/elements/service_order_widget.dart';
import 'package:trapp/src/models/order_model.dart';
import 'package:trapp/src/models/index.dart';

class CartListPanel extends StatefulWidget {
  final OrderModel? orderModel;

  CartListPanel({@required this.orderModel});

  @override
  _CartListPanelState createState() => _CartListPanelState();
}

class _CartListPanelState extends State<CartListPanel> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Column(
            children: List.generate(widget.orderModel!.products!.length, (index) {
              ProductOrderModel productOrderModel = widget.orderModel!.products![index];
              if (productOrderModel.couponQuantity == 0) return SizedBox();
              return Column(
                children: [
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ProductOrderDetailWidget(productOrderModel: productOrderModel),
                ],
              );
            }),
          ),
          Column(
            children: List.generate(widget.orderModel!.services!.length, (index) {
              ServiceOrderModel serviceOrderModel = widget.orderModel!.services![index];
              if (serviceOrderModel.couponQuantity == 0) return SizedBox();
              return Column(
                children: [
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ServiceOrderDetailWidget(serviceOrderModel: serviceOrderModel),
                ],
              );
            }),
          ),
          if (widget.orderModel!.bogoProducts!.isNotEmpty || widget.orderModel!.bogoServices!.isNotEmpty)
            Column(
              children: [
                Container(
                  width: deviceWidth,
                  padding: EdgeInsets.symmetric(vertical: heightDp * 10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.withOpacity(0.7)),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Buy ${widget.orderModel!.coupon!.discountData!["customerBogo"]["buy"]["quantity"]} "
                      "Get ${widget.orderModel!.coupon!.discountData!["customerBogo"]["get"]["quantity"]} "
                      "${widget.orderModel!.coupon!.discountData!["customerBogo"]["get"]["type"] == "Free" ? 'Free' : widget.orderModel!.coupon!.discountData!["customerBogo"]["get"]["percentValue"].toString() + ' % OFF'}",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                  ),
                ),
                Column(
                  children: List.generate(widget.orderModel!.bogoProducts!.length, (index) {
                    ProductOrderModel productOrderModel = widget.orderModel!.products![index];
                    return Column(
                      children: [
                        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                        ProductOrderDetailWidget(productOrderModel: productOrderModel),
                      ],
                    );
                  }),
                ),
                Column(
                  children: List.generate(widget.orderModel!.bogoServices!.length, (index) {
                    ServiceOrderModel serviceOrderModel = widget.orderModel!.services![index];
                    return Column(
                      children: [
                        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                        ServiceOrderDetailWidget(serviceOrderModel: serviceOrderModel),
                      ],
                    );
                  }),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
