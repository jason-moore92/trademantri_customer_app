import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;

class NormalDialog {
  static show(BuildContext context, {String title = "", String content = "", Function? callback}) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // backgroundColor: Colors.white,
          title: Text(
            title,
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          titlePadding: title == "" ? EdgeInsets.zero : EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
          content: Text(
            content,
            style: TextStyle(fontSize: fontSp * 14, color: Colors.black, height: 1.5),
            textAlign: TextAlign.center,
          ),
          contentPadding: content == "" ? EdgeInsets.zero : EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          actions: [
            FlatButton(
              color: config.Colors().mainColor(1),
              onPressed: () {
                Navigator.of(context).pop();
                if (callback != null) {
                  callback();
                }
              },
              child: Text(
                "OK",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}
