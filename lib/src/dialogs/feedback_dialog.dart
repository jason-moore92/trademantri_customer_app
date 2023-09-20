import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trapp/src/elements/keicy_rating_bar.dart';

class FeedbackDialog {
  static show(
    BuildContext context, {
    double ratingValue = 0.0,
    String feedbackText = "",
    Function(double, String)? callback,
  }) {
    GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);
    TextEditingController _controller = TextEditingController(text: feedbackText);
    FocusNode _focusNode = FocusNode();

    InputDecoration getInputDecoration({String? hintText, String? labelText}) {
      return new InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: Theme.of(context).textTheme.bodyText2!.merge(
              TextStyle(color: Theme.of(context).focusColor),
            ),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.3))),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.8))),
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).errorColor.withOpacity(0.3))),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).errorColor.withOpacity(0.8))),
        labelStyle: Theme.of(context).textTheme.bodyText2!.merge(
              TextStyle(color: Theme.of(context).hintColor),
            ),
        contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
      );
    }

    void _submit() {
      if (_formkey.currentState!.validate()) {
        if (ratingValue == 0.0) {
          Fluttertoast.showToast(msg: "Please rate and click save.");
          return;
        }
        _formkey.currentState!.save();
        Navigator.pop(context);

        if (callback != null) {
          callback(ratingValue, _controller.text.trim());
        }
      }
    }

    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 20),
          titlePadding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
          title: Row(
            children: <Widget>[
              Icon(Icons.person, size: heightDp * 20),
              SizedBox(width: heightDp * 10),
              Text(
                'Feedback',
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
          children: <Widget>[
            Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      KeicyRatingBar(
                        size: heightDp * 30,
                        spacing: widthDp * 10,
                        allowHalfRating: false,
                        rating: ratingValue,
                        defaultIconData: Icon(
                          Icons.star,
                          size: heightDp * 30,
                          color: Colors.grey.withOpacity(0.6),
                        ),
                        filledIconData: Icon(
                          Icons.star,
                          size: heightDp * 30,
                          color: Color(0xFF10FFED),
                        ),
                        halfStarThreshold: 0.5,
                        onRated: (value) {
                          ratingValue = value;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: heightDp * 20),
                  new TextFormField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: TextStyle(color: Theme.of(context).hintColor),
                    decoration: getInputDecoration(),
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                MaterialButton(
                  onPressed: _submit,
                  child: Text(
                    'Save',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
