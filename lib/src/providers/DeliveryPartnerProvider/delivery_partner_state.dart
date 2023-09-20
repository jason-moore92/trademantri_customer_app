import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class DeliveryPartnerState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final List<dynamic>? deliveryPartnerData;
  final bool? noDeliveryPartner;

  DeliveryPartnerState({
    @required this.progressState,
    @required this.message,
    @required this.deliveryPartnerData,
    @required this.noDeliveryPartner,
  });

  factory DeliveryPartnerState.init() {
    return DeliveryPartnerState(
      progressState: 0,
      message: "",
      deliveryPartnerData: [],
      noDeliveryPartner: false,
    );
  }

  DeliveryPartnerState copyWith({
    int? progressState,
    String? message,
    List<dynamic>? deliveryPartnerData,
    bool? noDeliveryPartner,
  }) {
    return DeliveryPartnerState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      deliveryPartnerData: deliveryPartnerData ?? this.deliveryPartnerData,
      noDeliveryPartner: noDeliveryPartner ?? this.noDeliveryPartner,
    );
  }

  DeliveryPartnerState update({
    int? progressState,
    String? message,
    List<dynamic>? deliveryPartnerData,
    bool? noDeliveryPartner,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      deliveryPartnerData: deliveryPartnerData,
      noDeliveryPartner: noDeliveryPartner,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "deliveryPartnerData": deliveryPartnerData,
      "noDeliveryPartner": noDeliveryPartner,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        deliveryPartnerData!,
        noDeliveryPartner!,
      ];

  @override
  bool get stringify => true;
}
