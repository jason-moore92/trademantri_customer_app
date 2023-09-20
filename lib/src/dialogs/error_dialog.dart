import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;

class ErrorDialog {
  static show(
    BuildContext context, {
    @required double? widthDp,
    @required double? heightDp,
    @required double? fontSp,
    EdgeInsets? insetPadding,
    EdgeInsets? titlePadding,
    EdgeInsets? contentPadding,
    double? borderRadius,
    Color? barrierColor,
    String text = "Something went wrong",
    String traceId = "",
    bool barrierDismissible = false,
    Function? callBack,
    Function? cancelCallback,
    int delaySecondes = 2,
    bool isTryButton = false,
  }) async {
    isTryButton = false;
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      // barrierColor: barrierColor,
      builder: (BuildContext context1) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.white,
          insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp! * 10)),
          titlePadding: titlePadding ?? EdgeInsets.zero,
          contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: widthDp! * 20, vertical: heightDp * 20),
          children: [
            Transform.rotate(
              angle: pi / 4,
              child: Icon(
                Icons.add_circle,
                size: heightDp * 60,
                color: Colors.redAccent,
              ),
            ),
            SizedBox(height: heightDp * 20),
            Text(
              text,
              style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: heightDp * 20),
            isTryButton
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      KeicyRaisedButton(
                        width: heightDp * 100,
                        height: heightDp * 40,
                        color: config.Colors().mainColor(1),
                        borderRadius: heightDp * 6,
                        padding: EdgeInsets.symmetric(horizontal: widthDp! * 5),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          // if (callBack != null) {
                          //   callBack();
                          // }
                        },
                        child: Text(
                          'Try again',
                          style: TextStyle(color: Colors.white, fontSize: fontSp * 14),
                        ),
                      ),
                      SizedBox(width: widthDp * 15),
                      KeicyRaisedButton(
                        width: heightDp * 100,
                        height: heightDp * 40,
                        borderRadius: heightDp * 6,
                        color: Colors.white,
                        borderColor: Colors.grey.withOpacity(0.6),
                        borderWidth: 1,
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          if (cancelCallback != null) cancelCallback();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black, fontSize: fontSp * 14),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: KeicyRaisedButton(
                      width: heightDp * 100,
                      height: heightDp * 40,
                      color: config.Colors().mainColor(1),
                      borderRadius: heightDp * 6,
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        // if (callBack != null) {
                        //   callBack();
                        // }
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.white, fontSize: fontSp * 14),
                      ),
                    ),
                  ),
            if (traceId != "")
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  top: heightDp * 16.0,
                  // bottom: heightDp * 16.0,
                ),
                child: InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                      text: traceId,
                    ));
                    Fluttertoast.showToast(
                      msg: "trace Id is copied.",
                      backgroundColor: Colors.red,
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  },
                  child: Text(
                    traceId,
                  ),
                ),
              ),
            // FutureBuilder(
            //   future: SharedPreferences.getInstance(),
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) {
            //       return Container();
            //     }

            //     SharedPreferences prefs = snapshot.data as SharedPreferences;

            //     if (!prefs.containsKey('session_id')) {
            //       return Container();
            //     }
            //     String? sessionId = prefs.getString('session_id');
            //     if (sessionId == null) {
            //       return Container();
            //     }
            //     return Container(
            //       alignment: Alignment.center,
            //       padding: EdgeInsets.only(
            //         top: heightDp * 16.0,
            //       ),
            //       child: InkWell(
            //         onTap: () {
            //           Clipboard.setData(
            //             ClipboardData(
            //               text: traceId,
            //             ),
            //           );
            //           Fluttertoast.showToast(
            //             msg: "Report Id is copied.",
            //             backgroundColor: Colors.red,
            //             toastLength: Toast.LENGTH_SHORT,
            //           );
            //         },
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Text("Report Id:"),
            //             SizedBox(
            //               height: 8.0,
            //             ),
            //             Text(
            //               "$sessionId",
            //             ),
            //           ],
            //         ),
            //       ),
            //     );
            //   },
            // ),
          ],
        );
      },
    );

    // if (result == null && cancelCallback != null) {
    //   cancelCallback();
    // }
  }
}
