import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/generated/l10n.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/helpers/helper.dart';

class ReferralStoreDetailDialog {
  static show(
    BuildContext context, {
    @required GlobalKey<FormState>? formkey,
    Function? callback,
  }) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);

    TextEditingController _storeNameController = TextEditingController();
    TextEditingController _storeMobileController = TextEditingController();
    TextEditingController _storeAddressController = TextEditingController();

    FocusNode _storeNameFocusNode = FocusNode();
    FocusNode _storeMobileFocusNode = FocusNode();
    FocusNode _storeAddressFocusNode = FocusNode();

    void referHandler() {
      if (!formkey!.currentState!.validate()) return;
      Map<String, dynamic> storeData = {
        "storeName": _storeNameController.text.trim(),
        "storeMobile": _storeMobileController.text.trim(),
        "storeAddress": _storeAddressController.text.trim(),
      };

      Navigator.of(context).pop();

      callback!(storeData);
    }

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 20),
          titlePadding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 30),
          title: Center(
            child: Text(
              'Enter Store Detail',
              style: TextStyle(fontSize: fontSp * 22, color: Colors.black),
            ),
          ),
          children: <Widget>[
            Form(
              key: formkey,
              child: Column(
                children: [
                  Text(
                    "Ask store to register using below phone number",
                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),

                  ///
                  SizedBox(height: heightDp * 20),
                  KeicyTextFormField(
                    controller: _storeNameController,
                    focusNode: _storeNameFocusNode,
                    width: double.infinity,
                    height: heightDp * 40,
                    border: Border.all(color: Colors.grey.withOpacity(0.7)),
                    errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                    borderRadius: heightDp * 8,
                    label: "Store Name",
                    labelSpacing: heightDp * 5,
                    labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    contentHorizontalPadding: widthDp * 10,
                    validatorHandler: (input) => input.trim().isEmpty ? "please enter the store name" : null,
                    onEditingCompleteHandler: () {
                      FocusScope.of(context).requestFocus(_storeMobileFocusNode);
                    },
                  ),

                  ///
                  SizedBox(height: heightDp * 10),
                  KeicyTextFormField(
                    controller: _storeMobileController,
                    focusNode: _storeMobileFocusNode,
                    width: double.infinity,
                    height: heightDp * 40,
                    border: Border.all(color: Colors.grey.withOpacity(0.7)),
                    errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                    borderRadius: heightDp * 8,
                    label: "Store Mobile",
                    labelSpacing: heightDp * 5,
                    labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    keyboardType: TextInputType.phone,
                    contentHorizontalPadding: widthDp * 10,
                    validatorHandler: (input) => (input.length != 10 || !isNumbers(input)) ? S.of(context).not_a_valid_phone : null,
                    onEditingCompleteHandler: () {
                      FocusScope.of(context).requestFocus(_storeAddressFocusNode);
                    },
                  ),

                  ///
                  SizedBox(height: heightDp * 10),
                  KeicyTextFormField(
                    controller: _storeAddressController,
                    focusNode: _storeAddressFocusNode,
                    width: double.infinity,
                    height: heightDp * 50,
                    border: Border.all(color: Colors.grey.withOpacity(0.7)),
                    errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                    borderRadius: heightDp * 8,
                    label: "Store Address",
                    labelSpacing: heightDp * 5,
                    labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    contentHorizontalPadding: widthDp * 10,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    validatorHandler: (input) => input.trim().isEmpty ? "please enter the store address" : null,
                    onEditingCompleteHandler: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),

                  ///
                  SizedBox(height: heightDp * 10),
                  KeicyRaisedButton(
                    width: widthDp * 230,
                    height: heightDp * 40,
                    color: config.Colors().mainColor(1),
                    borderRadius: heightDp * 8,
                    child: Text(
                      "Refer",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                    ),
                    onPressed: referHandler,
                  ),
                  SizedBox(height: heightDp * 30),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
