import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/coupon_widget.dart';
import 'package:trapp/src/elements/favorite_icon_widget.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/CouponDetailPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/services/dynamic_link_service.dart';

class AnnouncementDetailView extends StatefulWidget {
  final Map<String, dynamic>? announcementData;
  final Map<String, dynamic>? storeData;

  AnnouncementDetailView({Key? key, this.storeData, this.announcementData}) : super(key: key);

  @override
  _AnnouncementDetailViewState createState() => _AnnouncementDetailViewState();
}

class _AnnouncementDetailViewState extends State<AnnouncementDetailView> with SingleTickerProviderStateMixin {
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
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _shareHandler(Map<String, dynamic> announcementData) async {
    Uri dynamicUrl = await DynamicLinkService.createAnnouncementDynamicLink(
      storeData: widget.storeData,
      announcementData: announcementData,
    );
    Share.share(dynamicUrl.toString());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FavoriteProvider.of(context).favoriteUpdateHandler();
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return false;
          },
          child: SingleChildScrollView(
            child: Container(
              width: deviceWidth,
              color: config.Colors().mainColor(1),
              child: Column(
                children: [
                  ///
                  _headerWidget(),

                  _mainPanel(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerWidget() {
    String announcementStr = "";

    if (widget.announcementData!["announcementto"].toString().toLowerCase().contains("customer")) {
      announcementStr = "Customers";
    } else {
      announcementStr = "Business";
    }

    return Container(
      width: deviceWidth,
      color: config.Colors().mainColor(1),
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      margin: EdgeInsets.only(top: statusbarHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              FavoriteProvider.of(context).favoriteUpdateHandler();
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: heightDp * 10),
              child: Icon(Icons.arrow_back_ios, size: heightDp * 25, color: Colors.white),
            ),
          ),
          Center(
            child: KeicyAvatarImage(
              url: widget.announcementData!["images"].isNotEmpty ? widget.announcementData!["images"][0] : AppConfig.announcementImage[0],
              width: heightDp * 150,
              height: heightDp * 150,
              backColor: Colors.grey.withOpacity(0.6),
            ),
          ),
          SizedBox(height: heightDp * 15),
          Center(
            child: Text(
              "$announcementStr",
              style: TextStyle(fontSize: fontSp * 24, color: Colors.white, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: heightDp * 15),
        ],
      ),
    );
  }

  Widget _mainPanel() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(heightDp * 30),
          topRight: Radius.circular(heightDp * 30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: heightDp * 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Post Date: ",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    KeicyDateTime.convertDateTimeToDateString(
                      dateTime: DateTime.tryParse("${widget.announcementData!["datetobeposted"]}"),
                      formats: "Y-m-d",
                      isUTC: false,
                    ),
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                ],
              ),
              Row(
                children: [
                  FavoriteIconWidget(
                    category: "announcements",
                    id: widget.announcementData!["_id"],
                    storeId: widget.storeData!["_id"],
                    size: heightDp * 30,
                  ),
                  SizedBox(width: widthDp * 5),
                  GestureDetector(
                    onTap: () async {
                      Uri dynamicUrl = await DynamicLinkService.createAnnouncementDynamicLink(
                        announcementData: widget.announcementData,
                        storeData: widget.announcementData!["store"],
                      );
                      Share.share(dynamicUrl.toString());
                    },
                    child: Icon(Icons.share, size: heightDp * 30, color: config.Colors().mainColor(1)),
                  ),
                ],
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 15),
          Text(
            "Title",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 5),
          Text(
            "${widget.announcementData!["title"]}",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),

          ///
          SizedBox(height: heightDp * 15),
          Text(
            "Description",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 5),
          Text(
            "${widget.announcementData!["description"]}",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
          ),

          ///
          SizedBox(height: heightDp * 15),
          Text(
            "City",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 5),
          Text(
            "${widget.announcementData!["city"]}",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),

          ///
          SizedBox(height: heightDp * 15),
          Text(
            "Store Name",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 5),
          Text(
            "${widget.storeData!["name"]}",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
          if (widget.announcementData!["coupon"] != null) SizedBox(height: heightDp * 15),
          if (widget.announcementData!["coupon"] != null && widget.announcementData!["coupon"].isNotEmpty)
            CouponWidget(
              couponModel: widget.announcementData!["coupon"].isNotEmpty ? CouponModel.fromJson(widget.announcementData!["coupon"][0]) : null,
              isLoading: widget.announcementData!["coupon"].isEmpty,
              margin: EdgeInsets.zero,
              storeModel: StoreModel.fromJson(widget.storeData!),
              isShowFavorite: false,
              isShowShare: false,
            ),

          ///
          SizedBox(height: heightDp * 15),
        ],
      ),
    );
  }

  void _viewHandler(Map<String, dynamic> couponData) async {
    FavoriteProvider.of(context).favoriteUpdateHandler();

    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => CouponDetailPage(
          couponModel: CouponModel.fromJson(couponData),
          storeModel: StoreModel.fromJson(widget.storeData!),
        ),
      ),
    );
  }
}
