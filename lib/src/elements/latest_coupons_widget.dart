library keicy_text_form_field;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/coupon_widget.dart';
import 'package:trapp/src/elements/coupon_widget_short.dart';
import 'package:trapp/src/models/coupon_model.dart';
import 'package:trapp/src/pages/CouponDetailPage/coupon_detail_page.dart';
import 'package:trapp/src/pages/StorePage/store_view.dart';
import 'package:trapp/src/providers/index.dart';

class LatestCouponsWidget extends StatelessWidget {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  AppDataProvider? _appDataProvider;

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

    _appDataProvider = AppDataProvider.of(context);

    List<CouponModel> couponsList = [];
    couponsList.addAll(_appDataProvider!.appDataState.couponsList!);

    // double imageWidth = widthDp * 50;
    // double imageHeight = widthDp * 50;
    // double cardWidth = widthDp * 120;
    // double cardHeight = heightDp * 140;
    // double mainAxisSpacing = widthDp * 10;
    // double crossAxisSpacing = heightDp * 10;

    return Column(
      children: [
        SizedBox(height: heightDp * 20),
        // CarouselSlider(
        //   items: couponsList.map((coupon) {
        //     return Builder(
        //       builder: (BuildContext context) {
        //         return CouponWidgetShort(
        //           coupon: coupon,
        //           isLoading: false,
        //           tapHandler: () {
        //             Navigator.of(context).push(
        //               MaterialPageRoute(
        //                 builder: (BuildContext context) => StoreView(
        //                   storeModel: coupon.store,
        //                   immediateAction: "go_to_coupons",
        //                 ),
        //               ),
        //             );
        //           },
        //         );
        //       },
        //     );
        //   }).toList(),
        //   options: CarouselOptions(
        //     height: (deviceWidth - widthDp * 10) * 2 / 5,
        //     aspectRatio: 5 / 2,
        //     viewportFraction: 0.5,
        //     enableInfiniteScroll: true,
        //     autoPlay: true,
        //     enlargeCenterPage: true,
        //     pauseAutoPlayOnTouch: false,
        //   ),
        // ),
        Container(
          height: heightDp * 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: couponsList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              CouponModel coupon = couponsList[index];
              return CouponWidgetShort(
                coupon: coupon,
                isLoading: false,
                tapHandler: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => StoreView(
                        storeModel: coupon.store,
                        immediateAction: "go_to_coupons",
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Container(
        //   // height: heightDp * 360,
        //   width: deviceWidth,
        //   height: couponsList.length <= 3
        //       ? cardHeight + heightDp * 5
        //       : couponsList.length <= 6
        //           ? cardHeight * 2 + crossAxisSpacing + heightDp * 5
        //           : cardHeight * 3 + crossAxisSpacing * 2 + heightDp * 5,
        //   alignment: Alignment.center,
        //   child: GridView.builder(
        //     physics: couponsList.length <= 9 ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
        //     scrollDirection: couponsList.length <= 9 ? Axis.vertical : Axis.horizontal,
        //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 3,
        //       mainAxisSpacing: mainAxisSpacing,
        //       crossAxisSpacing: crossAxisSpacing,
        //       childAspectRatio: couponsList.length <= 9 ? cardWidth / cardHeight : cardHeight / cardWidth,
        //     ),
        //     padding: EdgeInsets.zero,
        //     itemCount: couponsList.length,
        //     shrinkWrap: true,
        //     itemBuilder: (context, index) {
        //       CouponModel coupon = couponsList[index];

        //       return CouponWidgetShort(
        //         coupon: coupon,
        //         isLoading: false,
        //         tapHandler: () {
        //           Navigator.of(context).push(
        //             MaterialPageRoute(
        //               builder: (BuildContext context) => StoreView(
        //                 storeModel: coupon.store,
        //                 immediateAction: "go_to_coupons",
        //               ),
        //             ),
        //           );
        //         },
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
