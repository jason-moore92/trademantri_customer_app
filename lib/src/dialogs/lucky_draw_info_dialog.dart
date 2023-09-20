import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LuckyDrawInfoDialog {
  static show(
    BuildContext context, {
    EdgeInsets? insetPadding,
    EdgeInsets? titlePadding,
    EdgeInsets? contentPadding,
    double? borderRadius,
    Color? barrierColor,
    String text = "",
    bool barrierDismissible = false,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      // barrierColor: barrierColor,
      builder: (BuildContext context1) {
        return AlertDialog(
          title: Text("Luckydraw Info"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "1) How to participate : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          "No need to do anything more other than ordering your required items. As TradeMantri conducts various luckydraws, you will be participated automatically.",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "2) What are the prizes : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Prizes can be of two types one is some x percentage discount on your order paid amount and other is fixed amount.",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "3) How we get the prizes : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          "As of now, the amount you own via luckdraw will given as TradeMantri reward points that you may use them in furhur orders.",
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Close",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
