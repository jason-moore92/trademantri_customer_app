import 'dart:convert';

import "package:equatable/equatable.dart";

class UserModel extends Equatable {
  String? id;
  String? imageUrl;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? dob;
  String? password;
  Map<String, dynamic>? location;
  String? referralCode;
  String? referredBy;
  String? referredByUserId;
  String? appliedFor;
  bool? isNotifiable;
  bool? verified;
  bool? phoneVerified;
  String? role;
  List<dynamic>? extraRoles;
  int? loginAttempts;
  String? registeredVia;
  String? otp;
  String? otpExpires;
  List<dynamic>? status;
  String? createdAt;
  String? updatedAt;
  String? jwtToken;
  String? fcmToken;
  Map<String, dynamic>? freshChat;

  UserModel({
    this.id,
    this.role = "user",
    this.extraRoles = const [],
    this.verified = false,
    this.phoneVerified = false,
    this.loginAttempts = 0,
    this.registeredVia = "",
    this.imageUrl = "",
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.mobile = "",
    this.dob,
    this.password = "",
    this.location,
    this.referralCode = "",
    this.referredBy = "",
    this.referredByUserId = "",
    this.appliedFor = "",
    this.isNotifiable = true,
    this.otp = "",
    this.otpExpires = "",
    this.status,
    this.createdAt,
    this.updatedAt,
    this.jwtToken,
    this.fcmToken,
    this.freshChat,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map["_id"] ?? null,
      role: map["role"] ?? "user",
      extraRoles: map["extraRoles"] ?? [],
      verified: map["verified"] ?? false,
      phoneVerified: map["phoneVerified"] ?? false,
      loginAttempts: map["loginAttempts"] ?? 0,
      registeredVia: map["registeredVia"] ?? "",
      imageUrl: map["imageUrl"] ?? "",
      firstName: map["firstName"] ?? "",
      lastName: map["lastName"] ?? "",
      email: map["email"] ?? "",
      mobile: map["mobile"] ?? "",
      dob: map["dob"],
      password: map["password"] ?? "",
      location: map["location"],
      referralCode: map["referralCode"] ?? "",
      referredBy: map["referredBy"] ?? "",
      referredByUserId: map["referredByUserId"] ?? "",
      appliedFor: map["appliedFor"] ?? "",
      isNotifiable: map["isNotifiable"] ?? true,
      otp: map["otp"] ?? "",
      otpExpires: map["otpExpires"] ?? "",
      status: map["status"] ?? [],
      createdAt: map["createdAt"] ?? "",
      updatedAt: map["updatedAt"] ?? "",
      jwtToken: map["jwtToken"] ?? "",
      fcmToken: map["fcmToken"] ?? "",
      freshChat: map["freshChat"] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "role": role ?? "user",
      "extraRoles": extraRoles ?? [],
      "verified": verified ?? false,
      "phoneVerified": phoneVerified ?? false,
      "loginAttempts": loginAttempts ?? 0,
      "registeredVia": registeredVia ?? "",
      "imageUrl": imageUrl ?? "",
      "firstName": firstName ?? "",
      "lastName": lastName ?? "",
      "email": email ?? "",
      "mobile": mobile ?? "",
      "dob": dob,
      "password": password ?? "",
      "location": location,
      "referralCode": referralCode ?? "",
      "referredBy": referredBy ?? "",
      "referredByUserId": referredByUserId ?? "",
      "appliedFor": appliedFor ?? "",
      "isNotifiable": isNotifiable ?? true,
      "otp": otp ?? "",
      "otpExpires": otpExpires ?? "",
      "status": status ?? [],
      "createdAt": createdAt ?? "",
      "updatedAt": updatedAt ?? "",
      "jwtToken": jwtToken ?? "",
      "fcmToken": fcmToken ?? "",
      "freshChat": freshChat ?? "",
    };
  }

  factory UserModel.copy(UserModel userModel) {
    return UserModel(
      id: userModel.id,
      role: userModel.role,
      extraRoles: List.from(userModel.extraRoles!),
      verified: userModel.verified,
      phoneVerified: userModel.phoneVerified,
      loginAttempts: userModel.loginAttempts,
      registeredVia: userModel.registeredVia,
      imageUrl: userModel.imageUrl,
      firstName: userModel.firstName,
      lastName: userModel.lastName,
      email: userModel.email,
      mobile: userModel.mobile,
      dob: userModel.dob,
      password: userModel.password,
      location: userModel.location,
      referralCode: userModel.referralCode,
      referredBy: userModel.referredBy,
      referredByUserId: userModel.referredByUserId,
      appliedFor: userModel.appliedFor,
      isNotifiable: userModel.isNotifiable,
      otp: userModel.otp,
      otpExpires: userModel.otpExpires,
      status: List.from(userModel.status!),
      createdAt: userModel.createdAt,
      updatedAt: userModel.updatedAt,
      jwtToken: userModel.jwtToken,
      fcmToken: userModel.fcmToken,
      freshChat: json.decode(json.encode(userModel.freshChat!)),
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        role!,
        extraRoles!,
        verified!,
        phoneVerified!,
        loginAttempts!,
        registeredVia!,
        imageUrl!,
        firstName!,
        lastName!,
        email!,
        mobile!,
        dob ?? "",
        password!,
        // location!,
        referralCode!,
        referredBy!,
        referredByUserId!,
        appliedFor!,
        isNotifiable!,
        otp!,
        otpExpires!,
        status!,
        createdAt!,
        updatedAt!,
        jwtToken!,
        fcmToken!,
        freshChat!,
      ];

  @override
  bool get stringify => true;
}
