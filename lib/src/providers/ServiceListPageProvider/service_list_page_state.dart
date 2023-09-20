import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class ServiceListPageState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? serviceCategoryData;
  final Map<String, dynamic>? serviceListData;
  final Map<String, dynamic>? serviceMetaData;
  final bool? isRefresh;

  ServiceListPageState({
    @required this.message,
    @required this.progressState,
    @required this.serviceCategoryData,
    @required this.serviceListData,
    @required this.serviceMetaData,
    @required this.isRefresh,
  });

  factory ServiceListPageState.init() {
    return ServiceListPageState(
      progressState: 0,
      message: "",
      serviceCategoryData: Map<String, dynamic>(),
      serviceListData: Map<String, dynamic>(),
      serviceMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  ServiceListPageState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? serviceCategoryData,
    Map<String, dynamic>? serviceListData,
    Map<String, dynamic>? serviceMetaData,
    bool? isRefresh,
  }) {
    return ServiceListPageState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      serviceCategoryData: serviceCategoryData ?? this.serviceCategoryData,
      serviceListData: serviceListData ?? this.serviceListData,
      serviceMetaData: serviceMetaData ?? this.serviceMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  ServiceListPageState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? serviceCategoryData,
    Map<String, dynamic>? serviceListData,
    Map<String, dynamic>? serviceMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      serviceCategoryData: serviceCategoryData,
      serviceListData: serviceListData,
      serviceMetaData: serviceMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "serviceCategoryData": serviceCategoryData,
      "serviceListData": serviceListData,
      "serviceMetaData": serviceMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        serviceCategoryData!,
        serviceListData!,
        serviceMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
