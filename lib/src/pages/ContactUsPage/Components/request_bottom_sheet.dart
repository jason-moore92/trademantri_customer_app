import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';
import 'package:trapp/generated/l10n.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/success_dialog.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/helpers/validators.dart';
import 'package:trapp/src/providers/index.dart';

class RequestBottomSheet {
  static show(BuildContext context) async {
    /// Responsive design variables
    double deviceWidth;
    double deviceHeight;
    double statusbarHeight;
    double widthDp;
    double heightDp;
    double fontSp;
    ///////////////////////////////

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    TextEditingController _nameController = TextEditingController();
    TextEditingController _mobileController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _addressController = TextEditingController();
    TextEditingController _titleController = TextEditingController();
    TextEditingController _descController = TextEditingController();

    FocusNode _nameFocusNode = FocusNode();
    FocusNode _mobileFocusNode = FocusNode();
    FocusNode _emailFocusNode = FocusNode();
    FocusNode _addressFocusNode = FocusNode();
    FocusNode _titleFocusNode = FocusNode();
    FocusNode _descFocusNode = FocusNode();

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    double fieldHeight = heightDp * 40;
    double labelSpacing = heightDp * 5;
    double borderRadius = heightDp * 6;
    TextStyle labelStyle = TextStyle(fontSize: fontSp * 14, color: Colors.black);
    TextStyle textStyle = TextStyle(fontSize: fontSp * 14, color: Colors.black);
    TextStyle hintStyle = TextStyle(fontSize: fontSp * 14, color: Colors.grey);

    ContactUsRequestProvider _contactUsRequestProvider = ContactUsRequestProvider.of(context);
    KeicyProgressDialog _keicyProgressDialog = KeicyProgressDialog.of(context);
    Map<String, dynamic> _contactUsRequestData = Map<String, dynamic>();

    void _sendRequestHandler() async {
      if (!_formKey.currentState!.validate()) return;

      _contactUsRequestData["userId"] = AuthProvider.of(context).authState.userModel!.id;
      await _keicyProgressDialog.show();

      _contactUsRequestProvider.addContactUsRequest(contactUsRequestData: _contactUsRequestData);
    }

    void _contactUsRequestProviderListener() async {
      if (_contactUsRequestProvider.contactUsRequestState.progressState != 1 && _keicyProgressDialog.isShowing()) {
        await _keicyProgressDialog.hide();
      }

      if (_contactUsRequestProvider.contactUsRequestState.progressState == 2) {
        Navigator.of(context).pop();

        SuccessDialog.show(
          context,
          heightDp: heightDp,
          fontSp: fontSp,
        );
      }
      if (_contactUsRequestProvider.contactUsRequestState.progressState == -1) {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: _contactUsRequestProvider.contactUsRequestState.message!,
          callBack: _sendRequestHandler,
        );
      }
    }

    _contactUsRequestProvider.addListener(_contactUsRequestProviderListener);

    var result = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          elevation: 0,
          children: [
            KeyboardAware(builder: (context, keyboardConfig) {
              return Container(
                width: deviceWidth,
                height: deviceHeight - statusbarHeight - (keyboardConfig.isKeyboardOpen ? keyboardConfig.keyboardHeight : 0),
                decoration: BoxDecoration(color: Colors.transparent),
                alignment: Alignment.bottomCenter,
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (notification) {
                    notification.disallowGlow();
                    return true;
                  },
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(heightDp * 20),
                                topRight: Radius.circular(heightDp * 20),
                              ),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Send a Request",
                                  style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                                ),

                                ///
                                SizedBox(height: heightDp * 15),
                                KeicyTextFormField(
                                  controller: _nameController,
                                  focusNode: _nameFocusNode,
                                  width: double.infinity,
                                  height: fieldHeight,
                                  border: Border.all(color: Colors.grey.withOpacity(0.8)),
                                  errorBorder: Border.all(color: Colors.red.withOpacity(0.8)),
                                  borderRadius: borderRadius,
                                  label: "Name",
                                  labelStyle: labelStyle,
                                  labelSpacing: labelSpacing,
                                  textStyle: textStyle,
                                  hintStyle: hintStyle,
                                  hintText: "Name",
                                  onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_mobileFocusNode),
                                  onChangeHandler: (input) => _contactUsRequestData["name"] = input.trim(),
                                  validatorHandler: (input) => input.length < 3 ? "Please enter a name" : null,
                                  onSaveHandler: (input) => _contactUsRequestData["name"] = input.trim(),
                                ),

                                ///
                                SizedBox(height: heightDp * 15),
                                KeicyTextFormField(
                                  controller: _mobileController,
                                  focusNode: _mobileFocusNode,
                                  width: double.infinity,
                                  height: fieldHeight,
                                  border: Border.all(color: Colors.grey.withOpacity(0.8)),
                                  errorBorder: Border.all(color: Colors.red.withOpacity(0.8)),
                                  borderRadius: borderRadius,
                                  label: "Mobile",
                                  labelStyle: labelStyle,
                                  labelSpacing: labelSpacing,
                                  textStyle: textStyle,
                                  hintStyle: hintStyle,
                                  hintText: "Mobile",
                                  keyboardType: TextInputType.number,
                                  onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_emailFocusNode),
                                  onChangeHandler: (input) => _contactUsRequestData["phone"] = input.trim(),
                                  validatorHandler: (input) => input.length != 10 ? "Please enter 10 digits" : null,
                                  onSaveHandler: (input) => _contactUsRequestData["phone"] = input.trim(),
                                ),

