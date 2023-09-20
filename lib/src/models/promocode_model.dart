import "package:equatable/equatable.dart";

class PromocodeModel extends Equatable {
  String? id;
  String? name;
  String? promocodeCode;
  String? description;
  double? promocodeValue;
  String? promocodeType;
  int? noOfTimesAppliedByUser;
  int? noOfTimesCanApply;
  int? orderNumberAppliedTo;
  DateTime? validityStartDate;
  DateTime? validityEndDate;
  String? termscondition;
  double? minimumorder;
  double? maximumDiscount;
  List<dynamic>? categoriesAppliedFor;
  List<dynamic>? images;
  List<dynamic>? loadedImages;
  List<dynamic>? userIds;
  List<dynamic>? storeIds;

  PromocodeModel({
    String? id,
    String? name,
    String? promocodeCode,
    String? description,
    double? promocodeValue,
    String? promocodeType,
    int? noOfTimesAppliedByUser,
    int? noOfTimesCanApply,
    int? orderNumberAppliedTo,
    DateTime? validityStartDate,
    DateTime? validityEndDate,
    String? termscondition,
    double? minimumorder,
    double? maximumDiscount,
    List<dynamic>? categoriesAppliedFor,
    List<dynamic>? images,
    List<dynamic>? loadedImages,
    List<dynamic>? userIds,
    List<dynamic>? storeIds,
  }) {
    this.id = id ?? null;
    this.name = name ?? "";
    this.promocodeCode = promocodeCode ?? "";
    this.description = description ?? "";
    this.promocodeValue = promocodeValue ?? 0;
    this.promocodeType = promocodeType ?? "";
    this.noOfTimesAppliedByUser = noOfTimesAppliedByUser ?? null;
    this.noOfTimesCanApply = noOfTimesCanApply ?? null;
    this.orderNumberAppliedTo = orderNumberAppliedTo ?? null;
    this.validityStartDate = validityStartDate ?? null;
    this.validityEndDate = validityEndDate ?? null;
    this.termscondition = termscondition ?? "";
    this.minimumorder = minimumorder ?? null;
    this.maximumDiscount = maximumDiscount ?? null;
    this.categoriesAppliedFor = categoriesAppliedFor ?? [];
    this.images = images ?? [];
    this.loadedImages = loadedImages ?? [];
    this.userIds = userIds ?? [];
    this.storeIds = storeIds ?? [];
  }

  factory PromocodeModel.fromJson(Map<String, dynamic> map) {
    return PromocodeModel(
      id: map["_id"] ?? null,
      name: map["name"] ?? "",
      promocodeCode: map["promocodeCode"] ?? "",
      description: map["description"] ?? "",
      promocodeValue: map["promocodeValue"] != null ? double.parse(map["promocodeValue"].toString()) : 0,
      promocodeType: map["promocodeType"] ?? "",
      noOfTimesAppliedByUser: map["noOfTimesAppliedByUser"] != null ? int.parse(map["noOfTimesAppliedByUser"].toString()) : null,
      noOfTimesCanApply: map["noOfTimesCanApply"] != null ? int.parse(map["noOfTimesCanApply"].toString()) : null,
      orderNumberAppliedTo: map["orderNumberAppliedTo"] != null ? int.parse(map["orderNumberAppliedTo"].toString()) : null,
      validityStartDate: map["validityStartDate"] != null ? DateTime.tryParse(map["validityStartDate"])!.toLocal() : null,
      validityEndDate: map["validityEndDate"] != null ? DateTime.tryParse(map["validityEndDate"])!.toLocal() : null,
      termscondition: map["termscondition"] ?? "",
      minimumorder: map["minimumorder"] != null ? double.parse(map["minimumorder"].toString()) : null,
      maximumDiscount: map["maximumDiscount"] != null ? double.parse(map["maximumDiscount"].toString()) : null,
      categoriesAppliedFor: map["categoriesAppliedFor"] ?? [],
      images: map["images"] ?? [],
      loadedImages: map["loadedImages"] ?? [],
      userIds: map["userIds"] ?? [],
      storeIds: map["storeIds"] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "name": name ?? "",
      "promocodeCode": promocodeCode ?? "",
      "description": description ?? "",
      "promocodeValue": promocodeValue ?? 0,
      "promocodeType": promocodeType ?? "",
      "noOfTimesAppliedByUser": noOfTimesAppliedByUser ?? null,
      "noOfTimesCanApply": noOfTimesCanApply ?? null,
      "orderNumberAppliedTo": orderNumberAppliedTo ?? null,
      "validityStartDate": validityStartDate != null ? validityStartDate!.toUtc().toIso8601String() : null,
      "validityEndDate": validityEndDate != null ? validityEndDate!.toUtc().toIso8601String() : null,
      "termscondition": termscondition ?? "",
      "minimumorder": minimumorder ?? null,
      "maximumDiscount": maximumDiscount ?? null,
      "categoriesAppliedFor": categoriesAppliedFor ?? [],
      "images": images ?? [],
      "loadedImages": loadedImages ?? [],
      "userIds": userIds ?? [],
      "storeIds": storeIds ?? [],
    };
  }

  factory PromocodeModel.copy(PromocodeModel model) {
    return PromocodeModel(
      id: model.id,
      name: model.name,
      promocodeCode: model.promocodeCode,
      description: model.description,
      promocodeValue: model.promocodeValue,
      promocodeType: model.promocodeType,
      noOfTimesAppliedByUser: model.noOfTimesAppliedByUser,
      noOfTimesCanApply: model.noOfTimesCanApply,
      orderNumberAppliedTo: model.orderNumberAppliedTo,
      validityStartDate: model.validityStartDate,
      validityEndDate: model.validityEndDate,
      termscondition: model.termscondition,
      minimumorder: model.minimumorder,
      maximumDiscount: model.maximumDiscount,
      categoriesAppliedFor: List.from(model.categoriesAppliedFor!),
      images: List.from(model.images!),
      loadedImages: List.from(model.loadedImages!),
      userIds: List.from(model.userIds!),
      storeIds: List.from(model.storeIds!),
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        name!,
        promocodeCode!,
        description!,
        promocodeValue!,
        promocodeType!,
        noOfTimesAppliedByUser ?? Object(),
        noOfTimesCanApply ?? Object(),
        orderNumberAppliedTo ?? Object(),
        validityStartDate ?? Object(),
        validityEndDate ?? Object(),
        termscondition!,
        minimumorder!,
        maximumDiscount!,
        categoriesAppliedFor!,
        images!,
        loadedImages!,
        userIds!,
        storeIds!,
      ];

  @override
  bool get stringify => true;
}
