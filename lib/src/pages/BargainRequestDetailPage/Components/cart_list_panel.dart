import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/product_order_widget.dart';
import 'package:trapp/src/elements/service_order_widget.dart';
import 'package:trapp/src/models/index.dart';

class CartListPanel extends StatefulWidget {
  final BargainRequestModel? bargainRequestModel;

  CartListPanel({
    @required this.bargainRequestModel,
  });

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
            children: List.generate(widget.bargainRequestModel!.products!.length, (index) {
              Map<String, dynamic> productData = widget.bargainRequestModel!.products![index].toJson();
              Map<String, dynamic> tmp = productData["data"];
              tmp["orderQuantity"] = double.parse(productData["orderQuantity"].toString());

              return Column(
                children: [
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ProductOrderWidget(
                    productData: tmp,
                    orderData: widget.bargainRequestModel!.toJson(),
                  ),
                ],
              );
            }),
          ),
          Column(
            children: List.generate(widget.bargainRequestModel!.services!.length, (index) {
              Map<String, dynamic> serviceData = widget.bargainRequestModel!.services![index].toJson();
              Map<String, dynamic> tmp = serviceData["data"];
              tmp["orderQuantity"] = double.parse(serviceData["orderQuantity"].toString());

              return Column(
                children: [
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  // ServiceBargainWidget(
                  //   serviceData: tmp,
                  //   orderData: widget.bargainRequestModel!,
                  // ),
                  ServiceOrderWidget(
                    serviceData: tmp,
                    orderData: widget.bargainRequestModel!.toJson(),
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
