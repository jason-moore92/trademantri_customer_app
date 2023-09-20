import 'dart:convert';
import 'dart:io';

import "package:equatable/equatable.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoreJobPostModel extends Equatable {
  String? id;
  String? storeId;
  String? jobTitle;
  String? description;
  int? peopleNumber;
  int? minYearExperience;
  String? jobType;
  DateTime? startDate;
  DateTime? endDate;
  double? salaryFrom;
  double? salaryTo;
  String? salaryType;
  String? benefits;
  bool? listonline;
  LatLng? location;
  String? status;
  List<dynamic>? skills;

  StoreJobPostModel({
    String? id,
    String? storeId,
    String? jobTitle,
    String? description,
    int? peopleNumber,
    int? minYearExperience,
    String? jobType,
    DateTime? startDate,
    DateTime? endDate,
    double? salaryFrom,
    double? salaryTo,
    String? salaryType,
    String? benefits,
    bool? listonline,
    LatLng? location,
    String? status,
    List<dynamic>? skills,
  }) {
    this.id = id ?? null;
    this.storeId = storeId ?? "";
    this.jobTitle = jobTitle ?? "";
    this.description = description ?? "";
    this.peopleNumber = peopleNumber ?? 1;
    this.minYearExperience = minYearExperience ?? 0;
    this.jobType = jobType ?? "";
    this.startDate = startDate ?? null;
    this.endDate = endDate ?? null;
    this.salaryFrom = salaryFrom ?? 0;
    this.salaryTo = salaryTo ?? 0;
    this.salaryType = salaryType ?? "";
    this.benefits = benefits ?? "";
    this.listonline = listonline ?? true;
    this.location = location ?? null;
    this.status = status ?? "";
    this.skills = skills ?? [];
  }

  factory StoreJobPostModel.fromJson(Map<String, dynamic> map) {
    return StoreJobPostModel(
      id: map["_id"] ?? null,
      storeId: map["storeId"] ?? "",
      jobTitle: map["jobTitle"] ?? "",
      description: map["description"] ?? "",
      peopleNumber: map["peopleNumber"] != null ? double.parse(map["peopleNumber"].toString()).toInt() : 0,
      minYearExperience: map["minYearExperience"] != null ? double.parse(map["minYearExperience"].toString()).toInt() : 0,
      jobType: map["jobType"] ?? "",
      startDate: map["startDate"] != null ? DateTime.tryParse(map["startDate"])!.toLocal() : null,
      endDate: map["endDate"] != null ? DateTime.tryParse(map["endDate"])!.toLocal() : null,
      salaryFrom: map["salaryFrom"] != null ? double.parse(map["salaryFrom"].toString()) : 0,
      salaryTo: map["salaryTo"] != null ? double.parse(map["salaryTo"].toString()) : 0,
      salaryType: map["salaryType"] ?? "",
      benefits: map["benefits"] ?? "",
      listonline: map["listonline"] ?? true,
      location: map["location"] != null ? LatLng(map["location"]["coordinates"][1], map["location"]["coordinates"][0]) : null,
      status: map["status"] ?? "",
      skills: map["skills"] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "storeId": storeId ?? "",
      "jobTitle": jobTitle ?? "",
      "description": description ?? "",
      "peopleNumber": peopleNumber ?? 0,
      "minYearExperience": minYearExperience ?? 0,
      "jobType": jobType ?? "",
      "startDate": startDate != null ? startDate!.toUtc().toIso8601String() : null,
      "endDate": endDate != null ? endDate!.toUtc().toIso8601String() : null,
      "salaryFrom": salaryFrom ?? 0,
      "salaryTo": salaryTo ?? 0,
      "salaryType": salaryType ?? "",
      "benefits": benefits ?? "",
      "listonline": listonline ?? true,
      "location": location != null
          ? {
              "type": "Point",
              "coordinates": [location!.longitude, location!.latitude]
            }
          : null,
      "status": status ?? "",
      "skills": skills ?? [],
    };
  }

  factory StoreJobPostModel.copy(StoreJobPostModel model) {
    return StoreJobPostModel(
      id: model.id,
      storeId: model.storeId,
      jobTitle: model.jobTitle,
      description: model.description,
      peopleNumber: model.peopleNumber,
      minYearExperience: model.minYearExperience,
      jobType: model.jobType,
      startDate: model.startDate,
      endDate: model.endDate,
      salaryFrom: model.salaryFrom,
      salaryTo: model.salaryTo,
      salaryType: model.salaryType,
      benefits: model.benefits,
      listonline: model.listonline,
      location: LatLng.fromJson(model.location!.toJson()),
      status: model.status,
      skills: List.from(model.skills!),
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        storeId!,
        jobTitle!,
        description!,
        peopleNumber!,
        minYearExperience!,
        jobType!,
        startDate!,
        endDate!,
        salaryFrom!,
        salaryTo!,
        salaryType!,
        benefits!,
        listonline!,
        location!,
        status!,
        skills!,
      ];

  @override
  bool get stringify => true;
}
