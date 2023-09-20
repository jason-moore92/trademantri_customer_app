import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class StoreJobPostingsProvider extends ChangeNotifier {
  static StoreJobPostingsProvider of(BuildContext context, {bool listen = false}) => Provider.of<StoreJobPostingsProvider>(context, listen: listen);

  StoreJobPostingsState _storeJobPostingsState = StoreJobPostingsState.init();
  StoreJobPostingsState get storeJobPostingsState => _storeJobPostingsState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setStoreJobPostingsState(StoreJobPostingsState storeJobPostingsState, {bool isNotifiable = true}) {
    if (_storeJobPostingsState != storeJobPostingsState) {
      _storeJobPostingsState = storeJobPostingsState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getStoreJobPostingsData({
    String storeId = "",
    String? userId,
    String status = "ALL",
    double? latitude,
    double? longitude,
    int? distance,
    String searchKey = "",
  }) async {
    List<dynamic> storeJobPostingsListData = _storeJobPostingsState.storeJobPostingsListData!;
    Map<String, dynamic> storeJobPostingsMetaData = _storeJobPostingsState.storeJobPostingsMetaData!;
    try {
      if (storeJobPostingsListData == null) storeJobPostingsListData = [];
      if (storeJobPostingsMetaData == null) storeJobPostingsMetaData = Map<String, dynamic>();

      var result;

      result = await StoreJobPostingsApiProvider.getStoreJobPostingsData(
        storeId: storeId,
        userId: userId,
        status: status,
        latitude: latitude,
        longitude: longitude,
        distance: distance,
        searchKey: searchKey,
        page: storeJobPostingsMetaData.isEmpty ? 1 : (storeJobPostingsMetaData["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          storeJobPostingsListData.add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        storeJobPostingsMetaData = result["data"];

        _storeJobPostingsState = _storeJobPostingsState.update(
          progressState: 2,
          storeJobPostingsListData: storeJobPostingsListData,
          storeJobPostingsMetaData: storeJobPostingsMetaData,
        );
      } else {
        _storeJobPostingsState = _storeJobPostingsState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _storeJobPostingsState = _storeJobPostingsState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }
}
