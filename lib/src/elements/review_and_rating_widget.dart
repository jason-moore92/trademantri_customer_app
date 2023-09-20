import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';

import 'keicy_rating_bar.dart';

class ReviewAndRatingWidget extends StatelessWidget {
  final Map<String, dynamic>? reviewAndRatingData;
  final bool isLoading;

  ReviewAndRatingWidget({
    @required this.reviewAndRatingData,
    this.isLoading = true,
  });

  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  @override
  Widget build(BuildContext context) {
    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    return isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            direction: ShimmerDirection.ltr,
            enabled: isLoading,
            period: Duration(milliseconds: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: heightDp * 200,
                  height: heightDp * 30,
                  color: Colors.white,
                ),
                SizedBox(height: heightDp * 10),
                Container(
                  color: Colors.white,
                  child: Text(
                    "review title title",
                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: heightDp * 15),
                Container(
                  color: Colors.white,
                  child: Text(
                    "review body",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "review body body body",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "review body body",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        KeicyRatingBar(
                          size: heightDp * 30,
                          spacing: widthDp * 10,
                          allowHalfRating: false,
                          rating: reviewAndRatingData!["rating"].toDouble(),
                          defaultIconData: Icon(
                            Icons.star,
                            size: heightDp * 30,
                            color: Colors.grey.withOpacity(0.6),
                          ),
                          filledIconData: Icon(
                            Icons.star,
                            size: heightDp * 30,
                            color: Colors.yellow,
                          ),
                          halfStarThreshold: 0.5,
                          isReadOnly: true,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Posted on:\n${KeicyDateTime.convertDateTimeToDateString(
                      dateTime: DateTime.tryParse(reviewAndRatingData!['updatedAt']),
                      formats: 'Y-m-d',
                      isUTC: false,
                    )}",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: heightDp * 10),
              Text(
                "${reviewAndRatingData!["title"]}",
                style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: heightDp * 15),
              Text(
                "${reviewAndRatingData!["review"]}",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              ),
            ],
          );
  }
}
