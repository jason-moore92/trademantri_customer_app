import "package:equatable/equatable.dart";

import 'index.dart';

class WeekModel extends Equatable {
  bool? open;
  bool? haveBreak;
  String? fromtime;
  String? totime;
  String? breakfromtime;
  String? breaktotime;

  WeekModel({
    bool? open,
    bool? haveBreak,
    String? fromtime,
    String? totime,
    String? breakfromtime,
    String? breaktotime,
  }) {
    this.open = open ?? false;
    this.haveBreak = haveBreak ?? false;
    this.fromtime = fromtime ?? "";
    this.totime = totime ?? "";
    this.breakfromtime = breakfromtime ?? "";
    this.breaktotime = breaktotime ?? "";
  }

  factory WeekModel.fromJson(Map<String, dynamic> map) {
    return WeekModel(
      open: map["open"] ?? false,
      haveBreak: map["haveBreak"] != null
          ? map["haveBreak"]
          : map["breakfromtime"] != "" && map["breaktotime"] != ""
              ? true
              : false,
      fromtime: map["fromtime"] ?? "",
      totime: map["totime"] ?? "",
      breakfromtime: map["breakfromtime"] ?? "",
      breaktotime: map["breaktotime"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "open": open ?? false,
      "haveBreak": haveBreak ?? false,
      "fromtime": fromtime ?? "",
      "totime": totime ?? "",
      "breakfromtime": breakfromtime ?? "",
      "breaktotime": breaktotime ?? "",
    };
  }

  factory WeekModel.copy(WeekModel model) {
    return WeekModel(
      open: model.open,
      haveBreak: model.haveBreak,
      fromtime: model.fromtime,
      totime: model.totime,
      breakfromtime: model.breakfromtime,
      breaktotime: model.breaktotime,
    );
  }

  @override
  List<Object> get props => [
        haveBreak!,
        open!,
        fromtime!,
        totime!,
        breakfromtime!,
        breaktotime!,
      ];

  @override
  bool get stringify => true;
}

class AppointmentModel extends Equatable {
  String? id;
  String? name;
  String? description;
  String? timeslot;
  String? storeId;
  StoreModel? storeModel;
  String? usersperslot;
  int? maxNumOfGuestsPerTimeSlot;
  bool? eventenable;
  bool? autoAccept;
  bool? active;
  bool? wholeday;
  String? address;
  bool? storeAddress;
  bool? isDeleted;
  WeekModel? sunday;
  WeekModel? monday;
  WeekModel? tuesday;
  WeekModel? wednesday;
  WeekModel? thursday;
  WeekModel? friday;
  WeekModel? saturday;
  DateTime? startDate;
  DateTime? endDate;
  String? image;

  AppointmentModel({
    String? id,
    String? name,
    String? description,
    String? timeslot,
    String? storeId,
    StoreModel? storeModel,
    String? usersperslot,
    int? maxNumOfGuestsPerTimeSlot,
    bool? eventenable,
    bool? autoAccept,
    bool? active,
    bool? wholeday,
    String? address,
    bool? storeAddress,
    bool? isDeleted,
    WeekModel? sunday,
    WeekModel? monday,
    WeekModel? tuesday,
    WeekModel? wednesday,
    WeekModel? thursday,
    WeekModel? friday,
    WeekModel? saturday,
    DateTime? startDate,
    DateTime? endDate,
    String? image,
  }) {
    this.id = id ?? null;
    this.name = name ?? "";
    this.description = description ?? "";
    this.timeslot = timeslot ?? "";
    this.storeId = storeId ?? null;
    this.storeModel = storeModel ?? null;
    this.usersperslot = usersperslot ?? "unlimited";
    this.maxNumOfGuestsPerTimeSlot = maxNumOfGuestsPerTimeSlot ?? 1;
    this.eventenable = eventenable ?? true;
    this.autoAccept = autoAccept ?? true;
    this.active = active ?? true;
    this.wholeday = wholeday ?? false;
    this.address = address ?? "";
    this.storeAddress = storeAddress ?? true;
    this.isDeleted = isDeleted ?? false;
    this.sunday = sunday ?? WeekModel();
    this.monday = monday ?? WeekModel();
    this.tuesday = tuesday ?? WeekModel();
    this.wednesday = wednesday ?? WeekModel();
    this.thursday = thursday ?? WeekModel();
    this.friday = friday ?? WeekModel();
    this.saturday = saturday ?? WeekModel();
    this.startDate = startDate ?? null;
    this.endDate = endDate ?? null;
    this.image = image ?? "";
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map["_id"] ?? null,
      name: map["name"] ?? "",
      description: map["description"] ?? "",
      timeslot: map["timeslot"] ?? "",
      storeId: map["storeId"] ?? null,
      storeModel: map["store"] != null ? StoreModel.fromJson(map["store"]) : null,
      usersperslot: map["usersperslot"] ?? "unlimited",
      maxNumOfGuestsPerTimeSlot: map["maxNumOfGuestsPerTimeSlot"] != null ? int.parse(map["maxNumOfGuestsPerTimeSlot"].toString()) : 1,
      eventenable: map["eventenable"] ?? true,
      autoAccept: map["autoAccept"] ?? true,
      active: map["active"] ?? true,
      wholeday: map["wholeday"] ?? false,
      address: map["address"] ?? "",
      storeAddress: map["storeAddress"] ?? true,
      isDeleted: map["isDeleted"] ?? false,
      sunday: map["sunday"] != null ? WeekModel.fromJson(map["sunday"]) : WeekModel(),
      monday: map["monday"] != null ? WeekModel.fromJson(map["monday"]) : WeekModel(),
      tuesday: map["tuesday"] != null ? WeekModel.fromJson(map["tuesday"]) : WeekModel(),
      wednesday: map["wednesday"] != null ? WeekModel.fromJson(map["wednesday"]) : WeekModel(),
      thursday: map["thursday"] != null ? WeekModel.fromJson(map["thursday"]) : WeekModel(),
      friday: map["friday"] != null ? WeekModel.fromJson(map["friday"]) : WeekModel(),
      saturday: map["saturday"] != null ? WeekModel.fromJson(map["saturday"]) : WeekModel(),
      startDate: map["startDate"] != null ? DateTime.tryParse(map["startDate"])!.toLocal() : null,
      endDate: map["endDate"] != null ? DateTime.tryParse(map["endDate"])!.toLocal() : null,
      image: map["image"] ?? "",
    );
  }

