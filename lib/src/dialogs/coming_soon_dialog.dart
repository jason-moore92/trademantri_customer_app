import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComingSoonDialog {
  static show(
    BuildContext context,
  ) {
    double heightDp = ScreenUtil().setHeight(1);
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Image.asset(
              "img/ComingSoon.png",
              width: heightDp * 200,
              height: heightDp * 200,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
