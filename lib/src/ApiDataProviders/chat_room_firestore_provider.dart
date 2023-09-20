import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/models/chat_room_model.dart';
import 'package:trapp/src/services/keicy_firestore_data_provider.dart';

class ChatRoomFirestoreProvider {
  static Future<Map<String, dynamic>> addChatRoom({
    @required String? chatRoomType,
    @required Map<String, dynamic>? data,
  }) async {
    String path = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      path = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      path = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      path = "/D_C_ChatRooms";
    }
    return await KeicyFireStoreDataProvider.instance.addDocument(path: path, data: data);
  }

  static Future<Map<String, dynamic>> updateChatRoom({
    @required String? chatRoomType,
    @required String? id,
    @required Map<String, dynamic>? data,
    @required bool? changeUpdateAt,
  }) async {
    String path = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      path = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      path = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      path = "/D_C_ChatRooms";
    }
    return await KeicyFireStoreDataProvider.instance.updateDocument(path: path, id: id, data: data, changeUpdateAt: changeUpdateAt);
  }

  static Future<Map<String, dynamic>> deleteChatRoom({@required String? chatRoomType, @required String? id}) async {
    String path = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      path = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      path = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      path = "/D_C_ChatRooms";
    }
    return await KeicyFireStoreDataProvider.instance.deleteDocument(path: path, id: id);
  }

  static Future<Map<String, dynamic>> isChatRoomExist({@required String? chatRoomType, @required String? id}) async {
    String path = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      path = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      path = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      path = "/D_C_ChatRooms";
    }
    return await KeicyFireStoreDataProvider.instance.isDocExist(path: path, id: id);
  }

  static Future<Map<String, dynamic>> getChatRoomByID({@required String? chatRoomType, @required String? id}) async {
    String path = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      path = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      path = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      path = "/D_C_ChatRooms";
    }

    return await KeicyFireStoreDataProvider.instance.getDocumentByID(path: path, id: id);
  }

  static Stream<Map<String, dynamic>>? getChatRoomStreamByID({@required String? chatRoomType, @required String? id}) {
    String path = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      path = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      path = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      path = "/D_C_ChatRooms";
    }
    return KeicyFireStoreDataProvider.instance.getDocumentStreamByID(path: path, id: id);
  }

  static Future<Map<String, dynamic>> getChatRoomsData({
    @required String? chatRoomType,
    List<Map<String, dynamic>>? wheres,
    List<Map<String, dynamic>>? orderby,
    int? limit,
  }) async {
    String path = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      path = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      path = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      path = "/D_C_ChatRooms";
    }
    return await KeicyFireStoreDataProvider.instance.getDocumentsData(
      path: path,
      wheres: wheres,
      orderby: orderby,
      limit: limit,
    );
  }

  static Stream<List<Map<String, dynamic>>>? getChatRoomStream({
    @required String? chatRoomType,
    List<Map<String, dynamic>>? wheres,
    List<Map<String, dynamic>>? orderby,
    int? limit,
  }) {
    String path = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      path = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      path = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      path = "/D_C_ChatRooms";
    }
    return KeicyFireStoreDataProvider.instance.getDocumentsStream(
      path: path,
      wheres: wheres,
      orderby: orderby,
      limit: limit,
    );
  }

  static Stream<List<Map<String, dynamic>>>? getChatRoomsStream({
    @required String? chatRoomType,
    @required String? customerId,
    // @required String? searchKey,
    int? limit,
  }) {
    String path = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      path = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      path = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      path = "/D_C_ChatRooms";
    }
    try {
      CollectionReference<Map<String, dynamic>> ref;
      Query<Map<String, dynamic>> query;
      ref = FirebaseFirestore.instance.collection(path);
      query = ref;
      query = ref;
      // if (searchKey!.isNotEmpty) {
      //   query = query.orderBy("userName");
      // }

      query = query.orderBy("lastMessageDate", descending: true);
      // if (searchKey.isNotEmpty) query = query.startAt([searchKey]).endAt(["$searchKey\uf8ff"]);
      query = query.where("ids", arrayContains: "Customer-$customerId");
      if (limit != null) query = query.limit(limit);
      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((document) {
          Map<String, dynamic> data = document.data();
          data["id"] = document.id;
          return data;
        }).toList();
      });
    } catch (e) {
      FlutterLogs.logThis(
        tag: "http_plus",
        level: LogLevel.ERROR,
        subTag: "httpExceptionWrapper",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
      return null;
    }

    // return KeicyFireStoreDataProvider.instance.getDocumentsStream(
    //   path: path,
    //   wheres: wheres,
    //   orderby: orderby,
    //   limit: limit,
    // );
  }

  static Future<Map<String, dynamic>> getChatRoomsLength({
    @required String? chatRoomType,
    List<Map<String, dynamic>>? wheres,
    List<Map<String, dynamic>>? orderby,
    int? limit,
  }) async {
    String path = "";
    if (chatRoomType == ChatRoomTypes.b2c) {
      path = "/B_C_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.b2b) {
      path = "/B_B_ChatRooms";
    }
    if (chatRoomType == ChatRoomTypes.d2c) {
      path = "/D_C_ChatRooms";
    }
    return await KeicyFireStoreDataProvider.instance.getDocumentsLength(path: path, wheres: wheres, orderby: orderby, limit: limit);
  }
}
