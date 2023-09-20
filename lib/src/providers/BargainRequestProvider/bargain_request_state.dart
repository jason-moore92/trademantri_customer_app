import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class BargainRequestState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? bargainRequestListData;
  final Map<String, dynamic>? bargainRequestMetaData;
  final bool? isRefresh;

  BargainRequestState({
    @required this.progressState,
    @required this.message,
    @required this.bargainRequestListData,
    @required this.bargainRequestMetaData,
    @required this.isRefresh,
  });

  factory BargainRequestState.init() {
    return BargainRequestState(
      progressState: 0,
      message: "",
      bargainRequestListData: Map<String, dynamic>(),
      bargainRequestMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  BargainRequestState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? bargainRequestListData,
    Map<String, dynamic>? bargainRequestMetaData,
    bool? isRefresh,
  }) {
    return BargainRequestState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      bargainRequestListData: bargainRequestListData ?? this.bargainRequestListData,
      bargainRequestMetaData: bargainRequestMetaData ?? this.bargainRequestMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  BargainRequestState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? bargainRequestListData,
    Map<String, dynamic>? bargainRequestMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      bargainRequestListData: bargainRequestListData,
      bargainRequestMetaData: bargainRequestMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "bargainRequestListData": bargainRequestListData,
      "bargainRequestMetaData": bargainRequestMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        bargainRequestListData!,
        bargainRequestMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
