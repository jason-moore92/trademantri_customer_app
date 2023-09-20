import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class StorePageProvider extends ChangeNotifier {
  static StorePageProvider of(BuildContext context, {bool listen = false}) => Provider.of<StorePageProvider>(context, listen: listen);

  StorePageState _storePageState = StorePageState.init();
  StorePageState get storePageState => _storePageState;

  void setStorePageState(StorePageState storePageState, {bool isNotifiable = true}) {
    if (_storePageState != storePageState) {
      _storePageState = storePageState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getRewardPoint({@required String? storeId}) async {
    var result = await RewardPointApiProvider.getRewardPoint(storeId: storeId);
    Map<String, dynamic> rewardPointData = _storePageState.rewardPointData!;

    if (result["success"]) {
      rewardPointData[storeId!] = result["data"] ?? Map<String, dynamic>();

      _storePageState = _storePageState.update(
        progressState: 2,
        message: "",
        rewardPointData: rewardPointData,
      );
    } else {
      rewardPointData[storeId!] = Map<String, dynamic>();
      _storePageState = _storePageState.update(
        progressState: 2,
        message: result["messsage"],
        rewardPointData: rewardPointData,
      );
    }

    notifyListeners();
  }

  Future<void> getStoreReview({@required String? userId, @required String? storeId}) async {
    var result = await StoreReviewApiProvider.getStoreReview(userId: userId, storeId: storeId);

    Map<String, dynamic> storeReviewData = _storePageState.storeReviewData!;
    if (result["success"]) {
      storeReviewData["${userId}_$storeId"] = result["data"] ?? Map<String, dynamic>();

      _storePageState = _storePageState.update(
        progressState: 2,
        message: "",
        storeReviewData: storeReviewData,
      );
    } else {
      storeReviewData["${userId}_$storeId"] = Map<String, dynamic>();
      _storePageState = _storePageState.update(
        progressState: 2,
        message: result["messsage"],
        storeReviewData: storeReviewData,
      );
    }

    notifyListeners();
  }

  Future<void> createStoreReview({@required Map<String, dynamic>? storeReview}) async {
    var result = await StoreReviewApiProvider.createStoreReview(storeReview: storeReview);

    if (result["success"]) {
      Map<String, dynamic> storeReviewData = _storePageState.storeReviewData!;
      storeReviewData["${storeReview!["userId"]}_${storeReview["storeId"]}"] = result["data"];

      /// update averateRatingData
      Map<String, dynamic> averateRatingData = _storePageState.averateRatingData!;
      if (averateRatingData[storeReview["storeId"]] == null) {
        averateRatingData[storeReview["storeId"]] = {"totalRating": storeReview["rating"], "totalCount": 1};
      } else {
        averateRatingData[storeReview["storeId"]] = {
          "totalRating": averateRatingData[storeReview["storeId"]]["totalRating"] + storeReview["rating"],
          "totalCount": averateRatingData[storeReview["storeId"]]["totalCount"] + 1,
        };
      }
      ///////////////
      _storePageState = _storePageState.update(
        progressState: 2,
        message: "",
        storeReviewData: storeReviewData,
        averateRatingData: averateRatingData,
      );
    } else {
      _storePageState = _storePageState.update(
        progressState: 2,
        message: result["messsage"],
      );
    }

    notifyListeners();
  }

  Future<void> updateStoreReview({@required Map<String, dynamic>? storeReview}) async {
    var result = await StoreReviewApiProvider.updateStoreReview(storeReview: storeReview);

    if (result["success"]) {
      Map<String, dynamic> storeReviewData = _storePageState.storeReviewData!;

      /// update averateRatingData
      Map<String, dynamic> averateRatingData = _storePageState.averateRatingData!;

      averateRatingData[storeReview!["storeId"]] = {
        "totalRating": averateRatingData[storeReview["storeId"]]["totalRating"] +
            storeReview["rating"] -
            storeReviewData["${storeReview["userId"]}_${storeReview["storeId"]}"]["rating"],
        "totalCount": averateRatingData[storeReview["storeId"]]["totalCount"],
      };
      ///////////////

      storeReviewData["${storeReview["userId"]}_${storeReview["storeId"]}"] = result["data"];

      _storePageState = _storePageState.update(
        progressState: 2,
        message: "",
        storeReviewData: storeReviewData,
        averateRatingData: averateRatingData,
      );
    } else {
      _storePageState = _storePageState.update(
        progressState: 2,
        message: result["messsage"],
      );
    }

    notifyListeners();
  }

  Future<void> getAverageRating({@required String? storeId}) async {
    try {
      var result = await StoreReviewApiProvider.getAverageRating(storeId: storeId);

      if (result["success"] && result["data"].isNotEmpty) {
        Map<String, dynamic> averateRatingData = _storePageState.averateRatingData!;
        averateRatingData[storeId!] = result["data"][0];

        _storePageState = _storePageState.update(
          // progressState: 2,
          message: "",
          averateRatingData: averateRatingData,
        );
      } else {
        _storePageState = _storePageState.update(
          // progressState: 2,
          message: result["messsage"],
        );
      }

      notifyListeners();
    } catch (e) {
      FlutterLogs.logThis(
        tag: "store_page_provider",
        level: LogLevel.ERROR,
        subTag: "getAverageRating",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  Future<void> getTopReviewList({@required String? storeId}) async {
    var result = await StoreReviewApiProvider.getReviewList(storeId: storeId, page: 1, limit: 3);

    if (result["success"]) {
      _storePageState = _storePageState.update(
        // progressState: 2,
        message: "",
        topReviewList: result["data"]["docs"],
        isLoadMore: result["data"]["hasNextPage"],
      );
    } else {
      _storePageState = _storePageState.update(
        // progressState: 2,
        message: "",
        topReviewList: [],
        isLoadMore: false,
      );
    }
    notifyListeners();
  }

  Future<void> getStoreGallery({@required String? storeId}) async {
    var result = await StoreGalleryApiProvider.get(storeId: storeId);

    if (result["success"]) {
      Map<String, dynamic>? storeGalleryData = _storePageState.storeGalleryData;
      if (storeGalleryData == null) storeGalleryData = Map<String, dynamic>();
      if (storeGalleryData[storeId] == null) storeGalleryData[storeId!] = Map<String, dynamic>();
      storeGalleryData[storeId!] = result["data"];
      _storePageState = _storePageState.update(
        // progressState: 2,
        message: "",
        storeGalleryData: storeGalleryData,
      );
    } else {
      _storePageState = _storePageState.update(
        // progressState: 2,
        message: "",
      );
    }
    notifyListeners();
  }
}
