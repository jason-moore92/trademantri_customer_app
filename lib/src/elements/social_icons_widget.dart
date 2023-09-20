import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialIconsWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
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

    return Container(
      width: deviceWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              ///
            },
            child: Image.asset("img/email.png", width: heightDp * 50, height: heightDp * 50, fit: BoxFit.fill),
          ),
          GestureDetector(
            onTap: () {
              ///
            },
            child: Image.asset("img/linkedin.png", width: heightDp * 50, height: heightDp * 50, fit: BoxFit.fill),
          ),
          GestureDetector(
            onTap: () {
              ///
            },
            child: Image.asset("img/facebook.png", width: heightDp * 50, height: heightDp * 50, fit: BoxFit.fill),
          ),
          GestureDetector(
            onTap: () {
              ///
            },
            child: Image.asset("img/twitter.png", width: heightDp * 50, height: heightDp * 50, fit: BoxFit.fill),
          ),
          GestureDetector(
            onTap: () {
              ///
            },
            child: Image.asset("img/instagram.png", width: heightDp * 50, height: heightDp * 50, fit: BoxFit.fill),
          ),
        ],
      ),
    );
  }
}
