import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;

class ErrorPage extends StatelessWidget {
  final String? message;
  final Function()? callback;

  ErrorPage({
    @required this.message,
    this.callback,
  });

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

    return Scaffold(
      body: Container(
        width: deviceWidth,
        padding: EdgeInsets.all(widthDp * 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: heightDp * 70, color: Colors.red),
            SizedBox(height: heightDp * 20),
            Text(
              message ?? "Something Error",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: heightDp * 20),
            KeicyRaisedButton(
              width: widthDp * 150,
              height: heightDp * 45,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 6,
              child: Text(
                "Try again",
                style: TextStyle(fontSize: fontSp * 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: callback,
            ),
          ],
        ),
      ),
    );
  }
}
