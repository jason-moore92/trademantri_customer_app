import 'package:flutter/material.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class StoreReviewPageProvider extends ChangeNotifier {
  static StoreReviewPageProvider of(BuildContext context, {bool listen = false}) => Provider.of<StoreReviewPageProvider>(context, listen: listen);

  StoreReviewPageState _storeReviewPageState = StoreReviewPageState.init();
  StoreReviewPageState get storeReviewPageState => _storeReviewPageState;

  void setStoreReviewPageState(StoreReviewPageState storeReviewPageState, {bool isNotifiable = true}) {
    if (_storeReviewPageState != storeReviewPageState) {
      _storeReviewPageState = storeReviewPageState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getStoreReviewList({@required String? storeId}) async {
    Map<String, dynamic> reviewMetaData = _storeReviewPageState.reviewMetaData!;
    Map<String, dynamic> reviewList = _storeReviewPageState.reviewList!;

    if (reviewMetaData[storeId] == null) reviewMetaData[storeId!] = Map<String, dynamic>();
    if (reviewList[storeId] == null) reviewList[storeId!] = [];

    var result = await StoreReviewApiProvider.getReviewList(
      storeId: storeId,
      page: reviewMetaData[storeId]["nextPage"] ?? 1,
      limit: AppConfig.countLimitForList,
    );

    if (result["success"]) {
      reviewList[storeId].addAll(result["data"]["docs"]);
      result["data"].remove("docs");
      reviewMetaData[storeId!] = result["data"];

      _storeReviewPageState = _storeReviewPageState.update(
        progressState: 2,
        message: "",
        reviewList: reviewList,
        reviewMetaData: reviewMetaData,
      );
    } else {
      _storeReviewPageState = _storeReviewPageState.update(
        progressState: reviewList[storeId].isEmpty ? -1 : 2,
        message: result["messsage"],
      );
    }
    notifyListeners();
  }
}
