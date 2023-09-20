import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/ApiDataProviders/order_api_provider.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/BargainRequestDetailPage/index.dart';
import 'package:trapp/src/pages/BookAppointmentDetailPage/index.dart';
import 'package:trapp/src/pages/MyJobDetailPage/index.dart';
import 'package:trapp/src/pages/OrderDetailNewPage/index.dart';
import 'package:trapp/src/pages/ReverseAuctionDetailPage/index.dart';
import 'package:trapp/src/pages/RewardPointsPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class NotificationWidget extends StatelessWidget {
  final Map<String, dynamic>? notificationData;
  final bool? isLoading;

  NotificationWidget({
    @required this.notificationData,
    @required this.isLoading,
  });

  /// Responsive design variables
  double? deviceWidth;
  double? deviceHeight;
  double? statusbarHeight;
  double? bottomBarHeight;
  double? appbarHeight;
  double? widthDp;
  double? heightDp;
  double? heightDp1;
  double? fontSp;
  ///////////////////////////////

  KeicyProgressDialog? _keicyProgressDialog;

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

    if (_keicyProgressDialog == null) _keicyProgressDialog = KeicyProgressDialog.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp! * 20, vertical: heightDp! * 10),
      color: Colors.transparent,
      child: isLoading! ? _shimmerWidget() : _notificationWidget(context),
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
          Container(width: heightDp! * 80, height: heightDp! * 80, color: Colors.black),
          SizedBox(width: widthDp! * 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    "notificationData storeName",
                    style: TextStyle(fontSize: fontSp! * 18, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: heightDp! * 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "2021-09-23",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightDp! * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "notificationData title",
                    style: TextStyle(fontSize: fontSp! * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: heightDp! * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "notificationData body\nnotificationData body body body body",
                    style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
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

  Widget _notificationWidget(BuildContext context) {
    String assetString = "img/order/${notificationData!["type"]}.png";

    String body = notificationData!["body"] ?? "";

    if (notificationData!["store"] != null && notificationData!["store"].isNotEmpty) {
      body = body.replaceAll("store_name", notificationData!["store"][0]["name"]);
    }

    body = body.replaceAll(
      "user_name",
      AuthProvider.of(context).authState.userModel!.firstName! + " " + AuthProvider.of(context).authState.userModel!.lastName!,
    );

    if (notificationData!["type"] == "order") {
      body = body.replaceAll("orderId", notificationData!["data"]["orderId"]);
      if (notificationData!["data"]["deliveryUserId"] != null && notificationData!["deliveryUser"] != null) {
        body = body.replaceAll(
          "delivery_person_name",
          "${notificationData!["deliveryUser"][0]["firstName"]} ${notificationData!["deliveryUser"][0]["lastName"]}",
        );

        body = body.replaceAll(
          "customerDeliveryCode",
          "${notificationData!["data"]["customerDeliveryCode"]}",
        );

        body = body.replaceAll(
          "storeDeliveryCode",
          "${notificationData!["data"]["storeDeliveryCode"]}",
        );
      }
    }
    if (notificationData!["type"] == "bargain") {
      body = body.replaceAll("bargainRequestId", notificationData!["data"]["bargainRequestId"]);
    }
    if (notificationData!["type"] == "reverse_auction") {
      body = body.replaceAll("reverseAuctionId", notificationData!["data"]["reverseAuctionId"]);
    }

    if (notificationData!["type"] == "job_posting") {
      body = body.replaceAll("job_title", notificationData!["data"]["jobTitle"]);
    }

    if (notificationData!["type"] == "referral_rewardpoint") {
      body = body.replaceAll("referralUserAmount", notificationData!["data"]["referralUserAmount"].toString());
      body = body.replaceAll("referralUserRewardPoints", notificationData!["data"]["referralUserRewardPoints"].toString());
      body = body.replaceAll("referredByUserAmount", notificationData!["data"]["referredByUserAmount"].toString());
      body = body.replaceAll("referredByUserRewardPoints", notificationData!["data"]["referredByUserRewardPoints"].toString());
    }

    String name = "";
    if (notificationData!["store"] != null && notificationData!["store"].isNotEmpty) {
      name = notificationData!["store"][0]["name"];
    }

    if (name == "" &&
        notificationData!["type"] == "referral_rewardpoint" &&
        notificationData!["user"].isNotEmpty &&
        notificationData!["user"][0] != null &&
        notificationData!["user"][0].isNotEmpty) {
      name = "${notificationData!["user"][0]["firstName"]} ${notificationData!["user"][0]["lastName"]}";
    }

    return GestureDetector(
      onTap: () async {
        _tapHandler(context);
      },
      child: Row(
        children: [
          if (notificationData!["type"] == "book_appointment")
            Icon(Icons.event, size: heightDp! * 50, color: config.Colors().mainColor(1))
          else if (notificationData!["type"] == "business_connection")
            Icon(Icons.storefront_outlined, size: heightDp! * 50, color: config.Colors().mainColor(1))
          else
            Image.asset(
              assetString,
              width: heightDp! * 50,
              height: heightDp! * 50,
              errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                return Container(
                  width: heightDp! * 80,
                  height: heightDp! * 80,
                  color: Colors.grey.withOpacity(0.5),
                  child: Center(child: Icon(Icons.not_interested, size: heightDp! * 25, color: Colors.black)),
                );
              },
            ),
          SizedBox(width: widthDp! * 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$name",
                  style: TextStyle(fontSize: fontSp! * 18, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: heightDp! * 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      KeicyDateTime.convertDateTimeToDateString(
                        dateTime: DateTime.tryParse("${notificationData!["updatedAt"]}"),
                        formats: "Y-m-d h:i A",
                        isUTC: false,
                      ),
                      style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: heightDp! * 5),
                Text(
                  "${notificationData!["title"]}",
                  style: TextStyle(fontSize: fontSp! * 16, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: heightDp! * 5),
                Text(
                  body,
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _tapHandler(BuildContext context) async {
    if (notificationData!["type"] == "order") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => OrderDetailNewPage(
            orderId: notificationData!["data"]["orderId"],
            storeId: notificationData!["data"]["storeId"],
            userId: notificationData!["data"]["userId"],
          ),
        ),
      );
    } else if (notificationData!["type"] == "bargain") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BargainRequestDetailPage(
            bargainRequestId: notificationData!["data"]["bargainRequestId"],
            storeId: notificationData!["data"]["storeId"],
            userId: notificationData!["data"]["userId"],
          ),
        ),
      );
    } else if (notificationData!["type"] == "reverse_auction") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => ReverseAuctionDetailPage(
            storeId: notificationData!["data"]["storeId"],
            userId: notificationData!["data"]["userId"],
            reverseAuctionId: notificationData!["data"]["reverseAuctionId"],
          ),
        ),
      );
    } else if (notificationData!["type"] == "job_posting") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => MyJobDetailPage(
            appliedJobData: null,
            jobId: notificationData!["data"]["id"],
          ),
        ),
      );
    } else if (notificationData!["type"] == "scratch_card") {
      await _keicyProgressDialog!.show();
      var result = await OrderApiProvider.getOrder(
        orderId: notificationData!["data"]["orderId"],
        storeId: notificationData!["data"]["storeId"],
        userId: notificationData!["data"]["userId"],
      );
      await _keicyProgressDialog!.hide();

      if (!result["success"] || result["data"].isEmpty) {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: result["message"] ?? "Something was wrong",
        );
      } else {
        OrderModel orderModel = OrderModel.fromJson(result["data"][0]);

        if (orderModel.scratchCard!.isEmpty) {
          ErrorDialog.show(
            context,
            widthDp: widthDp,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "There is no scratch card data",
          );
        } else {
          if (orderModel.scratchCard![0]["status"] == "not_scratched") {
            await ScratchCardDialog.show(
              context,
              scratchCardId: orderModel.scratchCard![0]["_id"],
              callback: (Map<String, dynamic> scratchCardData) {},
            );
          } else {
            await ScratchCardDialog.show(
              context,
              scratched: true,
              amount: orderModel.scratchCard![0]["amount"],
              amountInPoints: orderModel.scratchCard![0]["amountInPoints"],
              scratchCardId: notificationData!["data"]["scratchCardId"],
              callback: (Map<String, dynamic> scratchCardData) {
                // _orderModel!.scratchCard![0] = scratchCardData;
                // setState(() {});
              },
            );
          }
        }
      }
    } else if (notificationData!["type"] == "referral_rewardpoint") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => RewardPointsPage(),
        ),
      );
    } else if (notificationData!["type"] == "book_appointment") {
      if (notificationData!["data"]["id"] == null || notificationData!["data"]["id"] == "") {
        NormalDialog.show(
          context,
          content: "This notification is generated by initial.\nSo, this is old and have bad data.",
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => BookAppointmentDetailPage(
              bookAppointmentModel: null,
              id: notificationData!["data"]["id"],
            ),
          ),
        );
      }
    }
  }
}
