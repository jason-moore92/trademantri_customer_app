import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class CategoryProvider extends ChangeNotifier {
  static CategoryProvider of(BuildContext context, {bool listen = false}) => Provider.of<CategoryProvider>(context, listen: listen);

  CategoryState _categoryState = CategoryState.init();
  CategoryState get categoryState => _categoryState;

  void setCategoryState(CategoryState categoryState, {bool isNotifiable = true}) {
    if (_categoryState != categoryState) {
      _categoryState = categoryState;
      if (isNotifiable) notifyListeners();
    }
  }

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  Future<void> getCategoryAll({bool isNotifiable = true}) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    var result = _prefs!.getString("categryAll");
    var categoryData;
    if (result != null) {
      categoryData = json.decode(result);
      if (DateTime.fromMillisecondsSinceEpoch(categoryData["date"]).difference(DateTime.now()).inHours < 24) {
        _categoryState = _categoryState.update(
          progressState: 2,
          message: "",
          categoryData: categoryData["data"],
        );

        if (isNotifiable) notifyListeners();

        return;
      }
    }

    var result1 = await CategoryApiProvider.getCategoryAll();
    if (result1["success"]) {
      Map<String, dynamic> categoryData = Map<String, dynamic>();
      for (var i = 0; i < result1["data"].length; i++) {
        String type = result1["data"][i]["catgeorybusinessType"];
        if (categoryData[type] == null) categoryData[type] = [];
        categoryData[type].add(result1["data"][i]);
      }
      _prefs!.setString(
        "categryAll",
        json.encode({"date": DateTime.now().millisecondsSinceEpoch, "data": categoryData}),
      );

      _categoryState = _categoryState.update(
        progressState: 2,
        message: "",
        categoryData: categoryData,
      );
    } else {
      _categoryState = _categoryState.update(
        progressState: -1,
        message: result1["message"],
        categoryData: Map<String, dynamic>(),
      );
    }

    if (isNotifiable) notifyListeners();
  }
}
