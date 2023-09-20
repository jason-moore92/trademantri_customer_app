import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as appConfig;
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/entities/maintenance.dart';

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

class MaintenanceWidget extends StatefulWidget {
  final Maintenance? activeMaintenance;
  final void Function()? onSkip;

  MaintenanceWidget({
    Key? key,
    this.activeMaintenance,
    this.onSkip,
  }) : super(key: key);

  @override
  _MaintenanceWidgetState createState() => _MaintenanceWidgetState();
}

class _MaintenanceWidgetState extends State<MaintenanceWidget> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  late Maintenance activeMaintenance;
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
    activeMaintenance = widget.activeMaintenance!;
    List<String> messages = activeMaintenance.message!.split("\n");
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
            height: deviceHeight * 0.35,
            padding: EdgeInsets.only(
              bottom: 8.0,
            ),
            child: Image.asset(
              activeMaintenance.image != null ? activeMaintenance.image! : "img/maintenance.png",
              width: deviceWidth * 0.8,
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            height: deviceHeight * 0.45,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: appConfig.Colors().mainColor(1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Dear Valuable customer,",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      ...messages
                          .map(
                            (m) => Container(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                m,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (activeMaintenance.allowOperations! == true)
            Container(
              height: deviceHeight * 0.05,
              child: KeicyRaisedButton(
                width: deviceWidth * 0.75,
                // height: 32.0,
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                borderRadius: 32.0,
                onPressed: () async {
                  widget.onSkip!();
                },
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
      ..color = appConfig.Colors().mainColor(1)
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
