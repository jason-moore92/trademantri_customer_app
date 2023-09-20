import "package:equatable/equatable.dart";

class ContactModel extends Equatable {
  String? id;
  String? userId;
  String? name;
  String? phone;
  String? email;
  String? reason;
  String? category;

  ContactModel({
    this.id,
    this.userId = "",
    this.name = "",
    this.phone = "",
    this.email = "",
    this.reason = "",
    this.category = "user-app",
  });

  factory ContactModel.fromJson(Map<String, dynamic> map) {
    return ContactModel(
      id: map["_id"] ?? null,
      userId: map["userId"] ?? "",
      name: map["name"] ?? "",
      phone: map["phone"] ?? "",
      email: map["email"] ?? "",
      reason: map["reason"] ?? "",
      category: map["category"] ?? "user-app",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "userId": userId ?? "",
      "name": name ?? "",
      "phone": phone ?? "",
      "email": email ?? "",
      "reason": reason ?? "",
      "category": category ?? "user-app",
    };
  }

  factory ContactModel.copy(ContactModel contactModel) {
    return ContactModel(
      id: contactModel.id,
      userId: contactModel.userId,
      name: contactModel.name,
      phone: contactModel.phone,
      email: contactModel.email,
      reason: contactModel.reason,
      category: contactModel.category,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        userId!,
        name!,
        phone!,
        email!,
        reason!,
        category!,
      ];

  @override
  bool get stringify => true;
}
