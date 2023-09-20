import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/helpers/encrypt.dart';
import 'package:trapp/src/helpers/price_functions.dart';
import 'package:random_string/random_string.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class OrderProvider extends ChangeNotifier {
  static OrderProvider of(BuildContext context, {bool listen = false}) => Provider.of<OrderProvider>(context, listen: listen);

  OrderState _orderState = OrderState.init();
  OrderState get orderState => _orderState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setOrderState(OrderState orderState, {bool isNotifiable = true}) {
    if (_orderState != orderState) {
      _orderState = orderState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> addOrder({
    @required OrderModel? orderModel,
    @required String? category,
    @required String? status,
  }) async {
    // orderModel!.cashOnDelivery = false;
    orderModel = OrderModel.copy(orderModel!);
    try {
      // bool haveCustomProduct = false;
      // for (var i = 0; i < orderModel.products!.length; i++) {
      //   if (orderModel.products![i].productModel!.id == "") {
      //     // newData["name"] = orderModel.products![i]["data"]["name"];
      //     // newData["orderQuantity"] = orderModel.products![i]["orderQuantity"];
      //     // orderModel.products![i] = newData;
      //     haveCustomProduct = true;
      //   }
      // }

      // bool haveCustomService = false;
      // for (var i = 0; i < orderModel.services!.length; i++) {
      //   if (orderModel.services![i].serviceModel!.id == null) {
      //     // newData["name"] = orderModel.services![i]["data"]["name"];
      //     // newData["orderQuantity"] = orderModel.services![i]["orderQuantity"];
      //     // orderModel.services![i] = newData;
      //     haveCustomService = true;
      //   }
      // }

      // if (haveCustomService || haveCustomService) {
      //   // orderModel["productPriceForAllOrderQuantityBeforeTax"] = 0;
      //   // orderModel["productPriceForAllOrderQuantityAfterTax"] = 0;
      //   // orderModel["servicePriceForAllOrderQuantityBeforeTax"] = 0;
      //   // orderModel["servicePriceForAllOrderQuantityAfterTax"] = 0;
      //   // orderModel.paymentDetail = {
      //   //   "promocode": orderModel.paymentDetail["promocode"],
      //   //   "distance": orderModel.paymentDetail["distance"],
      //   //   "totalQuantity": orderModel.paymentDetail["totalQuantity"],
      //   //   "totalOriginPrice": 0,
      //   //   "totalPrice": 0,
      //   //   "deliveryCargeBeforeDiscount": 0,
      //   //   "deliveryCargeAfterDiscount": 0,
      //   //   "deliveryDiscount": 0,
      //   //   "tip": 0,
      //   //   "totalTax": 0,
      //   //   "totalTaxBeforeDiscount": 0,
      //   //   "toPay": 0,
      //   // };
      // }

      orderModel.status = status;
      orderModel.category = category;
      orderModel.orderId = "TM-" + randomAlphaNumeric(12);

      if (orderModel.products!.isEmpty && orderModel.services!.isNotEmpty) {
        orderModel.orderType = "Service";
      }

      /// --- tax Tyepe
      if (orderModel.orderType == "Pickup") {
        orderModel.paymentDetail!.taxType = "SGST";
      } else if (orderModel.orderType == "Delivery" &&
          orderModel.deliveryAddress!.address!.state.toString().toLowerCase() == orderModel.storeModel!.state!.toString().toLowerCase()) {
        orderModel.paymentDetail!.taxType = "SGST";
      } else if (orderModel.orderType == "Delivery" &&
          orderModel.deliveryAddress!.address!.state.toString().toLowerCase() != orderModel.storeModel!.state!.toString().toLowerCase()) {
        orderModel.paymentDetail!.taxType = "IGST";
      }

      if (orderModel.paymentDetail!.totalTaxAfterDiscount! > 0) {
        orderModel.paymentDetail!.taxBreakdown = [
          {"type": "CGST", "value": (orderModel.paymentDetail!.totalTaxAfterDiscount! / 2).toStringAsFixed(2)},
          {"type": orderModel.paymentDetail!.taxType!, "value": (orderModel.paymentDetail!.totalTaxAfterDiscount! / 2).toStringAsFixed(2)}
        ];
      }
      ///////////////////
      if (orderModel.redeemRewardData == null || orderModel.redeemRewardData!["sumRewardPoint"] == null) {
        orderModel.redeemRewardData = Map<String, dynamic>();
        orderModel.redeemRewardData!["sumRewardPoint"] = 0;
        orderModel.redeemRewardData!["redeemRewardValue"] = 0;
        orderModel.redeemRewardData!["redeemRewardPoint"] = 0;
        orderModel.redeemRewardData!["tradeSumRewardPoint"] = 0;
        orderModel.redeemRewardData!["tradeRedeemRewardPoint"] = 0;
        orderModel.redeemRewardData!["tradeRedeemRewardValue"] = 0;
      }
      ////

      /// order steps
      if (orderModel.orderType == OrderType.delivery) {
        orderModel.orderHistorySteps = [
          {"text": "Order Created"},
        ];
        if (orderModel.cashOnDelivery!)
          orderModel.orderFutureSteps = [
            {"text": "Order Accepted"},
            {"text": "Delivery Ready"},
            {"text": "Items Picked"},
            {"text": "Delivery done"},
          ];
        else
          orderModel.orderFutureSteps = [
            {"text": "Order Accepted"},
            {"text": "Order Paid"},
            {"text": "Delivery Ready"},
            {"text": "Items Picked"},
            {"text": "Delivery done"},
          ];
      } else if (orderModel.orderType == OrderType.pickup) {
        orderModel.orderHistorySteps = [
          {"text": "Order Created"},
        ];
        if (orderModel.payAtStore!)
          orderModel.orderFutureSteps = [
            {"text": "Order Accepted"},
            {"text": "Pickup Ready"},
            {"text": "Completed"},
          ];
        else
          orderModel.orderFutureSteps = [
            {"text": "Order Accepted"},
            {"text": "Order Paid"},
            {"text": "Pickup Ready"},
            {"text": "Completed"},
          ];
      }
      /////////////////////

      var result = await OrderApiProvider.addOrder(
        orderData: orderModel.toJson(),
        qrCode: Encrypt.encryptString("Order_${orderModel.orderId}_StoreId-${orderModel.storeModel!.id}_UserId-${orderModel.userModel!.id}"),
      );

      if (result["success"]) {
        OrderModel newOrderModel = OrderModel.fromJson(result["data"]);
        newOrderModel.storeModel = orderModel.storeModel;
        newOrderModel.userModel = orderModel.userModel;

        _orderState = _orderState.update(
          progressState: 2,
          newOrderModel: newOrderModel,
        );
      } else {
        _orderState = _orderState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _orderState = _orderState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    notifyListeners();
  }

/**
 * @Deprecated
 */
  Future<String?> generateUPI({
    @required String? orderId,
    @required String? storeId,
  }) async {
    try {
      var result;

      result = await OrderApiProvider.generateUPI(
        storeId: storeId,
        orderId: orderId,
      );

      if (result["success"]) {
        return result["intent"];
      } else {
        _orderState = _orderState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _orderState = _orderState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>?> paymentDetails({
    @required String? provider,
    @required String? orderId,
    @required String? storeId,
  }) async {
    try {
      var result;

      result = await OrderApiProvider.paymentDetails(
        provider: provider,
        storeId: storeId,
        orderId: orderId,
      );

      if (result["success"]) {
        return result["data"];
      } else {
        _orderState = _orderState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _orderState = _orderState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>?> payment({
    @required String? provider,
    @required String? orderId,
    @required String? storeId,
    @required Map<String, dynamic>? upiResponse,
  }) async {
    try {
      var result;

      result = await OrderApiProvider.payment(
        provider: provider,
        storeId: storeId,
        orderId: orderId,
        upiResponse: upiResponse,
      );

      return result;
    } catch (e) {
      _orderState = _orderState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }

  Future<void> getOrderData({@required String? userId, @required String? status, String searchKey = ""}) async {
    Map<String, dynamic> orderListData = _orderState.orderListData!;
    Map<String, dynamic> orderMetaData = _orderState.orderMetaData!;
    try {
      if (orderListData[status] == null) orderListData[status!] = [];
      if (orderMetaData[status] == null) orderMetaData[status!] = Map<String, dynamic>();

      var result;

      result = await OrderApiProvider.getOrderData(
        userId: userId,
        status: status,
        searchKey: searchKey,
        page: orderMetaData[status].isEmpty ? 1 : (orderMetaData[status]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          orderListData[status].add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        orderMetaData[status!] = result["data"];

        _orderState = _orderState.update(
          progressState: 2,
          orderListData: orderListData,
          orderMetaData: orderMetaData,
        );
      } else {
        _orderState = _orderState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _orderState = _orderState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }

  Future<dynamic> updateOrderData({
    @required OrderModel? orderModel,
    @required String? status,
    bool changedStatus = true,
    String signature = "",
  }) async {
    /// order_accepted
    if (status == AppConfig.orderStatusData[2]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Order Accepted"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Order Accepted");
    }

    /// order_paid
    if (status == AppConfig.orderStatusData[3]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Order Paid"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Order Paid");
    }

    /// pickup_ready
    if (status == AppConfig.orderStatusData[4]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Pickup Ready"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Pickup Ready");
    }

    /// delivery_ready
    if (status == AppConfig.orderStatusData[5]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Delivery Ready"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Delivery Ready");
    }

    /// delivered
    if (status == AppConfig.orderStatusData[6]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Delivery done"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Delivery done");
    }

    /// order_cancelled
    if (status == AppConfig.orderStatusData[7]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Order Cancelled"});
      orderModel.orderFutureSteps = [];
    }

    /// order_rejected
    if (status == AppConfig.orderStatusData[8]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Order Rejected"});
      orderModel.orderFutureSteps = [];
    }

    /// order_completed
    if (status == AppConfig.orderStatusData[9]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Order Completed"});
      orderModel.orderFutureSteps = [];
    }

    if (status == AppConfig.orderStatusData[2]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Order Accepted"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Order Accepted");
    }

    var result = await OrderApiProvider.updateOrderData(
      orderData: orderModel!.toJson(),
      status: status,
      changedStatus: changedStatus,
      signature: signature,
    );
    if (result["success"]) {
      _orderState = _orderState.update(
        progressState: 1,
        orderListData: Map<String, dynamic>(),
        orderMetaData: Map<String, dynamic>(),
      );
    }

    return result;
  }
}
