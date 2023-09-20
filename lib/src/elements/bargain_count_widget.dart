import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/providers/index.dart';

class BargainCountWidget extends StatelessWidget {
  final String? userId;

  BargainCountWidget({@required this.userId});

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

  BargainRequestProvider? bargainRequestProvider;

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

    bargainRequestProvider = BargainRequestProvider.of(context);

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
              "Bargain Requests",
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
        child: Consumer<BargainRequestProvider>(
          builder: (context, bargainRequestProvider, _) {
            return StreamBuilder<dynamic>(
              stream: Stream.fromFuture(BargainRequestApiProvider.getTotalBargainByUser(userId: userId)),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) return _shimmerWidget;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bargain Requests",
                      style: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
                    ),
                    SizedBox(height: heightDp! * 10),
                    Text(
                      snapshot.data["data"].isEmpty ? "0" : "${numFormat.format(snapshot.data["data"][0]["totalCount"])}",
                      style: TextStyle(fontSize: fontSp! * 20, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
