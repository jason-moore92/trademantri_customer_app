import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/helpers/date_time_convert.dart';

class StorePanel extends StatefulWidget {
  final Map<String, dynamic>? storeData;
  final Function? acceptHandler;
  final String? status;
  final bool? loadingStatus;

  StorePanel({
    @required this.storeData,
    @required this.acceptHandler,
    @required this.status,
    @required this.loadingStatus,
  });

  @override
  _CartListPanelState createState() => _CartListPanelState();
}

class _CartListPanelState extends State<StorePanel> {
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
      margin: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
      elevation: 4,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(heightDp * 6),
        ),
        child: widget.loadingStatus! ? SizedBox() : _mainPanel(),
      ),
    );
  }

  Widget _mainPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            KeicyAvatarImage(
              url: widget.storeData!["profile"]["image"],
              width: widthDp * 70,
              height: widthDp * 70,
              backColor: Colors.grey.withOpacity(0.4),
              borderRadius: heightDp * 6,
              errorWidget: ClipRRect(
                borderRadius: BorderRadius.circular(heightDp * 6),
                child: Image.asset(
                  "img/store-icon/${widget.storeData!["subType"].toString().toLowerCase()}-store.png",
                  width: widthDp * 70,
                  height: widthDp * 70,
                ),
              ),
            ),
            SizedBox(width: widthDp * 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.storeData!["name"]} Store",
                    style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.bold, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: heightDp * 5),
                  Text(
                    '${widget.storeData!["city"]}',
                    style: TextStyle(fontSize: fontSp * 11, color: Colors.black),
                  ),
                  SizedBox(height: heightDp * 5),
                  Text(
                    "${widget.storeData!["address"]}",
                    style: TextStyle(fontSize: fontSp * 11, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: heightDp * 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Store Offer Price: ",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "₹ ${widget.storeData!["storeBiddingPrice"]}",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(height: heightDp * 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Bidding Date: ",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              KeicyDateTime.convertDateTimeToDateString(
                dateTime: DateTime.tryParse(widget.storeData!["biddingDate"]),
                formats: 'Y-m-d h:i A',
                isUTC: false,
              ),
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(height: heightDp * 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Message",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                ),
                widget.status == AppConfig.reverseAuctionStatusData[2]["id"]
                    ? KeicyRaisedButton(
                        width: widthDp * 80,
                        height: heightDp * 30,
                        color: config.Colors().mainColor(1),
                        borderRadius: heightDp * 6,
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                        child: Text(
                          "Accept",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                        ),
                        onPressed: () {
                          widget.acceptHandler!(widget.storeData!["storeBiddingPrice"], widget.storeData!);
                        },
                      )
                    : SizedBox(),
              ],
            ),
            Text(
              widget.storeData!["storeBiddingMessage"] == "" ? "No message" : "${widget.storeData!["storeBiddingMessage"]}",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }
}
