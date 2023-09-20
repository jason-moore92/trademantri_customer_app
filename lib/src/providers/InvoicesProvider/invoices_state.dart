import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class InvoicesState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final List<dynamic>? invoicesListData;
  final Map<String, dynamic>? invoicesMetaData;
  final bool? isRefresh;

  InvoicesState({
    @required this.progressState,
    @required this.message,
    @required this.invoicesListData,
    @required this.invoicesMetaData,
    @required this.isRefresh,
  });

  factory InvoicesState.init() {
    return InvoicesState(
      progressState: 0,
      message: "",
      invoicesListData: [],
      invoicesMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  InvoicesState copyWith({
    int? progressState,
    String? message,
    List<dynamic>? invoicesListData,
    Map<String, dynamic>? invoicesMetaData,
    bool? isRefresh,
  }) {
    return InvoicesState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      invoicesListData: invoicesListData ?? this.invoicesListData,
      invoicesMetaData: invoicesMetaData ?? this.invoicesMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  InvoicesState update({
    int? progressState,
    String? message,
    List<dynamic>? invoicesListData,
    Map<String, dynamic>? invoicesMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      invoicesListData: invoicesListData,
      invoicesMetaData: invoicesMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "invoicesListData": invoicesListData,
      "invoicesMetaData": invoicesMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        invoicesListData!,
        invoicesMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
