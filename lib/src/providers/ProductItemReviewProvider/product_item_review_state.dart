import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class ProductItemReviewState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final List<dynamic>? reviewList;
  final Map<String, dynamic>? reviewMetaData;
  final Map<String, dynamic>? productItemReviewData;
  final Map<String, dynamic>? averateRatingData;
  final List<dynamic>? topReviewList;
  final bool? isLoadMore;
  final bool? isRefresh;

  ProductItemReviewState({
    @required this.message,
    @required this.progressState,
    @required this.reviewList,
    @required this.reviewMetaData,
    @required this.productItemReviewData,
    @required this.averateRatingData,
    @required this.topReviewList,
    @required this.isLoadMore,
    @required this.isRefresh,
  });

  factory ProductItemReviewState.init() {
    return ProductItemReviewState(
      progressState: 0,
      message: "",
      reviewList: [],
      reviewMetaData: Map<String, dynamic>(),
      productItemReviewData: Map<String, dynamic>(),
      averateRatingData: Map<String, dynamic>(),
      isRefresh: false,
      topReviewList: [],
      isLoadMore: false,
    );
  }

  ProductItemReviewState copyWith({
    int? progressState,
    String? message,
    List<dynamic>? reviewList,
    Map<String, dynamic>? reviewMetaData,
    Map<String, dynamic>? productItemReviewData,
    Map<String, dynamic>? averateRatingData,
    bool? isRefresh,
    List<dynamic>? topReviewList,
    bool? isLoadMore,
  }) {
    return ProductItemReviewState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      reviewList: reviewList ?? this.reviewList,
      reviewMetaData: reviewMetaData ?? this.reviewMetaData,
      productItemReviewData: productItemReviewData ?? this.productItemReviewData,
      averateRatingData: averateRatingData ?? this.averateRatingData,
      isRefresh: isRefresh ?? this.isRefresh,
      topReviewList: topReviewList ?? this.topReviewList,
      isLoadMore: isLoadMore ?? this.isLoadMore,
    );
  }

  ProductItemReviewState update({
    int? progressState,
    String? message,
    List<dynamic>? reviewList,
    Map<String, dynamic>? reviewMetaData,
    Map<String, dynamic>? productItemReviewData,
    Map<String, dynamic>? averateRatingData,
    bool? isRefresh,
    List<dynamic>? topReviewList,
    bool? isLoadMore,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      reviewList: reviewList,
      reviewMetaData: reviewMetaData,
      productItemReviewData: productItemReviewData,
      averateRatingData: averateRatingData,
      isRefresh: isRefresh,
      topReviewList: topReviewList,
      isLoadMore: isLoadMore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "reviewList": reviewList,
      "reviewMetaData": reviewMetaData,
      "productItemReviewData": productItemReviewData,
      "averateRatingData": averateRatingData,
      "isRefresh": isRefresh,
      "topReviewList": topReviewList,
      "isLoadMore": isLoadMore,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        reviewList!,
        reviewMetaData!,
        productItemReviewData!,
        averateRatingData!,
        isRefresh!,
        topReviewList!,
        isLoadMore!,
      ];

  @override
  bool get stringify => true;
}
