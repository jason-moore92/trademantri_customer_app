import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class ReferralRewardOfferTypeRulesProvider extends ChangeNotifier {
  static ReferralRewardOfferTypeRulesProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<ReferralRewardOfferTypeRulesProvider>(context, listen: listen);

  ReferralRewardOfferTypeRulesState _referralRewardOfferTypeRulesState = ReferralRewardOfferTypeRulesState.init();
  ReferralRewardOfferTypeRulesState get referralRewardOfferTypeRulesState => _referralRewardOfferTypeRulesState;

  void setReferralRewardOfferTypeRulesState(ReferralRewardOfferTypeRulesState referralRewardOfferTypeRulesState, {bool isNotifiable = true}) {
    if (_referralRewardOfferTypeRulesState != referralRewardOfferTypeRulesState) {
      _referralRewardOfferTypeRulesState = referralRewardOfferTypeRulesState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getReferralRules() async {
    try {
      var result = await ReferralRewardOfferTypeRulesApiProvider.getReferralRewardOfferTypeRulesData();

      Map<String, dynamic>? userReferralData = Map<String, dynamic>();
      Map<String, dynamic>? storeReferralData = Map<String, dynamic>();

      if (result["success"]) {
        for (var i = 0; i < result["data"].length; i++) {
          if (result["data"][i]["appliedFor"].toString().toLowerCase() == "usertouser") {
            userReferralData = result["data"][i];
          } else if (result["data"][i]["appliedFor"].toString().toLowerCase() == "usertostore") {
            storeReferralData = result["data"][i];
          }
        }

        _referralRewardOfferTypeRulesState = _referralRewardOfferTypeRulesState.update(
          progressState: 2,
          userReferralData: userReferralData,
          storeReferralData: storeReferralData,
        );
      } else {
        _referralRewardOfferTypeRulesState = _referralRewardOfferTypeRulesState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _referralRewardOfferTypeRulesState = _referralRewardOfferTypeRulesState.update(
        progressState: -1,
        message: e.toString(),
      );
    }
    notifyListeners();
  }
}
