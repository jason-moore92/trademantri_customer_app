import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class StorePageState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? rewardPointData;
  final Map<String, dynamic>? storeReviewData;
  final Map<String, dynamic>? averateRatingData;
  final Map<String, dynamic>? storeGalleryData;
  final List<dynamic>? topReviewList;
  final bool? isLoadMore;

  StorePageState({
    @required this.message,
    @required this.progressState,
    @required this.rewardPointData,
    @required this.storeReviewData,
    @required this.averateRatingData,
    @required this.storeGalleryData,
    @required this.topReviewList,
    @required this.isLoadMore,
  });

  factory StorePageState.init() {
    return StorePageState(
      progressState: 0,
      message: "",
      rewardPointData: Map<String, dynamic>(),
      storeReviewData: Map<String, dynamic>(),
      averateRatingData: Map<String, dynamic>(),
      storeGalleryData: Map<String, dynamic>(),
      topReviewList: List.generate(3, (index) => Map<String, dynamic>(), growable: true),
      isLoadMore: false,
    );
  }

  StorePageState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? rewardPointData,
    Map<String, dynamic>? storeReviewData,
    Map<String, dynamic>? averateRatingData,
    Map<String, dynamic>? storeGalleryData,
    List<dynamic>? topReviewList,
    bool? isLoadMore,
  }) {
    return StorePageState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      rewardPointData: rewardPointData ?? this.rewardPointData,
      storeReviewData: storeReviewData ?? this.storeReviewData,
      averateRatingData: averateRatingData ?? this.averateRatingData,
      storeGalleryData: storeGalleryData ?? this.storeGalleryData,
      topReviewList: topReviewList ?? this.topReviewList,
      isLoadMore: isLoadMore ?? this.isLoadMore,
    );
  }

  StorePageState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? rewardPointData,
    Map<String, dynamic>? storeReviewData,
    Map<String, dynamic>? averateRatingData,
    Map<String, dynamic>? storeGalleryData,
    List<dynamic>? topReviewList,
    bool? isLoadMore,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      rewardPointData: rewardPointData,
      storeReviewData: storeReviewData,
      averateRatingData: averateRatingData,
      storeGalleryData: storeGalleryData,
      topReviewList: topReviewList,
      isLoadMore: isLoadMore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "rewardPointData": rewardPointData,
      "storeReviewData": storeReviewData,
      "averateRatingData": averateRatingData,
      "storeGalleryData": storeGalleryData,
      "topReviewList": topReviewList,
      "isLoadMore": isLoadMore,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        rewardPointData!,
        storeReviewData!,
        averateRatingData!,
        storeGalleryData!,
        topReviewList!,
        isLoadMore!,
      ];

  @override
  bool get stringify => true;
}
