import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';

class CouponWidgetShort extends StatefulWidget {
  final CouponModel? coupon;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Function()? tapHandler;

  CouponWidgetShort({
    @required this.coupon,
    this.isLoading = true,
    this.padding,
    this.margin,
    this.tapHandler,
  });

  @override
  _CouponWidgetShortState createState() => _CouponWidgetShortState();
}

class _CouponWidgetShortState extends State<CouponWidgetShort> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  var numFormat = NumberFormat.currency(symbol: "", name: "");

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading ? _shimmerWidget() : _mainWidget();
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.isLoading,
      period: Duration(milliseconds: 1000),
      child: Column(
        children: [
          Container(
            height: heightDp * 50,
            color: Colors.white,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "discountValue",
                        style: TextStyle(fontSize: fontSp * 24, color: config.Colors().mainColor(1), fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: heightDp * 5),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "Validate : 202132",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  ],
                )),
                SizedBox(width: widthDp * 10),
                KeicyRaisedButton(
                  width: widthDp * 80,
                  height: heightDp * 35,
                  color: Colors.white,
                  borderRadius: heightDp * 10,
                  child: Text(
                    "View",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainWidget() {
    CouponModel coupon = widget.coupon!;

    Color backColor = Colors.white;
    Color backColor1 = Colors.white;

    Widget discountWidget = SizedBox();

    /// percent
    if (coupon.discountType == AppConfig.discountTypeForCoupon[0]["value"]) {
      backColor = Colors.green.shade500;
      backColor1 = Colors.green.shade600;
      discountWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${coupon.discountData!["discountValue"]}%",
            style: TextStyle(
              fontSize: fontSp * 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            " OFF",
            style: TextStyle(
              fontSize: fontSp * 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
    // fix amount
    else if (coupon.discountType == AppConfig.discountTypeForCoupon[1]["value"]) {
      // backColor = Color.fromRGBO(53, 81, 162, 1);
      // backColor1 = Color.fromRGBO(53, 110, 162, 1);
      backColor = Colors.blue.shade500;
      backColor1 = Colors.blue.shade600;

      discountWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${coupon.discountData!["discountValue"]}₹",
            style: TextStyle(
              fontSize: fontSp * 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            " OFF",
            style: TextStyle(
              fontSize: fontSp * 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
    // BOGO
    else if (coupon.discountType == AppConfig.discountTypeForCoupon[2]["value"]) {
      backColor = Colors.red.shade500;
      backColor1 = Colors.red.shade600;

      discountWidget = Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Buy ${coupon.discountData!["customerBogo"]["buy"]["quantity"]}",
                style: TextStyle(
                  fontSize: fontSp * 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Get ${coupon.discountData!["customerBogo"]["get"]["quantity"]}",
                    style: TextStyle(
                      fontSize: fontSp * 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: widthDp * 10),
                  Text(
                    coupon.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[0]["value"]
                        ? "${AppConfig.discountBuyValueForCoupon[0]["text"].toString().toUpperCase()}"
                        : "${coupon.discountData!["customerBogo"]["get"]["percentValue"]} %  OFF",
                    style: TextStyle(
                      fontSize: fontSp * 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () {
        if (widget.tapHandler != null) {
          widget.tapHandler!();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: deviceWidth * 0.4,
          decoration: BoxDecoration(
            // color: backColor,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.5, 0.7],
              colors: [
                backColor,
                backColor1,
              ],
            ),
            borderRadius: BorderRadius.circular(24.0),
          ),
          padding: EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 4.0,
              ),
              Text(
                coupon.discountCode!,
                style: TextStyle(
                  fontSize: coupon.discountCode!.length <= 8 ? 20 : 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              discountWidget,
              SizedBox(
                height: 4.0,
              ),
              Text(
                coupon.store!.name!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  // fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "img/go_to.png",
                    width: 25,
                    height: 25,
                  ),
                  Expanded(
                    child: KeicyAvatarImage(
                      //coupon.images!.isNotEmpty ? coupon.images![0] :
                      url: AppConfig.discountTypeImages1[coupon.discountType],
                      // width: 100,
                      // height: 80,
                      fit: BoxFit.fitHeight,
                      backColor: Colors.grey.withOpacity(0.6),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
