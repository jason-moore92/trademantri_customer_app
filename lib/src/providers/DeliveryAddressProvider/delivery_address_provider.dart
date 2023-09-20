import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class DeliveryAddressProvider extends ChangeNotifier {
  static DeliveryAddressProvider of(BuildContext context, {bool listen = false}) => Provider.of<DeliveryAddressProvider>(context, listen: listen);

  DeliveryAddressState _deliveryAddressState = DeliveryAddressState.init();
  DeliveryAddressState get deliveryAddressState => _deliveryAddressState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setDeliveryAddressState(DeliveryAddressState deliveryAddressState, {bool isNotifiable = true}) {
    if (_deliveryAddressState != deliveryAddressState) {
      _deliveryAddressState = deliveryAddressState;
      if (isNotifiable) notifyListeners();
    }
  }

  void init({@required String? userId}) async {
    if (_deliveryAddressState.deliveryAddressData![userId] == null) {
      var result = await DeliveryAddressApiProvider.getDeliveryAddressData();
      if (result["success"]) {
        Map<String, dynamic> deliveryAddressData = Map<String, dynamic>();
        deliveryAddressData[userId!] = result["data"];
        _deliveryAddressState = _deliveryAddressState.update(
          progressState: 0,
          message: "",
          deliveryAddressData: deliveryAddressData,
        );
      }
    }
  }

  Future<void> addDeliveryAddressData({@required Map<String, dynamic>? address}) async {
    Map<String, dynamic> deliveryAddressData = json.decode(json.encode(deliveryAddressState.deliveryAddressData));

    try {
      var result = await DeliveryAddressApiProvider.addDeliveryAddress(deliveryAddressData: address);

      if (result["success"]) {
        deliveryAddressData[address!["userId"]].add(result["data"]);

        _deliveryAddressState = _deliveryAddressState.update(
          progressState: 2,
          deliveryAddressData: deliveryAddressData,
          selectedDeliveryAddress: address,
        );
      } else {
        _deliveryAddressState = _deliveryAddressState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _deliveryAddressState = _deliveryAddressState.update(
        progressState: -1,
        message: e.toString(),
      );
    }
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
