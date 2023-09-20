import 'dart:convert';

import "package:equatable/equatable.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trapp/src/models/index.dart';

//TODO:: remove referedBy column, already commented.
class StoreModel extends Equatable {
  String? id;
  String? businessType;
  String? name;
  String? description;
  String? type;
  String? subType;
  String? address;
  String? city;
  String? state;
  String? country;
  String? zipCode;
  String? mobile;
  String? gstIn;
  String? email;
  String? storetype;
  String? servicetype;
  bool? delivery;
  DeliveryInfo? deliveryInfo;
  LatLng? location;
  List<dynamic>? representatives;
  bool? enabled;
  String? note;
  String? connectedstoresstatus;
  Map<String, dynamic>? status;
  List<dynamic>? services;
  Map<String, dynamic>? requested;
  // String? referedBy;
  String? referredBy;
  String? referredByUserId;
  String? appliedFor;
  String? referralCode;
  Map<String, dynamic>? profile;
  String? businessPANnumber;
  String? fssaiLicense;
  Map<String, dynamic>? settings;
  String? stateCode;
  String? storeCode;
  double? distance;
  // BusinessConnectionModel? connectionModel;

  StoreModel({
    String? id,
    String? businessType,
    String? name,
    String? description,
    String? type,
    String? subType,
    String? address,
    String? city,
    String? state,
    String? country,
    String? zipCode,
    String? mobile,
    String? gstIn,
    String? email,
    String? storetype,
    String? servicetype,
    bool? delivery,
    DeliveryInfo? deliveryInfo,
    LatLng? location,
    List<dynamic>? representatives,
    bool? enabled,
    String? note,
    String? connectedstoresstatus,
    Map<String, dynamic>? status,
    List<dynamic>? services,
    Map<String, dynamic>? requested,
    // String? referedBy,
    String? referredBy,
    String? referredByUserId,
    String? appliedFor,
    String? referralCode,
    Map<String, dynamic>? profile,
    String? businessPANnumber,
    String? fssaiLicense,
    Map<String, dynamic>? settings,
    String? stateCode,
    String? storeCode,
    double? distance,
    // BusinessConnectionModel? connectionModel,
  }) {
    this.id = id ?? null;
    this.businessType = businessType ?? "";
    this.name = name ?? "";
    this.description = description ?? "";
    this.type = type ?? "";
    this.subType = subType ?? "";
    this.address = address ?? "";
    this.city = city ?? "";
    this.state = state ?? "";
    this.country = country ?? "India";
    this.zipCode = zipCode ?? null;
    this.mobile = mobile ?? null;
    this.gstIn = gstIn ?? null;
    this.email = email ?? null;
    this.storetype = storetype ?? null;
    this.servicetype = servicetype ?? null;
    this.delivery = delivery ?? false;
    this.deliveryInfo = deliveryInfo ?? null;
    this.location = location ?? null;
    this.representatives = representatives ?? [];
    this.enabled = enabled ?? false;
    this.note = note ?? null;
    this.connectedstoresstatus = connectedstoresstatus ?? null;
    this.status = status ?? null;
    this.services = services ?? [];
    this.requested = requested ?? null;
    // this.referedBy = referedBy ?? null;
    this.referredBy = referredBy ?? null;
    this.referredByUserId = referredByUserId ?? null;
    this.appliedFor = appliedFor ?? null;
    this.referralCode = referralCode ?? null;
    this.profile = profile ?? Map<String, dynamic>();
    this.businessPANnumber = businessPANnumber ?? null;
    this.fssaiLicense = fssaiLicense ?? null;
    this.settings = settings ?? null;
    this.stateCode = stateCode ?? "";
    this.storeCode = storeCode ?? "";
    this.distance = distance ?? 0.0;
    // this.connectionModel = connectionModel ?? null;
  }