                                ///
                                SizedBox(height: heightDp * 15),
                                KeicyTextFormField(
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  width: double.infinity,
                                  height: fieldHeight,
                                  border: Border.all(color: Colors.grey.withOpacity(0.8)),
                                  errorBorder: Border.all(color: Colors.red.withOpacity(0.8)),
                                  borderRadius: borderRadius,
                                  label: "Email",
                                  labelStyle: labelStyle,
                                  labelSpacing: labelSpacing,
                                  textStyle: textStyle,
                                  hintStyle: hintStyle,
                                  hintText: "Email",
                                  keyboardType: TextInputType.emailAddress,
                                  onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_addressFocusNode),
                                  onChangeHandler: (input) => _contactUsRequestData["email"] = input.trim(),
                                  validatorHandler: (input) => !KeicyValidators.isValidEmail(input) ? S.of(context).should_be_a_valid_email : null,
                                  onSaveHandler: (input) => _contactUsRequestData["email"] = input.trim(),
                                ),

                                ///
                                SizedBox(height: heightDp * 15),
                                KeicyTextFormField(
                                  controller: _addressController,
                                  focusNode: _addressFocusNode,
                                  width: double.infinity,
                                  height: fieldHeight,
                                  border: Border.all(color: Colors.grey.withOpacity(0.8)),
                                  errorBorder: Border.all(color: Colors.red.withOpacity(0.8)),
                                  borderRadius: borderRadius,
                                  label: "Address",
                                  labelStyle: labelStyle,
                                  labelSpacing: labelSpacing,
                                  textStyle: textStyle,
                                  hintStyle: hintStyle,
                                  hintText: "Address",
                                  onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_titleFocusNode),
                                  onChangeHandler: (input) => _contactUsRequestData["address"] = input.trim(),
                                  onSaveHandler: (input) => _contactUsRequestData["address"] = input.trim(),
                                ),

                                ///
                                SizedBox(height: heightDp * 15),
                                KeicyTextFormField(
                                  controller: _titleController,
                                  focusNode: _titleFocusNode,
                                  width: double.infinity,
                                  height: fieldHeight,
                                  border: Border.all(color: Colors.grey.withOpacity(0.8)),
                                  errorBorder: Border.all(color: Colors.red.withOpacity(0.8)),
                                  borderRadius: borderRadius,
                                  label: "Request Title",
                                  labelStyle: labelStyle,
                                  labelSpacing: labelSpacing,
                                  textStyle: textStyle,
                                  hintStyle: hintStyle,
                                  hintText: "Request Title",
                                  onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_descFocusNode),
                                  onChangeHandler: (input) => _contactUsRequestData["title"] = input.trim(),
                                  validatorHandler: (input) => input.length < 3 ? "Please enter a request title" : null,
                                  onSaveHandler: (input) => _contactUsRequestData["title"] = input.trim(),
                                ),

                                ///
                                SizedBox(height: heightDp * 15),
                                KeicyTextFormField(
                                  controller: _descController,
                                  focusNode: _descFocusNode,
                                  width: double.infinity,
                                  height: fieldHeight * 2.5,
                                  border: Border.all(color: Colors.grey.withOpacity(0.8)),
                                  errorBorder: Border.all(color: Colors.red.withOpacity(0.8)),
                                  borderRadius: borderRadius,
                                  label: "Request Description",
                                  labelStyle: labelStyle,
                                  labelSpacing: labelSpacing,
                                  textStyle: textStyle,
                                  hintStyle: hintStyle,
                                  hintText: "Request Description",
                                  textAlign: TextAlign.left,
                                  maxLines: null,
                                  textInputAction: TextInputAction.newline,
                                  keyboardType: TextInputType.multiline,
                                  onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                                  onChangeHandler: (input) => _contactUsRequestData["message"] = input.trim(),
                                  validatorHandler: (input) => input.length < 5 ? "Please enter a request description" : null,
                                  onSaveHandler: (input) => _contactUsRequestData["message"] = input.trim(),
                                ),

                                ///
                                SizedBox(height: heightDp * 15),
                                KeicyRaisedButton(
                                  width: double.infinity,
                                  height: fieldHeight,
                                  color: config.Colors().mainColor(1),
                                  borderRadius: heightDp * 10,
                                  child: Text(
                                    "Send Request",
                                    style: textStyle.copyWith(fontSize: fontSp * 18, color: Colors.white),
                                  ),
                                  onPressed: _sendRequestHandler,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })
          ],
        );
      },
    );

    _contactUsRequestProvider.removeListener(_contactUsRequestProviderListener);
  }
}
