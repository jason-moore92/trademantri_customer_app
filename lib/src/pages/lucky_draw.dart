import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/entities/lucky_draw_config.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/config/app_config.dart' as config;

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

class LuckyDrawWidget extends StatefulWidget {
  final LuckyDrawConfig? luckyDrawConfig;

  LuckyDrawWidget({
    @required this.luckyDrawConfig,
  });

  @override
  _LuckyDrawWidgetState createState() => _LuckyDrawWidgetState();
}

class _LuckyDrawWidgetState extends State<LuckyDrawWidget> {
  LuckyDrawConfig? luckyDrawConfig;
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
      //   title: Text(
      //     'Luckydraw Details',
      //     style: Theme.of(context).textTheme.headline6!.merge(TextStyle(letterSpacing: 1.3)),
      //   ),
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
                    "img/lucky_draw/details.png",
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
                      style: TextStyle(
                        fontSize: fontSp * 16,
                        color: Colors.white,
                      ),
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
                      style: TextStyle(
                        fontSize: fontSp * 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (luckyDrawConfig!.entriesCount! > 0) ...[
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "No of participants so far : ${luckyDrawConfig!.entriesCount!}",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
                SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: luckyDrawConfig!.notes!
                          .map(
                            (note) => Container(
                              padding: EdgeInsets.only(bottom: 16.0),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "${note.title} : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: note.body,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              child: Center(
                child: KeicyRaisedButton(
                  color: config.Colors().mainColor(1),
                  borderRadius: 6,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Order Now',
                    style: TextStyle(color: Colors.white, fontSize: fontSp * 14),
                  ),
                ),
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
