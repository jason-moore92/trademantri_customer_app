import "package:equatable/equatable.dart";

import 'index.dart';

class BookAppointmentModel extends Equatable {
  String? id;
  String? bookingNumber;
  String? appointmentId;
  AppointmentModel? appointmentModel;
  String? storeId;
  StoreModel? storeModel;
  String? userId;
  UserModel? userModel;
  DateTime? dateTime;
  String? date;
  String? starttime;
  String? endtime;
  String? slottime;
  String? name;
  String? mobile;
  String? email;
  String? status;
  String? comments;
  String? commentForCancelled;
  String? commentForRejected;
  int? noOfGuests;

  BookAppointmentModel({
    String? id,
    String? bookingNumber,
    String? appointmentId,
    AppointmentModel? appointmentModel,
    String? storeId,
    StoreModel? storeModel,
    String? userId,
    UserModel? userModel,
    DateTime? dateTime,
    String? date,
    String? starttime,
    String? endtime,
    String? slottime,
    String? name,
    String? mobile,
    String? email,
    String? status,
    String? comments,
    String? commentForCancelled,
    String? commentForRejected,
    int? noOfGuests,
  }) {
    this.id = id ?? null;
    this.bookingNumber = bookingNumber ?? "";
    this.appointmentId = appointmentId ?? "";
    this.appointmentModel = appointmentModel ?? null;
    this.storeId = storeId ?? null;
    this.storeModel = storeModel ?? null;
    this.userId = userId ?? null;
    this.userModel = userModel ?? null;
    this.dateTime = dateTime ?? null;
    this.date = date ?? null;
    this.starttime = starttime ?? "";
    this.endtime = endtime ?? "";
    this.slottime = slottime ?? "";
    this.name = name ?? "";
    this.mobile = mobile ?? "";
    this.email = email ?? "";
    this.status = status ?? "created";
    this.comments = comments ?? "";
    this.commentForCancelled = commentForCancelled ?? "";
    this.commentForRejected = commentForRejected ?? "";
    this.noOfGuests = noOfGuests ?? 1;
  }

  factory BookAppointmentModel.fromJson(Map<String, dynamic> map) {
    return BookAppointmentModel(
      id: map["_id"] ?? null,
      bookingNumber: map["bookingNumber"] ?? "",
      appointmentId: map["appointmentId"] ?? "",
      appointmentModel: map["appointment"] != null ? AppointmentModel.fromJson(map["appointment"]) : null,
      storeId: map["storeId"] ?? null,
      storeModel: map["store"] != null ? StoreModel.fromJson(map["store"]) : null,
      userId: map["userId"] ?? null,
      userModel: map["user"] != null ? UserModel.fromJson(map["user"]) : null,
      dateTime: map["dateTime"] != null ? DateTime.tryParse(map["dateTime"])!.toLocal() : null,
      date: map["date"] ?? null,
      starttime: map["starttime"] ?? "",
      endtime: map["endtime"] ?? "",
      slottime: map["slottime"] ?? "",
      name: map["name"] ?? "",
      mobile: map["mobile"] ?? "",
      email: map["email"] ?? "",
      status: map["status"] ?? "created",
      comments: map["comments"] ?? "",
      commentForCancelled: map["commentForCancelled"] ?? "",
      commentForRejected: map["commentForRejected"] ?? "",
      noOfGuests: map["noOfGuests"] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "bookingNumber": bookingNumber ?? "",
      "appointmentId": appointmentId ?? (appointmentModel != null ? appointmentModel!.id : null),
      "appointment": appointmentModel != null ? appointmentModel!.toJson() : null,
      "store": storeModel != null ? storeModel!.toJson() : null,
      "storeId": storeId ?? (storeModel != null ? storeModel!.id : null),
      "user": userModel != null ? userModel!.toJson() : null,
      "userId": userId ?? (userModel != null ? userModel!.id : null),
      "dateTime": dateTime != null ? dateTime!.toUtc().toIso8601String() : null,
      "date": date ?? null,
      "starttime": starttime ?? "",
      "endtime": endtime ?? "",
      "slottime": slottime ?? "",
      "name": name ?? "",
      "mobile": mobile ?? "",
      "email": email ?? "",
      "status": status ?? "created",
      "comments": comments ?? "",
      "commentForCancelled": commentForCancelled ?? "",
      "commentForRejected": commentForRejected ?? "",
      "noOfGuests": noOfGuests ?? 1,
    };
  }

  factory BookAppointmentModel.copy(BookAppointmentModel model) {
    return BookAppointmentModel(
      id: model.id,
      bookingNumber: model.bookingNumber,
      appointmentId: model.appointmentId,
      appointmentModel: model.appointmentModel,
      storeId: model.storeId,
      storeModel: model.storeModel != null ? StoreModel.copy(model.storeModel!) : null,
      userId: model.userId,
      userModel: model.userModel != null ? UserModel.copy(model.userModel!) : null,
      dateTime: model.dateTime,
      date: model.date,
      starttime: model.starttime,
      endtime: model.endtime,
      slottime: model.slottime,
      name: model.name,
      mobile: model.mobile,
      email: model.email,
      status: model.status,
      comments: model.comments,
      commentForCancelled: model.commentForCancelled,
      commentForRejected: model.commentForRejected,
      noOfGuests: model.noOfGuests,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        bookingNumber!,
        appointmentId!,
        appointmentModel ?? Object(),
        storeId ?? Object(),
        storeModel ?? Object(),
        userId ?? Object(),
        userModel ?? Object(),
        dateTime ?? Object,
        date ?? Object,
        starttime!,
        endtime!,
        slottime!,
        name!,
        mobile!,
        email!,
        status!,
        comments!,
        commentForCancelled!,
        commentForRejected!,
        noOfGuests!,
      ];

  @override
  bool get stringify => true;
}
