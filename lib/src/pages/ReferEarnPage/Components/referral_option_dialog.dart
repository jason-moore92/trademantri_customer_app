import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;

class ReferralOptionDialog {
  static show(
    BuildContext context, {
    @required GlobalKey<FormState>? formkey,
    Function? callback,
  }) async {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);

    var result = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 20),
          titlePadding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 30),
          title: Center(
            child: Text(
              'Refer A Store',
              style: TextStyle(fontSize: fontSp * 22, color: Colors.black),
            ),
          ),
          children: <Widget>[
            Column(
              children: [
                Text(
                  "You can refer a store in two ways",
                  style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: heightDp * 20),
                KeicyRaisedButton(
                  width: widthDp * 230,
                  height: heightDp * 40,
                  color: config.Colors().mainColor(1),
                  borderRadius: heightDp * 8,
                  child: Text(
                    "Enter Store Detail",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop("store_detail");
                  },
                ),
                SizedBox(height: heightDp * 10),
                Text(
                  "( OR )",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
                SizedBox(height: heightDp * 10),
                KeicyRaisedButton(
                  width: widthDp * 230,
                  height: heightDp * 40,
                  color: config.Colors().mainColor(1),
                  borderRadius: heightDp * 8,
                  child: Text(
                    "Share Your Referral Link",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop("referral_link");
                  },
                ),
                SizedBox(height: heightDp * 30),
              ],
            ),
          ],
        );
      },
    );

    return result;
  }
}
