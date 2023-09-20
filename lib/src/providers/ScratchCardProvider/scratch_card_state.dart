import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class ScratchCardState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? scratchCardData;

  ScratchCardState({
    @required this.progressState,
    @required this.message,
    @required this.scratchCardData,
  });

  factory ScratchCardState.init() {
    return ScratchCardState(
      progressState: 0,
      message: "",
      scratchCardData: Map<String, dynamic>(),
    );
  }

  ScratchCardState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? scratchCardData,
  }) {
    return ScratchCardState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      scratchCardData: scratchCardData ?? this.scratchCardData,
    );
  }

  ScratchCardState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? scratchCardData,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      scratchCardData: scratchCardData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "scratchCardData": scratchCardData,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        scratchCardData!,
      ];

  @override
  bool get stringify => true;
}
