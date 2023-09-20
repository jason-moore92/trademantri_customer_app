import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class FavoriteProvider extends ChangeNotifier {
  static FavoriteProvider of(BuildContext context, {bool listen = false}) => Provider.of<FavoriteProvider>(context, listen: listen);

  FavoriteState _favoriteState = FavoriteState.init();
  FavoriteState get favoriteState => _favoriteState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setFavoriteState(FavoriteState favoriteState, {bool isNotifiable = true}) {
    if (_favoriteState != favoriteState) {
      _favoriteState = favoriteState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getFavorite({@required String? userId, bool isNotifiable = true}) async {
    if (_favoriteState.progressState != 2) {
      _favoriteState = _favoriteState.update(progressState: 1);
      if (_prefs == null) _prefs = await SharedPreferences.getInstance();
      try {
        Map<String, dynamic> favoriteData = Map<String, dynamic>();
        favoriteData["stores"] = [];
        favoriteData["products"] = [];
        favoriteData["services"] = [];

        var localResult = _prefs!.getString("favorite_data_$userId");
        if (localResult == null) {
          var result = await FavoriteApiProvider.getFavorite();
          if (result["success"]) {
            for (var i = 0; i < result["data"].length; i++) {
              if (result["data"][i]["products"].isEmpty && result["data"][i]["services"].isEmpty && result["data"][i]["stores"].isEmpty) continue;
              String category = result["data"][i]["category"];
              result["data"][i].remove("products");
              result["data"][i].remove("services");
              result["data"][i].remove("stores");
              favoriteData[category].add(result["data"][i]);
            }
            _prefs!.setString("favorite_data_$userId", json.encode(favoriteData));
          }
          _favoriteState = _favoriteState.update(
            favoriteData: favoriteData,
            progressState: 2,
          );
        } else {
          favoriteData = json.decode(localResult);
          Map<String, dynamic> newFavData = Map<String, dynamic>();
          favoriteData.forEach((category, data) {
            List<dynamic> newData = [];
            for (var i = 0; i < data.length; i++) {
              if (data[i]["storeId"] != null && data[i]["storeId"] != "") {
                newData.add(data[i]);
              } else {
                data[i]["isFavorite"] = false;
              }
            }
            newFavData[category] = newData;
          });

          _prefs!.setString("favorite_data_$userId", json.encode(newFavData));

          FavoriteApiProvider.backup(favoriteData: favoriteData);
          _favoriteState = _favoriteState.update(
            favoriteData: newFavData,
            progressState: 2,
          );
        }
      } catch (e) {
        _favoriteState = _favoriteState.update(
          progressState: 2,
        );
      }
    }
    if (isNotifiable) notifyListeners();
  }

  Future<void> getFavoriteData({@required String? userId, @required String? category, String? searchKey = ""}) async {
    Map<String, dynamic> favoriteObjectListData = _favoriteState.favoriteObjectListData!;
    Map<String, dynamic> favoriteObjectMetaData = _favoriteState.favoriteObjectMetaData!;
    try {
      if (favoriteObjectListData[category] == null) favoriteObjectListData[category!] = [];
      if (favoriteObjectMetaData[category] == null) favoriteObjectMetaData[category!] = Map<String, dynamic>();

      var result;

      result = await FavoriteApiProvider.getFavoriteData(
        userId: userId,
        category: category,
        searchKey: searchKey!,
        page: favoriteObjectMetaData[category].isEmpty ? 1 : (favoriteObjectMetaData[category]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          favoriteObjectListData[category].add({
            "data": result["data"]["docs"][i]["data"],
            "coupon": result["data"]["docs"][i]["coupon"],
            "store": result["data"]["docs"][i]["store"] == null ? null : result["data"]["docs"][i]["store"],
          });
        }
        result["data"].remove("docs");
        favoriteObjectMetaData[category!] = result["data"];

        _favoriteState = _favoriteState.update(
          progressState: 2,
          favoriteObjectListData: favoriteObjectListData,
          favoriteObjectMetaData: favoriteObjectMetaData,
        );
      } else {
        _favoriteState = _favoriteState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _favoriteState = _favoriteState.update(
        progressState: 2,
      );
    }
    Future.delayed(Duration(milliseconds: 300), () {
      notifyListeners();
    });
  }

  void setFavoriteData({
    @required String? storeId,
    @required String? userId,
    @required String? id,
    @required String? category,
    @required bool? isFavorite,
  }) async {
    try {
      Map<String, dynamic> favoriteData = _favoriteState.favoriteData!;

      bool isSelected = false;
      bool isUpdated = false;

      if (favoriteData[category!] == null) {
        favoriteData[category] = [];
      }

      for (var i = 0; i < favoriteData[category].length; i++) {
        if (favoriteData[category][i]["userId"] == userId &&
            favoriteData[category][i]["id"] == id &&
            favoriteData[category][i]["category"] == category) {
          isSelected = true;
          isUpdated = true;
          favoriteData[category][i]["isFavorite"] = isFavorite;
        }
      }

      if (!isSelected) {
        isUpdated = true;
        favoriteData[category].add({
          "userId": userId,
          "id": id,
          "category": category,
          "storeId": storeId,
          "isFavorite": isFavorite,
        });
      }
      _favoriteState = _favoriteState.update(
        progressState: 2,
        favoriteData: favoriteData,
        isUpdated: isUpdated,
      );

      _prefs!.setString("favorite_data_$userId", json.encode(favoriteData));
    } catch (e) {
      _favoriteState = _favoriteState.update(
        progressState: 2,
      );
    }

    notifyListeners();
  }

  void favoriteUpdateHandler() {
    if (_favoriteState.isUpdated!) {
      FavoriteApiProvider.backup(favoriteData: _favoriteState.favoriteData);
      _favoriteState = _favoriteState.update(isUpdated: false);
      notifyListeners();
    }
  }
}
