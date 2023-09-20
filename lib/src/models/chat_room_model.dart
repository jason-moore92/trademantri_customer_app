import 'dart:convert';

import "package:equatable/equatable.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_model.dart';

class ChatRoomTypes {
  static String b2c = "business-customer";
  static String b2b = "business-business";
  static String d2c = "delivery-customer";
}

class ChatUserTypes {
  static String customer = "customer";
  static String business = "business";
  static String delivery = "delivery";
}

class ChatRoomModel extends Equatable {
  String? id;
  String? type;
  List<dynamic>? ids;
  String? firstUserType;
  String? firstUserName;
  bool? firstUserLiveIn;
  Map<String, dynamic>? firstUserData;
  String? secondUserType;
  String? secondUserName;
  bool? secondUserLiveIn;
  Map<String, dynamic>? secondUserData;
  String? lastSenderId;
  String? lastMessage;
  int? lastMessageType;
  DateTime? lastMessageDate;
  Map<String, dynamic>? lastAdditionalData;
  int? newMessageCount;
  DateTime? createAt;
  DateTime? updateAt;
  bool? isBlocked;

  ChatRoomModel({
    id,
    type,
    ids,
    firstUserType = "",
    firstUserName = "",
    firstUserLiveIn = false,
    firstUserData,
    secondUserType = "",
    secondUserName = "",
    secondUserData,
    secondUserLiveIn = false,
    lastSenderId = "",
    lastMessage = "",
    lastMessageType,
    lastMessageDate,
    lastAdditionalData,
    newMessageCount = 0,
    createAt,
    updateAt,
    isBlocked = false,
  }) {
    this.id = id;
    this.type = type;
    this.ids = ids ?? [];
    this.firstUserType = firstUserType;
    this.firstUserName = firstUserName;
    this.firstUserLiveIn = firstUserLiveIn;
    this.firstUserData = firstUserData ?? Map<String, dynamic>();
    this.secondUserType = secondUserType;
    this.secondUserName = secondUserName;
    this.secondUserLiveIn = secondUserLiveIn;
    this.secondUserData = secondUserData ?? Map<String, dynamic>();
    this.lastSenderId = lastSenderId;
    this.lastMessage = lastMessage;
    this.lastMessageType = lastMessageType ?? MessageType.text;
    this.lastMessageDate = lastMessageDate;
    this.lastAdditionalData = lastAdditionalData ?? Map<String, dynamic>();
    this.newMessageCount = newMessageCount;
    this.createAt = createAt;
    this.updateAt = updateAt;
    this.isBlocked = isBlocked;
  }

  factory ChatRoomModel.fromJson(Map<String, dynamic> map) {
    return ChatRoomModel(
      id: map["id"] ?? null,
      type: map["type"] ?? "",
      ids: map["ids"] ?? [],
      firstUserType: map["firstUserType"] ?? "",
      firstUserName: map["firstUserName"] ?? "",
      firstUserLiveIn: map["firstUserLiveIn"] ?? false,
      firstUserData: map["firstUserData"] ?? Map<String, dynamic>(),
      secondUserType: map["secondUserType"] ?? "",
      secondUserName: map["secondUserName"] ?? "",
      secondUserLiveIn: map["secondUserLiveIn"] ?? false,
      secondUserData: map["secondUserData"] ?? Map<String, dynamic>(),
      lastSenderId: map["lastSenderId"] ?? "",
      lastMessage: map["lastMessage"] ?? "",
      lastMessageType: map["lastMessageType"] ?? MessageType.text,
      lastMessageDate: map["lastMessageDate"] != null ? map["lastMessageDate"].toDate() : null,
      lastAdditionalData: map["lastAdditionalData"] ?? Map<String, dynamic>(),
      newMessageCount: map["newMessageCount"] ?? 0,
      createAt: map["createAt"] != null ? map["createAt"].toDate() : null,
      updateAt: map["updateAt"] != null ? map["updateAt"].toDate() : null,
      isBlocked: map["isBlocked"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id ?? null,
      "type": type ?? "",
      "ids": ids ?? [],
      "firstUserType": firstUserType ?? "",
      "firstUserName": firstUserName ?? "",
      "firstUserLiveIn": firstUserLiveIn ?? false,
      "firstUserData": firstUserData ?? Map<String, dynamic>(),
      "secondUserType": secondUserType ?? "",
      "secondUserName": secondUserName ?? "",
      "secondUserLiveIn": secondUserLiveIn ?? false,
      "secondUserData": secondUserData ?? Map<String, dynamic>(),
      "lastSenderId": lastSenderId ?? "",
      "lastMessage": lastMessage ?? "",
      "lastMessageType": lastMessageType ?? MessageType.text,
      "lastMessageDate": lastMessageDate != null ? Timestamp.fromDate(lastMessageDate!) : null,
      "lastAdditionalData": lastAdditionalData ?? Map<String, dynamic>(),
      "newMessageCount": newMessageCount ?? 0,
      "createAt": createAt != null ? Timestamp.fromDate(createAt!) : null,
      "updateAt": updateAt != null ? Timestamp.fromDate(updateAt!) : null,
      "isBlocked": isBlocked ?? false,
    };
  }

  factory ChatRoomModel.copy(ChatRoomModel chatRoomModel) {
    return ChatRoomModel(
      id: chatRoomModel.id,
      type: chatRoomModel.type,
      ids: List.from(chatRoomModel.ids!),
      firstUserType: chatRoomModel.firstUserType,
      firstUserName: chatRoomModel.firstUserName,
      firstUserLiveIn: chatRoomModel.firstUserLiveIn,
      firstUserData: json.decode(json.encode(chatRoomModel.firstUserData!)),
      secondUserType: chatRoomModel.secondUserType,
      secondUserName: chatRoomModel.secondUserName,
      secondUserLiveIn: chatRoomModel.secondUserLiveIn,
      secondUserData: json.decode(json.encode(chatRoomModel.secondUserData!)),
      lastSenderId: chatRoomModel.lastSenderId,
      lastMessage: chatRoomModel.lastMessage,
      lastAdditionalData: json.decode(json.encode(chatRoomModel.lastAdditionalData!)),
      lastMessageType: chatRoomModel.lastMessageType,
      lastMessageDate: chatRoomModel.lastMessageDate,
      newMessageCount: chatRoomModel.newMessageCount,
      createAt: chatRoomModel.createAt,
      updateAt: chatRoomModel.updateAt,
      isBlocked: chatRoomModel.isBlocked,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        type!,
        ids!,
        firstUserType!,
        firstUserName!,
        firstUserLiveIn!,
        firstUserData!,
        secondUserType!,
        secondUserName!,
        secondUserLiveIn!,
        secondUserData!,
        lastSenderId!,
        lastMessage!,
        lastAdditionalData!,
        lastMessageType!,
        lastMessageDate!,
        newMessageCount!,
        createAt!,
        updateAt!,
        isBlocked!,
      ];

  @override
  bool get stringify => true;
}
