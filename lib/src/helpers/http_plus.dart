import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/helpers/interceptors/auth.dart';
import 'package:trapp/src/helpers/interceptors/headers.dart';
import 'package:trapp/src/helpers/interceptors/logging.dart';

Client http = InterceptedClient.build(
  interceptors: [
    HeadersInterceptor(),
    AuthInterceptor(),
    LoggingInterceptor(), //Note:: this should be last so that details changed in previous interceptors will be visible.
  ],
);

Future<Map<String, String>> commonHeaders() async {
  Map<String, String> headers = {};

  String authToken = await getAuthToken();

  if (authToken != "") {
    headers["Authorization"] = "Bearer " + authToken;
  }

  return headers;
}

Future<String> getAuthToken() async {
  SharedPreferences _prefs;
  String _rememberUserKey = "remember_me";

  _prefs = await SharedPreferences.getInstance();
  var rememberUserData = _prefs.getString(_rememberUserKey) == null ? null : json.decode(_prefs.getString(_rememberUserKey)!);

  if (rememberUserData != null) {
    return rememberUserData['jwtToken'];
  }

  return "";
}

Future<dynamic> httpExceptionWrapper<R>(Future<R> Function() body) async {
  // doSomeInitialWork();
  try {
    return await body();
  } on SocketException catch (e) {
    FlutterLogs.logThis(
      tag: "http_plus",
      subTag: "httpExceptionWrapper:SocketException",
      level: LogLevel.ERROR,
      exception: e,
    );
    return {
      "success": false,
      "message": "Something went wrong",
      // "message": e.osError!.errorCode == 110 || e.osError!.errorCode == 101 ? "Something went wrong" : e.osError!.message,
      "errorCode": e.osError!.errorCode,
    };
  } on PlatformException catch (e) {
    FlutterLogs.logThis(
      tag: "http_plus",
      subTag: "httpExceptionWrapper:PlatformException",
      level: LogLevel.ERROR,
      exception: e,
    );
    return {
      "success": false,
      "message": "Something went wrong",
    };
  } catch (e) {
    FlutterLogs.logThis(
      tag: "http_plus",
      level: LogLevel.ERROR,
      subTag: "httpExceptionWrapper",
      exception: e is Exception ? e : null,
      error: e is Error ? e : null,
      errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
    );
    return {
      "success": false,
      "message": "Something went wrong",
    };
  } finally {
    // doSomeCleanUpWork();
  }
}
