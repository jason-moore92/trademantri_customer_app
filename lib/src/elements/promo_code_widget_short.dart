import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/entities/promo_code.dart';

class PromoCodeWidgetShort extends StatefulWidget {
  final PromoCode? promoCode;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Function()? tapHandler;

  PromoCodeWidgetShort({
    @required this.promoCode,
    this.isLoading = true,
    this.padding,
    this.margin,
    this.tapHandler,
  });

  @override
  _PromoCodeWidgetShortState createState() => _PromoCodeWidgetShortState();
}

class _PromoCodeWidgetShortState extends State<PromoCodeWidgetShort> {
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
    PromoCode promoCode = widget.promoCode!;

    Color backColor = Colors.white;
    Color backColor1 = Colors.white;

    Widget discountWidget = SizedBox();

    /// percent
    if (promoCode.type == AppConfig.promoCodeTypes[0]["value"]) {
      backColor = Colors.green.shade500;
      backColor1 = Colors.green.shade600;
      discountWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${promoCode.value}%",
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
    else if (promoCode.type == AppConfig.promoCodeTypes[1]["value"]) {
      // backColor = Color.fromRGBO(53, 81, 162, 1);
      // backColor1 = Color.fromRGBO(53, 110, 162, 1);
      backColor = Colors.blue.shade500;
      backColor1 = Colors.blue.shade600;

      discountWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${promoCode.value}₹",
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
    } else if (promoCode.type == AppConfig.promoCodeTypes[2]["value"]) {
      // backColor = Color.fromRGBO(53, 81, 162, 1);
      // backColor1 = Color.fromRGBO(53, 110, 162, 1);
      backColor = Colors.red.shade500;
      backColor1 = Colors.red.shade600;

      discountWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${promoCode.value}₹",
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
                promoCode.code!,
                style: TextStyle(
                  fontSize: promoCode.code!.length <= 8 ? 20 : 17,
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
                promoCode.description!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  // fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "img/go_to.png",
                    width: 25,
                    height: 25,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: KeicyAvatarImage(
                        url: AppConfig.promoCodeTypeImages[promoCode.type],
                        fit: BoxFit.fitHeight,
                        backColor: Colors.grey.withOpacity(0.6),
                      ),
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
