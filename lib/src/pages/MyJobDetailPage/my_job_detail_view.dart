import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/helpers/string_helper.dart';
import 'package:trapp/src/providers/index.dart';

class MyJobDetailView extends StatefulWidget {
  Map<String, dynamic>? appliedJobData;

  MyJobDetailView({Key? key, this.appliedJobData}) : super(key: key);

  @override
  _MyJobDetailViewState createState() => _MyJobDetailViewState();
}

class _MyJobDetailViewState extends State<MyJobDetailView> with SingleTickerProviderStateMixin {
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

  Map<String, dynamic>? _appliedJobData;
  Map<String, dynamic> _updatedState = {
    "isUpdated": false,
  };

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

    _appliedJobData = json.decode(json.encode(widget.appliedJobData));

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String approvealStatus = "";
    for (var i = 0; i < AppConfig.appliedJobApprovalStatusType.length; i++) {
      if (_appliedJobData!["approvalStatus"] == AppConfig.appliedJobApprovalStatusType[i]["id"]) {
        approvealStatus = AppConfig.appliedJobApprovalStatusType[i]["text"];
      }
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_updatedState);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: config.Colors().mainColor(1),
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop(_updatedState);
            },
          ),
          centerTitle: true,
          title: Text(
            "Application",
            style: TextStyle(fontSize: fontSp * 20, color: Colors.white),
          ),
          elevation: 0,
        ),
        body: Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              Stack(
                children: [
                  _jobPostPanel(),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: deviceWidth,
                      alignment: Alignment.center,
                      child: Container(
                        height: heightDp * 40,
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(heightDp * 6),
                          color: _appliedJobData!["approvalStatus"] == AppConfig.appliedJobApprovalStatusType[1]["id"]
                              ? Colors.yellow
                              : _appliedJobData!["approvalStatus"] == AppConfig.appliedJobApprovalStatusType[2]["id"]
                                  ? Colors.green
                                  : _appliedJobData!["approvalStatus"] == AppConfig.appliedJobApprovalStatusType[3]["id"]
                                      ? Colors.red
                                      : Colors.blue,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              approvealStatus,
                              style: TextStyle(
                                fontSize: fontSp * 20,
                                color: _appliedJobData!["approvalStatus"] == AppConfig.appliedJobApprovalStatusType[1]["id"]
                                    ? Colors.black
                                    : _appliedJobData!["approvalStatus"] == AppConfig.appliedJobApprovalStatusType[2]["id"]
                                        ? Colors.white
                                        : _appliedJobData!["approvalStatus"] == AppConfig.appliedJobApprovalStatusType[3]["id"]
                                            ? Colors.white
                                            : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              ///
              SizedBox(height: heightDp * 20),
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (notification) {
                    notification.disallowGlow();
                    return false;
                  },
                  child: SingleChildScrollView(
                    child: _mainPanel(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jobPostPanel() {
    return Container(
      width: deviceWidth,
      color: config.Colors().mainColor(1),
      margin: EdgeInsets.only(bottom: heightDp * 20),
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
          SizedBox(height: heightDp * 20),
        ],
      ),
    );
  }

  Widget _mainPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Name :",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: widthDp * 10),
                ],
              ),
              Text(
                "${_appliedJobData!["firstName"]} ${_appliedJobData!["lastName"]}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Email :",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: widthDp * 10),
                ],
              ),
              Text(
                "${_appliedJobData!["email"]}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Phone :",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: widthDp * 10),
                ],
              ),
              Text(
                "${_appliedJobData!["mobile"]}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Year Of Experience",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: widthDp * 10),
                ],
              ),
              Text(
                "${_appliedJobData!["yearOfExperience"]}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Experience",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: heightDp * 5),
              Text(
                "${_appliedJobData!["experience"]}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Education",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: heightDp * 5),
              Text(
                "${_appliedJobData!["education"]}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Addhar",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: widthDp * 10),
                ],
              ),
              Text(
                "${_appliedJobData!["aadhar"]}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Address",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: heightDp * 5),
              Text(
                "${_appliedJobData!["address"]}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
            ],
          ),

          ///
          if (_appliedJobData!["comments"] != null && _appliedJobData!["comments"] != "") SizedBox(height: heightDp * 15),
          if (_appliedJobData!["comments"] != null && _appliedJobData!["comments"] != "")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Comments",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: heightDp * 5),
                Text(
                  "${_appliedJobData!["comments"]}",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                ),
              ],
            ),

          SizedBox(height: heightDp * 15),
          Center(
            child: Container(
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
                  errorWidget: KeicyAvatarImage(
                    url: AuthProvider.of(context).authState.userModel!.imageUrl,
                    width: widthDp * 150,
                    height: heightDp * 150,
                    backColor: Colors.grey.withOpacity(0.4),
                    borderRadius: heightDp * 6,
                    userName: StringHelper.getUpperCaseString(
                      "${AuthProvider.of(context).authState.userModel!.firstName} ${AuthProvider.of(context).authState.userModel!.lastName}",
                    ),
                    textStyle: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                  ),
                )),
          ),

          ///
          SizedBox(height: heightDp * 20),
        ],
      ),
    );
  }
}
