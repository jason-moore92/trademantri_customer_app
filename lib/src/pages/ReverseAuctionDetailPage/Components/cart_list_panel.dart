import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/product_order_widget.dart';
import 'package:trapp/src/elements/service_order_widget.dart';

class CartListPanel extends StatefulWidget {
  final Map<String, dynamic>? reverseAuctionData;

  CartListPanel({
    @required this.reverseAuctionData,
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
          widget.reverseAuctionData!["products"].length == 0
              ? SizedBox()
              : Column(
                  children: List.generate(widget.reverseAuctionData!["products"].length, (index) {
                    Map<String, dynamic> productData = widget.reverseAuctionData!["products"][index]["data"];
                    productData["orderQuantity"] = widget.reverseAuctionData!["products"][index]["orderQuantity"];

                    return ProductOrderWidget(
                      productData: productData,
                      orderData: widget.reverseAuctionData!,
                    );

                    // return ProductReverseAuctionWidget(
                    //   productData: productData,
                    //   reverseAuctionData: widget.reverseAuctionData!,
                    //   index: index,
                    //   deleteCallback: (int index) {
                    //     widget.reverseAuctionData!["products"].removeAt(index);
                    //     setState(() {});
                    //   },
                    // );
                  }),
                ),
          widget.reverseAuctionData!["services"].length == 0
              ? SizedBox()
              : Column(
                  children: List.generate(widget.reverseAuctionData!["services"].length, (index) {
                    Map<String, dynamic> serviceData = widget.reverseAuctionData!["services"][index]["data"];
                    serviceData["orderQuantity"] = widget.reverseAuctionData!["services"][index]["orderQuantity"];

                    return ServiceOrderWidget(
                      serviceData: serviceData,
                      orderData: widget.reverseAuctionData!,
                    );

                    // return ServiceReverseAuctionWidget(
                    //   serviceData: serviceData,
                    //   reverseAuctionData: widget.reverseAuctionData!,
                    //   index: index,
                    //   deleteCallback: (int index) {
                    //     widget.reverseAuctionData!["services"].removeAt(index);
                    //     setState(() {});
                    //   },
                    // );
                  }),
                ),
        ],
      ),
    );
  }
}
