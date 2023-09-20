import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/dialogs/lucky_draw_info_dialog.dart';
import 'package:trapp/src/entities/lucky_draw_config.dart';
import 'package:trapp/src/entities/lucky_draw_entry.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/pages/lucky_draw_prize.dart';

/// Responsive design variables
double deviceWidth = 0;
double deviceHeight = 0;
double statusbarHeight = 0;
double bottomBarHeight = 0;
double appbarHeight = 0;
double widthDp = 0;
// double heightDp;
double heightDp1 = 0;
double fontSp = 0;

class LuckyDrawWinnersWidget extends StatefulWidget {
  final LuckyDrawConfig? luckyDrawConfig;

  LuckyDrawWinnersWidget({
    @required this.luckyDrawConfig,
  });

  @override
  _LuckyDrawWinnersWidgetState createState() => _LuckyDrawWinnersWidgetState();
}

class _LuckyDrawWinnersWidgetState extends State<LuckyDrawWinnersWidget> {
  LuckyDrawConfig? luckyDrawConfig;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  void initState() {
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;

    widthDp = ScreenUtil().setWidth(1);
    // heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    luckyDrawConfig = widget.luckyDrawConfig;
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   centerTitle: true,
      //   backgroundColor: config.Colors().mainColor(1),
      //   // actionsIconTheme: Theme.of(context).appBarTheme.actionsIconTheme!.merge(IconThemeData(color: Colors.white)),
      //   actionsIconTheme: IconThemeData(color: Colors.white),
      //   title: Text(
      //     'Luckydraw Winners',
      //     style: Theme.of(context).textTheme.headline6!.merge(
      //           TextStyle(
      //             letterSpacing: 1.3,
      //             color: Colors.white,
      //           ),
      //         ),
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         LuckyDrawInfoDialog.show(
      //           context,
      //         );
      //       },
      //       icon: Icon(Icons.info_outline),
      //     )
      //   ],
      // ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            // color: Colors.white,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.5, 0.7],
                colors: [
                  Color.fromRGBO(243, 111, 47, 1),
                  Color.fromRGBO(240, 80, 46, 1),
                ],
              ),
              // gradient: RadialGradient(
              //   radius: 90.6703,
              //   colors: [
              //     Color.fromRGBO(243, 111, 47, 1),
              //     Color.fromRGBO(240, 80, 46, 1),
              //   ],
              // ),
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Image.asset(
                    "img/lucky_draw/winners.png",
                    height: MediaQuery.of(context).size.height * 0.4,
                    fit: BoxFit.fitHeight,
                    // color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      KeicyDateTime.convertDateTimeToDateString(
                        dateTime: luckyDrawConfig!.start!,
                        formats: "Y-m-d H:i",
                        isUTC: false,
                      ),
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                        Icons.repeat_rounded,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      KeicyDateTime.convertDateTimeToDateString(
                        dateTime: luckyDrawConfig!.end!,
                        formats: "Y-m-d H:i",
                        isUTC: false,
                      ),
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 0),
                  child: CarouselSlider.builder(
                    itemCount: luckyDrawConfig!.entries!.length,
                    itemBuilder: (context, itemIndex, pageViewIndex) {
                      LuckyDrawEntry entry = luckyDrawConfig!.entries![itemIndex];
                      return LuckyDrawPrizeWidget(
                        entry: entry,
                        index: itemIndex,
                        prize: luckyDrawConfig!.prizes![itemIndex],
                      );
                    },
                    carouselController: _controller,
                    options: CarouselOptions(
                      height: deviceHeight * 0.4,
                      // aspectRatio: 3 / 2,
                      viewportFraction: 0.7,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      pauseAutoPlayOnTouch: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: luckyDrawConfig!.entries!.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // color: config.Colors().mainColor(_current == entry.key ? 0.9 : 0.4),
                          color: Colors.white.withOpacity(_current == entry.key ? 0.9 : 0.4),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              padding: EdgeInsets.only(top: 32),
              onPressed: () {
                LuckyDrawInfoDialog.show(
                  context,
                );
              },
              icon: Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              padding: EdgeInsets.only(top: 32),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