  Map<String, dynamic> toJsonForAdd() {
    return {
      "_id": id ?? null,
      "details": {
        "name": name ?? "",
        "description": description ?? "",
        "timeslot": timeslot ?? "",
        "store": storeModel != null ? storeModel!.toJson() : null,
        "storeId": storeId ?? (storeModel != null ? storeModel!.id : null),
        "usersperslot": usersperslot ?? "unlimited",
        "maxNumOfGuestsPerTimeSlot": maxNumOfGuestsPerTimeSlot ?? 1,
        "eventenable": eventenable ?? true,
        "autoAccept": autoAccept ?? true,
        "active": active ?? true,
        "wholeday": wholeday ?? false,
        "address": address ?? "",
        "storeAddress": storeAddress ?? true,
        "isDeleted": isDeleted ?? false,
        "startDate": startDate != null ? startDate!.toUtc().toIso8601String() : null,
        "endDate": endDate != null ? endDate!.toUtc().toIso8601String() : null,
        "image": image ?? "",
      },
      "sunday": sunday!.toJson(),
      "monday": monday!.toJson(),
      "tuesday": tuesday!.toJson(),
      "wednesday": wednesday!.toJson(),
      "thursday": thursday ?? WeekModel(),
      "friday": friday ?? WeekModel(),
      "saturday": saturday ?? WeekModel(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "name": name ?? "",
      "description": description ?? "",
      "timeslot": timeslot ?? "",
      "store": storeModel != null ? storeModel!.toJson() : null,
      "storeId": storeId ?? (storeModel != null ? storeModel!.id : null),
      "usersperslot": usersperslot ?? "unlimited",
      "maxNumOfGuestsPerTimeSlot": maxNumOfGuestsPerTimeSlot ?? 1,
      "eventenable": eventenable ?? true,
      "autoAccept": autoAccept ?? true,
      "active": active ?? true,
      "wholeday": wholeday ?? false,
      "address": address ?? "",
      "storeAddress": storeAddress ?? true,
      "isDeleted": isDeleted ?? false,
      "startDate": startDate != null ? startDate!.toUtc().toIso8601String() : null,
      "endDate": endDate != null ? endDate!.toUtc().toIso8601String() : null,
      "sunday": sunday!.toJson(),
      "monday": monday!.toJson(),
      "tuesday": tuesday!.toJson(),
      "wednesday": wednesday!.toJson(),
      "thursday": thursday!.toJson(),
      "friday": friday!.toJson(),
      "saturday": saturday!.toJson(),
      "image": image ?? "",
    };
  }

  factory AppointmentModel.copy(AppointmentModel model) {
    return AppointmentModel(
      id: model.id,
      name: model.name,
      description: model.description,
      timeslot: model.timeslot,
      storeId: model.storeId,
      storeModel: model.storeModel != null ? StoreModel.copy(model.storeModel!) : null,
      usersperslot: model.usersperslot,
      maxNumOfGuestsPerTimeSlot: model.maxNumOfGuestsPerTimeSlot,
      eventenable: model.eventenable,
      autoAccept: model.autoAccept,
      active: model.active,
      wholeday: model.wholeday,
      address: model.address,
      storeAddress: model.storeAddress,
      isDeleted: model.isDeleted,
      sunday: model.sunday,
      monday: model.monday,
      tuesday: model.tuesday,
      wednesday: model.wednesday,
      thursday: model.thursday,
      friday: model.friday,
      saturday: model.saturday,
      startDate: model.startDate,
      endDate: model.endDate,
      image: model.image,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        name!,
        description!,
        timeslot!,
        storeId!,
        storeModel ?? Object(),
        usersperslot!,
        maxNumOfGuestsPerTimeSlot!,
        eventenable!,
        autoAccept!,
        active!,
        wholeday!,
        address!,
        storeAddress!,
        isDeleted!,
        sunday!,
        monday!,
        tuesday!,
        wednesday!,
        thursday!,
        friday!,
        saturday!,
        startDate ?? Object(),
        endDate ?? Object(),
        image!,
      ];

  @override
  bool get stringify => true;
}
