import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class AppliedJobState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final List<dynamic>? appliedJobListData;
  final Map<String, dynamic>? appliedJobMetaData;
  final bool? isRefresh;

  AppliedJobState({
    @required this.progressState,
    @required this.message,
    @required this.appliedJobListData,
    @required this.appliedJobMetaData,
    @required this.isRefresh,
  });

  factory AppliedJobState.init() {
    return AppliedJobState(
      progressState: 0,
      message: "",
      appliedJobListData: [],
      appliedJobMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  AppliedJobState copyWith({
    int? progressState,
    String? message,
    List<dynamic>? appliedJobListData,
    Map<String, dynamic>? appliedJobMetaData,
    bool? isRefresh,
  }) {
    return AppliedJobState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      appliedJobListData: appliedJobListData ?? this.appliedJobListData,
      appliedJobMetaData: appliedJobMetaData ?? this.appliedJobMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  AppliedJobState update({
    int? progressState,
    String? message,
    List<dynamic>? appliedJobListData,
    Map<String, dynamic>? appliedJobMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      appliedJobListData: appliedJobListData,
      appliedJobMetaData: appliedJobMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "appliedJobListData": appliedJobListData,
      "appliedJobMetaData": appliedJobMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        appliedJobListData!,
        appliedJobMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
