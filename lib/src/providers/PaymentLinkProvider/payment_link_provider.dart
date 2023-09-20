import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class PaymentLinkProvider extends ChangeNotifier {
  static PaymentLinkProvider of(BuildContext context, {bool listen = false}) => Provider.of<PaymentLinkProvider>(context, listen: listen);

  PaymentLinkState _paymentLinkState = PaymentLinkState.init();
  PaymentLinkState get paymentLinkState => _paymentLinkState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setPaymentLinkState(PaymentLinkState paymentLinkState, {bool isNotifiable = true}) {
    if (_paymentLinkState != paymentLinkState) {
      _paymentLinkState = paymentLinkState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getNotificationData({@required String? userId, String searchKey = ""}) async {
    List<dynamic> paymentLinkListData = _paymentLinkState.paymentLinkListData!;
    Map<String, dynamic> paymentLinkMetaData = _paymentLinkState.paymentLinkMetaData!;
    try {
      paymentLinkListData = [];
      paymentLinkMetaData = Map<String, dynamic>();

      var result;

      result = await PaymentLinkApiProvider.getPaymentLinks(
        userId: userId,
        searchKey: searchKey,
        page: paymentLinkMetaData.isEmpty ? 1 : (paymentLinkMetaData["nextPage"] ?? 1),
      );

      if (result["success"]) {
        List<dynamic> paymentLinkData = [];
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          paymentLinkData.add(
            {"index": paymentLinkListData.length, "data": result["data"]["docs"][i]},
          );
          paymentLinkListData.add(result["data"]["docs"][i]);
        }
        getPaymentStatus(paymentLinkData);
        result["data"].remove("docs");
        paymentLinkMetaData = result["data"];

        _paymentLinkState = _paymentLinkState.update(
          progressState: 2,
          paymentLinkListData: paymentLinkListData,
          paymentLinkMetaData: paymentLinkMetaData,
        );
      } else {
        _paymentLinkState = _paymentLinkState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _paymentLinkState = _paymentLinkState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }

  void getPaymentStatus(List<dynamic> paymentLinkData) async {
    for (var i = 0; i < paymentLinkData.length; i++) {
      if (paymentLinkData[i]["data"]["paymentData"]["status"] != "paid") {
        PaymentLinkApiProvider.getPaymentData(
          id: paymentLinkData[i]["data"]["paymentData"]["id"],
          paymentLinkId: paymentLinkData[i]["data"]["_id"],
          status: paymentLinkData[i]["data"]["paymentData"]["status"],
        ).then((result) {
          try {
            if (result["success"]) {
              List<dynamic> paymentLinkListData = _paymentLinkState.paymentLinkListData!;
              paymentLinkListData[paymentLinkData[i]["index"]]["paymentData"] = result["data"];
              _paymentLinkState = _paymentLinkState.update(
                paymentLinkListData: paymentLinkListData,
              );
              notifyListeners();
            }
          } catch (e) {
            FlutterLogs.logThis(
              tag: "payment_link_provider",
              level: LogLevel.ERROR,
              subTag: "getPaymentStatus",
              exception: e is Exception ? e : null,
              error: e is Error ? e : null,
              errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
            );
          }
        });
      }
    }
  }
}
