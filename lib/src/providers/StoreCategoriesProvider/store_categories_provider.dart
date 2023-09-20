import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/providers/AppDataProvider/index.dart';

import 'index.dart';

class StoreCategoriesProvider extends ChangeNotifier {
  static StoreCategoriesProvider of(BuildContext context, {bool listen = false}) => Provider.of<StoreCategoriesProvider>(context, listen: listen);

  StoreCategoriesState _searchState = StoreCategoriesState.init();
  StoreCategoriesState get searchState => _searchState;

  void setStoreCategoriesState(StoreCategoriesState searchState, {bool isNotifiable = true}) {
    if (_searchState != searchState) {
      _searchState = searchState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getStoreList({
    @required String? categoryId,
    @required Map<String, dynamic>? location,
    @required int? distance,
  }) async {
    Map<String, dynamic> storeMetaData = _searchState.storeMetaData!;
    Map<String, dynamic> storeList = _searchState.storeList!;

    if (storeMetaData[categoryId] == null) storeMetaData[categoryId!] = Map<String, dynamic>();
    if (storeList[categoryId] == null) storeList[categoryId!] = [];

    // if (_searchState.storeMetaData[categoryId].isNotEmpty && _searchState.storeMetaData[categoryId]["nextPage"] == null) {
    //   _searchState = _searchState.update(
    //     progressState: 2,
    //     message: "",
    //     storeList: storeList,
    //     storeMetaData: storeMetaData,
    //   );
    //   notifyListeners();
    //   return;
    // }

    var result = await StoreApiProvider.getStoreList(
      categoryId: categoryId,
      location: location,
      distance: distance,
      page: storeMetaData[categoryId]["nextPage"] ?? 1,
    );

    if (result["success"]) {
      storeList[categoryId].addAll(result["data"]["docs"]);
      result["data"].remove("docs");
      storeMetaData[categoryId!] = result["data"];

      _searchState = _searchState.update(
        progressState: 2,
        message: "",
        storeList: storeList,
        storeMetaData: storeMetaData,
      );
    } else {
      _searchState = _searchState.update(
        progressState: -1,
        message: result["messsage"],
      );
    }

    notifyListeners();
  }

  /// get store list
  void getCategoryList({
    @required AppDataProvider? appDataProvider,
    @required int? distance,
    @required String? userId,
    @required Map<String, dynamic>? currentLocation,
    String searchKey = "",
  }) async {
    try {
      List<dynamic> categoryList = await appDataProvider!.getCategoryListData(
        distance: distance,
        currentLocation: currentLocation,
        searchKey: searchKey,
      );

      List<dynamic> _categorySearchKeywords = appDataProvider.prefs!.getString("category_search_keywords") == null
          ? []
          : json.decode(appDataProvider.prefs!.getString("category_search_keywords")!);
      if (categoryList.isNotEmpty && searchKey != "" && (_categorySearchKeywords.indexWhere((str) => str == searchKey) == -1)) {
        if (_categorySearchKeywords.length >= 5) {
          _categorySearchKeywords.removeRange(0, _categorySearchKeywords.length - 4);
        }
        _categorySearchKeywords.add(searchKey);
        await appDataProvider.prefs!.setString("category_search_keywords", json.encode(_categorySearchKeywords));
      }

      _searchState = _searchState.update(
        progressState: 2,
        categoryList: categoryList,
      );

      notifyListeners();
    } catch (e) {
      FlutterLogs.logThis(
        tag: "store_categories_provider",
        level: LogLevel.ERROR,
        subTag: "getCategoryList",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }
}
