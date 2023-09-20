import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/keicy_rating_bar.dart';
import 'package:trapp/config/app_config.dart' as config;

class ReviewAndRatingDialog {
  static show(BuildContext context, Map<String, dynamic> reviewAndRating, {Function(Map<String, dynamic>)? callback}) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    reviewAndRating = json.decode(json.encode(reviewAndRating));
    double ratingValue = reviewAndRating["rating"] == null ? 0 : reviewAndRating["rating"].toDouble();

    TextEditingController _titleController = TextEditingController(text: reviewAndRating["title"] ?? "");
    TextEditingController _reviewController = TextEditingController(text: reviewAndRating["review"] ?? "");
    FocusNode _titleFocusNode = FocusNode();
    FocusNode _reviewFocusNode = FocusNode();

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
        alignLabelWithHint: true,
        labelStyle: Theme.of(context).textTheme.bodyText2!.merge(
              TextStyle(color: Theme.of(context).hintColor),
            ),
        contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 15),
          titlePadding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
          title: Row(
            children: <Widget>[
              Image.asset(
                "img/reviews-icon.png",
                width: heightDp * 30,
                height: heightDp * 30,
              ),
              SizedBox(width: heightDp * 10),
              Text(
                reviewAndRating.isEmpty ? 'Add Review' : "Edit Review",
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                          color: Colors.yellow,
                        ),
                        halfStarThreshold: 0.5,
                        onRated: (value) {
                          ratingValue = value;
                        },
                      ),
                    ],
                  ),

                  ///
                  SizedBox(height: heightDp * 20),
                  TextFormField(
                    controller: _titleController,
                    focusNode: _titleFocusNode,
                    style: TextStyle(color: Theme.of(context).hintColor),
                    decoration: getInputDecoration(labelText: "Title"),
                    textAlign: TextAlign.left,
                    validator: (input) => input!.isEmpty ? "Please input title" : null,
                    onFieldSubmitted: (input) {
                      FocusScope.of(context).requestFocus(_reviewFocusNode);
                    },
                  ),

                  SizedBox(height: heightDp * 20),
                  TextFormField(
                    controller: _reviewController,
                    focusNode: _reviewFocusNode,
                    style: TextStyle(color: Theme.of(context).hintColor),
                    decoration: getInputDecoration(labelText: "Review"),
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.left,
                    validator: (input) => input!.isEmpty ? "Please input review" : null,
                    onFieldSubmitted: (input) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),

                  ///
                  SizedBox(height: heightDp * 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton(
                        color: config.Colors().mainColor(1),
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;

                          Navigator.of(context).pop();
                          if (callback != null) {
                            reviewAndRating["rating"] = ratingValue;
                            reviewAndRating["title"] = _titleController.text.trim();
                            reviewAndRating["review"] = _reviewController.text.trim();
                            callback(reviewAndRating);
                          }
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                        ),
                      ),
                      FlatButton(
                        color: Colors.grey.withOpacity(0.4),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: fontSp * 14),
                        ),
                      ),
                    ],
                  ),

                  ///
                  SizedBox(height: heightDp * 20),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
