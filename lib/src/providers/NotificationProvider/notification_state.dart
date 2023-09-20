import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? newNotificationData;
  final Map<String, dynamic>? notificationListData;
  final Map<String, dynamic>? notificationMetaData;
  final bool? isRefresh;

  NotificationState({
    @required this.progressState,
    @required this.message,
    @required this.newNotificationData,
    @required this.notificationListData,
    @required this.notificationMetaData,
    @required this.isRefresh,
  });

  factory NotificationState.init() {
    return NotificationState(
      progressState: 0,
      message: "",
      newNotificationData: Map<String, dynamic>(),
      notificationListData: Map<String, dynamic>(),
      notificationMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  NotificationState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? newNotificationData,
    Map<String, dynamic>? notificationListData,
    Map<String, dynamic>? notificationMetaData,
    bool? isRefresh,
  }) {
    return NotificationState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      newNotificationData: newNotificationData ?? this.newNotificationData,
      notificationListData: notificationListData ?? this.notificationListData,
      notificationMetaData: notificationMetaData ?? this.notificationMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  NotificationState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? newNotificationData,
    Map<String, dynamic>? notificationListData,
    Map<String, dynamic>? notificationMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      newNotificationData: newNotificationData,
      notificationListData: notificationListData,
      notificationMetaData: notificationMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "newNotificationData": newNotificationData,
      "notificationListData": notificationListData,
      "notificationMetaData": notificationMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        newNotificationData!,
        notificationListData!,
        notificationMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
