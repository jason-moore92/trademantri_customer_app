import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';

class ProfileSettingsDialog extends StatefulWidget {
  UserModel? userModel;
  Function? onChanged;

  ProfileSettingsDialog({Key? key, this.userModel, this.onChanged}) : super(key: key);

  @override
  _ProfileSettingsDialogState createState() => _ProfileSettingsDialogState();
}

class _ProfileSettingsDialogState extends State<ProfileSettingsDialog> {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();
  String? oldMobile;
  final dobController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.userModel!.dob != null) {
      dobController.text = widget.userModel!.dob!;
    }
  }

  @override
  Widget build(BuildContext context) {
    oldMobile = widget.userModel!.mobile;

    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                      'Profile Settings',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: 'John Doe', labelText: 'First Name'),
                          initialValue: widget.userModel!.firstName,
                          validator: (input) => input!.trim().length < 3 ? 'Not a valid first name' : null,
                          onSaved: (input) => widget.userModel!.firstName = input!.trim(),
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: 'John Doe', labelText: 'Last Name'),
                          initialValue: widget.userModel!.lastName,
                          validator: (input) => input!.trim().length < 3 ? 'Not a valid last name' : null,
                          onSaved: (input) => widget.userModel!.lastName = input!.trim(),
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          enabled: false,
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration(hintText: '123445', labelText: 'Phone Number'),
                          initialValue: widget.userModel!.mobile,
                          validator: (input) => input!.trim().length != 10 ? 'Please enter 10 numbers' : null,
                          onSaved: (input) => widget.userModel!.mobile = input!.trim(),
                        ),
                        new TextFormField(
                          controller: dobController,
                          style: TextStyle(color: Theme.of(context).hintColor),
                          decoration: getInputDecoration(hintText: '1992-04-12', labelText: 'Date of Birth'),
                          // initialValue: widget.userModel!.dob,
                          readOnly: true,
                          onTap: () async {
                            DateTime initialDate = DateTime(DateTime.now().year - 10, 12, 31);
                            if (widget.userModel!.dob != null) {
                              DateTime? resInitialDate = KeicyDateTime.convertDateStringToDateTime(dateString: widget.userModel!.dob, isUTC: false);
                              if (resInitialDate != null) {
                                initialDate = resInitialDate;
                              }
                            }
                            DateTime? selecteDate = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime(DateTime.now().year - 100, 1, 1),
                              lastDate: DateTime(DateTime.now().year - 10, 12, 31),
                            );

                            if (selecteDate == null) return;

                            dobController.text = KeicyDateTime.convertDateTimeToDateString(
                              dateTime: selecteDate,
                              isUTC: false,
                            );

                            widget.userModel!.dob = dobController.text;

                            setState(() {});
                          },
                          // validator: (input) => input!.trim().length != 10 ? 'Please enter 10 numbers' : null,
                          // onSaved: (input) => widget.userModel!.mobile = input!.trim(),
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
                      SizedBox(width: 20),
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
            });
      },
      child: Text(
        "Edit",
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  InputDecoration getInputDecoration({String? hintText, String? labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2!.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
      labelStyle: Theme.of(context).textTheme.bodyText2!.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    if (_profileSettingsFormKey.currentState!.validate()) {
      _profileSettingsFormKey.currentState!.save();
      Navigator.pop(context);
      widget.onChanged!(widget.userModel);
    }
  }
}
