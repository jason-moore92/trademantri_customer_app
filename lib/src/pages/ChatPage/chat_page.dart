import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/chat_room_model.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/src/providers/index.dart';

import '../../providers/ChatProvider/index.dart';
import 'index.dart';

class ChatPage extends StatelessWidget {
  final ChatRoomModel? chatRoomModel;
  final String? chatRoomType;
  final Map<String, dynamic>? userData;
  final String? chatRoomId;

  ChatPage({
    @required this.chatRoomType,
    this.userData,
    this.chatRoomModel,
    this.chatRoomId,
  });

  @override
  Widget build(BuildContext context) {
    if (userData == null && chatRoomId != null) {
      return StreamBuilder<Map<String, dynamic>>(
        stream: Stream.fromFuture(
          ChatRoomFirestoreProvider.getChatRoomByID(
            chatRoomType: chatRoomType,
            id: chatRoomId,
          ),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(body: Center(child: CupertinoActivityIndicator()));
          }

          if (!snapshot.data!["success"] || snapshot.data!["data"] == null) {
            return ErrorPage(message: "Someting was wrong");
          }

          ChatRoomModel _chatRoomModel = ChatRoomModel.fromJson(snapshot.data!["data"]);

          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ChatProvider()),
            ],
            child: ChatView(
              chatRoomType: chatRoomType,
              chatRoomModel: _chatRoomModel,
            ),
          );
        },
      );
    } else {
      if (chatRoomModel != null) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ChatProvider()),
          ],
          child: ChatView(chatRoomType: chatRoomType, chatRoomModel: chatRoomModel),
        );
      } else {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ChatProvider()),
          ],
          child: Builder(builder: (context) {
            String? firstUserType;
            String? secondUserType;
            Map<String, dynamic>? firstUserData;
            Map<String, dynamic>? secondUserData;

            if (userData!["_id"].toString().hashCode >= AuthProvider.of(context).authState.userModel!.id.toString().hashCode) {
              if (chatRoomType == ChatRoomTypes.b2c) {
                firstUserType = ChatUserTypes.business;
              } else if (chatRoomType == ChatRoomTypes.b2b) {
                firstUserType = ChatUserTypes.business;
              } else if (chatRoomType == ChatRoomTypes.d2c) {
                firstUserType = ChatUserTypes.delivery;
              }
              firstUserData = userData;

              secondUserType = ChatUserTypes.customer;
              secondUserData = AuthProvider.of(context).authState.userModel!.toJson();
            } else {
              firstUserType = ChatUserTypes.customer;
              firstUserData = AuthProvider.of(context).authState.userModel!.toJson();

              if (chatRoomType == ChatRoomTypes.b2c) {
                secondUserType = ChatUserTypes.business;
              } else if (chatRoomType == ChatRoomTypes.b2b) {
                secondUserType = ChatUserTypes.business;
              } else if (chatRoomType == ChatRoomTypes.d2c) {
                secondUserType = ChatUserTypes.delivery;
              }
              secondUserData = userData;
            }

            return FutureBuilder<ChatRoomModel?>(
              future: ChatProvider.of(context).getChatRoom(
                chatRoomType: chatRoomType,
                firstUserType: firstUserType,
                firstUserData: firstUserData,
                secondUserType: secondUserType,
                secondUserData: secondUserData,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Scaffold(body: Center(child: CupertinoActivityIndicator()));
                }

                if (snapshot.data == null) {
                  return ErrorPage(message: "Someting was wrong");
                }
                return ChatView(chatRoomType: chatRoomType, chatRoomModel: snapshot.data);
              },
            );
          }),
        );
      }
    }
  }
}
