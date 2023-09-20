import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;

class PaymentFailedDialog {
  static show(
    BuildContext context, {
    @required double? heightDp,
    @required double? fontSp,
    EdgeInsets? insetPadding,
    EdgeInsets? titlePadding,
    EdgeInsets? contentPadding,
    double? borderRadius,
    Color? barrierColor,
    bool? barrierDismissible = false,
    int? delaySecondes = 3,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible!,
      // barrierColor: barrierColor ?? Colors.black.withOpacity(0.3),
      builder: (BuildContext context1) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp! * 10)),
          title: Icon(Icons.check_circle, size: heightDp * 60, color: Colors.red),
          titlePadding: EdgeInsets.only(
            left: heightDp * 10,
            right: heightDp * 10,
            top: heightDp * 20,
            bottom: heightDp * 5,
          ),
          contentPadding: EdgeInsets.only(
            left: heightDp * 10,
            right: heightDp * 10,
            top: heightDp * 5,
            bottom: heightDp * 20,
          ),
          children: [
            Text(
              "Payment Failed!",
              style: TextStyle(fontSize: fontSp! * 20, color: Colors.black, height: 1.5, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: heightDp * 30),
            Text(
              "Something was wrong",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: heightDp * 30),
            Center(
              child: KeicyRaisedButton(
                width: heightDp * 120,
                height: heightDp * 35,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 6,
                child: Text("OK", style: TextStyle(fontSize: fontSp * 16, color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
    // Future.delayed(Duration(seconds: delaySecondes), () {
    //   Navigator.of(context).pop();
    // });
  }
}
