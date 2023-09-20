import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;

import '../login.dart';

class LoginAskView extends StatefulWidget {
  final Function? callback;

  LoginAskView({Key? key, this.callback}) : super(key: key);

  @override
  _LoginAskViewState createState() => _LoginAskViewState();
}

class _LoginAskViewState extends State<LoginAskView> {
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You didn't login yet",
              style: TextStyle(fontSize: fontSp * 20, fontWeight: FontWeight.w600, color: Colors.black),
            ),
            SizedBox(height: heightDp * 20),
            Text("Do you want to login now", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
            SizedBox(height: heightDp * 40),
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 35,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 6,
              child: Text(
                "Login",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => LoginWidget(callback: widget.callback)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
