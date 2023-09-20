import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class CartProvider extends ChangeNotifier {
  static CartProvider of(BuildContext context, {bool listen = false}) => Provider.of<CartProvider>(context, listen: listen);

  CartState _cartState = CartState.init();
  CartState get cartState => _cartState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setCartState(CartState cartState, {bool isNotifiable = true}) {
    if (_cartState != cartState) {
      _cartState = cartState;
      if (isNotifiable) notifyListeners();
    }
  }

  void init({@required String? userId, @required String? lastDeviceToken, bool isNotifiable = true}) async {
    try {
      if (_cartState.progressState == 0) {
        _cartState = _cartState.update(progressState: 1);

        if (_prefs == null) _prefs = await SharedPreferences.getInstance();

        var localResult = _prefs!.getString("cart_data_$userId");
        if (localResult == null) {
          var result = await CartApiProvider.getCartData();
          if (result["success"]) {
            _getCartData(userId!, result);
            return;
          } else {
            _cartState = _cartState.update(
              progressState: 2,
            );
          }
        } else {
          Map<String, dynamic> cartData = json.decode(localResult);

          json.decode(localResult).forEach((storeId, cart) {
            if (cart["products"].isEmpty && cart["services"].isEmpty) {
              cartData.remove(storeId);
            }
          });

          var result = await CartApiProvider.backup(
            cartData: cartData,
            lastDeviceToken: lastDeviceToken,
            userId: userId,
          );
          if (result["success"]) {
            _getCartData(userId!, result);
            return;
          } else {
            _cartState = _cartState.update(
              progressState: 2,
              message: "",
              cartData: cartData,
            );
          }
        }
      }
    } catch (e) {
      _cartState = _cartState.update(
        progressState: 2,
      );
      FlutterLogs.logThis(
        tag: "cart_provider",
        subTag: "init",
        level: LogLevel.ERROR,
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
    if (isNotifiable) notifyListeners();
  }

  void _getCartData(String userId, Map<String, dynamic> result) async {
    Map<String, dynamic> cartData = Map<String, dynamic>();
    for (var i = 0; i < result["data"].length; i++) {
      List<dynamic> products = [];
      for (var j = 0; j < result["data"][i]["products"].length; j++) {
        result["data"][i]["products"][j].remove("_id");
        for (var k = 0; k < result["data"][i]["productList"].length; k++) {
          if (result["data"][i]["products"][j]["id"] == result["data"][i]["productList"][k]["_id"]) {
            result["data"][i]["products"][j]["data"] = result["data"][i]["productList"][k];
            products.add(result["data"][i]["products"][j]);
            break;
          }
        }
      }
      result["data"][i].remove("productList");
      result["data"][i]["products"] = products;

      List<dynamic> services = [];
      for (var j = 0; j < result["data"][i]["services"].length; j++) {
        result["data"][i]["services"][j].remove("_id");
        for (var k = 0; k < result["data"][i]["serviceList"].length; k++) {
          if (result["data"][i]["services"][j]["id"] == result["data"][i]["serviceList"][k]["_id"]) {
            result["data"][i]["services"][j]["data"] = result["data"][i]["serviceList"][k];
            services.add(result["data"][i]["services"][j]);
            break;
          }
        }
      }
      result["data"][i].remove("serviceList");
      result["data"][i]["services"] = services;

      cartData[result["data"][i]["storeId"]] = result["data"][i];
    }
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs!.setString("cart_data_$userId", json.encode(cartData));

    _cartState = _cartState.update(
      progressState: 2,
      message: "",
      cartData: cartData,
    );
    notifyListeners();
  }

  bool setCartData({
    @required StoreModel? storeModel,
    @required String? storeId,
    @required String? userId,
    @required Map<String, dynamic>? objectData,
    @required String? category,
    @required int? orderQuantity,
    @required String? lastDeviceToken,
  }) {
    try {
      Map<String, dynamic> cartData = json.decode(json.encode(_cartState.cartData));
      if (cartData.isEmpty) cartData = Map<String, dynamic>();
      if (cartData[storeId] == null) cartData[storeId!] = Map<String, dynamic>();
      if (cartData[storeId]["products"] == null) cartData[storeId]["products"] = [];
      if (cartData[storeId]["services"] == null) cartData[storeId]["services"] = [];

      cartData[storeId]["storeId"] = cartData[storeId]["storeId"] ?? storeId;
      cartData[storeId]["userId"] = cartData[storeId]["userId"] ?? userId;
      cartData[storeId]["status"] = cartData[storeId]["status"] ?? "";
      cartData[storeId]["store"] = cartData[storeId]["store"] ?? storeModel!.toJson();
      cartData[storeId]["lastDeviceToken"] = lastDeviceToken;

      bool _isSelected = false;
      bool isUpdated = false;
      for (var i = 0; i < cartData[storeId][category].length; i++) {
        if (cartData[storeId][category][i]["data"]["_id"] == objectData!["_id"]) {
          if (orderQuantity! <= 0) {
            cartData[storeId][category].removeAt(i);
            _isSelected = true;
            isUpdated = true;
            break;
          } else {
            if (cartData[storeId][category][i]["orderQuantity"] != orderQuantity) {
              cartData[storeId]["updatedAt"] = DateTime.now().toUtc().toIso8601String();
              isUpdated = true;
            }

            cartData[storeId][category][i]["orderQuantity"] = orderQuantity;
            cartData[storeId]["updatedAt"] = DateTime.now().toUtc().toIso8601String();
            _isSelected = true;
            break;
          }
        }
      }

      if (!_isSelected) {
        isUpdated = true;
        cartData[storeId][category].add({
          "orderQuantity": orderQuantity,
          "data": objectData,
        });
        cartData[storeId]["updatedAt"] = DateTime.now().toUtc().toIso8601String();
      }

      // if (cartData[storeId]["products"].isEmpty && cartData[storeId]["services"].isEmpty) {
      //   cartData.remove(storeId);
      // }

      Map<String, dynamic> sortedCartData = Map<String, dynamic>();

      sortedCartData[storeId!] = cartData[storeId];

      cartData.forEach((otherStoreID, cartData) {
        if (storeId != otherStoreID) {
          sortedCartData[otherStoreID] = cartData;
        }
      });

      _cartState = _cartState.update(
        progressState: 2,
        cartData: sortedCartData,
        isUpdated: isUpdated,
      );

      _prefs!.setString("cart_data_$userId", json.encode(cartData));

      notifyListeners();
      return true;
    } catch (e) {
      _cartState = _cartState.update(
        progressState: 2,
      );
      notifyListeners();
      return false;
    }
  }

  void removePlacedOrderdedCart({@required String? storeId, @required String? userId, @required String? lastDeviceToken}) async {
    Map<String, dynamic> cartData = json.decode(json.encode(_cartState.cartData));
    cartData[storeId]["status"] = "placed_order";
    CartApiProvider.backup(
      cartData: cartData,
      lastDeviceToken: lastDeviceToken,
      userId: userId,
    );
    cartData.remove(storeId);
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs!.setString("cart_data_$userId", json.encode(cartData));
    _cartState = _cartState.update(
      progressState: 2,
      cartData: cartData,
      isUpdated: false,
    );
    notifyListeners();
  }

  void cartUpdateHandler({@required String? fcmToken, @required String? userId}) {
    if (_cartState.isUpdated!) {
      CartApiProvider.backup(
        cartData: _cartState.cartData,
        lastDeviceToken: fcmToken,
        userId: userId,
      );
      _cartState = _cartState.update(isUpdated: false);
      notifyListeners();
    }
  }
}
