import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class StoreCategoriesState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? storeList;
  final List<dynamic>? categoryList;
  final Map<String, dynamic>? storeMetaData;
  final bool? isRefresh;

  StoreCategoriesState({
    @required this.message,
    @required this.progressState,
    @required this.storeList,
    @required this.categoryList,
    @required this.storeMetaData,
    @required this.isRefresh,
  });

  factory StoreCategoriesState.init() {
    return StoreCategoriesState(
      progressState: 0,
      message: "",
      storeList: Map<String, dynamic>(),
      categoryList: [],
      storeMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  StoreCategoriesState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? storeList,
    List<dynamic>? categoryList,
    Map<String, dynamic>? storeMetaData,
    bool? isRefresh,
  }) {
    return StoreCategoriesState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      storeList: storeList ?? this.storeList,
      categoryList: categoryList ?? this.categoryList,
      storeMetaData: storeMetaData ?? this.storeMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  StoreCategoriesState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? storeList,
    List<dynamic>? categoryList,
    Map<String, dynamic>? storeMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      storeList: storeList,
      categoryList: categoryList,
      storeMetaData: storeMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "storeList": storeList,
      "categoryList": categoryList,
      "storeMetaData": storeMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        storeList!,
        categoryList!,
        storeMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
