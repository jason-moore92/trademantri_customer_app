import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class ReverseAuctionStoreProvider extends ChangeNotifier {
  static ReverseAuctionStoreProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<ReverseAuctionStoreProvider>(context, listen: listen);

  ReverseAuctionStoreState _reverseAuctionStoreState = ReverseAuctionStoreState.init();
  ReverseAuctionStoreState get reverseAuctionStoreState => _reverseAuctionStoreState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setReverseAuctionStoreState(ReverseAuctionStoreState reverseAuctionStoreState, {bool isNotifiable = true}) {
    if (_reverseAuctionStoreState != reverseAuctionStoreState) {
      _reverseAuctionStoreState = reverseAuctionStoreState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getAuctionStoreData({
    @required String? reverseAuctionId,
    @required String? storeIdList,
    String searchKey = "",
  }) async {
    List<dynamic> reverseAuctionStoreListData = _reverseAuctionStoreState.reverseAuctionStoreListData!;
    Map<String, dynamic> reverseAuctionStoreMetaData = _reverseAuctionStoreState.reverseAuctionStoreMetaData!;
    try {
      if (reverseAuctionStoreListData == null) reverseAuctionStoreListData = [];
      if (reverseAuctionStoreMetaData == null) reverseAuctionStoreMetaData = Map<String, dynamic>();

      var result;

      result = await ReverseAuctionApiProvider.getAuctionStoreData(
        reverseAuctionId: reverseAuctionId,
        storeIdList: storeIdList,
        searchKey: searchKey,
        page: reverseAuctionStoreMetaData.isEmpty ? 1 : (reverseAuctionStoreMetaData["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          reverseAuctionStoreListData.add(result["data"]["docs"][i]["store"]);
          reverseAuctionStoreListData[i]["biddingDate"] = result["data"]["docs"][i]["createdAt"];
          reverseAuctionStoreListData[i]["storeBiddingPrice"] = double.parse(result["data"]["docs"][i]["offerPrice"]);
          reverseAuctionStoreListData[i]["storeBiddingMessage"] = result["data"]["docs"][i]["message"];
        }
        result["data"].remove("docs");
        reverseAuctionStoreMetaData = result["data"];

        _reverseAuctionStoreState = _reverseAuctionStoreState.update(
          progressState: 2,
          reverseAuctionStoreListData: reverseAuctionStoreListData,
          reverseAuctionStoreMetaData: reverseAuctionStoreMetaData,
        );
      } else {
        _reverseAuctionStoreState = _reverseAuctionStoreState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _reverseAuctionStoreState = _reverseAuctionStoreState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }
}
