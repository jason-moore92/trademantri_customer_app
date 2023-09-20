import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/services/dynamic_link_service.dart';

import 'favorite_icon_widget.dart';
import 'keicy_avatar_image.dart';

class JobPostingWidget extends StatelessWidget {
  final Map<String, dynamic>? jobPostingData;
  final bool? isLoading;
  final bool? isShowFavorite;
  final Function()? applyHandler;
  final Function()? detailHandler;

  JobPostingWidget({
    @required this.jobPostingData,
    @required this.isLoading,
    this.isShowFavorite = true,
    this.applyHandler,
    this.detailHandler,
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
          Center(
            child: Container(
              color: Colors.white,
              child: Text(
                "Job Desc : ",
                style: TextStyle(fontSize: fontSp! * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
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
              "${jobPostingData!["jobTitle"]}",
              style: TextStyle(fontSize: fontSp! * 20, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),

          ///
          SizedBox(height: heightDp! * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Job Desc : ",
                style: TextStyle(fontSize: fontSp! * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  if (isShowFavorite!)
                    FavoriteIconWidget(
                      category: "store-job-postings",
                      id: jobPostingData!["_id"],
                      storeId: jobPostingData!["store"]["_id"],
                      size: heightDp! * 25,
                    ),
                  SizedBox(width: widthDp! * 5),
                  GestureDetector(
                    onTap: () async {
                      Uri dynamicUrl = await DynamicLinkService.createJobDynamicLink(
                        jobData: jobPostingData,
                        storeData: jobPostingData!["store"],
                      );
                      Share.share(dynamicUrl.toString());
                    },
                    child: Icon(Icons.share, size: heightDp! * 25, color: config.Colors().mainColor(1)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: heightDp! * 5),
          Text(
            "${jobPostingData!["description"]}",
            style: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
          ),

          ///
          if (jobPostingData!["appliedJob"] != null)
            Column(
              children: [
                SizedBox(height: heightDp! * 10),
                Stack(
                  children: [
                    Container(
                      height: heightDp! * 30,
                      color: Colors.transparent,
                      child: Divider(height: heightDp! * 20, thickness: 1, color: Colors.grey.withOpacity(0.7)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: widthDp! * 15),
                          child: Container(
                            height: heightDp! * 30,
                            padding: EdgeInsets.symmetric(horizontal: widthDp! * 15),
                            decoration: BoxDecoration(
                              color: config.Colors().mainColor(1),
                              borderRadius: BorderRadius.circular(heightDp! * 6),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Applied",
                              style: TextStyle(fontSize: fontSp! * 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          else
            Divider(height: heightDp! * 20, thickness: 1, color: Colors.grey.withOpacity(0.7)),

          ///
          Row(
            children: [
              KeicyAvatarImage(
                url: jobPostingData!["store"]["profile"]["image"],
                width: widthDp! * 70,
                height: widthDp! * 70,
                backColor: Colors.grey.withOpacity(0.4),
                borderRadius: heightDp! * 6,
                errorWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(heightDp! * 6),
                  child: Image.asset(
                    "img/store-icon/${jobPostingData!["store"]["subType"].toString().toLowerCase()}-store.png",
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
                      jobPostingData!["store"]["name"],
                      style: TextStyle(fontSize: fontSp! * 16, color: Colors.black, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: heightDp! * 5),
                    Text(
                      jobPostingData!["store"]["address"],
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
                    "${jobPostingData!["minYearExperience"]}+ years",
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
                      "${jobPostingData!["salaryFrom"]} - ${jobPostingData!["salaryTo"]}",
                      style: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
                    ),
                    SizedBox(width: widthDp! * 5),
                    Text(
                      "${jobPostingData!["salaryType"]}",
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              KeicyRaisedButton(
                width: widthDp! * 140,
                height: heightDp! * 35,
                color: jobPostingData!["appliedJob"] == null ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                borderRadius: heightDp! * 6,
                child: Text(
                  "Apply Now",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.white),
                ),
                onPressed: jobPostingData!["appliedJob"] == null ? applyHandler : null,
              ),
              KeicyRaisedButton(
                width: widthDp! * 140,
                height: heightDp! * 35,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp! * 6,
                child: Text(
                  "Job Details",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.white),
                ),
                onPressed: detailHandler,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
