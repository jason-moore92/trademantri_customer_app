import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/pages/DocViewPage/index.dart';

import 'index.dart';

class LegalResourcesView extends StatefulWidget {
  LegalResourcesView({Key? key}) : super(key: key);

  @override
  _LegalResourcesViewState createState() => _LegalResourcesViewState();
}

class _LegalResourcesViewState extends State<LegalResourcesView> {
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
          LegalResourcesPageString.appbarTitle,
          style: TextStyle(fontSize: fontSp * 18, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => DocViewPage(
                      appBarTitle: LegalResourcesPageString.privacy,
                      doc: AppConfig.privacyDocLink,
                    ),
                  ),
                );
              },
              title: Text(
                LegalResourcesPageString.privacy,
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.grey),
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => DocViewPage(
                      appBarTitle: LegalResourcesPageString.terms,
                      doc: AppConfig.termsDocLink,
                    ),
                  ),
                );
              },
              title: Text(
                LegalResourcesPageString.terms,
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.grey),
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => DocViewPage(
                      appBarTitle: LegalResourcesPageString.disclaimer,
                      doc: AppConfig.disclaimerDocLink,
                    ),
                  ),
                );
              },
              title: Text(
                LegalResourcesPageString.disclaimer,
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.grey),
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
