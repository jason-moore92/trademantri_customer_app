import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/entities/lucky_draw_entry.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/entities/lucky_draw_prize.dart';
import 'package:trapp/src/helpers/helper.dart';

class LuckyDrawPrizeWidget extends StatelessWidget {
  final LuckyDrawEntry? entry;
  final int? index;
  final LuckyDrawPrize? prize;
  final bool? revertColors;

  const LuckyDrawPrizeWidget({
    Key? key,
    @required this.entry,
    @required this.index,
    @required this.prize,
    this.revertColors = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = 1.sw;
    double deviceHeight = 1.sh;
    double statusbarHeight = ScreenUtil().statusBarHeight;
    double bottomBarHeight = ScreenUtil().bottomBarHeight;
    double appbarHeight = AppBar().preferredSize.height;

    double widthDp = ScreenUtil().setWidth(1);
    // heightDp = ScreenUtil().setWidth(1);
    double heightDp1 = ScreenUtil().setHeight(1);
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    int winPosition = index! + 1;

    Color backColor = Colors.white;
    Color frontColor = config.Colors().mainColor(1);
    if (revertColors != null) {
      if (revertColors!) {
        backColor = config.Colors().mainColor(1);
        frontColor = Colors.white;
      }
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: deviceWidth * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: backColor,
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image.asset(
            //   "img/logo_small.png",
            //   height: 50,
            //   fit: BoxFit.fitHeight,
            // ),
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(50),
            //   ),
            //   padding: EdgeInsets.all(10.0),
            //   width: 50,
            //   height: 50,
            //   child: Text(
            //     "${entry!.user!.firstName!.characters.first} ${entry!.user!.lastName!.characters.first}",
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontSize: fontSp * 18,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            Icon(
              Icons.account_circle,
              size: 50,
              color: frontColor,
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  entry!.user!.firstName!,
                  style: TextStyle(
                    color: frontColor,
                    fontSize: fontSp * 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  entry!.user!.lastName!,
                  style: TextStyle(
                    color: frontColor,
                    fontSize: fontSp * 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "${winPosition}${ordinal(winPosition)} Prize",
              style: TextStyle(
                color: frontColor,
                fontSize: fontSp * 25,
              ),
            ),

            SizedBox(
              height: 16.0,
            ),
            Text(
              "₹ ${entry!.rewardAmount!.toString()}",
              style: TextStyle(
                color: frontColor,
                fontSize: fontSp * 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            if (prize!.rewardType == "percentage")
              Text(
                "${prize!.amount!.toString()}% on order amount",
                style: TextStyle(
                  color: frontColor,
                  fontSize: fontSp * 16,
                ),
              ),
            if (prize!.rewardType == "fixed")
              Text(
                "Flat ${prize!.amount!.toString()} refund",
                style: TextStyle(
                  color: frontColor,
                  fontSize: fontSp * 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
