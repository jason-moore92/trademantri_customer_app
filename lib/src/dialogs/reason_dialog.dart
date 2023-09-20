import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/providers/RefreshProvider/refresh_provider.dart';

class ReasonDialog {
  static show(
    BuildContext context, {
    @required String? tilte,
    @required String? content,
    Function? callback,
  }) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);

    showDialog(
      context: context,
      builder: (context) {
        TextEditingController _controller = TextEditingController();

        return SimpleDialog(
          title: Text(
            tilte!,
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Column(
                children: [
                  Text(
                    content!,
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: heightDp * 20),
                  Row(
                    children: [
                      Text(
                        "Reason",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: heightDp * 10),
                  KeicyTextFormField(
                    controller: _controller,
                    width: double.infinity,
                    height: heightDp * 100,
                    border: Border.all(color: Colors.grey.withOpacity(0.7)),
                    textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxHeight: null,
                    onChangeHandler: (input) {
                      RefreshProvider.of(context).refresh();
                    },
                  ),
                  SizedBox(height: heightDp * 20),
                  Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FlatButton(
                          onPressed: () {
                            if (_controller.text.isEmpty) return;
                            Navigator.of(context).pop();
                            if (callback != null) callback(_controller.text);
                          },
                          color: _controller.text.isEmpty ? Colors.grey.withOpacity(0.6) : config.Colors().mainColor(1),
                          child: Text(
                            "OK",
                            style: TextStyle(fontSize: fontSp * 14, color: _controller.text.isEmpty ? Colors.black : Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
