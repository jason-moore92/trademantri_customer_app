import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/helpers/helper.dart';
import 'package:trapp/src/helpers/validators.dart';
import 'package:trapp/src/models/contact_model.dart';
import 'package:trapp/src/models/user_model.dart';
import 'package:trapp/generated/l10n.dart';

class ContactDialog {
  static show(BuildContext context, UserModel userModel, {Function(ContactModel)? callback}) {
    GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);
    TextEditingController _nameController = TextEditingController(text: userModel.firstName! + " " + userModel.lastName!);
    TextEditingController _phoneController = TextEditingController(text: userModel.mobile);
    TextEditingController _emailController = TextEditingController(text: userModel.email);
    TextEditingController _reasonController = TextEditingController();
    FocusNode _nameFocusNode = FocusNode();
    FocusNode _phoneFocusNode = FocusNode();
    FocusNode _emailFocusNode = FocusNode();
    FocusNode _reasonFocusNode = FocusNode();

    ContactModel _contactModel = ContactModel();

    _contactModel.userId = userModel.id;
    _contactModel.name = _nameController.text.trim();
    _contactModel.phone = _phoneController.text.trim();
    _contactModel.email = _emailController.text.trim();

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
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
      );
    }

    void _submit() {
      if (_formkey.currentState!.validate()) {
        _formkey.currentState!.save();
        Navigator.pop(context);

        if (callback != null) {
          callback(_contactModel);
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 20),
          titlePadding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
          title: Row(
            children: <Widget>[
              Icon(Icons.info, size: heightDp * 20),
              SizedBox(width: heightDp * 10),
              Text(
                'Contact Us',
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
          children: <Widget>[
            Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  new TextFormField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    style: TextStyle(color: Theme.of(context).hintColor),
                    keyboardType: TextInputType.text,
                    decoration: getInputDecoration(labelText: 'Name'),
                    validator: (input) => input!.isEmpty ? S.of(context).should_be_a_name : null,
                    onFieldSubmitted: (input) {
                      FocusScope.of(context).requestFocus(_phoneFocusNode);
                    },
                    onSaved: (input) {
                      _contactModel.name = input!.trim();
                    },
                  ),
                  SizedBox(height: heightDp * 10),
                  new TextFormField(
                    controller: _phoneController,
                    focusNode: _phoneFocusNode,
                    style: TextStyle(color: Theme.of(context).hintColor),
                    keyboardType: TextInputType.phone,
                    decoration: getInputDecoration(hintText: '', labelText: 'Phone Number'),
                    validator: (input) => (input!.length != 10 || !isNumbers(input)) ? S.of(context).not_a_valid_phone : null,
                    onFieldSubmitted: (input) {
                      FocusScope.of(context).requestFocus(_emailFocusNode);
                    },
                    onSaved: (input) {
                      _contactModel.phone = input!.trim();
                    },
                  ),
                  SizedBox(height: heightDp * 10),
                  new TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    style: TextStyle(color: Theme.of(context).hintColor),
                    keyboardType: TextInputType.emailAddress,
                    decoration: getInputDecoration(hintText: '', labelText: 'email'),
                    validator: (input) => !KeicyValidators.isValidEmail(input!) ? S.of(context).should_be_a_valid_email : null,
                    onFieldSubmitted: (input) {
                      FocusScope.of(context).requestFocus(_reasonFocusNode);
                    },
                    onSaved: (input) {
                      _contactModel.email = input!.trim();
                    },
                  ),
                  SizedBox(height: heightDp * 10),
                  new TextFormField(
                    controller: _reasonController,
                    focusNode: _reasonFocusNode,
                    style: TextStyle(color: Theme.of(context).hintColor),
                    decoration: getInputDecoration(hintText: '', labelText: 'Reason'),
                    validator: (input) => input!.length < 8 ? S.of(context).should_be_contact_reason : null,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.left,
                    onFieldSubmitted: (input) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    onSaved: (input) {
                      _contactModel.reason = input!.trim();
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
        );
      },
    );
  }
}
