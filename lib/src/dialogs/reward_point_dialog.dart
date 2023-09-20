import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/models/contact_model.dart';

class RewardPointDialog {
  static show(BuildContext context, Map<String, dynamic> rewardPointData, {Function(ContactModel)? callback}) {
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 15),
          titlePadding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
          title: Row(
            children: <Widget>[
              Image.asset(
                "img/reward_points_icon.png",
                width: heightDp * 30,
                height: heightDp * 30,
              ),
              SizedBox(width: heightDp * 10),
              Text(
                'RewardPoint',
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
          children: rewardPointData.isEmpty
              ? [
                  Center(
                    child: Text(
                      "There is no Reward Point data",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: heightDp * 30),
                ]
              : <Widget>[
                  Text(
                    "Buy:",
                    style: TextStyle(fontSize: 16),
                  ),
                  Divider(height: heightDp * 20, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: widthDp * 10),
                          Text(
                            "RewardPoints:",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: widthDp * 10),
                          Text(
                            "${rewardPointData["buy"]["rewardPoints"]}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Value:",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: widthDp * 10),
                          Text(
                            "${rewardPointData["buy"]["value"]}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: heightDp * 10),
                  Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),

                  ///
                  SizedBox(height: heightDp * 20),
                  Text(
                    "Redeem:",
                    style: TextStyle(fontSize: 16),
                  ),
                  Divider(height: heightDp * 20, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: widthDp * 10),
                          Text(
                            "RewardPoints:",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: widthDp * 10),
                          Text(
                            "${rewardPointData["redeem"]["rewardPoints"]}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Value:",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: widthDp * 10),
                          Text(
                            "${rewardPointData["redeem"]["value"]}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: heightDp * 10),
                  Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),

                  ///
                  SizedBox(height: heightDp * 20),
                  Row(
                    children: [
                      Text(
                        "Min Order Amount:",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: widthDp * 10),
                      Text(
                        "${rewardPointData["minOrderAmount"]}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: heightDp * 10),
                  Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),

                  ///
                  SizedBox(height: heightDp * 20),
                  Row(
                    children: [
                      Text(
                        "Max Rewards Per Order:",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: widthDp * 10),
                      Text(
                        "${rewardPointData["maxRewardsPerOrder"]}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: heightDp * 10),
                  Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),

                  ///
                  SizedBox(height: heightDp * 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        color: Colors.grey.withOpacity(0.4),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),

                  ///
                  SizedBox(height: heightDp * 20),
                ],
        );
      },
    );
  }
}
