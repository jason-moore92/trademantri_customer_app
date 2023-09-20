import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;

class NoInAppPaymentDialog {
  static show(
    BuildContext context, {
    // @required Function? cancelCallback,
    @required Function? proceedCallback,
  }) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double heightDp = ScreenUtil().setHeight(1);
    return showDialog(
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
                  Text(
                    "In App Payment",
                    style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.close, size: heightDp * 20),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          titlePadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          content: Text(
            "We regret to say that our in app payment service is currently unavailable. We are currently only handling COD and pick up (Pay at store) orders. ",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1.5),
            textAlign: TextAlign.center,
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // FlatButton(
                  //   color: config.Colors().mainColor(1),
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //     if (cancelCallback != null) cancelCallback();
                  //   },
                  //   child: Text(
                  //     "Cancel",
                  //     style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  FlatButton(
                    color: config.Colors().mainColor(1),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (proceedCallback != null) proceedCallback();
                    },
                    child: Text(
                      "Ok",
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
