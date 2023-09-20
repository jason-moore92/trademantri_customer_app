import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdditionalChatComponentsDialog {
  static Future<String?> show(BuildContext context) async {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);

    var result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(heightDp * 8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(heightDp * 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, size: heightDp * 20, color: Colors.black),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Text(
                          "Contents and Tools",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, size: heightDp * 20, color: Colors.transparent),
                          onPressed: null,
                        ),
                      ],
                    ),
                  ),

                  // ///
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.of(context).pop("Invoice");
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.all(heightDp * 10.0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: <Widget>[
                  //         Transform.rotate(
                  //           angle: pi / 4,
                  //           child: Icon(
                  //             Icons.link,
                  //             color: Colors.black.withOpacity(0.7),
                  //             size: heightDp * 25.0,
                  //           ),
                  //         ),
                  //         SizedBox(width: widthDp * 10.0),
                  //         Text(
                  //           "Create Invoice",
                  //           style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  ///
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.5), indent: widthDp * 10, endIndent: widthDp * 10),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop("photo");
                    },
                    child: Container(
                      padding: EdgeInsets.all(heightDp * 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.photo_outlined, color: Colors.black.withOpacity(0.7), size: heightDp * 25),
                          SizedBox(width: widthDp * 10.0),
                          Text(
                            "Photo",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.5), indent: widthDp * 10, endIndent: widthDp * 10),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop("file");
                    },
                    child: Container(
                      padding: EdgeInsets.all(heightDp * 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Transform.rotate(
                            angle: -pi / 2,
                            child: Icon(Icons.note_outlined, color: Colors.black.withOpacity(0.7), size: heightDp * 25),
                          ),
                          SizedBox(width: widthDp * 10.0),
                          Text(
                            "File",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );

    return result;
  }
}
