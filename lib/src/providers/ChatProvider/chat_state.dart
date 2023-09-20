import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class ChatState extends Equatable {
  final int? progressState;
  final String? message;

  ChatState({
    @required this.message,
    @required this.progressState,
  });

  factory ChatState.init() {
    return ChatState(
      progressState: 0,
      message: "",
    );
  }

  ChatState copyWith({
    int? progressState,
    String? message,
  }) {
    return ChatState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
    );
  }

  ChatState update({
    int? progressState,
    String? message,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
      ];

  @override
  bool get stringify => true;
}
