import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/providers/index.dart';

class RedeemDialog {
  static show(
    BuildContext context, {
    @required double? widthDp,
    @required double? heightDp,
    @required double? fontSp,
    @required String? storeId,
    @required String? userId,
    @required double? toPay,
    EdgeInsets? insetPadding,
    EdgeInsets? titlePadding,
    EdgeInsets? contentPadding,
    double? borderRadius,
    Color? barrierColor,
    bool? barrierDismissible = false,
    @required Function? callBack,
    Function? cancelCallback,
    int? delaySecondes = 2,
  }) async {
    RewardPointProvider? _rewardPointProvider;
    RewardPointHistoryProvider? _rewardPointHistoryProvider;

    GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    TextEditingController _controller = TextEditingController();
    FocusNode _focusNode = FocusNode();

    void _redeemHandler() async {
      if (!_formkey.currentState!.validate()) return;
      FocusScope.of(context).requestFocus(FocusNode());

      int sumRewardPoint = _rewardPointHistoryProvider!.rewardPointHistoryState.sumRewardPoint!;
      int redeemRewardPoint = (double.parse(_controller.text) /
              double.parse(_rewardPointProvider!.rewardPointState.rewardPointData![storeId]["redeem"]["rewardPoints"].toString()) *
              double.parse(_rewardPointProvider!.rewardPointState.rewardPointData![storeId]["redeem"]["rewardPoints"].toString()))
          .toInt();

      int redeemValue = (double.parse(_controller.text) /
              double.parse(_rewardPointProvider!.rewardPointState.rewardPointData![storeId]["redeem"]["rewardPoints"].toString()) *
              double.parse(_rewardPointProvider!.rewardPointState.rewardPointData![storeId]["redeem"]["value"].toString()))
          .toInt();
      Navigator.of(context).pop();
      callBack!(sumRewardPoint, redeemValue, redeemRewardPoint);
    }

    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible!,
      // barrierColor: barrierColor,
      builder: (BuildContext context1) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.white,
          insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: widthDp! * 30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp! * 10)),
          titlePadding: titlePadding ?? EdgeInsets.zero,
          contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: widthDp! * 20, vertical: heightDp * 20),
          children: [
            MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => RewardPointHistoryProvider()),
              ],
              child: Consumer2<RewardPointHistoryProvider, RewardPointProvider>(
                builder: (context, rewardPointHistoryProvider, rewardPointProvider, _) {
                  _rewardPointProvider = rewardPointProvider;
                  _rewardPointHistoryProvider = rewardPointHistoryProvider;

                  if (rewardPointHistoryProvider.rewardPointHistoryState.progressState == 0) {
                    rewardPointHistoryProvider.sumRewardPoints(userId: userId, storeId: storeId!);
                  }

                  // if (rewardPointProvider.rewardPointState.progressState == 0) {
                  //   // rewardPointProvider.getRewardPoint(storeId: storeId);
                  // }

                  if (rewardPointHistoryProvider.rewardPointHistoryState.progressState == 0 ||
                      rewardPointProvider.rewardPointState.progressState == 0) {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }

                  if (rewardPointHistoryProvider.rewardPointHistoryState.progressState == -1 ||
                      rewardPointProvider.rewardPointState.progressState == -1) {
                    return Center(
                      child: Text("Something was wrong", style: TextStyle(fontSize: fontSp! * 16)),
                    );
                  }

                  FlutterLogs.logInfo(
                    "redeem_dailog",
                    "show",
                    rewardPointProvider.rewardPointState.rewardPointData.toString(),
                  );

                  if (rewardPointProvider.rewardPointState.rewardPointData![storeId].isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          Text("There is no Reward Point data", style: TextStyle(fontSize: fontSp! * 18)),
                          SizedBox(height: heightDp * 20),
                          KeicyRaisedButton(
                            width: widthDp! * 100,
                            height: heightDp * 35,
                            color: config.Colors().mainColor(1),
                            borderRadius: heightDp * 6,
                            child: Text(
                              "Close",
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Text(
                          "Total Reward Point",
                          style: TextStyle(fontSize: fontSp! * 18),
                        ),
                        SizedBox(height: heightDp * 20),
                        Text(
                          "${rewardPointHistoryProvider.rewardPointHistoryState.sumRewardPoint}",
                          style: TextStyle(fontSize: fontSp * 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: heightDp * 20),
                        Text("Redeem Reward Point", style: TextStyle(fontSize: fontSp * 16)),
                        Text(
                          "(multiples of "
                          "${rewardPointProvider.rewardPointState.rewardPointData![storeId]["redeem"]["rewardPoints"]}"
                          " as "
                          "${rewardPointProvider.rewardPointState.rewardPointData![storeId]["redeem"]["rewardPoints"]}"
                          " reward points = "
                          "${rewardPointProvider.rewardPointState.rewardPointData![storeId]["redeem"]["value"]}"
                          " rupee)",
                          style: TextStyle(fontSize: fontSp * 12),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: heightDp * 15),
                        Container(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _controller,
                            focusNode: _focusNode,
                            style: TextStyle(fontSize: fontSp * 18, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: widthDp! * 15, vertical: heightDp * 8),
                              errorMaxLines: 2,
                            ),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                            validator: (input) {
                              if (input!.isEmpty) return "please enter redeem value";
                              var price = double.parse(input) ~/
                                  double.parse(
                                    rewardPointProvider.rewardPointState.rewardPointData![storeId]["redeem"]["rewardPoints"].toString(),
                                  ) *
                                  double.parse(
                                    rewardPointProvider.rewardPointState.rewardPointData![storeId]["redeem"]["value"].toString(),
                                  );

                              var remaining = double.parse(input) %
                                  double.parse(
                                    rewardPointProvider.rewardPointState.rewardPointData![storeId]["redeem"]["rewardPoints"].toString(),
                                  ) *
                                  double.parse(
                                    rewardPointProvider.rewardPointState.rewardPointData![storeId]["redeem"]["value"].toString(),
                                  );

                              if (remaining != 0.0) {
                                return "Please enter multiples of ${rewardPointProvider.rewardPointState.rewardPointData![storeId]["redeem"]["rewardPoints"]}";
                              }

                              if (double.parse(input) > rewardPointHistoryProvider.rewardPointHistoryState.sumRewardPoint!)
                                return "Please enter less value then ${rewardPointHistoryProvider.rewardPointHistoryState.sumRewardPoint}";
                              else if (price > toPay!) {
                                return "The total value of order is below 0 rupees. You cant place an order like this";
                              } else if (double.parse(input) <
                                  rewardPointProvider.rewardPointState.rewardPointData![storeId]["redeem"]["rewardPoints"])
                                return "Please enter bigger value then ${rewardPointProvider.rewardPointState.rewardPointData![storeId]["redeem"]["rewardPoints"]}";
                              else
                                return null;
                            },
                          ),
                        ),
                        SizedBox(height: heightDp * 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            KeicyRaisedButton(
                              width: widthDp * 100,
                              height: heightDp * 35,
                              color: rewardPointHistoryProvider.rewardPointHistoryState.sumRewardPoint == 0
                                  ? Color(0xFFDDDBDB)
                                  : config.Colors().mainColor(1),
                              borderRadius: heightDp * 4,
                              child: Text(
                                "Redeem",
                                style: TextStyle(
                                  fontSize: fontSp * 16,
                                  color: rewardPointHistoryProvider.rewardPointHistoryState.sumRewardPoint == 0 ? Colors.black : Colors.white,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                              onPressed: rewardPointHistoryProvider.rewardPointHistoryState.sumRewardPoint! == 0 ? () {} : _redeemHandler,
                            ),
                            KeicyRaisedButton(
                              width: widthDp * 100,
                              height: heightDp * 35,
                              color: Color(0xFFDDDBDB),
                              borderRadius: heightDp * 4,
                              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                              child: Text("Cancel", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
