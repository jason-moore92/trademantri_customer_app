import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? cartData;
  final bool? isUpdated;

  CartState({
    @required this.progressState,
    @required this.message,
    @required this.cartData,
    @required this.isUpdated,
  });

  factory CartState.init() {
    return CartState(
      progressState: 0,
      message: "",
      cartData: Map<String, dynamic>(),
      isUpdated: false,
    );
  }

  CartState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? cartData,
    bool? isUpdated,
  }) {
    return CartState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      cartData: cartData ?? this.cartData,
      isUpdated: isUpdated ?? this.isUpdated,
    );
  }

  CartState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? cartData,
    bool? isUpdated,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      cartData: cartData,
      isUpdated: isUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "cartData": cartData,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        cartData!,
        isUpdated!,
      ];

  @override
  bool get stringify => true;
}
