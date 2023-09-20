import 'dart:convert';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter_reachability/flutter_reachability.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/helpers/http_plus.dart';

class HeadersInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    data.headers["x-source"] = "app";

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    data.headers["x-version"] = packageInfo.version;
    data.headers["x-build-number"] = packageInfo.buildNumber;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.androidId != null) {
        data.headers["x-device-id"] = androidInfo.androidId!;
      }
      //Note:: will store the details when fcm token seperate store implemented.
      // data.headers["x-device-data"] = jsonEncode(androidInfo.toMap());
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.identifierForVendor != null) {
        data.headers["x-device-id"] = iosInfo.identifierForVendor!;
      }
      // data.headers["x-device-data"] = jsonEncode(iosInfo.toMap());
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('session_id')) {
      String? sessionId = prefs.getString('session_id');
      if (sessionId != null) {
        data.headers["x-session-id"] = sessionId;
      }
    }

    Battery battery = Battery();
    int level = await battery.batteryLevel;
    data.headers["x-battery"] = level.toString();

    ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
    data.headers["x-connectivity"] = connectivityResult.toString().replaceAll("ConnectivityResult.", "");

    //TODO::  After https://github.com/full-of-fire/flutter_reachability/pull/1
    // NetworkStatus netStatus = await FlutterReachbility().currentNetworkStatus();
    // data.headers["x-connectivity"] = netStatus.toString().replaceAll("NetworkStatus.", "");

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}
