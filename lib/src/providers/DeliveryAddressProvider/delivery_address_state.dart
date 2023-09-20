import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class DeliveryAddressState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? deliveryAddressData;
  final Map<String, dynamic>? selectedDeliveryAddress;
  final double? maxDeliveryDistance;

  DeliveryAddressState({
    @required this.progressState,
    @required this.message,
    @required this.deliveryAddressData,
    @required this.selectedDeliveryAddress,
    @required this.maxDeliveryDistance,
  });

  factory DeliveryAddressState.init() {
    return DeliveryAddressState(
      progressState: 0,
      message: "",
      deliveryAddressData: Map<String, dynamic>(),
      selectedDeliveryAddress: Map<String, dynamic>(),
      maxDeliveryDistance: 0,
    );
  }

  DeliveryAddressState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? deliveryAddressData,
    Map<String, dynamic>? selectedDeliveryAddress,
    double? maxDeliveryDistance,
  }) {
    return DeliveryAddressState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      deliveryAddressData: deliveryAddressData ?? this.deliveryAddressData,
      selectedDeliveryAddress: selectedDeliveryAddress ?? this.selectedDeliveryAddress,
      maxDeliveryDistance: maxDeliveryDistance ?? this.maxDeliveryDistance,
    );
  }

  DeliveryAddressState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? deliveryAddressData,
    Map<String, dynamic>? selectedDeliveryAddress,
    double? maxDeliveryDistance,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      deliveryAddressData: deliveryAddressData,
      selectedDeliveryAddress: selectedDeliveryAddress,
      maxDeliveryDistance: maxDeliveryDistance,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "deliveryAddressData": deliveryAddressData,
      "selectedDeliveryAddress": selectedDeliveryAddress,
      "maxDeliveryDistance": maxDeliveryDistance,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        deliveryAddressData!,
        selectedDeliveryAddress!,
        maxDeliveryDistance!,
      ];

  @override
  bool get stringify => true;
}
