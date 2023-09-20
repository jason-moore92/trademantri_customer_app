import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class AppliedJobProvider extends ChangeNotifier {
  static AppliedJobProvider of(BuildContext context, {bool listen = false}) => Provider.of<AppliedJobProvider>(context, listen: listen);

  AppliedJobState _appliedJobState = AppliedJobState.init();
  AppliedJobState get appliedJobState => _appliedJobState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setAppliedJobState(AppliedJobState appliedJobState, {bool isNotifiable = true}) {
    if (_appliedJobState != appliedJobState) {
      _appliedJobState = appliedJobState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getAppliedJobData({
    String status = "ALL",
    String searchKey = "",
  }) async {
    List<dynamic> appliedJobListData = _appliedJobState.appliedJobListData!;
    Map<String, dynamic> appliedJobMetaData = _appliedJobState.appliedJobMetaData!;
    try {
      appliedJobListData = [];
      appliedJobMetaData = Map<String, dynamic>();

      var result;

      result = await AppliedJobApiProvider.getAppliedJobData(
        status: status,
        searchKey: searchKey,
        page: appliedJobMetaData.isEmpty ? 1 : (appliedJobMetaData["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          appliedJobListData.add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        appliedJobMetaData = result["data"];

        _appliedJobState = _appliedJobState.update(
          progressState: 2,
          appliedJobListData: appliedJobListData,
          appliedJobMetaData: appliedJobMetaData,
        );
      } else {
        _appliedJobState = _appliedJobState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _appliedJobState = _appliedJobState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }
}
