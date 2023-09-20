import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/helpers/string_helper.dart';
import 'keicy_avatar_image.dart';

class UserRewardPointWidget extends StatefulWidget {
  final Map<String, dynamic>? referralRewardData;
  final bool isLoading;
  final Function()? tapCallback;

  UserRewardPointWidget({
    @required this.referralRewardData,
    this.isLoading = true,
    this.tapCallback,
  });

  @override
  _UserRewardPointWidgetState createState() => _UserRewardPointWidgetState();
}

class _UserRewardPointWidgetState extends State<UserRewardPointWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  bool isAdded = false;
  int selectedCount = 0;

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

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0, 3), blurRadius: 6)],
        borderRadius: BorderRadius.circular(heightDp * 8),
      ),
      child: widget.isLoading ? _shimmerWidget() : _productWidget(),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.isLoading,
      period: Duration(milliseconds: 1000),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: widthDp * 80,
            height: widthDp * 80,
            color: Colors.white,
          ),
          SizedBox(width: widthDp * 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    "user name 12",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: widthDp * 10),
          Column(
            children: [
              Row(
                children: [
                  Container(width: heightDp * 25, height: heightDp * 25, color: Colors.white),
                  SizedBox(width: widthDp * 5),
                  Container(
                    color: Colors.white,
                    child: Text(
                      "234.34",
                      style: TextStyle(fontSize: fontSp * 18, fontWeight: FontWeight.bold, color: config.Colors().mainColor(1)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightDp * 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 6), color: Colors.white),
                child: Text(
                  "pending",
                  style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _productWidget() {
    return GestureDetector(
      onTap: widget.tapCallback,
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            KeicyAvatarImage(
              url: widget.referralRewardData!["user"]["imageUrl"],
              width: widthDp * 80,
              height: widthDp * 80,
              backColor: Colors.grey.withOpacity(0.4),
            ),
            SizedBox(width: widthDp * 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.referralRewardData!["user"]["firstName"]} ${widget.referralRewardData!["user"]["lastName"]}",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: widthDp * 10),
            Column(
              children: [
                Row(
                  children: [
                    Image.asset("img/reward_points_icon.png", width: heightDp * 25, height: heightDp * 25),
                    SizedBox(width: widthDp * 5),
                    Text(
                      "${widget.referralRewardData!["referralUserRewardPoints"]}",
                      style: TextStyle(fontSize: fontSp * 18, fontWeight: FontWeight.bold, color: config.Colors().mainColor(1)),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 6), color: config.Colors().mainColor(1)),
                  child: Text(
                    StringHelper.getUpperCaseString(widget.referralRewardData!["status"]),
                    style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
