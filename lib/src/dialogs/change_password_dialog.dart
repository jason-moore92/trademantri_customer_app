import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/generated/l10n.dart';
import 'package:trapp/src/helpers/helper.dart';

class ChangePasswordDialog {
  static show(BuildContext context, {Function(String, String)? callback}) {
    GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);
    TextEditingController _oldPasswordController = TextEditingController();
    TextEditingController _newPasswordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();
    FocusNode _oldPasswordFocusNode = FocusNode();
    FocusNode _newPasswordFocusNode = FocusNode();
    FocusNode _confirmPasswordFocusNode = FocusNode();
    bool _oldPasswordObscure = true;
    bool _newPasswordObscure = true;
    bool _confirmPasswordObscure = true;

    InputDecoration getInputDecoration({
      String? hintText,
      String? labelText,
      bool? obscure,
      Function()? suffixPress,
    }) {
      return new InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: Theme.of(context).textTheme.bodyText2!.merge(
              TextStyle(color: Theme.of(context).focusColor),
            ),
        errorMaxLines: 2,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.3))),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.8))),
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).errorColor.withOpacity(0.3))),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).errorColor.withOpacity(0.8))),
        labelStyle: Theme.of(context).textTheme.bodyText2!.merge(
              TextStyle(color: Theme.of(context).hintColor),
            ),
        contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 0),
        suffixIcon: IconButton(
          onPressed: suffixPress,
          color: Colors.grey,
          icon: Icon(
            obscure! ? Icons.visibility_off : Icons.remove_red_eye,
          ),
        ),
      );
    }

    void _submit() {
      if (_profileSettingsFormKey.currentState!.validate()) {
        _profileSettingsFormKey.currentState!.save();
        Navigator.pop(context);

        if (callback != null) {
          callback(_oldPasswordController.text.trim(), _newPasswordController.text.trim());
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              titlePadding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
              title: Row(
                children: <Widget>[
                  Icon(Icons.person, size: heightDp * 20),
                  SizedBox(width: heightDp * 10),
                  Text(
                    'Change Password',
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          controller: _oldPasswordController,
                          focusNode: _oldPasswordFocusNode,
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                            labelText: 'Old Password',
                            obscure: _oldPasswordObscure,
                            suffixPress: () {
                              _oldPasswordObscure = !_oldPasswordObscure;
                              setState(() {});
                            },
                          ),
                          obscureText: _oldPasswordObscure,
                          validator: (input) => input!.length < 8 ? S.of(context).should_password_input : null,
                          onFieldSubmitted: (input) {
                            FocusScope.of(context).requestFocus(_newPasswordFocusNode);
                          },
                        ),
                        SizedBox(height: heightDp * 10),
                        new TextFormField(
                          controller: _newPasswordController,
                          focusNode: _newPasswordFocusNode,
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          obscureText: _newPasswordObscure,
                          decoration: getInputDecoration(
                            hintText: '',
                            labelText: 'New Password',
                            obscure: _newPasswordObscure,
                            suffixPress: () {
                              _newPasswordObscure = !_newPasswordObscure;
                              setState(() {});
                            },
                          ),
                          validator: (input) => !passwordValidation(input!) || input.length < 8
                              ? S.of(context).should_password_input
                              : (_newPasswordController.text != _confirmPasswordController.text)
                                  ? S.of(context).should_password_match
                                  : null,
                          onFieldSubmitted: (input) {
                            FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
                          },
                        ),
                        SizedBox(height: heightDp * 10),
                        new TextFormField(
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocusNode,
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          obscureText: _confirmPasswordObscure,
                          decoration: getInputDecoration(
                            hintText: '',
                            labelText: 'Confirm Password',
                            obscure: _confirmPasswordObscure,
                            suffixPress: () {
                              _confirmPasswordObscure = !_confirmPasswordObscure;
                              setState(() {});
                            },
                          ),
                          validator: (input) => !passwordValidation(input!) || input.length < 8
                              ? S.of(context).should_password_input
                              : (_newPasswordController.text != _confirmPasswordController.text)
                                  ? S.of(context).should_password_match
                                  : null,
                          onFieldSubmitted: (input) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
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
              ),
            );
          },
        );
      },
    );
  }
}
