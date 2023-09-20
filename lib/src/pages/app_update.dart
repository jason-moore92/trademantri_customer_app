import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/environment.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:url_launcher/url_launcher.dart';

/// Responsive design variables
double deviceWidth = 0;
double deviceHeight = 0;
double statusbarHeight = 0;
double bottomBarHeight = 0;
double appbarHeight = 0;
double widthDp = 0;
// double heightDp;
double heightDp1 = 0;
double fontSp = 0;

class AppUpdate extends StatefulWidget {
  final String? updateType;
  final void Function()? onSkip;
  final void Function()? doReload;

  AppUpdate({
    Key? key,
    this.updateType,
    this.onSkip,
    this.doReload,
  }) : super(key: key);

  @override
  _AppUpdateState createState() => _AppUpdateState();
}

class _AppUpdateState extends State<AppUpdate> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

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
    // heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    // forceResult = "do_immediate_update";
    // forceResult = "do_flexible_update";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: deviceHeight * 0.1,
            child: Row(
              children: [
                Expanded(child: Container()),
                Container(
                  color: Colors.white,
                  child: CustomPaint(
                    size: Size(100, 100),
                    painter: Curve1(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: deviceHeight * 0.25,
            padding: EdgeInsets.only(
              bottom: 8.0,
            ),
            child: Image.asset(
              "img/logo.png",
              width: deviceWidth * 0.5,
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            height: deviceHeight * 0.35,
            padding: EdgeInsets.only(
              bottom: 8.0,
            ),
            child: Image.asset(
              "img/app_update.png",
              width: deviceWidth * 0.8,
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            height: deviceHeight * 0.3,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: config.Colors().mainColor(1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Time To Update!",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "We added lot of new features and fix some bugs to make your experience as smooth as possible",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    KeicyRaisedButton(
                      width: deviceWidth * 0.75,
                      height: 32.0,
                      child: Text(
                        "Update App",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      borderRadius: 32.0,
                      onPressed: () async {
                        PackageInfo packageInfo = await PackageInfo.fromPlatform();
                        String appPackageName = packageInfo.packageName;

                        //TODO:: how to get updated url for qa
                        //May be connecting aws ci/cd pipeline and saving the url in firestore
                        if (Environment.envName != "production") {
                          Fluttertoast.showToast(msg: "In QA opening the app not supported, so check the url shared via developer.");
                          return;
                        }
                        bool launched = await launch("https://play.google.com/store/apps/details?id=" + appPackageName);
                        if (widget.doReload != null) {
                          widget.doReload!();
                        }
                      },
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    if (widget.updateType == "do_flexible_update")
                      InkWell(
                        onTap: () {
                          if (widget.onSkip != null) {
                            widget.onSkip!();
                          }
                        },
                        child: Text(
                          "NOT NOW",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Curve1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = config.Colors().mainColor(1)
      ..strokeWidth = 15;

    var path = Path();

    // path.moveTo(0, size.height * 0.7);
    // path.quadraticBezierTo(size.width * 0.25, size.height * 0.7, size.width * 0.5, size.height * 0.8);
    // path.quadraticBezierTo(size.width * 0.75, size.height * 0.9, size.width * 1.0, size.height * 0.8);
    // path.lineTo(size.width, size.height);
    // path.lineTo(0, size.height);

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    // path.lineTo(0, size.height);

    path.quadraticBezierTo(size.width, size.height, size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.8, size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
