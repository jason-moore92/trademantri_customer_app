import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class RewardPointProvider extends ChangeNotifier {
  static RewardPointProvider of(BuildContext context, {bool listen = false}) => Provider.of<RewardPointProvider>(context, listen: listen);

  RewardPointState _rewardPointState = RewardPointState.init();
  RewardPointState get rewardPointState => _rewardPointState;

  void setRewardPointState(RewardPointState rewardPointState, {bool isNotifiable = true}) {
    if (_rewardPointState != rewardPointState) {
      _rewardPointState = rewardPointState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getRewardPoint({@required String? storeId}) async {
    try {
      var result = await RewardPointApiProvider.getRewardPoint(storeId: storeId);
      Map<String, dynamic> rewardPointData = _rewardPointState.rewardPointData!;

      if (result["success"]) {
        rewardPointData[storeId!] = result["data"] ?? Map<String, dynamic>();
        _rewardPointState = _rewardPointState.update(
          progressState: 2,
          message: "",
          rewardPointData: rewardPointData,
        );
      } else {
        _rewardPointState = _rewardPointState.update(
          progressState: -1,
          message: result["messsage"],
        );
      }
    } catch (e) {
      _rewardPointState = _rewardPointState.update(
        progressState: -1,
        message: e.toString(),
      );
    }
    notifyListeners();
  }
}
