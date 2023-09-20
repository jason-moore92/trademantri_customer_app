library keicy_fcm_for_mobile_7_0;

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/src/models/chat_room_model.dart';
import 'package:trapp/src/pages/ChatPage/chat_page.dart';
import 'package:trapp/src/pages/login.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/services/keicy_local_notification.dart';
import 'package:trapp/environment.dart';

class KeicyFCMForMobile {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static GlobalKey<NavigatorState>? navigatorKey;

  static void setNavigatorey(GlobalKey<NavigatorState> key) {
    navigatorKey = key;
  }

  static Future<void> init() async {
    try {
      messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      messaging.subscribeToTopic("customer");

      RemoteMessage? initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        if (initialMessage.notification != null) {
          ///
        } else if (initialMessage.data != null && initialMessage.data.isNotEmpty) {
          localNotificationHandler(initialMessage);
        }
      }

      token = await messaging.getToken(vapidKey: Environment.vapidKey);

      await KeicyLocalNotification.instance.init();

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        try {
          if (await Freshchat.isFreshchatNotification(message.data)) {
            Freshchat.handlePushNotification(message.data);
            return;
          }
          if (message.notification != null) {
            if (message.data != null && message.data.isNotEmpty) {
              if (message.data["type"] == "new_chat") {
                sendNewMessageHandler(message);
              }
            }
          } else if (message.data != null && message.data.isNotEmpty) {
            localNotificationHandler(message);
          }
        } catch (e) {
          FlutterLogs.logThis(
            tag: "keicy_fcm_for_mobile",
            level: LogLevel.ERROR,
            subTag: "init",
            exception: e is Exception ? e : null,
            error: e is Error ? e : null,
            errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
        try {
          if (message.notification != null) {
            if (message.data != null && message.data.isNotEmpty) {
              if (message.data["type"] == "new_chat") {
                sendNewMessageHandler(message);
              }
            }
          } else if (message.data != null && message.data.isNotEmpty) {
            ///
          }
        } catch (e) {
          FlutterLogs.logThis(
            tag: "keicy_fcm_for_mobile",
            level: LogLevel.ERROR,
            subTag: "onMessageOpenedApp",
            exception: e is Exception ? e : null,
            error: e is Error ? e : null,
            errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
          );
        }
      });

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } catch (e) {
      FlutterLogs.logThis(
        tag: "keicy_fcm_for_mobile",
        level: LogLevel.ERROR,
        subTag: "init1",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
    await Firebase.initializeApp();
    var result = await KeicyLocalNotification.instance.init();
    try {
      if (message!.notification != null) {
        ///
      } else if (message.data != null && message.data.isNotEmpty) {
        localNotificationHandler(message);
      }
    } catch (e) {
      FlutterLogs.logThis(
        tag: "keicy_fcm_for_mobile",
        level: LogLevel.ERROR,
        subTag: "_firebaseMessagingBackgroundHandler",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  static Future<Map<String, dynamic>> sendMessage(
    String body,
    String title,
    List<String> partnerToken, {
    Map<String, dynamic>? data,
  }) async {
    String apiUrl = 'fcm/sendMessage';
    String url = Environment.apiBaseUrl! + apiUrl;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, dynamic>{
          'registration_ids': partnerToken,
          'notification': <String, dynamic>{'body': body, 'title': title},
          'priority': 'high',
          'data': data ?? {},
        },
      ),
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> sendDataMessage(
    String? body,
    String? title,
    List<String>? partnerToken, {
    Map<String, dynamic>? data,
  }) async {
    data = data;
    data!["title"] = title;
    data["body"] = body;

    String apiUrl = 'fcm/sendMessage';
    String url = Environment.apiBaseUrl! + apiUrl;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, dynamic>{
          'registration_ids': partnerToken,
          'priority': 'high',
          'data': data,
        },
      ),
    );
    return json.decode(response.body);
  }

  // static Future<Map<String, dynamic>> sendMessageByTopic(
  //     String body, String title, String topic,
  //     {Map<String, dynamic> data}) async {
  //   http.Response response = await http.post(
  //     // Uri.parse('https://fcm.googleapis.com/v1/projects/user-app-trapp/messages:send'),
  //     Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Authorization': 'key=${Environment.serverKey}',
  //     },
  //     body: jsonEncode(
  //       <String, dynamic>{
  //         'notification': <String, dynamic>{'body': body, 'title': title},
  //         'data': data ?? {},
  //         'priority': 'high',
  //         'to': "/topics/$topic",
  //       },
  //     ),
  //   );
  //   return json.decode(response.body);
  // }

  static void sendNewMessageHandler(RemoteMessage? message) {
    if (AuthProvider.of(navigatorKey!.currentState!.context).authState.userModel!.id == message!.data["userId"]) {
      navigatorKey!.currentState!.push(
        MaterialPageRoute(
          builder: (BuildContext context) => ChatPage(
            chatRoomType: message.data["chatRoomType"],
            chatRoomId: message.data["chatRoomModelId"],
          ),
        ),
      );
    } else {
      navigatorKey!.currentState!
        ..push(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginWidget(
              callback: () {
                if (AuthProvider.of(navigatorKey!.currentState!.context).authState.userModel!.id == message.data["userId"]) {
                  navigatorKey!.currentState!.push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => ChatPage(
                        chatRoomType: message.data["chatRoomType"],
                        chatRoomId: message.data["chatRoomModelId"],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
    }
  }

  static localNotificationHandler(RemoteMessage? message) async {
    await KeicyLocalNotification.instance.showNotification(
      ReceivedNotification(
        id: message!.data.hashCode,
        title: message.data["title"],
        body: message.data["body"],
        payload: message.data["data"],
      ),
      channelName: message.data["title"],
    );
  }
}
