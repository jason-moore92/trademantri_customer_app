import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class AppointmentState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? appointmentsData;
  final Map<String, dynamic>? appointmentsMetaData;
  final List<dynamic>? categories;
  final bool? isRefresh;

  AppointmentState({
    @required this.progressState,
    @required this.message,
    @required this.appointmentsData,
    @required this.appointmentsMetaData,
    @required this.categories,
    @required this.isRefresh,
  });

  factory AppointmentState.init() {
    return AppointmentState(
      progressState: 0,
      message: "",
      appointmentsData: Map<String, dynamic>(),
      appointmentsMetaData: Map<String, dynamic>(),
      categories: null,
      isRefresh: false,
    );
  }

  AppointmentState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? appointmentsData,
    Map<String, dynamic>? appointmentsMetaData,
    List<dynamic>? categories,
    bool? isRefresh,
  }) {
    return AppointmentState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      appointmentsData: appointmentsData ?? this.appointmentsData,
      appointmentsMetaData: appointmentsMetaData ?? this.appointmentsMetaData,
      categories: categories ?? this.categories,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  AppointmentState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? appointmentsData,
    Map<String, dynamic>? appointmentsMetaData,
    List<dynamic>? categories,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      appointmentsData: appointmentsData,
      appointmentsMetaData: appointmentsMetaData,
      categories: categories,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "appointmentsData": appointmentsData,
      "appointmentsMetaData": appointmentsMetaData,
      "categories": categories,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        appointmentsData!,
        appointmentsMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
