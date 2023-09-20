import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class ScratchCardListProvider extends ChangeNotifier {
  static ScratchCardListProvider of(BuildContext context, {bool listen = false}) => Provider.of<ScratchCardListProvider>(context, listen: listen);

  ScratchCardListState _scratchCardListState = ScratchCardListState.init();
  ScratchCardListState get scratchCardListState => _scratchCardListState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setScratchCardListState(ScratchCardListState scratchCardListState, {bool isNotifiable = true}) {
    if (_scratchCardListState != scratchCardListState) {
      _scratchCardListState = scratchCardListState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getScratchCardListData({String searchKey = ""}) async {
    Map<String, dynamic> scratchCardListData = _scratchCardListState.scratchCardListData!;
    Map<String, dynamic> scratchCardMetaData = _scratchCardListState.scratchCardMetaData!;
    try {
      if (scratchCardListData["ALL"] == null) scratchCardListData["ALL"] = [];
      if (scratchCardMetaData["ALL"] == null) scratchCardMetaData["ALL"] = Map<String, dynamic>();

      var result;

      result = await OrderApiProvider.getScratchCardData(
        searchKey: searchKey,
        page: scratchCardMetaData["ALL"].isEmpty ? 1 : (scratchCardMetaData["ALL"]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          scratchCardListData["ALL"].add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        scratchCardMetaData["ALL"] = result["data"];

        _scratchCardListState = _scratchCardListState.update(
          progressState: 2,
          scratchCardListData: scratchCardListData,
          scratchCardMetaData: scratchCardMetaData,
        );
      } else {
        _scratchCardListState = _scratchCardListState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _scratchCardListState = _scratchCardListState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }

  Future<void> sumRewardPoints() async {
    try {
      var result;

      result = await ScratchCardApiProvider.sumRewardPoints();

      if (result["success"]) {
        _scratchCardListState =
            _scratchCardListState.update(sumRewardPoints: result["data"].isEmpty ? 0 : double.parse(result["data"][0]["sum"].toString()));
      } else {
        _scratchCardListState = _scratchCardListState.update();
      }
    } catch (e) {
      _scratchCardListState = _scratchCardListState.update();
    }
    notifyListeners();
  }
}
