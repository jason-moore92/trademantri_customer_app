import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scratcher/widgets.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class ScratchCardDialog {
  static show(
    BuildContext context, {
    @required String? scratchCardId,
    bool scratched = false,
    dynamic amount,
    dynamic amountInPoints,
    Function? callback,
  }) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        double _opacity = 0.0;
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ScratchCardProvider()),
          ],
          child: Consumer<ScratchCardProvider>(builder: (context, scratchCardProvider, _) {
            if (scratchCardProvider.scratchCardState.scratchCardData!["status"] == "scratched") {
              if (callback != null) {
                callback(scratchCardProvider.scratchCardState.scratchCardData);
              }
            }

            Widget _nextTimeWidget = Container(
              width: widthDp * 200,
              height: heightDp * 250,
              child: Center(
                child: Image.asset(
                  "img/betterlucknexttime.png",
                  width: heightDp * 150,
                  height: heightDp * 150,
                  fit: BoxFit.fitHeight,
                ),
              ),
            );

            Widget _loadingWidget = Container(
              width: widthDp * 200,
              height: heightDp * 250,
              child: Center(
                child: Text(
                  "Loading ...",
                  style: TextStyle(fontSize: fontSp * 20),
                ),
              ),
            );

            Widget _winWidget = Container(
              width: widthDp * 200,
              height: heightDp * 250,
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      "img/youwon.png",
                      height: double.infinity,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  SizedBox(height: heightDp * 10),
                  Text(
                    "₹ ${amount ?? scratchCardProvider.scratchCardState.scratchCardData!["amount"]}",
                    style: TextStyle(fontSize: fontSp * 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: heightDp * 5),
                  Text(
                    "* The amount is converted into TradeMantri points and is added to your account. The total points you won",
                    style: TextStyle(fontSize: fontSp * 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: heightDp * 5),
                  Text(
                    "${amountInPoints ?? scratchCardProvider.scratchCardState.scratchCardData!["amountInPoints"]} Pts",
                    style: TextStyle(fontSize: fontSp * 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );

            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(heightDp * 10),
              ),
              titlePadding: EdgeInsets.fromLTRB(widthDp * 15, heightDp * 15, widthDp * 15, 0.0),
              contentPadding: EdgeInsets.fromLTRB(widthDp * 15, heightDp * 15, widthDp * 15, heightDp * 20),
              title: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "You Earned\nA Scratch Card",
                      style: TextStyle(color: Colors.red, fontSize: fontSp * 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              children: [
                if (scratched)
                  if (amount == 0) _nextTimeWidget else _winWidget
                else
                  StatefulBuilder(builder: (context, StateSetter setState) {
                    return Scratcher(
                      color: scratchCardProvider.scratchCardState.progressState != 1 && _opacity == 1
                          ? Colors.transparent
                          : config.Colors().mainColor(1),
                      accuracy: ScratchAccuracy.low,
                      threshold: 50,
                      brushSize: heightDp * 40,
                      onThreshold: () async {
                        _opacity = 1;
                        setState(() {});
                      },
                      onScratchStart: () {
                        if (scratchCardProvider.scratchCardState.progressState == 0) {
                          scratchCardProvider.setScratchCardState(scratchCardProvider.scratchCardState.update(progressState: 1));
                          scratchCardProvider.getScratchCard(scratchCardId: scratchCardId);
                        }
                      },
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 100),
                        opacity: _opacity,
                        child: Container(
                          width: widthDp * 200,
                          height: heightDp * 250,
                          child: scratchCardProvider.scratchCardState.progressState == 1
                              ? _loadingWidget
                              : scratchCardProvider.scratchCardState.progressState == -1
                                  ? _nextTimeWidget
                                  : scratchCardProvider.scratchCardState.progressState == 2 &&
                                          scratchCardProvider.scratchCardState.scratchCardData!["amount"] == 0
                                      ? _nextTimeWidget
                                      : scratchCardProvider.scratchCardState.progressState == 2 &&
                                              scratchCardProvider.scratchCardState.scratchCardData!["amount"] != 0
                                          ? _winWidget
                                          : SizedBox(),
                        ),
                      ),
                    );
                  }),
              ],
            );
          }),
        );
      },
    );
  }
}
