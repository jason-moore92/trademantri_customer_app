import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/helpers/validators.dart';
import 'package:trapp/src/providers/index.dart';

import '../../elements/keicy_progress_dialog.dart';

class StoreJobPostingApplyView extends StatefulWidget {
  final Map<String, dynamic>? appliedJobData;
  final bool? isNew;

  StoreJobPostingApplyView({Key? key, this.appliedJobData, this.isNew}) : super(key: key);

  @override
  _StoreJobPostingApplyViewState createState() => _StoreJobPostingApplyViewState();
}

class _StoreJobPostingApplyViewState extends State<StoreJobPostingApplyView> with SingleTickerProviderStateMixin {
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

  AuthProvider? _authProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _yearOfExperienceController = TextEditingController();
  TextEditingController _educationController = TextEditingController();
  TextEditingController _aadharController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _commentsController = TextEditingController();

  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _experienceFocusNode = FocusNode();
  FocusNode _yearOfExperienceFocusNode = FocusNode();
  FocusNode _educationFocusNode = FocusNode();
  FocusNode _aadharFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _commentsFocusNode = FocusNode();

  Map<String, dynamic>? _appliedJobData;

  Map<String, dynamic> _isUpdatedData = {
    "isUpdated": false,
  };

  final picker = ImagePicker();
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

    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _appliedJobData = json.decode(json.encode(widget.appliedJobData));
    if (!widget.isNew!) {
      _firstNameController.text = _appliedJobData!["firstName"];
      _lastNameController.text = _appliedJobData!["lastName"];
      _emailController.text = _appliedJobData!["email"];
      _phoneController.text = _appliedJobData!["mobile"];
      _experienceController.text = _appliedJobData!["experience"];
      _yearOfExperienceController.text = _appliedJobData!["yearOfExperience"].toString();
      _educationController.text = _appliedJobData!["education"];
      _aadharController.text = _appliedJobData!["aadhar"];
      _addressController.text = _appliedJobData!["address"];
      _commentsController.text = _appliedJobData!["comments"];
    } else {
      _firstNameController.text = _authProvider!.authState.userModel!.firstName!;
      _lastNameController.text = _authProvider!.authState.userModel!.lastName!;
      _emailController.text = _authProvider!.authState.userModel!.email!;
      _phoneController.text = _authProvider!.authState.userModel!.mobile!;
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _applyHandler() async {
    Map<String, dynamic> applyJobData = Map<String, dynamic>();

    if (!_formkey.currentState!.validate()) return;

    _formkey.currentState!.save();

    applyJobData = json.decode(json.encode(_appliedJobData));
    applyJobData.remove("jobPosting");
    applyJobData.remove("store");

    NormalAskDialog.show(
      context,
      title: "Apply Job",
      content: "Please check all your details once again before you apply. Once you applied you can’t edit your application.",
      callback: () async {
        FocusScope.of(context).requestFocus(FocusNode());

        await _keicyProgressDialog!.show();
        applyJobData["firstName"] = _firstNameController.text;
        applyJobData["lastName"] = _lastNameController.text;
        applyJobData["email"] = _emailController.text;
        applyJobData["mobile"] = _phoneController.text;
        applyJobData["storeId"] = _appliedJobData!["jobPosting"]["storeId"];
        applyJobData["jobId"] = _appliedJobData!["jobPosting"]["_id"];
        applyJobData["userId"] = _authProvider!.authState.userModel!.id;
        applyJobData["status"] = AppConfig.appliedJobStatusType[0]["id"];

        if (_imageFile != null) {
          var result = await UploadFileApiProvider.uploadFile(
            file: _imageFile,
            bucketName: "PROFILE_BUCKET_NAME",
            directoryName: "${applyJobData["jobId"]}_${applyJobData["userId"]}_${applyJobData["storeId"]}",
          );

          if (result["success"]) {
            applyJobData["image"] = result["data"];
          }
        }

        var result;

        result = await AppliedJobApiProvider.createAppliedJob(appliedJobData: applyJobData);

        await _keicyProgressDialog!.hide();

        if (result["success"]) {
          _isUpdatedData = {
            "isUpdated": true,
            "appliedJob": applyJobData,
          };
          SuccessDialog.show(context, heightDp: heightDp, fontSp: fontSp, callBack: () {
            Navigator.of(context).pop(_isUpdatedData);
          });
        } else {
          ErrorDialog.show(
            context,
            widthDp: widthDp,
            heightDp: heightDp,
            fontSp: fontSp,
            text: result["message"] != "already_exist"
                ? result["message"]
                : "You have already applied for this job. Please check the details in the My Jobs page",
            isTryButton: false,
            callBack: null,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_isUpdatedData);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: config.Colors().mainColor(1),
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop(_isUpdatedData);
            },
          ),
          centerTitle: true,
          title: Text(
            "Apply Job",
            style: TextStyle(fontSize: fontSp * 20, color: Colors.white),
          ),
          elevation: 0,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();

            return false;
          },
          child: SingleChildScrollView(
            child: Container(
              width: deviceWidth,
              child: Form(
                key: _formkey,
                child: _mainPanel(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///
        Container(
          width: deviceWidth,
          color: config.Colors().mainColor(1),
          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
          child: Column(
            children: [
              Text(
                "${_appliedJobData!["jobPosting"]["jobTitle"]}",
                style: TextStyle(fontSize: fontSp * 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: heightDp * 15),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: heightDp * 25,
                          color: Colors.white,
                        ),
                        SizedBox(width: widthDp * 5),
                        Expanded(
                          child: Text(
                            "${_appliedJobData!["store"]["city"]}",
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: widthDp * 5),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          size: heightDp * 25,
                          color: Colors.white,
                        ),
                        SizedBox(width: widthDp * 5),
                        Text(
                          "${_appliedJobData!["jobPosting"]["minYearExperience"]}+ years",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "₹ ",
                          style: TextStyle(fontSize: fontSp * 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: widthDp * 5),
                        Text(
                          "${_appliedJobData!["jobPosting"]["salaryFrom"]} - ${_appliedJobData!["jobPosting"]["salaryTo"]}",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        ///
        Container(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KeicyTextFormField(
                controller: _firstNameController,
                focusNode: _firstNameFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                label: "First Name",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintText: "First Name",
                hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 5,
                readOnly: (_appliedJobData!["status"] == AppConfig.appliedJobStatusType[0]["id"]),
                validatorHandler: (input) => input.trim().isEmpty ? "Please enter first name" : null,
                onSaveHandler: (input) => _appliedJobData!["firstName"] = input.trim(),
                onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_lastNameFocusNode),
              ),

              ///
              SizedBox(height: heightDp * 15),
              KeicyTextFormField(
                controller: _lastNameController,
                focusNode: _lastNameFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                label: "Last Name",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintText: "Last Name",
                hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 5,
                readOnly: (_appliedJobData!["status"] == AppConfig.appliedJobStatusType[0]["id"]),
                validatorHandler: (input) => input.trim().isEmpty ? "Please enter last name" : null,
                onSaveHandler: (input) => _appliedJobData!["lastName"] = input.trim(),
                onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_experienceFocusNode),
              ),

              ///
              SizedBox(height: heightDp * 15),
              KeicyTextFormField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                label: "Email",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintText: "Email",
                hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 5,
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
                validatorHandler: (input) => !KeicyValidators.isValidEmail(input) ? "Please enter email" : null,
                onSaveHandler: (input) => _appliedJobData!["email"] = input.trim(),
                onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
              ),

              ///
              SizedBox(height: heightDp * 15),
              KeicyTextFormField(
                controller: _phoneController,
                focusNode: _phoneFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                label: "Phone Number",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintText: "Phone Number",
                hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 5,
                readOnly: true,
                validatorHandler: (input) => input.trim().isEmpty ? "Please enter phone number" : null,
                onSaveHandler: (input) => _appliedJobData!["mobile"] = input.trim(),
                onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
              ),

              ///
              SizedBox(height: heightDp * 15),
              KeicyTextFormField(
                controller: _experienceController,
                focusNode: _experienceFocusNode,
                width: double.infinity,
                height: heightDp * 150,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                label: "Experience Summary",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintText: "Experience Summary",
                hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                readOnly: (_appliedJobData!["status"] == AppConfig.appliedJobStatusType[0]["id"]),
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 5,
                validatorHandler: (input) => input.trim().isEmpty ? "Please enter experience" : null,
                onSaveHandler: (input) => _appliedJobData!["experience"] = input.trim(),
                onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_yearOfExperienceFocusNode),
              ),

              ///
              SizedBox(height: heightDp * 15),
              KeicyTextFormField(
                controller: _yearOfExperienceController,
                focusNode: _yearOfExperienceFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                label: "Year Of Experience",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintText: "Year Of Experience",
                hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 5,
                readOnly: (_appliedJobData!["status"] == AppConfig.appliedJobStatusType[0]["id"]),
                keyboardType: TextInputType.number,
                validatorHandler: (input) => input.trim().isEmpty ? "Please enter year of experience" : null,
                onSaveHandler: (input) => _appliedJobData!["yearOfExperience"] = int.parse(input.trim()),
                onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_educationFocusNode),
              ),

              ///
              SizedBox(height: heightDp * 15),
              KeicyTextFormField(
                controller: _educationController,
                focusNode: _educationFocusNode,
                width: double.infinity,
                height: heightDp * 150,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                label: "Education Summary",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintText: "Education Summary",
                hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                readOnly: (_appliedJobData!["status"] == AppConfig.appliedJobStatusType[0]["id"]),
                maxLines: null,
                validatorHandler: (input) => input.trim().isEmpty ? "Please enter education" : null,
                onSaveHandler: (input) => _appliedJobData!["education"] = input.trim(),
                onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_aadharFocusNode),
              ),

              ///
              SizedBox(height: heightDp * 15),
              KeicyTextFormField(
                controller: _aadharController,
                focusNode: _aadharFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                label: "Aadhaar",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintText: "Aadhaar",
                hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                contentHorizontalPadding: widthDp * 10,
                readOnly: (_appliedJobData!["status"] == AppConfig.appliedJobStatusType[0]["id"]),
                contentVerticalPadding: heightDp * 5,
                // validatorHandler: (input) => input.trim().isEmpty ? "Please enter aadhaar" : null,
                onSaveHandler: (input) => _appliedJobData!["aadhar"] = input.trim(),
                onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_addressFocusNode),
              ),

              ///
              SizedBox(height: heightDp * 15),
              KeicyTextFormField(
                controller: _addressController,
                focusNode: _addressFocusNode,
                width: double.infinity,
                height: heightDp * 150,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                label: "Address",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintText: "Address",
                hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                readOnly: (_appliedJobData!["status"] == AppConfig.appliedJobStatusType[0]["id"]),
                validatorHandler: (input) => input.trim().isEmpty ? "Please enter address" : null,
                onSaveHandler: (input) => _appliedJobData!["address"] = input.trim(),
                onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
              ),

              ///
              SizedBox(height: heightDp * 15),
              KeicyTextFormField(
                controller: _commentsController,
                focusNode: _commentsFocusNode,
                width: double.infinity,
                height: heightDp * 150,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                label: "Comments",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintText: "Comments",
                hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                readOnly: (_appliedJobData!["status"] == AppConfig.appliedJobStatusType[0]["id"]),
                maxLines: null,
                // validatorHandler: (input) => input.trim().isEmpty ? "Please enter comments" : null,
                onSaveHandler: (input) => _appliedJobData!["comments"] = input.trim(),
                onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
              ),

              ///
              SizedBox(height: heightDp * 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add Your Image",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                  if (_appliedJobData!["status"] != AppConfig.appliedJobStatusType[0]["id"])
                    KeicyRaisedButton(
                      width: widthDp * 120,
                      height: heightDp * 35,
                      color: config.Colors().mainColor(1),
                      borderRadius: heightDp * 6,
                      child: Text(
                        "Add",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                      ),
                      onPressed: _selectOptionBottomSheet,
                    ),
                ],
              ),
              SizedBox(height: heightDp * 5),
              if (_imageFile != null)
                Wrap(
                  children: [
                    Container(
                      width: widthDp * 150,
                      height: heightDp * 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: Image.file(
                        _imageFile!,
                        width: widthDp * 150,
                        height: heightDp * 150,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              if (!widget.isNew!)
                Wrap(
                  children: [
                    Container(
                      width: widthDp * 150,
                      height: heightDp * 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: KeicyAvatarImage(
                        url: _appliedJobData!["image"],
                        width: widthDp * 150,
                        height: heightDp * 150,
                      ),
                    )
                  ],
                ),

              if (_appliedJobData!["status"] != AppConfig.appliedJobStatusType[0]["id"]) SizedBox(height: heightDp * 30),
              if (_appliedJobData!["status"] != AppConfig.appliedJobStatusType[0]["id"])
                Center(
                  child: KeicyRaisedButton(
                    width: widthDp * 150,
                    height: heightDp * 35,
                    color: config.Colors().mainColor(1),
                    borderRadius: heightDp * 6,
                    child: Text("Apply", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
                    onPressed: _applyHandler,
                  ),
                ),

              ///
              SizedBox(height: heightDp * 30),
            ],
          ),
        ),
      ],
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
      FlutterLogs.logInfo(
        "store_job_posting_apply_view",
        "_getAvatarImage",
        "No image selected.",
      );
    }
  }
}
