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

class CartListPanelForCheckoutWidget extends StatefulWidget {
  final OrderModel? orderModel;
  final Function? refreshPageCallback;

  CartListPanelForCheckoutWidget({
    @required this.orderModel,
    @required this.refreshPageCallback,
  });

  @override
  _CartListPanelForCheckoutWidgetState createState() => _CartListPanelForCheckoutWidgetState();
}

class _CartListPanelForCheckoutWidgetState extends State<CartListPanelForCheckoutWidget> {
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp! * 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: heightDp! * 10),
                  child: Text(
                    "${widget.orderModel!.storeModel!.name} Store",
                    style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                  ),
                ),
              ),
              if (widget.orderModel!.category == AppConfig.orderCategories["bargain"] ||
                  widget.orderModel!.category == AppConfig.orderCategories["reverse_auction"])
                SizedBox()
              else
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (BuildContext context) => StorePage(storeModel: widget.orderModel!.storeModel)),
                      (route) {
                        if (route.settings.name == "home_page") return true;
                        return false;
                      },
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: widthDp! * 10, top: heightDp! * 10, bottom: heightDp! * 10),
                    child: Text(
                      "+ Add More",
                      style: TextStyle(fontSize: fontSp! * 14, color: config.Colors().mainColor(1), fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          Column(
            children: List.generate(widget.orderModel!.products!.length, (index) {
              ProductOrderModel productOrderModel = widget.orderModel!.products![index];
              if (productOrderModel.couponQuantity == 0) return SizedBox();
              return Column(
                children: [
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ProductCheckoutWidget(
                    orderModel: widget.orderModel,
                    productOrderModel: productOrderModel,
                    callback: () {
                      widget.refreshPageCallback!();
                    },
                  ),
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
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  ServiceCheckoutWidget(
                    orderModel: widget.orderModel,
                    serviceOrderModel: serviceOrderModel,
                    callback: () {
                      widget.refreshPageCallback!();
                    },
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
