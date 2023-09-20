import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class AnnouncementListProvider extends ChangeNotifier {
  static AnnouncementListProvider of(BuildContext context, {bool listen = false}) => Provider.of<AnnouncementListProvider>(context, listen: listen);

  AnnouncementListState _announcementState = AnnouncementListState.init();
  AnnouncementListState get announcementState => _announcementState;

  void setAnnouncementListState(AnnouncementListState announcementState, {bool isNotifiable = true}) {
    if (_announcementState != announcementState) {
      _announcementState = announcementState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getAnnouncements({
    String? storeId,
    String? city,
    String? category,
    String searchKey = "",
  }) async {
    Map<String, dynamic>? announcementListData = _announcementState.announcementListData;
    Map<String, dynamic>? announcementMetaData = _announcementState.announcementMetaData;
    try {
      if (announcementListData!["ALL"] == null) announcementListData["ALL"] = [];
      if (announcementMetaData!["ALL"] == null) announcementMetaData["ALL"] = Map<String, dynamic>();

      var result;

      result = await AnnouncementsApiProvider.getAnnouncements(
        storeId: storeId,
        city: city,
        category: category,
        searchKey: searchKey,
        page: announcementMetaData["ALL"].isEmpty ? 1 : (announcementMetaData["ALL"]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          announcementListData["ALL"].add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        announcementMetaData["ALL"] = result["data"];

        _announcementState = _announcementState.update(
          progressState: 2,
          announcementListData: announcementListData,
          announcementMetaData: announcementMetaData,
        );
      } else {
        _announcementState = _announcementState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _announcementState = _announcementState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }

  Future<void> getCategories() async {
    try {
      var result = await AnnouncementsApiProvider.getCategories();
      if (result["success"]) {
        List<dynamic> categories = [];
        for (var i = 0; i < result["data"].length; i++) {
          categories.add(result["data"][i]["category"]);
        }

        _announcementState = _announcementState.update(
          categories: categories,
        );
      } else {
        _announcementState = _announcementState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _announcementState = _announcementState.update(
        progressState: -1,
        message: e.toString(),
      );
    }
    notifyListeners();
  }
}
