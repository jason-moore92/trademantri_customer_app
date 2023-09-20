import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'keicy_avatar_image.dart';

class BookAppointmentWidget extends StatefulWidget {
  final BookAppointmentModel? bookAppointmentModel;
  final bool? loadingStatus;
  final Function()? detailHandler;

  BookAppointmentWidget({
    @required this.bookAppointmentModel,
    @required this.loadingStatus,
    @required this.detailHandler,
  });

  @override
  _BookAppointmentWidgetState createState() => _BookAppointmentWidgetState();
}

class _BookAppointmentWidgetState extends State<BookAppointmentWidget> {
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
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        left: widthDp * 15,
        right: widthDp * 15,
        top: heightDp * 5,
        bottom: heightDp * 10,
      ),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
        color: Colors.transparent,
        child: widget.loadingStatus! ? _shimmerWidget() : _orderWidget(),
      ),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.loadingStatus!,
      period: Duration(milliseconds: 1000),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: widthDp * 70,
                height: widthDp * 70,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(heightDp * 6)),
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "Store Name",
                        style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.bold, color: Colors.transparent),
                      ),
                    ),
                    SizedBox(height: heightDp * 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          color: Colors.white,
                          child: Text(
                            'Order Id 123123',
                            style: TextStyle(fontSize: fontSp * 12, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: Text(
                            '2021-05-65',
                            style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "order city",
                        style: TextStyle(fontSize: fontSp * 11, color: Colors.transparent),
                      ),
                    ),
                    SizedBox(height: heightDp * 5),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "Store address sfsdf",
                        style: TextStyle(fontSize: fontSp * 11, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(heightDp * 6),
                    bottomRight: Radius.circular(heightDp * 6),
                  ),
                ),
                child: Text(
                  "Not Paid",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: heightDp * 10),

          ///
          Column(
            children: [
              Container(
                width: deviceWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "Order Status:   ",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "orderStatus",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 7),
          Column(
            children: [
              Container(
                width: deviceWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "Order Type:   ",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "pick up",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///
          Column(
            children: [
              SizedBox(height: heightDp * 7),
              Container(
                width: deviceWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "Pickup Date:  ",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "2021-05-26",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "To Pay: ",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "₹ 4163.25",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderWidget() {
    String status = "Created";
    for (var i = 0; i < AppConfig.bookAppointmentStatus.length; i++) {
      if (widget.bookAppointmentModel!.status == AppConfig.bookAppointmentStatus[i]["id"]) {
        status = AppConfig.bookAppointmentStatus[i]["name"];
      }
    }
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                KeicyAvatarImage(
                  url: widget.bookAppointmentModel!.appointmentModel!.image,
                  width: heightDp * 70,
                  height: heightDp * 70,
                  backColor: Colors.transparent,
                  errorWidget: Icon(Icons.event, size: heightDp * 70, color: config.Colors().mainColor(1)),
                ),
                SizedBox(width: widthDp * 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Event Name : ",
                            style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                          ),
                          Expanded(
                            child: Text(
                              "${widget.bookAppointmentModel!.appointmentModel!.name}",
                              style: TextStyle(fontSize: fontSp * 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp * 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Location : ",
                            style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                          ),
                          Expanded(
                            child: Text(
                              "${widget.bookAppointmentModel!.appointmentModel!.address}",
                              style: TextStyle(fontSize: fontSp * 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp * 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Store Name : ",
                            style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                          ),
                          Expanded(
                            child: Text(
                              "${widget.bookAppointmentModel!.storeModel!.name}",
                              style: TextStyle(fontSize: fontSp * 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: heightDp * 20, thickness: 1, color: Colors.grey.withOpacity(0.7)),
            Text(
              "${widget.bookAppointmentModel!.bookingNumber}",
              style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: heightDp * 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey.withOpacity(0.7)),
                        top: BorderSide(color: Colors.grey.withOpacity(0.7)),
                        bottom: BorderSide(color: Colors.grey.withOpacity(0.7)),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${widget.bookAppointmentModel!.date}",
                          style: TextStyle(fontSize: fontSp * 16),
                        ),
                        SizedBox(height: heightDp * 5),
                        Text(
                          "Date",
                          style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey.withOpacity(0.7)),
                        right: BorderSide(color: Colors.grey.withOpacity(0.7)),
                        top: BorderSide(color: Colors.grey.withOpacity(0.7)),
                        bottom: BorderSide(color: Colors.grey.withOpacity(0.7)),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${widget.bookAppointmentModel!.starttime}",
                          style: TextStyle(fontSize: fontSp * 16),
                        ),
                        SizedBox(height: heightDp * 5),
                        Text(
                          "Time",
                          style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey.withOpacity(0.7)),
                        top: BorderSide(color: Colors.grey.withOpacity(0.7)),
                        bottom: BorderSide(color: Colors.grey.withOpacity(0.7)),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${widget.bookAppointmentModel!.slottime} min",
                          style: TextStyle(fontSize: fontSp * 16),
                        ),
                        SizedBox(height: heightDp * 5),
                        Text(
                          "Time Slot",
                          style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: heightDp * 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Status : ",
                  style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "$status",
                  style: TextStyle(fontSize: fontSp * 16),
                ),
              ],
            ),
            SizedBox(height: heightDp * 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: heightDp * 25),
                SizedBox(width: widthDp * 5),
                Text(
                  "${widget.bookAppointmentModel!.noOfGuests} " + (widget.bookAppointmentModel!.noOfGuests == 1 ? "Guest" : " Guests"),
                  style: TextStyle(fontSize: fontSp * 16),
                ),
              ],
            ),
            SizedBox(height: heightDp * 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                KeicyRaisedButton(
                  width: widthDp * 90,
                  height: heightDp * 30,
                  color: config.Colors().mainColor(1),
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                  borderRadius: heightDp * 6,
                  child: Text(
                    "Details",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                  ),
                  onPressed: widget.detailHandler,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
