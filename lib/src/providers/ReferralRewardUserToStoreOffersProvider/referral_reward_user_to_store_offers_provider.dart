import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class ReferralRewardU2SOffersProvider extends ChangeNotifier {
  static ReferralRewardU2SOffersProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<ReferralRewardU2SOffersProvider>(context, listen: listen);

  ReferralRewardU2SOffersState _referralRewardU2SOffersState = ReferralRewardU2SOffersState.init();
  ReferralRewardU2SOffersState get referralRewardU2SOffersState => _referralRewardU2SOffersState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setReferralRewardU2SOffersState(ReferralRewardU2SOffersState referralRewardU2SOffersState, {bool isNotifiable = true}) {
    if (_referralRewardU2SOffersState != referralRewardU2SOffersState) {
      _referralRewardU2SOffersState = referralRewardU2SOffersState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getReferralRewardU2SOffersData({@required String? referredByUserId, String searchKey = ""}) async {
    Map<String, dynamic> referralRewardOffersListData = _referralRewardU2SOffersState.referralRewardOffersListData!;
    Map<String, dynamic> referralRewardOffersMetaData = _referralRewardU2SOffersState.referralRewardOffersMetaData!;
    try {
      if (referralRewardOffersListData["ALL"] == null) referralRewardOffersListData["ALL"] = [];
      if (referralRewardOffersMetaData["ALL"] == null) referralRewardOffersMetaData["ALL"] = Map<String, dynamic>();

      var result;

      result = await ReferralRewardU2SOffersApiProvider.getReferralRewardOffersData(
        referredByUserId: referredByUserId,
        searchKey: searchKey,
        page: referralRewardOffersMetaData["ALL"].isEmpty ? 1 : (referralRewardOffersMetaData["ALL"]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          referralRewardOffersListData["ALL"].add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        referralRewardOffersMetaData["ALL"] = result["data"];

        _referralRewardU2SOffersState = _referralRewardU2SOffersState.update(
          progressState: 2,
          referralRewardOffersListData: referralRewardOffersListData,
          referralRewardOffersMetaData: referralRewardOffersMetaData,
        );
      } else {
        _referralRewardU2SOffersState = _referralRewardU2SOffersState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _referralRewardU2SOffersState = _referralRewardU2SOffersState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }
}
