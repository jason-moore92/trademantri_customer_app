import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class ProductItemReviewProvider extends ChangeNotifier {
  static ProductItemReviewProvider of(BuildContext context, {bool listen = false}) => Provider.of<ProductItemReviewProvider>(context, listen: listen);

  ProductItemReviewState _productItemReviewState = ProductItemReviewState.init();
  ProductItemReviewState get productItemReviewState => _productItemReviewState;

  void setProductItemReviewState(ProductItemReviewState productItemReviewState, {bool isNotifiable = true}) {
    if (_productItemReviewState != productItemReviewState) {
      _productItemReviewState = productItemReviewState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getProductItemReviewList({@required String? itemId, @required String? type}) async {
    Map<String, dynamic> reviewMetaData = _productItemReviewState.reviewMetaData!;
    List<dynamic> reviewList = _productItemReviewState.reviewList!;

    reviewMetaData = Map<String, dynamic>();
    reviewList = [];

    var result = await ProductItemReviewApiProvider.getReviewList(
      itemId: itemId,
      type: type,
      page: reviewMetaData["nextPage"] ?? 1,
      limit: AppConfig.countLimitForList,
    );

    if (result["success"]) {
      reviewList.addAll(result["data"]["docs"]);
      result["data"].remove("docs");
      reviewMetaData = result["data"];

      _productItemReviewState = _productItemReviewState.update(
        progressState: 2,
        message: "",
        reviewList: reviewList,
        reviewMetaData: reviewMetaData,
      );
    } else {
      _productItemReviewState = _productItemReviewState.update(
        progressState: reviewList.isEmpty ? -1 : 2,
        message: result["messsage"],
      );
    }
    notifyListeners();
  }

  Future<void> getProductItemReview({@required String? userId, @required String? itemId, @required String? type}) async {
    var result = await ProductItemReviewApiProvider.getProductItemReview(
      userId: userId,
      itemId: itemId,
      type: type,
    );

    String key = "${userId}_${itemId}_$type";

    Map<String, dynamic> productItemReviewData = _productItemReviewState.productItemReviewData!;
    if (result["success"]) {
      productItemReviewData[key] = result["data"] ?? Map<String, dynamic>();

      _productItemReviewState = _productItemReviewState.update(
        progressState: 2,
        message: "",
        productItemReviewData: productItemReviewData,
      );
    } else {
      productItemReviewData[key] = Map<String, dynamic>();
      _productItemReviewState = _productItemReviewState.update(
        progressState: 2,
        message: result["messsage"],
        productItemReviewData: productItemReviewData,
      );
    }

    notifyListeners();
  }

  Future<void> createProductItemReview({@required Map<String, dynamic>? productItemReview}) async {
    var result = await ProductItemReviewApiProvider.createProductItemReview(itemReview: productItemReview);

    String key = "${productItemReview!["userId"]}_${productItemReview["itemId"]}_${productItemReview["type"]}";

    if (result["success"]) {
      Map<String, dynamic> productItemReviewData = _productItemReviewState.productItemReviewData!;
      productItemReviewData[key] = result["data"];

      // /// update averateRatingData
      // Map<String, dynamic> averateRatingData = _productItemReviewState.averateRatingData;
      // if (averateRatingData.isEmpty) {
      //   averateRatingData = {"totalRating": productItemReview["rating"], "totalCount": 1};
      // } else {
      //   averateRatingData = {
      //     "totalRating": averateRatingData["totalRating"] + productItemReview["rating"],
      //     "totalCount": averateRatingData["totalCount"] + 1,
      //   };
      // }
      // ///////////////
      _productItemReviewState = _productItemReviewState.update(
        progressState: 2,
        message: "",
        productItemReviewData: productItemReviewData,
        // averateRatingData: averateRatingData,
      );
    } else {
      _productItemReviewState = _productItemReviewState.update(
        progressState: 2,
        message: result["messsage"],
      );
    }

    notifyListeners();
  }

  Future<void> updateProductItemReview({@required Map<String, dynamic>? productItemReview}) async {
    var result = await ProductItemReviewApiProvider.updateProductItemReview(itemReview: productItemReview);

    String key = "${productItemReview!["userId"]}_${productItemReview["itemId"]}_${productItemReview["type"]}";

    if (result["success"]) {
      Map<String, dynamic> productItemReviewData = _productItemReviewState.productItemReviewData!;

      // /// update averateRatingData
      // Map<String, dynamic> averateRatingData = _productItemReviewState.averateRatingData;

      // averateRatingData = {
      //   "totalRating": averateRatingData["totalRating"] + productItemReview["rating"] - productItemReviewData[key]["rating"],
      //   "totalCount": averateRatingData["totalCount"],
      // };
      // ///////////////

      productItemReviewData[key] = result["data"];

      _productItemReviewState = _productItemReviewState.update(
        progressState: 2,
        message: "",
        productItemReviewData: productItemReviewData,
        // averateRatingData: averateRatingData,
      );
    } else {
      _productItemReviewState = _productItemReviewState.update(
        progressState: 2,
        message: result["messsage"],
      );
    }

    notifyListeners();
  }

  Future<void> getAverageRating({@required String? itemId, @required String? type}) async {
    try {
      var result = await ProductItemReviewApiProvider.getAverageRating(itemId: itemId, type: type);

      if (result["success"] && result["data"].isNotEmpty) {
        Map<String, dynamic> averateRatingData = _productItemReviewState.averateRatingData!;
        averateRatingData = result["data"][0];

        _productItemReviewState = _productItemReviewState.update(
          progressState: 2,
          message: "",
          averateRatingData: averateRatingData,
        );
      } else {
        _productItemReviewState = _productItemReviewState.update(
          progressState: 2,
          message: result["messsage"],
        );
      }

      notifyListeners();
    } catch (e) {
      FlutterLogs.logThis(
        tag: "product_item_review_provider",
        level: LogLevel.ERROR,
        subTag: "getAverageRating",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  Future<void> getTopReviewList({@required String? itemId, @required String? type}) async {
    var result = await ProductItemReviewApiProvider.getReviewList(itemId: itemId, type: type, page: 1, limit: 3);

    if (result["success"]) {
      _productItemReviewState = _productItemReviewState.update(
        progressState: 2,
        message: "",
        topReviewList: result["data"]["docs"],
        isLoadMore: result["data"]["hasNextPage"],
      );
    } else {
      _productItemReviewState = _productItemReviewState.update(
        progressState: 2,
        message: "",
        topReviewList: [],
        isLoadMore: false,
      );
    }
    notifyListeners();
  }
}
