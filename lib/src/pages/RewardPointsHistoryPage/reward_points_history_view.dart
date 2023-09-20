import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/helpers/date_time_convert.dart';

class RewardPointsHistoryView extends StatefulWidget {
  final List<dynamic>? historyData;
  final Map<String, dynamic>? storeData;

  RewardPointsHistoryView({Key? key, this.historyData, this.storeData}) : super(key: key);

  @override
  _RewardPointsHistoryViewState createState() => _RewardPointsHistoryViewState();
}

class _RewardPointsHistoryViewState extends State<RewardPointsHistoryView> {
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

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text("History", style: TextStyle(fontSize: fontSp * 20)),
        elevation: 1,
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(widget.historyData!.length, (index) {
                Map<String, dynamic> history = widget.historyData![index];

                String body = history["body"];
                body = body.replaceAll("store_name", widget.storeData!["name"]);

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.6)))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${history["title"]}", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
                            SizedBox(height: heightDp * 5),
                            Text(body, style: TextStyle(fontSize: fontSp * 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      SizedBox(width: widthDp * 10),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 3),
                            decoration: BoxDecoration(
                              color: config.Colors().mainColor(1),
                              borderRadius: BorderRadius.circular(heightDp * 6),
                            ),
                            child: Text(
                              "${history["type"]}",
                              style: TextStyle(fontSize: fontSp * 15, color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: heightDp * 5),
                          Row(
                            children: [
                              Image.asset("img/reward_points_icon.png", width: heightDp * 20, height: heightDp * 20),
                              SizedBox(width: widthDp * 5),
                              Text(
                                "${history["rewardPoints"]}",
                                style: TextStyle(fontSize: fontSp * 15, color: Colors.black, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: heightDp * 5),
                          Text(
                            KeicyDateTime.convertDateTimeToDateString(
                              dateTime: DateTime.fromMillisecondsSinceEpoch(history["createAt"]),
                              isUTC: false,
                            ),
                            style: TextStyle(fontSize: fontSp * 15, color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
