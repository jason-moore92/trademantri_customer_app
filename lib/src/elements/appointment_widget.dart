import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'keicy_avatar_image.dart';

class ApointmentWidget extends StatelessWidget {
  final AppointmentModel? appointmentModel;
  final bool? isLoading;
  final void Function()? bookHandler;

  ApointmentWidget({
    @required this.appointmentModel,
    @required this.isLoading,
    this.bookHandler,
  });

  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
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
      margin: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 8)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(heightDp * 8),
        ),
        child: isLoading! ? _shimmerWidget() : _mainPanel(),
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
      child: Row(
        children: [
          Container(width: heightDp * 80, height: heightDp * 80, color: Colors.black),
          SizedBox(width: widthDp * 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    "notification storeName",
                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "2021-09-23",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "appointmentModel title",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "appointmentModel body\nnotificationData body body body body",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainPanel() {
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            KeicyAvatarImage(
              url: appointmentModel!.image,
              width: heightDp * 70,
              height: heightDp * 70,
              backColor: Colors.transparent,
              errorWidget: Icon(Icons.event, size: heightDp * 70, color: config.Colors().mainColor(1)),
            ),
            SizedBox(width: widthDp * 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///
                  Text(
                    "Event Name : ${appointmentModel!.name}",
                    style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  ///
                  SizedBox(height: heightDp * 5),
                  Text(
                    "${appointmentModel!.description}",
                    style: TextStyle(fontSize: fontSp * 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  ///
                  SizedBox(height: heightDp * 5),
                  Wrap(
                    children: [
                      if (appointmentModel!.monday!.open!)
                        Padding(
                          padding: EdgeInsets.only(right: widthDp * 5),
                          child: Text(
                            "Monday,",
                            style: TextStyle(fontSize: fontSp * 14),
                          ),
                        ),
                      if (appointmentModel!.tuesday!.open!)
                        Text(
                          "Tuesday,",
                          style: TextStyle(fontSize: fontSp * 14),
                        ),
                      if (appointmentModel!.wednesday!.open!)
                        Text(
                          "Wednesday,",
                          style: TextStyle(fontSize: fontSp * 14),
                        ),
                      if (appointmentModel!.thursday!.open!)
                        Text(
                          "Thursday,",
                          style: TextStyle(fontSize: fontSp * 14),
                        ),
                      if (appointmentModel!.friday!.open!)
                        Text(
                          "Friday,",
                          style: TextStyle(fontSize: fontSp * 14),
                        ),
                      if (appointmentModel!.saturday!.open!)
                        Text(
                          "Saturday,",
                          style: TextStyle(fontSize: fontSp * 14),
                        ),
                      if (appointmentModel!.sunday!.open!)
                        Text(
                          "Sunday,",
                          style: TextStyle(fontSize: fontSp * 14),
                        ),
                    ],
                  ),

                  ///
                  SizedBox(height: heightDp * 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${appointmentModel!.timeslot} min",
                            style: TextStyle(fontSize: fontSp * 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: heightDp * 2),
                          Row(
                            children: [
                              Text(
                                KeicyDateTime.convertDateTimeToDateString(
                                  dateTime: appointmentModel!.startDate,
                                  isUTC: false,
                                ),
                                style: TextStyle(fontSize: fontSp * 12, color: Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (appointmentModel!.endDate != null)
                                Text(
                                  " ~ " +
                                      KeicyDateTime.convertDateTimeToDateString(
                                        dateTime: appointmentModel!.endDate,
                                        isUTC: false,
                                      ),
                                  style: TextStyle(fontSize: fontSp * 12, color: Colors.grey),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ],
                      ),
                      KeicyRaisedButton(
                        width: widthDp * 90,
                        height: heightDp * 30,
                        color: config.Colors().mainColor(1),
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                        borderRadius: heightDp * 6,
                        child: Text(
                          "Book",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                        ),
                        onPressed: bookHandler,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
