import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReceivedNotification {
  final int? id;
  final String? title;
  final String? body;
  final String? payload;
  final String? icon;

  ReceivedNotification({
    this.id,
    @required this.title,
    @required this.body,
    this.payload,
    this.icon,
  });
}

class KeicyLocalNotification {
  static final KeicyLocalNotification _instance = KeicyLocalNotification();
  static KeicyLocalNotification get instance => _instance;

  final MethodChannel _platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');

  NotificationAppLaunchDetails? _notificationAppLaunchDetails;

  final BehaviorSubject<ReceivedNotification> _didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
  final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();
  String? _selectedNotificationPayload;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings? _initializationSettingsAndroid;
  IOSInitializationSettings? _initializationSettingsIOS;
  MacOSInitializationSettings? _initializationSettingsMacOS;
  InitializationSettings? _initializationSettings;

  Function(ReceivedNotification)? _receivedNotificationHandler;
  Function(String)? _selectNotificationHandler;

  Map<String, AndroidNotificationChannel> channels = Map<String, AndroidNotificationChannel>();

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await _platform.invokeMethod('getTimeZoneName');
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<bool> init({String androidDefaltIcon = "launcher_icon", String channelName = "test"}) async {
    try {
      /// timezone setting
      // _configureLocalTimeZone();

      _notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

      if (_notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
        _selectedNotificationPayload = _notificationAppLaunchDetails!.payload;
      }

      /// init setting
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      _initializationSettingsAndroid = AndroidInitializationSettings(androidDefaltIcon);
      _initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (int? id, String? title, String? body, String? payload) async {
          _didReceiveLocalNotificationSubject.add(ReceivedNotification(id: id, title: title, body: body, payload: payload));
        },
      );
      _initializationSettingsMacOS = MacOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      _initializationSettings = InitializationSettings(
        android: _initializationSettingsAndroid,
        iOS: _initializationSettingsIOS,
        macOS: _initializationSettingsMacOS,
      );

      var result = await flutterLocalNotificationsPlugin.initialize(
        _initializationSettings!,
        onSelectNotification: (String? payload) async {
          if (payload != null) {
            debugPrint('notification payload: $payload');
          }
          _selectedNotificationPayload = payload;
          selectNotificationSubject.add(payload!);
        },
      );

      /// create android channel and permission for ios
      AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
        '${channelName}_channel_id',
        '${channelName}_channel_name',
        importance: Importance.max,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            androidNotificationChannel,
          );
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      ////////////////////////////////////////////////////

      return result!;
    } catch (e) {
      FlutterLogs.logThis(
        tag: "keicy_local_notification",
        level: LogLevel.ERROR,
        subTag: "init",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
      return false;
    }
  }

  void setReceivedNotificationHandler(Function(ReceivedNotification)? handler) {
    if (handler != null) {
      _receivedNotificationHandler = handler;
      _configureDidReceiveLocalNotificationSubject();
    }
  }

  void _configureDidReceiveLocalNotificationSubject() {
    _didReceiveLocalNotificationSubject.stream.listen((ReceivedNotification receivedNotification) async {
      if (_receivedNotificationHandler != null) _receivedNotificationHandler!(receivedNotification);
      // await showDialog(
      //   context: context,
      //   builder: (BuildContext context) => CupertinoAlertDialog(
      //     title: receivedNotification.title != null ? Text(receivedNotification.title) : null,
      //     content: receivedNotification.body != null ? Text(receivedNotification.body) : null,
      //     actions: <Widget>[
      //       CupertinoDialogAction(
      //         isDefaultAction: true,
      //         onPressed: () async {
      //           Navigator.of(context, rootNavigator: true).pop();
      //           await Navigator.push(
      //             context,
      //             MaterialPageRoute<void>(
      //               builder: (BuildContext context) => SecondPage(receivedNotification.payload),
      //             ),
      //           );
      //         },
      //         child: const Text('Ok'),
      //       )
      //     ],
      //   ),
      // );
    });
  }

  void setSelectNotificationHandler(Function(String)? handler) {
    if (handler != null) {
      _selectNotificationHandler = handler;
      _configureSelectNotificationSubject();
    }
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      if (_selectNotificationHandler != null) _selectNotificationHandler!(payload);
    });
  }

  Future<void> showNotification(ReceivedNotification receivedNotification, {String channelName = "test"}) async {
    try {
      String largeIconPath = "";
      if (receivedNotification.icon != null) {
        largeIconPath = await _downloadAndSaveFile(receivedNotification.icon!, 'largeIcon');
      }

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        receivedNotification.body!,
        htmlFormatBigText: true,
        contentTitle: receivedNotification.title,
        htmlFormatContentTitle: true,
        summaryText: 'TradeMantri',
        htmlFormatSummaryText: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '${channelName}_channel_id',
        '${channelName}_channel_name',
        largeIcon: receivedNotification.icon != null ? FilePathAndroidBitmap(largeIconPath) : null,
        importance: Importance.max,
        priority: Priority.high,
        color: const Color(0xFFf46f2c),
        visibility: NotificationVisibility.public,
        styleInformation: bigTextStyleInformation,
      );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: IOSNotificationDetails(subtitle: 'the subtitle'),
      );

      if (receivedNotification.title!.toLowerCase().contains("reward points")) {
        Future.delayed(Duration(seconds: 3), () {
          flutterLocalNotificationsPlugin.show(
            channelName.hashCode,
            receivedNotification.title,
            receivedNotification.body,
            platformChannelSpecifics,
            payload: receivedNotification.payload,
          );
        });
      } else {
        await flutterLocalNotificationsPlugin.show(
          channelName.hashCode,
          receivedNotification.title,
          receivedNotification.body,
          platformChannelSpecifics,
          payload: receivedNotification.payload,
        );
      }
    } catch (e) {
      FlutterLogs.logThis(
        tag: "keicy_local_notification",
        level: LogLevel.ERROR,
        subTag: "showNotification",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
