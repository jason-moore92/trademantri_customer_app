import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/favorite_icon_widget.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/pages/StoreJobPostingApplyPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/services/dynamic_link_service.dart';

import '../../elements/keicy_progress_dialog.dart';

class StoreJobPostingDetailView extends StatefulWidget {
  final Map<String, dynamic>? jobPostingData;

  StoreJobPostingDetailView({Key? key, this.jobPostingData}) : super(key: key);

  @override
  _StoreJobPostingDetailViewState createState() => _StoreJobPostingDetailViewState();
}

class _StoreJobPostingDetailViewState extends State<StoreJobPostingDetailView> with SingleTickerProviderStateMixin {
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

  KeicyProgressDialog? _keicyProgressDialog;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Map<String, dynamic> _jobPostData = Map<String, dynamic>();

  Map<String, dynamic> _isUpdatedData = {
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

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _jobPostData = Map<String, dynamic>();

    _jobPostData = json.decode(json.encode(widget.jobPostingData));

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FavoriteProvider.of(context).favoriteUpdateHandler();
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
              FavoriteProvider.of(context).favoriteUpdateHandler();
              Navigator.of(context).pop(_isUpdatedData);
            },
          ),
          centerTitle: true,
          title: Text(
            "Job Details",
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
          padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
          child: Column(
            children: [
              SizedBox(height: heightDp * 20),
              Text(
                "${_jobPostData["jobTitle"]}",
                style: TextStyle(fontSize: fontSp * 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: heightDp * 20),
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
                            "${_jobPostData["store"]["city"]}",
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
                          "${_jobPostData["minYearExperience"]}+ years",
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
                          "${_jobPostData["salaryFrom"]} - ${_jobPostData["salaryTo"]}",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightDp * 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FavoriteIconWidget(
                    category: "store-job-postings",
                    id: _jobPostData["_id"],
                    storeId: _jobPostData["store"]["_id"],
                    size: heightDp * 25,
                    color: Colors.white,
                  ),
                  SizedBox(width: widthDp * 5),
                  GestureDetector(
                    onTap: () async {
                      Uri dynamicUrl = await DynamicLinkService.createJobDynamicLink(
                        jobData: _jobPostData,
                        storeData: _jobPostData["store"],
                      );
                      Share.share(dynamicUrl.toString());
                    },
                    child: Icon(Icons.share, size: heightDp * 25, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: heightDp * 10),
            ],
          ),
        ),

        ///
        Container(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///
              Text(
                "Job Description",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: heightDp * 5),
              Text(
                "${_jobPostData["description"]}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),

              ///
              Divider(height: heightDp * 20, thickness: 1, color: Colors.grey.withOpacity(0.7)),
              Text(
                "Skills",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              Column(
                children: List.generate(_jobPostData["skills"].length, (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                    child: Row(
                      children: [
                        Icon(Icons.fiber_manual_record, size: heightDp * 15, color: Colors.black),
                        SizedBox(width: widthDp * 5),
                        Text(
                          "${_jobPostData["skills"][index]}",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              ///
              Divider(height: heightDp * 20, thickness: 1, color: Colors.grey.withOpacity(0.7)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Number Of People",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${_jobPostData["peopleNumber"]}",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                ],
              ),

              ///
              Divider(height: heightDp * 20, thickness: 1, color: Colors.grey.withOpacity(0.7)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Job Type",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${_jobPostData["jobType"]}",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                ],
              ),

              ///
              Divider(height: heightDp * 20, thickness: 1, color: Colors.grey.withOpacity(0.7)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Salary Type",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${_jobPostData["salaryType"]}",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                ],
              ),

              ///
              Divider(height: heightDp * 20, thickness: 1, color: Colors.grey.withOpacity(0.7)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Start Date",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    KeicyDateTime.convertDateTimeToDateString(
                      dateTime: DateTime.tryParse(_jobPostData["startDate"])!.toLocal(),
                      isUTC: false,
                    ),
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                ],
              ),

              ///
              if (_jobPostData["endDate"] != null) Divider(height: heightDp * 20, thickness: 1, color: Colors.grey.withOpacity(0.7)),
              if (_jobPostData["endDate"] != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "End Date",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      KeicyDateTime.convertDateTimeToDateString(
                        dateTime: DateTime.tryParse(_jobPostData["endDate"])!.toLocal(),
                        isUTC: false,
                      ),
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                  ],
                ),

              ///
              Divider(height: heightDp * 20, thickness: 1, color: Colors.grey.withOpacity(0.7)),
              SizedBox(height: heightDp * 20),
              if (widget.jobPostingData!["appliedJob"] != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, size: heightDp * 30, color: Colors.green),
                    SizedBox(width: widthDp * 10),
                    Text(
                      "This job is already applied.",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                  ],
                )
              else
                Center(
                  child: KeicyRaisedButton(
                    width: widthDp * 130,
                    height: heightDp * 35,
                    color: config.Colors().mainColor(1),
                    borderRadius: heightDp * 6,
                    child: Text(
                      "Apply Now",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                    ),
                    onPressed: widget.jobPostingData!["appliedJob"] != null
                        ? null
                        : () async {
                            FavoriteProvider.of(context).favoriteUpdateHandler();
                            if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin &&
                                AuthProvider.of(context).authState.userModel!.id != null) {
                              var result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => StoreJobPostingApplyPage(
                                    appliedJobData: {
                                      "jobPosting": widget.jobPostingData,
                                      "store": widget.jobPostingData!["store"],
                                    },
                                    isNew: true,
                                  ),
                                ),
                              );

                              if (result != null && result["isUpdated"]) {
                                Navigator.of(context).pop();
                              }
                            } else {
                              LoginAskDialog.show(context, callback: () async {
                                var result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => StoreJobPostingApplyPage(
                                      appliedJobData: {
                                        "jobPosting": widget.jobPostingData,
                                        "store": widget.jobPostingData!["store"],
                                      },
                                      isNew: true,
                                    ),
                                  ),
                                );

                                if (result != null && result["isUpdated"]) {
                                  Navigator.of(context).pop();
                                }
                              });
                            }
                          },
                  ),
                ),
              SizedBox(height: heightDp * 20),
            ],
          ),
        ),
      ],
    );
  }
}