  factory StoreModel.fromJson(Map<String, dynamic> map) {
    DeliveryInfo? deliveryInfo;
    if (map["deliveryInfo"] != null) {
      deliveryInfo = DeliveryInfo.fromJson(map["deliveryInfo"]);
      if (deliveryInfo.deliveryDistance == "" && map["deliverydistance"] != null) {
        deliveryInfo.deliveryDistance = map["deliverydistance"];
      }
    }

    /// deliveryInfo init setting
    if (map["deliveryInfo"] == null) {
      deliveryInfo = DeliveryInfo.fromJson({
        "mode":
            map["delivery"] == true && map["deliverydistance"] != null && map["deliverydistance"] != "" ? "DELIVERY_BY_OWN" : "NO_DELIVERY_CHOICE",
        "deliveryDistance": map["delivery"] == true ? map["deliverydistance"] : "",
        "minAmountForFreeDelivery": "",
      });
    }

    return StoreModel(
      id: map["_id"] ?? null,
      businessType: map["businessType"] ?? "",
      name: map["name"] ?? "",
      description: map["description"] ?? "",
      type: map["type"] ?? "",
      subType: map["subType"] ?? "",
      address: map["address"] ?? "",
      city: map["city"] ?? "",
      state: map["state"] ?? "",
      country: map["country"] ?? "India",
      zipCode: map["zipCode"] ?? null,
      mobile: map["mobile"] ?? "",
      gstIn: map["gstIn"] ?? null,
      email: map["email"] ?? null,
      storetype: map["storetype"] ?? null,
      servicetype: map["servicetype"] ?? null,
      delivery: map["delivery"] ?? false,
      deliveryInfo: deliveryInfo,
      location: map["location"] != null ? LatLng(map["location"]["coordinates"][1], map["location"]["coordinates"][0]) : null,
      representatives: map["representatives"] ?? [],
      enabled: map["enabled"] ?? false,
      note: map["note"] ?? null,
      connectedstoresstatus: map["connectedstoresstatus"] ?? null,
      status: map["status"] ?? null,
      services: map["services"] ?? [],
      requested: map["requested"] ?? null,
      // referedBy: map["referedBy"] ?? null,
      referredBy: map["referredBy"] ?? null,
      referredByUserId: map["referredByUserId"] ?? null,
      appliedFor: map["appliedFor"] ?? null,
      referralCode: map["referralCode"] ?? null,
      profile: map["profile"] ?? Map<String, dynamic>(),
      businessPANnumber: map["businessPANnumber"] ?? null,
      fssaiLicense: map["fssaiLicense"] ?? null,
      settings: map["settings"] ?? null,
      stateCode: map["stateCode"] ?? "",
      storeCode: map["cistoreCodety"] ?? "",
      distance: map["distance"] != null ? double.parse(map["distance"].toString()) : 0.0,
      // connectionModel: map["connectionModel"] != null ? BusinessConnectionModel.fromJson(map["connectionModel"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "businessType": businessType ?? "",
      "name": name ?? "",
      "description": description ?? "",
      "type": type ?? "",
      "subType": subType ?? "",
      "address": address ?? "",
      "city": city ?? "",
      "state": state ?? "",
      "country": country ?? "India",
      "zipCode": zipCode ?? null,
      "mobile": mobile ?? "",
      "gstIn": gstIn ?? null,
      "email": email ?? null,
      "storetype": storetype ?? null,
      "servicetype": servicetype ?? null,
      "delivery": delivery ?? false,
      "deliveryInfo": deliveryInfo != null ? deliveryInfo!.toJson() : Map<String, dynamic>(),
      "location": location != null
          ? {
              "type": "Point",
              "coordinates": [location!.longitude, location!.latitude]
            }
          : null,
      "representatives": representatives ?? [],
      "enabled": enabled ?? false,
      "note": note ?? null,
      "connectedstoresstatus": connectedstoresstatus ?? null,
      "status": status ?? null,
      "services": services ?? [],
      "requested": requested ?? null,
      // "referedBy": referedBy ?? null,
      "referredBy": referredBy ?? null,
      "referredByUserId": referredByUserId ?? null,
      "appliedFor": appliedFor ?? null,
      "referralCode": referralCode ?? null,
      "profile": profile ?? Map<String, dynamic>(),
      "businessPANnumber": businessPANnumber ?? null,
      "fssaiLicense": fssaiLicense ?? null,
      "settings": settings ?? null,
      "stateCode": stateCode ?? "",
      "storeCode": storeCode ?? "",
      "distance": distance ?? 0.0,

      //Temp:: for server purpose
      "ownerFirstName": profile!["ownerInfo"] != null ? profile!["ownerInfo"]["firstName"] : null,
      "ownerLastName": profile!["ownerInfo"] != null ? profile!["ownerInfo"]["lastName"] : null,
      "latitude": location != null ? location!.latitude : null,
      "longitude": location != null ? location!.longitude : null,
      "iAgree": true,
      // "connectionModel": connectionModel != null ? connectionModel!.toJson() : null,
    };
  }

