import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'keicy_avatar_image.dart';

class AppliedJobWidget extends StatelessWidget {
  final Map<String, dynamic>? appliedJobData;
  final bool? isLoading;
  final Function? detailHandler;

  AppliedJobWidget({
    @required this.appliedJobData,
    @required this.isLoading,
    @required this.detailHandler,
  });

  /// Responsive design variables
  double? deviceWidth;
  double? deviceHeight;
  double? statusbarHeight;
  double? bottomBarHeight;
  double? appbarHeight;
  double? widthDp;
  double? heightDp;
  double? heightDp1;
  double? fontSp;
  ///////////////////////////////

  @override
  Widget build(BuildContext context) {
    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    return Card(
      margin: EdgeInsets.symmetric(horizontal: widthDp! * 15, vertical: heightDp! * 5),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp! * 15, vertical: heightDp! * 15),
        color: Colors.transparent,
        child: isLoading! ? _shimmerWidget() : _jobPostingWidget(context),
      ),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: isLoading!,
      period: Duration(milliseconds: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "Job Title : ",
                  style: TextStyle(fontSize: fontSp! * 16, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Text(
                    "asf asdf adsf asdf asdf asdf asdf asd asdf asd fasdf asdf asdf asdfasf asdfasdf asdf asdfas dfas fasd fa",
                    style: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp! * 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "Job Desc : ",
                  style: TextStyle(fontSize: fontSp! * 16, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Text(
                    "adsf asdf asdf asf asdf asdf asdfasdfsdf asdfasdfsd fasdfasd fasdfasdfasdf asdfsdfa dfasdfsd asdfasdf asdfasdf",
                    style: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp! * 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "Number Of People : ",
                  style: TextStyle(fontSize: fontSp! * 16, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Text(
                    "54",
                    style: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp! * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              KeicyRaisedButton(
                width: widthDp! * 140,
                height: heightDp! * 35,
                color: Colors.white,
                borderRadius: heightDp! * 6,
                child: Text(
                  "Applicants",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.white),
                ),
              ),
              KeicyRaisedButton(
                width: widthDp! * 140,
                height: heightDp! * 35,
                color: Colors.white,
                borderRadius: heightDp! * 6,
                child: Text(
                  "Edit Job",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _jobPostingWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "${appliedJobData!["jobPosting"]["jobTitle"]}",
              style: TextStyle(fontSize: fontSp! * 20, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),

          ///
          SizedBox(height: heightDp! * 10),
          Text(
            "Job Desc : ",
            style: TextStyle(fontSize: fontSp! * 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp! * 5),
          Text(
            "${appliedJobData!["jobPosting"]["description"]}",
            style: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
          ),

          ///
          Divider(height: heightDp! * 20, thickness: 1, color: Colors.grey.withOpacity(0.7)),
          Row(
            children: [
              KeicyAvatarImage(
                url: appliedJobData!["store"]["profile"]["image"],
                width: widthDp! * 70,
                height: widthDp! * 70,
                backColor: Colors.grey.withOpacity(0.4),
                borderRadius: heightDp! * 6,
                errorWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(heightDp! * 6),
                  child: Image.asset(
                    "img/store-icon/${appliedJobData!["store"]["subType"].toString().toLowerCase()}-store.png",
                    width: widthDp! * 70,
                    height: widthDp! * 70,
                  ),
                ),
              ),
              SizedBox(width: widthDp! * 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appliedJobData!["store"]["name"],
                      style: TextStyle(fontSize: fontSp! * 16, color: Colors.black, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: heightDp! * 5),
                    Text(
                      appliedJobData!["store"]["address"],
                      style: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ],
          ),
          Divider(height: heightDp! * 20, thickness: 1, color: Colors.grey.withOpacity(0.7)),

          ///
          Row(
            children: [
              Row(
                children: [
                  Icon(Icons.schedule_outlined, size: heightDp! * 20, color: Colors.black),
                  SizedBox(width: widthDp! * 5),
                  Text(
                    "${appliedJobData!["jobPosting"]["minYearExperience"]}+ years",
                    style: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
                  ),
                  SizedBox(width: widthDp! * 15),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      "₹ ",
                      style: TextStyle(fontSize: fontSp! * 16, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${appliedJobData!["jobPosting"]["salaryFrom"]} - ${appliedJobData!["jobPosting"]["salaryTo"]}",
                      style: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
                    ),
                    SizedBox(width: widthDp! * 5),
                    Text(
                      "${appliedJobData!["jobPosting"]["salaryType"]}",
                      style: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp! * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              KeicyRaisedButton(
                width: widthDp! * 170,
                height: heightDp! * 35,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp! * 6,
                child: Text(
                  "View Application",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.white),
                ),
                onPressed: () {
                  if (detailHandler != null) detailHandler!();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
