library keicy_text_form_field;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trapp/src/elements/promo_code_widget_short.dart';
import 'package:trapp/src/entities/promo_code.dart';
import 'package:trapp/src/providers/index.dart';

class ActivePromoCodesWidget extends StatelessWidget {
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

    List<PromoCode> promoCodes = [];
    promoCodes.addAll(_appDataProvider!.appDataState.promoCodes!);

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
        //   items: promoCodes.map((coupon) {
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
            itemCount: promoCodes.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              PromoCode promoCode = promoCodes[index];
              return PromoCodeWidgetShort(
                promoCode: promoCode,
                isLoading: false,
                tapHandler: () {
                  Clipboard.setData(ClipboardData(text: promoCode.code));
                  Fluttertoast.showToast(msg: "${promoCode.code} is copied to clipboard.");
                },
              );
            },
          ),
        ),

        // Container(
        //   // height: heightDp * 360,
        //   width: deviceWidth,
        //   height: promoCodes.length <= 3
        //       ? cardHeight + heightDp * 5
        //       : promoCodes.length <= 6
        //           ? cardHeight * 2 + crossAxisSpacing + heightDp * 5
        //           : cardHeight * 3 + crossAxisSpacing * 2 + heightDp * 5,
        //   alignment: Alignment.center,
        //   child: GridView.builder(
        //     physics: promoCodes.length <= 9 ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
        //     scrollDirection: promoCodes.length <= 9 ? Axis.vertical : Axis.horizontal,
        //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 3,
        //       mainAxisSpacing: mainAxisSpacing,
        //       crossAxisSpacing: crossAxisSpacing,
        //       childAspectRatio: promoCodes.length <= 9 ? cardWidth / cardHeight : cardHeight / cardWidth,
        //     ),
        //     padding: EdgeInsets.zero,
        //     itemCount: promoCodes.length,
        //     shrinkWrap: true,
        //     itemBuilder: (context, index) {
        //       PromoCode coupon = promoCodes[index];

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
