import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class ProductListPageState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? productCategoryData;
  final Map<String, dynamic>? productListData;
  final Map<String, dynamic>? productMetaData;
  final bool? isRefresh;

  ProductListPageState({
    @required this.message,
    @required this.progressState,
    @required this.productCategoryData,
    @required this.productListData,
    @required this.productMetaData,
    @required this.isRefresh,
  });

  factory ProductListPageState.init() {
    return ProductListPageState(
      progressState: 0,
      message: "",
      productCategoryData: Map<String, dynamic>(),
      productListData: Map<String, dynamic>(),
      productMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  ProductListPageState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? productCategoryData,
    Map<String, dynamic>? productListData,
    Map<String, dynamic>? productMetaData,
    bool? isRefresh,
  }) {
    return ProductListPageState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      productCategoryData: productCategoryData ?? this.productCategoryData,
      productListData: productListData ?? this.productListData,
      productMetaData: productMetaData ?? this.productMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  ProductListPageState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? productCategoryData,
    Map<String, dynamic>? productListData,
    Map<String, dynamic>? productMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      productCategoryData: productCategoryData,
      productListData: productListData,
      productMetaData: productMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "productCategoryData": productCategoryData,
      "productListData": productListData,
      "productMetaData": productMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        productCategoryData!,
        productListData!,
        productMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
