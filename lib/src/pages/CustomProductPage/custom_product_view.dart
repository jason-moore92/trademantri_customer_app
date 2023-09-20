import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trapp/src/elements/keicy_checkbox.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/config/app_config.dart' as config;

class CustomProductView extends StatefulWidget {
  final Function(String, Map<String, dynamic>)? callback;

  CustomProductView({Key? key, this.callback}) : super(key: key);

  @override
  _CustomProductViewState createState() => _CustomProductViewState();
}

class _CustomProductViewState extends State<CustomProductView> with SingleTickerProviderStateMixin {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();

  Map<String, dynamic> productItemData = Map<String, dynamic>();

  bool isProduct = true;

  ImagePicker picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveHandler() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    productItemData["imageFile"] = _imageFile;

    widget.callback!(isProduct ? "products" : "services", productItemData);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Custom Product / Service",
          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: deviceWidth,
          height: deviceHeight - statusbarHeight - appbarHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 30, vertical: heightDp * 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ///
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            KeicyCheckBox(
                              iconSize: heightDp * 20,
                              iconColor: config.Colors().mainColor(1),
                              value: isProduct,
                              label: "Product",
                              labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              onChangeHandler: (value) {
                                if (value) {
                                  isProduct = true;
                                } else {
                                  isProduct = false;
                                }
                                setState(() {});
                              },
                            ),
                            KeicyCheckBox(
                              iconSize: heightDp * 20,
                              iconColor: config.Colors().mainColor(1),
                              value: !isProduct,
                              label: "Service",
                              labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              onChangeHandler: (value) {
                                if (value) {
                                  isProduct = false;
                                } else {
                                  isProduct = true;
                                }
                                setState(() {});
                              },
                            )
                          ],
                        ),

                        ///
                        SizedBox(height: heightDp * 15),
                        KeicyTextFormField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          width: double.infinity,
                          height: heightDp * 35,
                          border: Border.all(color: Colors.grey.withOpacity(0.7)),
                          errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                          borderRadius: heightDp * 4,
                          textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                          hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.8)),
                          hintText: "",
                          label: isProduct ? "Product Item Name" : "Service Item Name",
                          labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                          labelSpacing: heightDp * 5,
                          validatorHandler: (input) => input.isEmpty ? "Please input the name" : null,
                          onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                          onSaveHandler: (input) => productItemData["name"] = input.trim(),
                        ),

                        SizedBox(height: heightDp * 15),
                        KeicyTextFormField(
                          controller: _descriptionController,
                          focusNode: _descriptionFocusNode,
                          width: double.infinity,
                          height: heightDp * 80,
                          border: Border.all(color: Colors.grey.withOpacity(0.7)),
                          errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                          borderRadius: heightDp * 4,
                          textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                          hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.8)),
                          hintText: "",
                          label: "Description",
                          labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                          labelSpacing: heightDp * 5,
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          maxLines: null,
                          validatorHandler: (input) => input.isEmpty ? "Please input the description" : null,
                          onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                          onSaveHandler: (input) => productItemData["description"] = input.trim(),
                        ),

                        ///
                        SizedBox(height: heightDp * 20),
                        Text(
                          "Select an image to show store person about what you are looking for",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: heightDp * 10),
                        KeicyRaisedButton(
                          width: widthDp * 90,
                          height: heightDp * 30,
                          borderRadius: heightDp * 8,
                          color: config.Colors().mainColor(1),
                          child: Text("Select", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
                          onPressed: _selectOptionBottomSheet,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Expanded(
                        //       child: SizedBox(),
                        //     ),
                        //     SizedBox(width: widthDp * 10),
                        //     KeicyRaisedButton(
                        //       width: widthDp * 90,
                        //       height: heightDp * 30,
                        //       borderRadius: heightDp * 8,
                        //       color: config.Colors().mainColor(1),
                        //       child: Text("Select", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
                        //       onPressed: _selectOptionBottomSheet,
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: heightDp * 10),
                        _imageFile == null
                            ? SizedBox()
                            : Expanded(
                                child: Image.file(
                                  _imageFile!,
                                  width: double.infinity,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: heightDp * 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          KeicyRaisedButton(
                            width: widthDp * 120,
                            height: heightDp * 40,
                            color: config.Colors().mainColor(1),
                            borderRadius: heightDp * 8,
                            child: Text(
                              "Save",
                              style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                            ),
                            onPressed: _saveHandler,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectOptionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              Container(
                child: Container(
                  padding: EdgeInsets.all(heightDp * 8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: deviceWidth,
                        padding: EdgeInsets.all(heightDp * 10.0),
                        child: Text(
                          "Choose Option",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _getAvatarImage(ImageSource.camera);
                        },
                        child: Container(
                          width: deviceWidth,
                          padding: EdgeInsets.all(heightDp * 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.camera_alt,
                                color: Colors.black.withOpacity(0.7),
                                size: heightDp * 25.0,
                              ),
                              SizedBox(width: widthDp * 10.0),
                              Text(
                                "From Camera",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _getAvatarImage(ImageSource.gallery);
                        },
                        child: Container(
                          width: deviceWidth,
                          padding: EdgeInsets.all(heightDp * 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.photo, color: Colors.black.withOpacity(0.7), size: heightDp * 25),
                              SizedBox(width: widthDp * 10.0),
                              Text(
                                "From Gallery",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future _getAvatarImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, maxWidth: 500, maxHeight: 500);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      FlutterLogs.logWarn(
        "custom_product_view",
        "_selectPickupDateTimeHandler",
        {
          "message": "No image selected",
        }.toString(),
      );
    }
  }
}
