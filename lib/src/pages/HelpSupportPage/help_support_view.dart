import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'index.dart';

class HelpSupportView extends StatefulWidget {
  HelpSupportView({Key? key}) : super(key: key);

  @override
  _HelpSupportViewState createState() => _HelpSupportViewState();
}

class _HelpSupportViewState extends State<HelpSupportView> {
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
      appBar: AppBar(
        backgroundColor: Color(0xFF162779),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          HelpSupportPageString.appbarTitle,
          style: TextStyle(fontSize: fontSp * 18, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  HelpSupportPageString.popularArticle,
                  style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: heightDp * 20),
                Column(
                  children: List.generate(
                    HelpSupportPageString.popularItems.length,
                    (index) {
                      return Column(
                        children: [
                          Divider(height: 1, thickness: 1, color: Colors.grey),
                          ListTile(
                            onTap: () {},
                            title: Text(
                              HelpSupportPageString.popularItems[index],
                              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.grey),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey),
                SizedBox(height: heightDp * 20),
                Text(
                  HelpSupportPageString.topics,
                  style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: heightDp * 10),
                Container(
                  width: deviceWidth,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: heightDp * 10,
                    children: List.generate(
                      HelpSupportPageString.topicsItems.length,
                      (index) {
                        return Card(
                          elevation: 4,
                          child: Container(
                            width: widthDp * 170,
                            height: heightDp * 150,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(heightDp * 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "img/help/help_${index + 1}.png",
                                  width: heightDp * 70,
                                  height: heightDp * 70,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: heightDp * 10),
                                Text(
                                  HelpSupportPageString.topicsItems[index],
                                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
