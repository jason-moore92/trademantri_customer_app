import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

import 'keicy_raised_button.dart';

class RedeemRewardPointPanel extends StatefulWidget {
  final OrderModel? orderModel;
  final Function? refreshCallback;

  RedeemRewardPointPanel({
    @required this.orderModel,
    @required this.refreshCallback,
  });

  @override
  _RedeemRewardPointPanelState createState() => _RedeemRewardPointPanelState();
}

class _RedeemRewardPointPanelState extends State<RedeemRewardPointPanel> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Store specific points",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
                SizedBox(height: heightDp * 10),
                Text(
                  "Reward Points: ${widget.orderModel!.redeemRewardData == null || widget.orderModel!.redeemRewardData!["redeemRewardPoint"] == null ? 0 : widget.orderModel!.redeemRewardData!["redeemRewardPoint"]}",
                  style: TextStyle(
                    fontSize: fontSp * 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: widthDp * 10),
          if (widget.orderModel!.redeemRewardData != null &&
              widget.orderModel!.redeemRewardData!["redeemRewardPoint"] != null &&
              widget.orderModel!.redeemRewardData!["redeemRewardPoint"] > 0)
            Container(
              padding: EdgeInsets.only(
                right: 8.0,
              ),
              child: GestureDetector(
                onTap: () {
                  widget.orderModel!.redeemRewardData!["sumRewardPoint"] = 0;
                  widget.orderModel!.redeemRewardData!["redeemRewardValue"] = 0;
                  widget.orderModel!.redeemRewardData!["redeemRewardPoint"] = 0;
                  if (widget.orderModel!.redeemRewardData!["tradeSumRewardPoint"] == null) {
                    widget.orderModel!.redeemRewardData!["tradeSumRewardPoint"] = 0;
                  }
                  if (widget.orderModel!.redeemRewardData!["tradeRedeemRewardPoint"] == null) {
                    widget.orderModel!.redeemRewardData!["tradeRedeemRewardPoint"] = 0;
                  }
                  if (widget.orderModel!.redeemRewardData!["tradeRedeemRewardValue"] == null) {
                    widget.orderModel!.redeemRewardData!["tradeRedeemRewardValue"] = 0;
                  }

                  widget.refreshCallback!();
                },
                child: Icon(
                  Icons.close,
                ),
              ),
            ),
          KeicyRaisedButton(
            width: widthDp * 100,
            height: heightDp * 35,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 4,
            child: Text(
              "Redeem",
              style: TextStyle(
                fontSize: fontSp * 16,
                color: Colors.white,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            onPressed: () async {
              await RedeemDialog.show(
                context,
                widthDp: widthDp,
                heightDp: heightDp,
                fontSp: fontSp,
                storeId: widget.orderModel!.storeModel!.id,
                userId: AuthProvider.of(context).authState.userModel!.id,
                toPay: widget.orderModel!.paymentDetail!.totalPrice! + widget.orderModel!.paymentDetail!.totalTaxAfterDiscount!,
                callBack: (int sumRewardPoint, int redeemRewardValue, int redeemRewardPoint) {
                  if (widget.orderModel!.redeemRewardData == null) {
                    widget.orderModel!.redeemRewardData = Map<String, dynamic>();
                    widget.orderModel!.redeemRewardData!["sumRewardPoint"] = 0;
                    widget.orderModel!.redeemRewardData!["redeemRewardValue"] = 0;
                    widget.orderModel!.redeemRewardData!["redeemRewardPoint"] = 0;
                    widget.orderModel!.redeemRewardData!["tradeSumRewardPoint"] = 0;
                    widget.orderModel!.redeemRewardData!["tradeRedeemRewardPoint"] = 0;
                    widget.orderModel!.redeemRewardData!["tradeRedeemRewardValue"] = 0;
                  }
                  if (widget.orderModel!.redeemRewardData!["sumRewardPoint"] != null) {
                    widget.orderModel!.redeemRewardData!["sumRewardPoint"] += sumRewardPoint;
                  } else {
                    widget.orderModel!.redeemRewardData!["sumRewardPoint"] = sumRewardPoint;
                  }
                  widget.orderModel!.redeemRewardData!["redeemRewardPoint"] = redeemRewardPoint;
                  widget.orderModel!.redeemRewardData!["redeemRewardValue"] = redeemRewardValue;

                  widget.refreshCallback!();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
