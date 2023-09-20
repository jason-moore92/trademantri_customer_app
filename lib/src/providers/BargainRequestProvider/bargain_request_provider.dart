import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:trapp/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class BargainRequestProvider extends ChangeNotifier {
  static BargainRequestProvider of(BuildContext context, {bool listen = false}) => Provider.of<BargainRequestProvider>(context, listen: listen);

  BargainRequestState _bargainRequestState = BargainRequestState.init();
  BargainRequestState get bargainRequestState => _bargainRequestState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setBargainRequestState(BargainRequestState bargainRequestState, {bool isNotifiable = true}) {
    if (_bargainRequestState != bargainRequestState) {
      _bargainRequestState = bargainRequestState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<bool> addBargainRequestData({@required Map<String, dynamic>? bargainRequestData}) async {
    try {
      if (bargainRequestData!["products"].isNotEmpty && bargainRequestData["products"][0]["data"]["imageFile"] != null) {
        var result = await UploadFileApiProvider.uploadFile(
          file: bargainRequestData["products"][0]["data"]["imageFile"],
          directoryName: "UserId-${bargainRequestData["userId"]}/StoreId-${bargainRequestData["storeId"]}/",
          fileName: (bargainRequestData["products"][0]["data"]["name"] +
              "-" +
              DateTime.now().millisecondsSinceEpoch.toString() +
              "." +
              bargainRequestData["products"][0]["data"]["imageFile"].toString().split("/").last.split('.').last),
          bucketName: "BARGAIN_BUCKET_NAME",
        );

        if (result["success"]) {
          bargainRequestData["products"][0]["data"]["images"] = [result["data"]];
          bargainRequestData["products"][0]["data"].remove("imageFile");
        } else {
          bargainRequestData["products"][0]["data"].remove("imageFile");
        }
      }

      if (bargainRequestData["services"].isNotEmpty && bargainRequestData["services"][0]["data"]["imageFile"] != null) {
        var result = await UploadFileApiProvider.uploadFile(
          file: bargainRequestData["services"][0]["data"]["imageFile"],
          directoryName: "UserId-${bargainRequestData["userId"]}/StoreId-${bargainRequestData["storeId"]}/",
          fileName: bargainRequestData["services"][0]["data"]["name"] +
              "-" +
              DateTime.now().millisecondsSinceEpoch.toString() +
              bargainRequestData["services"][0]["data"]["imageFile"].toString().split("/").last.split('.').last,
          bucketName: "BARGAIN_BUCKET_NAME",
        );

        if (result["success"]) {
          bargainRequestData["services"][0]["data"]["images"] = [result["data"]];
          bargainRequestData["services"][0]["data"].remove("imageFile");
        } else {
          bargainRequestData["services"][0]["data"].remove("imageFile");
        }
      }

      bargainRequestData["bargainRequestId"] = "TMBR-" + randomAlphaNumeric(12);

      var result = await BargainRequestApiProvider.addBargainRequest(
        bargainRequestData: bargainRequestData,
      );

      if (result["success"]) {
        _bargainRequestState = _bargainRequestState.update(
          progressState: 2,
          message: "",
          // bargainRequestData: bargainRequestData,
        );
        notifyListeners();

        return true;
      } else {
        _bargainRequestState = _bargainRequestState.update(
          progressState: -1,
          message: result["message"],
        );
        notifyListeners();
        return false;
      }
    } catch (e) {
      _bargainRequestState = _bargainRequestState.update(
        progressState: -1,
        message: e.toString(),
      );
      notifyListeners();
      return false;
    }
  }

  Future<void> getBargainRequestData({@required String? status, String searchKey = ""}) async {
    Map<String, dynamic> bargainRequestListData = _bargainRequestState.bargainRequestListData!;
    Map<String, dynamic> bargainRequestMetaData = _bargainRequestState.bargainRequestMetaData!;
    try {
      if (bargainRequestListData[status] == null) bargainRequestListData[status!] = [];
      if (bargainRequestMetaData[status] == null) bargainRequestMetaData[status!] = Map<String, dynamic>();

      var result;

      result = await BargainRequestApiProvider.getBargainRequestData(
        status: status,
        searchKey: searchKey,
        page: bargainRequestMetaData[status].isEmpty ? 1 : (bargainRequestMetaData[status]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          bargainRequestListData[status].add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        bargainRequestMetaData[status!] = result["data"];

        _bargainRequestState = _bargainRequestState.update(
          progressState: 2,
          bargainRequestListData: bargainRequestListData,
          bargainRequestMetaData: bargainRequestMetaData,
        );
      } else {
        _bargainRequestState = _bargainRequestState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _bargainRequestState = _bargainRequestState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }

  Future<dynamic> updateBargainRequestData({
    @required BargainRequestModel? bargainRequestModel,
    @required String? status,
    @required String? subStatus,
  }) async {
    var result = await BargainRequestApiProvider.updateBargainRequestData(
      bargainRequestData: bargainRequestModel!.toJson(),
      status: status,
      subStatus: subStatus,
    );
    if (result["success"]) {
      _bargainRequestState = _bargainRequestState.update(
        progressState: 1,
        bargainRequestListData: Map<String, dynamic>(),
        bargainRequestMetaData: Map<String, dynamic>(),
      );
    }
    return result;
  }
}
