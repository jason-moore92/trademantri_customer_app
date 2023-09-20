import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class ContactUsRequestState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? contactUsRequestListData;

  ContactUsRequestState({
    @required this.progressState,
    @required this.message,
    @required this.contactUsRequestListData,
  });

  factory ContactUsRequestState.init() {
    return ContactUsRequestState(
      progressState: 0,
      message: "",
      contactUsRequestListData: Map<String, dynamic>(),
    );
  }

  ContactUsRequestState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? contactUsRequestListData,
  }) {
    return ContactUsRequestState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      contactUsRequestListData: contactUsRequestListData ?? this.contactUsRequestListData,
    );
  }

  ContactUsRequestState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? contactUsRequestListData,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      contactUsRequestListData: contactUsRequestListData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "contactUsRequestListData": contactUsRequestListData,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        contactUsRequestListData!,
      ];

  @override
  bool get stringify => true;
}
