import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/config/app_config.dart' as config;

class ReverseAuctionWidget extends StatefulWidget {
  final Map<String, dynamic>? reverseAuctionData;
  final bool? loadingStatus;
  final Function()? cancelCallback;
  final Function()? detailCallback;
  final Function()? changeEndDateHandler;

  ReverseAuctionWidget({
    @required this.reverseAuctionData,
    @required this.loadingStatus,
    this.cancelCallback,
    this.detailCallback,
    this.changeEndDateHandler,
  });

  @override
  _ReverseAuctionWidgetState createState() => _ReverseAuctionWidgetState();
}

class _ReverseAuctionWidgetState extends State<ReverseAuctionWidget> {
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

  String reverseAuctionStatus = "";

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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0, 3), blurRadius: 6)],
        borderRadius: BorderRadius.circular(heightDp * 8),
      ),
      child: widget.loadingStatus! ? _shimmerWidget() : _orderWidget(),
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
          ///
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "asdf -asdfasfsfasf",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
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

          ///
          Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "Reverse Auction Status:",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "Pick up",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: heightDp * 7),
          Container(
            width: deviceWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    "Bidding Start Date",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Text(
                    "2021-05-06",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: heightDp * 7),
          Container(
            width: deviceWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    "Bidding End Date:  ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Text(
                    "2021-05-06",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: heightDp * 7),
          Container(
            width: deviceWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    "Bidding Price:",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Text(
                    "₹ 1235.32",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderWidget() {
    for (var i = 0; i < AppConfig.reverseAuctionStatusData.length; i++) {
      if (AppConfig.reverseAuctionStatusData[i]["id"] == widget.reverseAuctionData!["status"]) {
        reverseAuctionStatus = AppConfig.reverseAuctionStatusData[i]["name"];
        break;
      }
    }
    if ((DateTime.tryParse(widget.reverseAuctionData!['biddingEndDateTime'])!.toLocal()).isBefore(DateTime.now())) {
      reverseAuctionStatus = "Auction ended";
    }

    return GestureDetector(
      onTap: widget.detailCallback!,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.reverseAuctionData!["reverseAuctionId"],
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  KeicyDateTime.convertDateTimeToDateString(
                    dateTime: DateTime.parse(widget.reverseAuctionData!["updatedAt"]),
                    formats: "Y-m-d H:i",
                    isUTC: false,
                  ),
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ],
            ),

            ///
            Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Reverse Auction Status:   ",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                Text(
                  reverseAuctionStatus,
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: heightDp * 7),
            Container(
              width: deviceWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bidding Start Date:  ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    KeicyDateTime.convertDateTimeToDateString(
                      dateTime: DateTime.tryParse(widget.reverseAuctionData!['biddingStartDateTime']),
                      formats: 'Y-m-d h:i A',
                      isUTC: false,
                    ),
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ],
              ),
            ),

            SizedBox(height: heightDp * 7),
            Container(
              width: deviceWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bidding End Date:  ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    KeicyDateTime.convertDateTimeToDateString(
                      dateTime: DateTime.tryParse(widget.reverseAuctionData!['biddingEndDateTime']),
                      formats: 'Y-m-d h:i A',
                      isUTC: false,
                    ),
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ],
              ),
            ),

            SizedBox(height: heightDp * 7),
            Container(
              width: deviceWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bidding Price:  ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "₹ ${widget.reverseAuctionData!['biddingPrice']}",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ],
              ),
            ),

            ///
            if (AppConfig.reverseAuctionStatusData[1]["name"] == reverseAuctionStatus)
              Column(
                children: [
                  SizedBox(height: heightDp * 7),
                  Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  _placeBidButtonGrop(),
                ],
              )
            else if (AppConfig.reverseAuctionStatusData[2]["name"] == reverseAuctionStatus)
              Column(
                children: [
                  SizedBox(height: heightDp * 7),
                  Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  _placeBidButtonGrop(),
                ],
              )
            else
              SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _placeBidButtonGrop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        KeicyRaisedButton(
          width: widthDp * 140,
          height: heightDp * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Change End Date",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: widget.changeEndDateHandler,
        ),
        KeicyRaisedButton(
          width: widthDp * 140,
          height: heightDp * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: widget.cancelCallback,
        ),
      ],
    );
  }
}