  factory StoreModel.copy(StoreModel model) {
    return StoreModel(
      id: model.id,
      businessType: model.businessType,
      name: model.name,
      description: model.description,
      type: model.type,
      subType: model.subType,
      address: model.address,
      city: model.city,
      state: model.state,
      country: model.country,
      zipCode: model.zipCode,
      mobile: model.mobile,
      gstIn: model.gstIn,
      email: model.email,
      storetype: model.storetype,
      servicetype: model.servicetype,
      delivery: model.delivery,
      deliveryInfo: model.deliveryInfo != null ? DeliveryInfo.copy(model.deliveryInfo!) : null,
      location: model.location != null ? LatLng.fromJson(model.location!.toJson()) : null,
      representatives: List.from(model.representatives!),
      enabled: model.enabled,
      note: model.note,
      connectedstoresstatus: model.connectedstoresstatus,
      status: model.status != null ? json.decode(json.encode(model.status!)) : null,
      services: model.services,
      requested: model.requested != null ? json.decode(json.encode(model.requested!)) : null,
      // referedBy: model.referedBy,
      referredBy: model.referredBy,
      referredByUserId: model.referredByUserId,
      appliedFor: model.appliedFor,
      referralCode: model.referralCode,
      profile: json.decode(json.encode(model.profile!)),
      businessPANnumber: model.businessPANnumber,
      fssaiLicense: model.fssaiLicense,
      settings: model.settings != null ? json.decode(json.encode(model.settings!)) : null,
      stateCode: model.stateCode,
      storeCode: model.storeCode,
      distance: model.distance,
      // connectionModel: model.connectionModel,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        businessType!,
        name!,
        description!,
        type!,
        subType!,
        address!,
        city!,
        state!,
        country!,
        zipCode ?? Object(),
        mobile ?? Object(),
        gstIn ?? Object(),
        email ?? Object(),
        storetype ?? Object(),
        servicetype ?? Object(),
        delivery ?? Object(),
        deliveryInfo ?? Object(),
        location ?? Object(),
        representatives!,
        enabled!,
        note ?? Object(),
        connectedstoresstatus ?? Object(),
        status ?? Object(),
        services!,
        requested ?? Object(),
        // referedBy ?? Object(),
        referredBy ?? Object(),
        referredByUserId ?? Object(),
        appliedFor ?? Object(),
        referralCode ?? Object(),
        profile!,
        businessPANnumber ?? Object(),
        fssaiLicense ?? Object(),
        settings ?? Object(),
        stateCode!,
        storeCode!,
        distance!,
        // connectionModel!,
      ];

  @override
  bool get stringify => true;
}

class DeliveryInfo extends Equatable {
  String? mode;
  double? deliveryDistance;
  String? deliveryPartnerId;
  Map<String, dynamic>? deliveryPartner;
  double? minAmountForDelivery;
  double? minAmountForFreeDelivery;
  List<dynamic>? chargesForDeliveryOwn;

  DeliveryInfo({
    mode,
    deliveryDistance,
    deliveryPartnerId,
    deliveryPartner,
    minAmountForDelivery,
    minAmountForFreeDelivery,
    chargesForDeliveryOwn,
  }) {
    this.mode = mode ?? "";
    this.deliveryDistance = deliveryDistance ?? 0.0;
    this.deliveryPartnerId = deliveryPartnerId ?? "";
    this.deliveryPartner = deliveryPartner ?? null;
    this.minAmountForDelivery = minAmountForDelivery ?? 0.0;
    this.minAmountForFreeDelivery = minAmountForFreeDelivery ?? 0.0;
    this.chargesForDeliveryOwn = chargesForDeliveryOwn ?? [];
  }

  factory DeliveryInfo.fromJson(Map<String, dynamic> map) {
    return DeliveryInfo(
      mode: map["mode"] ?? "",
      deliveryDistance: map["deliveryDistance"] != null && map["deliveryDistance"] != "" ? double.parse(map["deliveryDistance"].toString()) : 0.0,
      deliveryPartnerId: map["deliveryPartnerId"] ?? "",
      deliveryPartner: map["deliveryPartner"] ?? Map<String, dynamic>(),
      minAmountForDelivery:
          map["minAmountForDelivery"] != null && map["minAmountForDelivery"] != "" ? double.parse(map["minAmountForDelivery"].toString()) : 0.0,
      minAmountForFreeDelivery: map["minAmountForFreeDelivery"] != null && map["minAmountForFreeDelivery"] != ""
          ? double.parse(map["minAmountForFreeDelivery"].toString())
          : 0.0,
      chargesForDeliveryOwn: map["chargesForDeliveryOwn"] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "mode": mode ?? "",
      "deliveryDistance": deliveryDistance ?? 0.0,
      "deliveryPartnerId": deliveryPartnerId ?? "",
      "deliveryPartner": deliveryPartner ?? Map<String, dynamic>(),
      "minAmountForDelivery": minAmountForDelivery ?? 0.0,
      "minAmountForFreeDelivery": minAmountForFreeDelivery ?? 0.0,
      "chargesForDeliveryOwn": chargesForDeliveryOwn ?? [],
    };
  }

  factory DeliveryInfo.copy(DeliveryInfo model) {
    return DeliveryInfo(
      mode: model.mode,
      deliveryDistance: model.deliveryDistance,
      deliveryPartnerId: model.deliveryPartnerId,
      deliveryPartner: json.decode(json.encode(model.deliveryPartner)),
      minAmountForDelivery: model.minAmountForDelivery,
      minAmountForFreeDelivery: model.minAmountForFreeDelivery,
      chargesForDeliveryOwn: List.generate(
        model.chargesForDeliveryOwn!.length,
        (index) => json.decode(json.encode(model.chargesForDeliveryOwn![index])),
      ),
    );
  }

  @override
  List<Object> get props => [
        mode!,
        deliveryDistance!,
        deliveryPartnerId!,
        deliveryPartner!,
        minAmountForDelivery!,
        minAmountForFreeDelivery!,
        chargesForDeliveryOwn!,
      ];

  @override
  bool get stringify => true;
}
