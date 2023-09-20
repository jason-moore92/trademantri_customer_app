import 'package:flutter/material.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/models/chat_room_model.dart';
import 'package:trapp/src/services/keicy_firestore_data_provider.dart';

class ChatFirestoreProvider {
  static Future<Map<String, dynamic>> addChat({
    @required String? chatRoomType,
    @required String? chatRoomId,
    @required Map<String, dynamic>? data,
  }) async {
    String chatRoom = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      chatRoom = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      chatRoom = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      chatRoom = "/D_C_ChatRooms";
    }
    String path = "$chatRoom/$chatRoomId/Chats";
    return await KeicyFireStoreDataProvider.instance.addDocument(path: path, data: data);
  }

  static Future<Map<String, dynamic>> updateChat({
    @required String? chatRoomType,
    @required String? chatRoomId,
    @required String? id,
    @required Map<String, dynamic>? data,
    @required bool? changeUpdateAt,
  }) async {
    String chatRoom = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      chatRoom = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      chatRoom = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      chatRoom = "/D_C_ChatRooms";
    }
    String path = "$chatRoom/$chatRoomId/Chats";
    return await KeicyFireStoreDataProvider.instance.updateDocument(
      path: path,
      id: id,
      data: data,
      changeUpdateAt: changeUpdateAt,
    );
  }

  static Future<Map<String, dynamic>> deleteChat({
    @required String? chatRoomType,
    @required String? chatRoomId,
    @required String? id,
  }) async {
    String chatRoom = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      chatRoom = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      chatRoom = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      chatRoom = "/D_C_ChatRooms";
    }
    String path = "$chatRoom/$chatRoomId/Chats";
    return await KeicyFireStoreDataProvider.instance.deleteDocument(path: path, id: id);
  }

  static Future<Map<String, dynamic>> isChatExist({
    @required String? chatRoomType,
    @required String? chatRoomId,
    @required String? id,
  }) async {
    String chatRoom = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      chatRoom = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      chatRoom = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      chatRoom = "/D_C_ChatRooms";
    }
    String path = "$chatRoom/$chatRoomId/Chats";
    return await KeicyFireStoreDataProvider.instance.isDocExist(path: path, id: id);
  }

  static Future<Map<String, dynamic>> getChatByID({
    @required String? chatRoomType,
    @required String? chatRoomId,
    @required String? id,
  }) async {
    String chatRoom = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      chatRoom = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      chatRoom = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      chatRoom = "/D_C_ChatRooms";
    }
    String path = "$chatRoom/$chatRoomId/Chats";
    return await KeicyFireStoreDataProvider.instance.getDocumentByID(path: path, id: id);
  }

  static Stream<Map<String, dynamic>>? getChatStreamByID({
    @required String? chatRoomType,
    @required String? chatRoomId,
    @required String? id,
  }) {
    String chatRoom = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      chatRoom = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      chatRoom = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      chatRoom = "/D_C_ChatRooms";
    }
    String path = "$chatRoom/$chatRoomId/Chats";
    return KeicyFireStoreDataProvider.instance.getDocumentStreamByID(path: path, id: id);
  }

  static Future<Map<String, dynamic>> getChatsData({
    @required String? chatRoomType,
    @required String? chatRoomId,
    List<Map<String, dynamic>>? wheres,
    List<Map<String, dynamic>>? orderby,
    int? limit,
  }) async {
    String chatRoom = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      chatRoom = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      chatRoom = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      chatRoom = "/D_C_ChatRooms";
    }
    String path = "$chatRoom/$chatRoomId/Chats";
    return await KeicyFireStoreDataProvider.instance.getDocumentsData(
      path: path,
      wheres: wheres,
      orderby: orderby,
      limit: limit,
    );
  }

  static Stream<List<Map<String, dynamic>>>? getChatsStream({
    @required String? chatRoomType,
    @required String? chatRoomId,
    List<Map<String, dynamic>>? wheres,
    List<Map<String, dynamic>>? orderby,
    int? limit,
  }) {
    String chatRoom = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      chatRoom = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      chatRoom = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      chatRoom = "/D_C_ChatRooms";
    }
    String path = "$chatRoom/$chatRoomId/Chats";
    return KeicyFireStoreDataProvider.instance.getDocumentsStream(
      path: path,
      wheres: wheres,
      orderby: orderby,
      limit: limit,
    );
  }

  static Future<Map<String, dynamic>> getChatsLength({
    @required String? chatRoomType,
    @required String? chatRoomId,
    List<Map<String, dynamic>>? wheres,
    List<Map<String, dynamic>>? orderby,
    int? limit,
  }) async {
    String chatRoom = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      chatRoom = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      chatRoom = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      chatRoom = "/D_C_ChatRooms";
    }
    String path = "$chatRoom/$chatRoomId/Chats";
    return await KeicyFireStoreDataProvider.instance.getDocumentsLength(
      path: path,
      wheres: wheres,
      orderby: orderby,
      limit: limit,
    );
  }

  static Stream<int>? getChatsLengthStream({
    @required String? chatRoomType,
    @required String? chatRoomId,
    List<Map<String, dynamic>>? wheres,
    List<Map<String, dynamic>>? orderby,
    int? limit,
  }) {
    String chatRoom = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      chatRoom = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      chatRoom = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      chatRoom = "/D_C_ChatRooms";
    }
    String path = "$chatRoom/$chatRoomId/Chats";
    return KeicyFireStoreDataProvider.instance.getDocumentsLengthStream(
      path: path,
      wheres: wheres,
      orderby: orderby,
      limit: limit,
    );
  }
}
