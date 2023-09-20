import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class StoreJobPostingsState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final List<dynamic>? storeJobPostingsListData;
  final Map<String, dynamic>? storeJobPostingsMetaData;
  final bool? isRefresh;

  StoreJobPostingsState({
    @required this.progressState,
    @required this.message,
    @required this.storeJobPostingsListData,
    @required this.storeJobPostingsMetaData,
    @required this.isRefresh,
  });

  factory StoreJobPostingsState.init() {
    return StoreJobPostingsState(
      progressState: 0,
      message: "",
      storeJobPostingsListData: [],
      storeJobPostingsMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  StoreJobPostingsState copyWith({
    int? progressState,
    String? message,
    List<dynamic>? storeJobPostingsListData,
    Map<String, dynamic>? storeJobPostingsMetaData,
    bool? isRefresh,
  }) {
    return StoreJobPostingsState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      storeJobPostingsListData: storeJobPostingsListData ?? this.storeJobPostingsListData,
      storeJobPostingsMetaData: storeJobPostingsMetaData ?? this.storeJobPostingsMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  StoreJobPostingsState update({
    int? progressState,
    String? message,
    List<dynamic>? storeJobPostingsListData,
    Map<String, dynamic>? storeJobPostingsMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      storeJobPostingsListData: storeJobPostingsListData,
      storeJobPostingsMetaData: storeJobPostingsMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "storeJobPostingsListData": storeJobPostingsListData,
      "storeJobPostingsMetaData": storeJobPostingsMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        storeJobPostingsListData!,
        storeJobPostingsMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
