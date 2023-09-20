import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/chat_model.dart';
import 'package:trapp/src/models/chat_room_model.dart';

import 'index.dart';

class ChatProvider extends ChangeNotifier {
  static ChatProvider of(BuildContext context, {bool listen = false}) => Provider.of<ChatProvider>(context, listen: listen);

  ChatState _chatState = ChatState.init();
  ChatState get chatState => _chatState;

  void setChatState(ChatState chatState, {bool isNotifiable = true}) {
    if (_chatState != chatState) {
      _chatState = chatState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<ChatRoomModel?> getChatRoom({
    @required String? chatRoomType,
    @required String? firstUserType,
    @required Map<String, dynamic>? firstUserData,
    @required String? secondUserType,
    @required Map<String, dynamic>? secondUserData,
  }) async {
    String firstUserId = firstUserData!["_id"];
    String secondUserId = secondUserData!["_id"];

    List<String> ids = [];

    if (firstUserType == ChatUserTypes.customer) {
      ids.add("Customer-$firstUserId");
    } else if (firstUserType == ChatUserTypes.business) {
      ids.add("Business-$firstUserId");
    } else if (firstUserType == ChatUserTypes.delivery) {
      ids.add("Delivery-$firstUserId");
    }

    if (secondUserType == ChatUserTypes.customer) {
      ids.add("Customer-$secondUserId");
    } else if (secondUserType == ChatUserTypes.business) {
      ids.add("Business-$secondUserId");
    } else if (secondUserType == ChatUserTypes.delivery) {
      ids.add("Delivery-$secondUserId");
    }

    try {
      var result = await ChatRoomFirestoreProvider.getChatRoomsData(
        chatRoomType: chatRoomType,
        wheres: [
          {
            "key": "ids",
            // "cond": "whereIn",
            "val": ids,
          },
        ],
      );

      if (!result["success"]) {
        return null;
      }

      /// update chat room
      if (result["success"] && result["data"].isNotEmpty) {
        ChatRoomModel chatRoomModel = ChatRoomModel.fromJson(result["data"][0]);
        chatRoomModel.firstUserData = firstUserData;
        chatRoomModel.secondUserData = secondUserData;

        return (await updateChatRoom(chatRoomModel: chatRoomModel, changeUpdateAt: false));
      }

      /// create new chat room
      else if (result["success"] && result["data"].isEmpty) {
        ChatRoomModel chatRoomModel = ChatRoomModel();
        chatRoomModel.type = chatRoomType;
        chatRoomModel.ids = ids;
        chatRoomModel.firstUserType = firstUserType;
        chatRoomModel.firstUserLiveIn = false;
        chatRoomModel.firstUserName = getChatUserName(userType: firstUserType, userData: firstUserData);
        chatRoomModel.firstUserData = await convertChatUserData(userType: firstUserType, userData: firstUserData);
        chatRoomModel.secondUserType = secondUserType;
        chatRoomModel.secondUserLiveIn = false;
        chatRoomModel.secondUserName = getChatUserName(userType: secondUserType, userData: secondUserData);
        chatRoomModel.secondUserData = await convertChatUserData(userType: secondUserType, userData: secondUserData);

        var result = await ChatRoomFirestoreProvider.addChatRoom(
          chatRoomType: chatRoomType,
          data: chatRoomModel.toJson(),
        );
        if (result["success"]) {
          return ChatRoomModel.fromJson(result["data"]);
        } else {
          return null;
        }
      }
    } catch (e) {
      FlutterLogs.logThis(
        tag: "chat_provider",
        subTag: "getChatRoom",
        level: LogLevel.ERROR,
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
      return null;
    }
  }

  Future<Map<String, dynamic>> addChatData({
    @required String? chatRoomType,
    @required String? chatRoomId,
    @required ChatModel? chatModel,
    bool isNotifiable = true,
  }) async {
    try {
      var result = await ChatFirestoreProvider.addChat(
        chatRoomType: chatRoomType,
        chatRoomId: chatRoomId,
        data: chatModel!.toJson(),
      );
      return result;
    } catch (e) {
      return {"success": false};
    }
  }

  Future<Map<String, dynamic>> updateChatData({
    @required String? chatRoomId,
    @required String? chatRoomType,
    @required ChatModel? chatModel,
    bool isNotifiable = true,
  }) async {
    try {
      var result = await ChatFirestoreProvider.updateChat(
        chatRoomType: chatRoomType,
        id: chatModel!.id,
        chatRoomId: chatRoomId,
        data: chatModel.toJson(),
        changeUpdateAt: true,
      );
      return result;
    } catch (e) {
      return {"success": false};
    }
  }

  Future<ChatRoomModel> updateChatRoom({
    @required ChatRoomModel? chatRoomModel,
    @required bool? changeUpdateAt,
  }) async {
    ChatRoomModel newChatRoomModel = ChatRoomModel.copy(chatRoomModel!);

    newChatRoomModel.firstUserName = getChatUserName(
      userType: newChatRoomModel.firstUserType,
      userData: newChatRoomModel.firstUserData,
    );
    newChatRoomModel.firstUserData = await convertChatUserData(
      userType: newChatRoomModel.firstUserType,
      userData: newChatRoomModel.firstUserData,
    );
    newChatRoomModel.secondUserName = getChatUserName(
      userType: newChatRoomModel.secondUserType,
      userData: newChatRoomModel.secondUserData,
    );
    newChatRoomModel.secondUserData = await convertChatUserData(
      userType: newChatRoomModel.secondUserType,
      userData: newChatRoomModel.secondUserData,
    );

    var result = await ChatRoomFirestoreProvider.updateChatRoom(
      chatRoomType: newChatRoomModel.type,
      id: newChatRoomModel.id,
      data: newChatRoomModel.toJson(),
      changeUpdateAt: changeUpdateAt,
    );

    if (result["success"]) {
      return ChatRoomModel.fromJson(result["data"]);
    } else {
      return chatRoomModel;
    }
  }

  static Future<Map<String, dynamic>> convertChatUserData({@required String? userType, @required Map<String, dynamic>? userData}) async {
    if (userType == ChatUserTypes.customer) {
      List<String> tokens = [];
      if (userData!["status"] != null) {
        for (var i = 0; i < userData["status"].length; i++) {
          if (userData["status"][i]["fcmToken"] == null) continue;
          tokens.add(userData["status"][i]["fcmToken"]);
        }
        userData["tokens"] = tokens;
      }

      return {
        "_id": userData["_id"],
        "imageUrl": userData["imageUrl"],
        "firstName": userData["firstName"],
        "lastName": userData["lastName"],
        "email": userData["email"],
        "tokens": userData["tokens"],
      };
    } else if (userType == ChatUserTypes.business) {
      if (userData!["tokens"] == null) {
        var result = await StoreApiProvider.getFCMTokenByStoreUserId(storeId: userData["_id"]);
        if (result["success"]) {
          userData["tokens"] = result["data"];
        }
      }

      return {
        "_id": userData["_id"],
        "businessType": userData["businessType"],
        "subType": userData["subType"],
        "profile": {
          "image": userData["profile"]["image"],
          "ownerInfo": userData["profile"]["ownerInfo"],
        },
        "email": userData["email"],
        "name": userData["name"],
        "tokens": userData["tokens"],
      };
    } else if (userType == ChatUserTypes.delivery) {
      List<String> tokens = [];
      if (userData!["status"] != null) {
        for (var i = 0; i < userData["status"].length; i++) {
          if (userData["status"][i]["fcmToken"] == null) continue;
          tokens.add(userData["status"][i]["fcmToken"]);
        }
        userData["tokens"] = tokens;
      }

      return {
        "_id": userData["_id"],
        "imageUrl": userData["imageUrl"],
        "firstName": userData["firstName"],
        "lastName": userData["lastName"],
        "email": userData["email"],
        "tokens": userData["tokens"],
      };
    }

    return Map<String, dynamic>();
  }

  static String getChatUserName({@required String? userType, @required Map<String, dynamic>? userData}) {
    if (userType == ChatUserTypes.customer) {
      return "${userData!["firstName"]} ${userData["lastName"]}";
    } else if (userType == ChatUserTypes.business) {
      return "${userData!["name"]}";
    } else if (userType == ChatUserTypes.delivery) {
      return "${userData!["firstName"]} ${userData["lastName"]}";
    }

    return "";
  }
}
