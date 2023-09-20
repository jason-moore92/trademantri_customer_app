import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class AnnouncementListState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? announcementListData;
  final Map<String, dynamic>? announcementMetaData;
  final List<dynamic>? categories;
  final bool? isRefresh;

  AnnouncementListState({
    @required this.progressState,
    @required this.message,
    @required this.announcementListData,
    @required this.announcementMetaData,
    @required this.categories,
    @required this.isRefresh,
  });

  factory AnnouncementListState.init() {
    return AnnouncementListState(
      progressState: 0,
      message: "",
      announcementListData: Map<String, dynamic>(),
      announcementMetaData: Map<String, dynamic>(),
      categories: null,
      isRefresh: false,
    );
  }

  AnnouncementListState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? announcementListData,
    Map<String, dynamic>? announcementMetaData,
    List<dynamic>? categories,
    bool? isRefresh,
  }) {
    return AnnouncementListState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      announcementListData: announcementListData ?? this.announcementListData,
      announcementMetaData: announcementMetaData ?? this.announcementMetaData,
      categories: categories ?? this.categories,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  AnnouncementListState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? announcementListData,
    Map<String, dynamic>? announcementMetaData,
    List<dynamic>? categories,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      announcementListData: announcementListData,
      announcementMetaData: announcementMetaData,
      categories: categories,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "announcementListData": announcementListData,
      "announcementMetaData": announcementMetaData,
      "categories": categories,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        announcementListData!,
        announcementMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
