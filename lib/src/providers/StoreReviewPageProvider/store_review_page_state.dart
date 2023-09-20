import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class StoreReviewPageState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? reviewList;
  final Map<String, dynamic>? reviewMetaData;
  final bool? isRefresh;

  StoreReviewPageState({
    @required this.message,
    @required this.progressState,
    @required this.reviewList,
    @required this.reviewMetaData,
    @required this.isRefresh,
  });

  factory StoreReviewPageState.init() {
    return StoreReviewPageState(
      progressState: 0,
      message: "",
      reviewList: Map<String, dynamic>(),
      reviewMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  StoreReviewPageState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? reviewList,
    Map<String, dynamic>? reviewMetaData,
    bool? isRefresh,
  }) {
    return StoreReviewPageState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      reviewList: reviewList ?? this.reviewList,
      reviewMetaData: reviewMetaData ?? this.reviewMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  StoreReviewPageState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? reviewList,
    Map<String, dynamic>? reviewMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      reviewList: reviewList,
      reviewMetaData: reviewMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "reviewList": reviewList,
      "reviewMetaData": reviewMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        reviewList!,
        reviewMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
