import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/coupon_widget.dart';
import 'package:trapp/src/elements/favorite_icon_widget.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/CouponDetailPage/index.dart';
import 'package:trapp/src/services/dynamic_link_service.dart';

class AnnouncementWidget extends StatelessWidget {
  final Map<String, dynamic>? announcementData;
  final Map<String, dynamic>? storeData;
  final bool? isLoading;
  final bool? isShowStoreButton;
  final bool? isShowFavoriteButton;
  final Function()? editHandler;
  final Function()? shareHandler;
  final Function(bool)? enableHandler;
  final Function()? goToStoreHandler;
  final Function()? detailHandler;

  AnnouncementWidget({
    @required this.announcementData,
    @required this.storeData,
    @required this.isLoading,
    this.isShowStoreButton = true,
    this.isShowFavoriteButton = true,
    this.editHandler,
    this.shareHandler,
    this.enableHandler,
    this.goToStoreHandler,
    this.detailHandler,
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
      margin: EdgeInsets.only(
        left: widthDp * 15,
        right: widthDp * 15,
        top: heightDp * 5,
        bottom: heightDp * 10,
      ),
      elevation: 5,
      child: Container(
        width: widthDp * 175,
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
        child: isLoading! ? _shimmerWidget() : _announcementWidget(context),
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
                    "announcementData title",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "announcementData body\nannouncementData body body body body",
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

  Widget _announcementWidget(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            KeicyAvatarImage(
              url: announcementData!["images"].isNotEmpty ? announcementData!["images"][0] : AppConfig.announcementImage[0],
              width: heightDp * 70,
              height: heightDp * 70,
              backColor: Colors.grey.withOpacity(0.7),
            ),
            SizedBox(width: widthDp * 10),
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${announcementData!["title"]}",
                            style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isShowFavoriteButton!)
                          FavoriteIconWidget(
                            category: "announcements",
                            id: announcementData!["_id"],
                            storeId: announcementData!["store"]["_id"],
                            size: heightDp * 25,
                          ),
                        SizedBox(width: widthDp * 5),
                        GestureDetector(
                          onTap: () async {
                            Uri dynamicUrl = await DynamicLinkService.createAnnouncementDynamicLink(
                              announcementData: announcementData,
                              storeData: announcementData!["store"],
                            );
                            Share.share(dynamicUrl.toString());
                          },
                          child: Icon(Icons.share, size: heightDp * 25, color: config.Colors().mainColor(1)),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Text(
                      "${announcementData!["description"]}",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: heightDp * 5),
                    Row(
                      children: [
                        Text(
                          "City:  ",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${announcementData!["city"]}",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Row(
                      children: [
                        Text(
                          "Store:  ",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: Text(
                            "${announcementData!["store"]["name"]}",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: heightDp * 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isShowStoreButton!)
              KeicyRaisedButton(
                width: widthDp * 110,
                height: heightDp * 35,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 6,
                padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                child: Text(
                  "Go to Store",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
                onPressed: goToStoreHandler,
              ),
            SizedBox(width: widthDp * 10),
            KeicyRaisedButton(
              width: widthDp * 80,
              height: heightDp * 35,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 6,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Detail",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
              ),
              onPressed: detailHandler,
            ),
          ],
        ),
        if (announcementData!["coupon"].isNotEmpty) SizedBox(height: heightDp * 10),
        if (announcementData!["coupon"].isNotEmpty)
          CouponWidget(
            couponModel: announcementData!["coupon"][0].isNotEmpty ? CouponModel.fromJson(announcementData!["coupon"][0]) : null,
            isLoading: announcementData!["coupon"][0].isEmpty,
            margin: EdgeInsets.zero,
            storeModel: StoreModel.fromJson(storeData!),
            isShowFavorite: false,
            isShowShare: false,
          ),
      ],
    );
  }
}
