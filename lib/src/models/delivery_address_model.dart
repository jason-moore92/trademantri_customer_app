import "package:equatable/equatable.dart";
import 'package:trapp/src/models/index.dart';

class DeliveryAddressModel extends Equatable {
  String? id;
  String? userId;
  String? building;
  String? howToReach;
  String? addressType;
  String? contactPhone;
  AddressModel? address;
  double? distance;

  DeliveryAddressModel({
    String? id,
    String? userId,
    String? building,
    String? howToReach,
    String? addressType,
    String? contactPhone,
    AddressModel? address,
    double? distance,
  }) {
    this.id = id ?? null;
    this.userId = userId ?? "";
    this.building = building ?? "";
    this.howToReach = howToReach ?? "";
    this.addressType = addressType ?? "";
    this.contactPhone = contactPhone ?? "";
    this.address = address ?? null;
    this.distance = distance ?? 0;
  }

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> map) {
    return DeliveryAddressModel(
      id: map["_id"] ?? null,
      userId: map["userId"] ?? "",
      building: map["building"] ?? "",
      howToReach: map["howToReach"] ?? "",
      addressType: map["addressType"] ?? "",
      contactPhone: map["contactPhone"] ?? "",
      address: map["address"] != null ? AddressModel.fromJson(map["address"]) : null,
      distance: map["distance"] != null ? double.parse(map["distance"].toString()) : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "userId": userId ?? "",
      "building": building ?? "",
      "howToReach": howToReach ?? "",
      "addressType": addressType ?? "",
      "contactPhone": contactPhone ?? "",
      "address": address != null ? address!.toJson() : null,
      "distance": distance ?? 0,
    };
  }

  factory DeliveryAddressModel.copy(DeliveryAddressModel model) {
    return DeliveryAddressModel(
      id: model.id,
      userId: model.userId,
      building: model.building,
      howToReach: model.howToReach,
      addressType: model.addressType,
      contactPhone: model.contactPhone,
      address: model.address != null ? AddressModel.copy(model.address!) : null,
      distance: model.distance,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        userId!,
        building!,
        howToReach!,
        addressType!,
        contactPhone!,
        address ?? Object(),
        distance!,
      ];

  @override
  bool get stringify => true;
}
