import "package:equatable/equatable.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressModel extends Equatable {
  String? placeId;
  String? name;
  String? address;
  String? city;
  String? state;
  String? zipCode;
  String? countryCode;
  LatLng? location;

  AddressModel({
    String? placeId,
    String? name,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? countryCode,
    LatLng? location,
  }) {
    this.placeId = placeId ?? "";
    this.name = name ?? "";
    this.address = address ?? "";
    this.city = city ?? "";
    this.state = state ?? "";
    this.zipCode = zipCode ?? "";
    this.countryCode = countryCode ?? "";
    this.location = location ?? null;
  }

  factory AddressModel.fromJson(Map<String, dynamic> map) {
    return AddressModel(
      placeId: map["placeId"] ?? "",
      name: map["name"] ?? "",
      address: map["address"] ?? "",
      city: map["city"] ?? "",
      state: map["state"] ?? "",
      zipCode: map["zipCode"] ?? "",
      countryCode: map["countryCode"] ?? "",
      location: map["location"] != null ? LatLng(map["location"]["lat"], map["location"]["lng"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "placeId": placeId ?? "",
      "name": name ?? "",
      "address": address ?? "",
      "city": city ?? "",
      "state": state ?? "",
      "zipCode": zipCode ?? "",
      "countryCode": countryCode ?? "",
      "location": location != null ? {"lat": location!.latitude, "lng": location!.longitude} : null,
    };
  }

  factory AddressModel.copy(AddressModel model) {
    return AddressModel(
      placeId: model.placeId,
      name: model.name,
      address: model.address,
      city: model.city,
      state: model.state,
      zipCode: model.zipCode,
      countryCode: model.countryCode,
      location: model.location != null ? LatLng.fromJson(model.location!.toJson()) : null,
    );
  }

  @override
  List<Object> get props => [
        placeId!,
        name!,
        address!,
        city!,
        state!,
        zipCode!,
        countryCode!,
        location ?? Object(),
      ];

  @override
  bool get stringify => true;
}
