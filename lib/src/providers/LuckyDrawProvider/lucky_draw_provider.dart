import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/ApiDataProviders/lucky_draw_api_provider.dart';
import 'package:trapp/src/entities/lucky_draw_config.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class LuckyDrawProvider extends ChangeNotifier {
  static LuckyDrawProvider of(BuildContext context, {bool listen = false}) => Provider.of<LuckyDrawProvider>(context, listen: listen);

  LuckyDrawState _luckyDrawState = LuckyDrawState.init();
  LuckyDrawState get luckyDrawState => _luckyDrawState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setLuckyDrawState(LuckyDrawState luckyDrawState, {bool isNotifiable = true}) {
    if (_luckyDrawState != luckyDrawState) {
      _luckyDrawState = luckyDrawState;
      if (isNotifiable) notifyListeners();
    }
  }

  initPrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  String prefPrefix = "lucky_draw_winner_pop_";

  int callCount = 0;

  checkLatestWinners() async {
    if (callCount >= 1) {
      return;
    }
    callCount++;
    await initPrefs();

    Map<String, dynamic> result = await LuckyDrawApiProvider.getLatestWinners();

    if (result["success"]) {
      LuckyDrawConfig config = LuckyDrawConfig.fromJson(result["data"]);
      bool? isViewed = _prefs!.getBool("${prefPrefix}${config.id}");
      // isViewed = null;
      if (isViewed == null) {
        _luckyDrawState = _luckyDrawState.update(
          progressState: 2,
          luckyDrawConfig: config,
        );
        _prefs!.setBool("${prefPrefix}${config.id}", true);
      }
    }

    notifyListeners();
  }
}
