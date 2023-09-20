import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;

class NewMessageDialog {
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
    text = "Something went wrong",
    bool barrierDismissible = true,
    @required Function(String)? callBack,
    int delaySecondes = 2,
  }) async {
    TextEditingController _controller = TextEditingController();
    FocusNode _focusNode = FocusNode();

    GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    var result = await showDialog(
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
            Center(
              child: Text(
                "New Message",
                style: TextStyle(fontSize: fontSp! * 20, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),

            ///
            SizedBox(height: heightDp * 20),
            Form(
              key: _formkey,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: TextFormField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(heightDp * 4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(heightDp * 4),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(heightDp * 4),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(heightDp * 4),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(heightDp * 4),
                    ),
                    errorStyle: TextStyle(fontSize: fontSp * 10, color: Colors.red),
                    errorMaxLines: 2,
                    contentPadding: EdgeInsets.symmetric(horizontal: widthDp! * 10, vertical: heightDp * 5),
                    isDense: true,
                  ),
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onChanged: (input) {},
                  validator: (input) => input!.isEmpty ? "Please enter a message" : null,
                ),
              ),
            ),

            ///
            SizedBox(height: heightDp * 20),

            SizedBox(height: heightDp * 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                KeicyRaisedButton(
                  width: widthDp * 100,
                  height: heightDp * 30,
                  color: config.Colors().mainColor(1),
                  borderRadius: heightDp * 6,
                  child: Text(
                    "Send",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                  ),
                  onPressed: () {
                    if (!_formkey.currentState!.validate()) return;
                    Navigator.of(context).pop();
                    if (callBack != null) {
                      callBack(_controller.text.trim());
                    }
                  },
                ),
              ],
            )
          ],
        );
      },
    );

    // if (result == null && cancelCallback != null) {
    //   cancelCallback();
    // }
  }
}
