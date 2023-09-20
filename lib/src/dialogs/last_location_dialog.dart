import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;

class LastLocationDialog {
  static show(BuildContext context, {@required Function? currentCallback, @required Function? lastCallback}) {
    double fontSp = ScreenUtil().setSp(
          1,
        ) /
        ScreenUtil().textScaleFactor;
    double heightDp = ScreenUtil().setHeight(1);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: heightDp * 20,
                  color: Colors.transparent,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Row(
                children: [
                  Image.asset(
                    "img/location.png",
                    width: heightDp * 25,
                    height: heightDp * 25,
                    fit: BoxFit.cover,
                    color: config.Colors().mainColor(1),
                  ),
                  SizedBox(width: heightDp * 10),
                  Text(
                    "Location",
                    style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: heightDp * 20,
                ), //color: Colors.black
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          titlePadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          content: Text(
            "Do you want to see the stores in your current location or previously used location?",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1.5),
            textAlign: TextAlign.center,
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton(
                    color: config.Colors().mainColor(1),
                    onPressed: () {
                      Navigator.of(context).pop();
                      currentCallback!();
                    },
                    child: Text(
                      "Current location",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FlatButton(
                    color: config.Colors().mainColor(1),
                    onPressed: () {
                      Navigator.of(context).pop();
                      lastCallback!();
                    },
                    child: Text(
                      "Previous location",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
