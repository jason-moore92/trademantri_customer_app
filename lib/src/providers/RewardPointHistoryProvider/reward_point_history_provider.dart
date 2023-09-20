import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class RewardPointHistoryProvider extends ChangeNotifier {
  static RewardPointHistoryProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<RewardPointHistoryProvider>(context, listen: listen);

  RewardPointHistoryState _rewardPointHistoryState = RewardPointHistoryState.init();
  RewardPointHistoryState get rewardPointHistoryState => _rewardPointHistoryState;

  void setRewardPointHistoryState(RewardPointHistoryState rewardPointHistoryState, {bool isNotifiable = true}) {
    if (_rewardPointHistoryState != rewardPointHistoryState) {
      _rewardPointHistoryState = rewardPointHistoryState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> sumRewardPoints({@required String? userId, String storeId = ""}) async {
    try {
      var result = await RewardPointHistoryApiProvider.sumRewardPoints(userId: userId!, storeId: storeId);

      if (result["success"]) {
        _rewardPointHistoryState = _rewardPointHistoryState.update(
          progressState: 2,
          message: "",
          sumRewardPoint: result["data"].isEmpty ? 0 : result["data"][0]["sum"],
        );
      } else {
        _rewardPointHistoryState = _rewardPointHistoryState.update(
          progressState: -1,
          message: result["messsage"],
        );
      }
    } catch (e) {
      _rewardPointHistoryState = _rewardPointHistoryState.update(
        progressState: -1,
        message: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> getRewardPointsByUser({@required String? userId, String searchKey = ""}) async {
    List<dynamic> rewardPointListData = _rewardPointHistoryState.rewardPointListData!;
    Map<String, dynamic> rewardPointMetaData = _rewardPointHistoryState.rewardPointMetaData!;

    if (rewardPointListData == null) rewardPointListData = [];
    if (rewardPointMetaData == null) rewardPointMetaData = Map<String, dynamic>();

    try {
      var result = await RewardPointHistoryApiProvider.getRewardPointsByUser(
        userId: userId,
        searchKey: searchKey,
        page: rewardPointMetaData.isEmpty ? 1 : (rewardPointMetaData["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
      );

      if (result["success"]) {
        rewardPointListData.addAll(result["data"]["docs"]);
        result["data"].remove("docs");
        rewardPointMetaData = result["data"];

        _rewardPointHistoryState = _rewardPointHistoryState.update(
          progressState: 2,
          message: "",
          rewardPointListData: rewardPointListData,
          rewardPointMetaData: rewardPointMetaData,
        );
      } else {
        _rewardPointHistoryState = _rewardPointHistoryState.update(
          progressState: 2,
          message: result["messsage"],
        );
      }
    } catch (e) {
      _rewardPointHistoryState = _rewardPointHistoryState.update(
        progressState: 2,
        message: e.toString(),
      );
    }

    notifyListeners();
  }

  Future<Map<String, dynamic>> redeemRewordPoint({
    @required String? id,
    @required String? storeId,
    @required String? userId,
    @required String? orderId,
    @required int? sumRewardPoint,
    @required int? redeemRewardPoint,
    @required int? redeemValue,
  }) async {
    try {
      var result = await RewardPointHistoryApiProvider.redeemRewordPoint(
        id: id,
        storeId: storeId,
        userId: userId,
        orderId: orderId,
        sumRewardPoint: sumRewardPoint,
        redeemRewardPoint: redeemRewardPoint,
        redeemValue: redeemValue,
      );

      return result;
    } catch (e) {
      return {"success": false, "message": "Something was wrong"};
    }
  }
}
