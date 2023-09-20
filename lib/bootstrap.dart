import 'dart:async';
import 'dart:io';

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/app.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/helpers/helper.dart';
import 'package:trapp/src/providers/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_logs/flutter_logs.dart';

void bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterLogs.initLogs(
    logLevelsEnabled: [LogLevel.INFO, LogLevel.WARNING, LogLevel.ERROR, LogLevel.SEVERE],
    timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
    directoryStructure: DirectoryStructure.FOR_DATE,
    logTypesEnabled: ["device", "network", "errors"],
    logFileExtension: LogFileExtension.CSV,
    logsWriteDirectoryName: "MyLogs",
    logsExportDirectoryName: "MyLogs/Exported",
    debugFileOperations: !isProd(),
    isDebuggable: !isProd(),
    encryptionEnabled: Environment.logsEncryptionKey != null,
    encryptionKey: Environment.logsEncryptionKey ?? "",
  );

  await Firebase.initializeApp();

  FirebaseApp appy = Firebase.app();
  FlutterLogs.logInfo(
    "bootstrap",
    "firebase",
    {"projectId": appy.options.projectId}.toString(),
  );

  await getFirebaseAnalytics().setAnalyticsCollectionEnabled(true);

  var uuid = Uuid();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String newId = uuid.v4();
  prefs.setString("session_id", newId);

  FlutterLogs.logInfo(
    "bootstrap",
    "session",
    {
      "state": "started",
      "id": newId,
    }.toString(),
  );

  // if (Platform.isAndroid) {
  //   await Permission.phone.request();
  // }

  Freshchat.init(
    Environment.freshChatId!,
    Environment.freshChatKey!,
    Environment.freshChatDomain!,
    // teamMemberInfoVisible: true,
    cameraCaptureEnabled: true,
    // gallerySelectionEnabled: true,
    responseExpectationEnabled: true,
    userEventsTrackingEnabled: Environment.enableFreshChatEvents!,
  );

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  runZonedGuarded(
    () {
      runApp(
        EasyDynamicThemeWidget(
          child: Phoenix(
            child: MyApp(),
          ),
        ),
      );
    },
    FirebaseCrashlytics.instance.recordError,
  );

  // runApp(
  //   Phoenix(
  //     child: MyApp(),
  //   ),
  // );
}
