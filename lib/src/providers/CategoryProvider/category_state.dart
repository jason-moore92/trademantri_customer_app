import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class CategoryState extends Equatable {
  final int? progressState;
  final String? message;
  final Map<String, dynamic>? categoryData;

  CategoryState({
    @required this.message,
    @required this.progressState,
    @required this.categoryData,
  });

  factory CategoryState.init() {
    return CategoryState(
      progressState: 0,
      message: "",
      categoryData: Map<String, dynamic>(),
    );
  }

  CategoryState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? categoryData,
  }) {
    return CategoryState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      categoryData: categoryData ?? this.categoryData,
    );
  }

  CategoryState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? categoryData,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      categoryData: categoryData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "categoryData": categoryData,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        categoryData!,
      ];

  @override
  bool get stringify => true;
}
