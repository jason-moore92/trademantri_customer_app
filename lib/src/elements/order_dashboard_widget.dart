import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/providers/index.dart';

class OrderDashboardWidget extends StatelessWidget {
  final Map<String, dynamic>? dashboardOrderData;
  final String? fieldName;
  final String? description;
  final String? prefix;

  OrderDashboardWidget({
    @required this.dashboardOrderData,
    @required this.fieldName,
    @required this.description,
    this.prefix = "",
  });

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

  OrderProvider? orderProvider;

  var numFormat = NumberFormat.currency(symbol: "", name: "");

  @override
  Widget build(BuildContext context) {
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

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    orderProvider = OrderProvider.of(context);

    Widget _shimmerWidget = Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      period: Duration(milliseconds: 1000),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.white,
            child: Text(
              "Total Units",
              style: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
            ),
          ),
          SizedBox(height: heightDp! * 10),
          Container(
            color: Colors.white,
            child: Text(
              "₹ 82.56",
              style: TextStyle(fontSize: fontSp! * 20, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    return Card(
      margin: EdgeInsets.only(left: widthDp! * 10, right: widthDp! * 10, top: heightDp! * 3, bottom: heightDp! * 17),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp! * 10)),
      child: Container(
        width: heightDp! * 170,
        height: heightDp! * 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp! * 10), color: Colors.white),
        child: dashboardOrderData!.isEmpty
            ? _shimmerWidget
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    description!,
                    style: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: heightDp! * 10),
                  Text(
                    "$prefix ${numFormat.format(dashboardOrderData![fieldName])}",
                    style: TextStyle(fontSize: fontSp! * 20, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }
}
