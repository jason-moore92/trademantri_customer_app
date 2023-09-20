import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trapp/src/models/index.dart';

class PromocodeState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, List<PromocodeModel>>? promocodeData;

  PromocodeState({
    @required this.progressState,
    @required this.message,
    @required this.promocodeData,
  });

  factory PromocodeState.init() {
    return PromocodeState(
      progressState: 0,
      message: "",
      promocodeData: Map<String, List<PromocodeModel>>(),
    );
  }

  PromocodeState copyWith({
    int? progressState,
    String? message,
    Map<String, List<PromocodeModel>>? promocodeData,
  }) {
    return PromocodeState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      promocodeData: promocodeData ?? this.promocodeData,
    );
  }

  PromocodeState update({
    int? progressState,
    String? message,
    Map<String, List<PromocodeModel>>? promocodeData,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      promocodeData: promocodeData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "promocodeData": promocodeData,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        promocodeData!,
      ];

  @override
  bool get stringify => true;
}
