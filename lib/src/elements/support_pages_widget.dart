import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/pages/ContactUsPage/index.dart';
import 'package:trapp/src/pages/AboutUsPage/index.dart';

class SupportPagesWidget extends StatelessWidget {
  String? type;

  SupportPagesWidget({@required this.type});

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

    List<Widget> _listWidget = [];
    if (type != "about_us") {
      _listWidget.add(
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => AboutUsPage()),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: heightDp * 5),
            child: Text(
              "About Us",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    if (type != "contact_us") {
      _listWidget.add(
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => ContactUsPage()),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: heightDp * 5),
            child: Text(
              "Contact Us",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    if (type != "privacy") {
      _listWidget.add(
        GestureDetector(
          onTap: () {
            ///
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: heightDp * 5),
            child: Text(
              "Privacy Policy",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    if (type != "help_support") {
      _listWidget.add(
        GestureDetector(
          onTap: () {
            ///
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: heightDp * 5),
            child: Text(
              "Help & Support",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    if (type != "terms") {
      _listWidget.add(
        GestureDetector(
          onTap: () {
            ///
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: heightDp * 5),
            child: Text(
              "Terms and Conditions",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    return Container(
      width: deviceWidth,
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: widthDp * 30,
        runSpacing: heightDp * 10,
        children: _listWidget,
      ),
    );
  }
}
