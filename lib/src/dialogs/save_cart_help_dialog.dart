import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;

class SaveCartHelpDialog {
  static Future<void> show(
    BuildContext context, {
    @required String? oldStoreName,
    @required String? newStoreName,
    Function? saveCallback,
    Function? clearCallback,
  }) async {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          backgroundColor: Colors.white,
          builder: (context) {
            return Container(
              height: heightDp * 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: heightDp * 20),
                        Icon(Icons.shopping_cart_outlined, size: heightDp * 50),
                        SizedBox(height: heightDp * 20),
                        Text(
                          "Save or Clear Cart",
                          style: TextStyle(fontSize: fontSp * 22),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Your cart contains items from $oldStoreName. Do you want to clear the cart and add items from $newStoreName?",
                      style: TextStyle(fontSize: fontSp * 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        SizedBox(width: widthDp * 15),
                        Expanded(
                          child: KeicyRaisedButton(
                            height: heightDp * 40,
                            color: config.Colors().mainColor(1),
                            borderRadius: heightDp * 40,
                            child: Text(
                              "Save Cart",
                              style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        SizedBox(width: widthDp * 15),
                        Expanded(
                          child: KeicyRaisedButton(
                            height: heightDp * 40,
                            color: Colors.grey.withOpacity(0.6),
                            borderRadius: heightDp * 40,
                            child: Text(
                              "Clear Cart",
                              style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (clearCallback != null) {
                                clearCallback();
                              }
                            },
                          ),
                        ),
                        SizedBox(width: widthDp * 15),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
