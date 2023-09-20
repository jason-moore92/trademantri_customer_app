import "package:equatable/equatable.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageType {
  static const int text = 0;
  static const int invoice = 1;
  static const int image = 2;
  static const int file = 3;
  static const int coupon = 4;
  static const int b2bInvoice = 5;
}

class ChatModel extends Equatable {
  String? id;
  String? senderId;
  String? message;
  int? messageType;
  dynamic additionalData;
  DateTime? createAt;
  DateTime? updateAt;
  bool? isFirst;

  ChatModel({
    id,
    senderId = "",
    message = "",
    messageType,
    additionalData,
    createAt,
    updateAt,
    isFirst = false,
  }) {
    this.id = id;
    this.senderId = senderId;
    this.message = message;
    this.messageType = messageType ?? MessageType.text;
    this.additionalData = additionalData ?? Map<String, dynamic>();
    this.createAt = createAt;
    this.updateAt = updateAt;
    this.isFirst = isFirst;
  }

  factory ChatModel.fromJson(Map<String, dynamic> map) {
    return ChatModel(
      id: map["id"] ?? null,
      senderId: map["senderId"] ?? "",
      message: map["message"] ?? "",
      additionalData: map["additionalData"] ?? Map<String, dynamic>(),
      messageType: map["messageType"] ?? MessageType.text,
      createAt: map["createAt"] != null ? map["createAt"].toDate() : null,
      updateAt: map["updateAt"] != null ? map["updateAt"].toDate() : null,
      isFirst: map["isFirst"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id ?? null,
      "senderId": senderId ?? "",
      "message": message ?? "",
      "additionalData": additionalData ?? Map<String, dynamic>(),
      "messageType": messageType ?? MessageType.text,
      "createAt": createAt != null ? Timestamp.fromDate(createAt!) : null,
      "updateAt": updateAt != null ? Timestamp.fromDate(updateAt!) : null,
      "isFirst": isFirst ?? false,
    };
  }

  factory ChatModel.copy(ChatModel chatModel) {
    return ChatModel(
      id: chatModel.id,
      senderId: chatModel.senderId,
      message: chatModel.message,
      additionalData: chatModel.additionalData,
      messageType: chatModel.messageType,
      createAt: chatModel.createAt,
      updateAt: chatModel.updateAt,
      isFirst: chatModel.isFirst,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        senderId!,
        message!,
        additionalData,
        messageType!,
        createAt!,
        updateAt!,
        isFirst!,
      ];

  @override
  bool get stringify => true;
}
