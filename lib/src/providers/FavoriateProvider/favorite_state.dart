import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class FavoriteState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? favoriteData;
  final Map<String, dynamic>? favoriteObjectListData;
  final Map<String, dynamic>? favoriteObjectMetaData;
  final bool? isRefresh;
  final bool? isUpdated;

  FavoriteState({
    @required this.progressState,
    @required this.message,
    @required this.favoriteData,
    @required this.favoriteObjectListData,
    @required this.favoriteObjectMetaData,
    @required this.isRefresh,
    @required this.isUpdated,
  });

  factory FavoriteState.init() {
    return FavoriteState(
      progressState: 0,
      message: "",
      favoriteData: Map<String, dynamic>(),
      favoriteObjectListData: Map<String, dynamic>(),
      favoriteObjectMetaData: Map<String, dynamic>(),
      isRefresh: false,
      isUpdated: false,
    );
  }

  FavoriteState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? favoriteData,
    Map<String, dynamic>? favoriteObjectListData,
    Map<String, dynamic>? favoriteObjectMetaData,
    bool? isRefresh,
    bool? isUpdated,
  }) {
    return FavoriteState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      favoriteData: favoriteData ?? this.favoriteData,
      favoriteObjectListData: favoriteObjectListData ?? this.favoriteObjectListData,
      favoriteObjectMetaData: favoriteObjectMetaData ?? this.favoriteObjectMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
      isUpdated: isUpdated ?? this.isUpdated,
    );
  }

  FavoriteState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? favoriteData,
    Map<String, dynamic>? favoriteObjectListData,
    Map<String, dynamic>? favoriteObjectMetaData,
    bool? isRefresh,
    bool? isUpdated,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      favoriteData: favoriteData,
      favoriteObjectListData: favoriteObjectListData,
      favoriteObjectMetaData: favoriteObjectMetaData,
      isRefresh: isRefresh,
      isUpdated: isUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "favoriteData": favoriteData,
      "favoriteObjectListData": favoriteObjectListData,
      "favoriteObjectMetaData": favoriteObjectMetaData,
      "isRefresh": isRefresh,
      "isUpdated": isUpdated,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        favoriteData!,
        favoriteObjectListData!,
        favoriteObjectMetaData!,
        isRefresh!,
        isUpdated!,
      ];

  @override
  bool get stringify => true;
}
