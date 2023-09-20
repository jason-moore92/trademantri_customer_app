import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class CouponListProvider extends ChangeNotifier {
  static CouponListProvider of(BuildContext context, {bool listen = false}) => Provider.of<CouponListProvider>(context, listen: listen);

  CouponListState _couponState = CouponListState.init();
  CouponListState get couponState => _couponState;

  void setCouponListState(CouponListState couponState, {bool isNotifiable = true}) {
    if (_couponState != couponState) {
      _couponState = couponState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getCouponListData({
    @required String? storeId,
    String? userId,
    List<dynamic>? productCategories,
    List<dynamic>? serviceCategories,
    List<dynamic>? productIds,
    List<dynamic>? serviceIds,
    @required String? status,
    String searchKey = "",
  }) async {
    Map<String, dynamic>? couponListData = _couponState.couponListData;
    Map<String, dynamic>? couponMetaData = _couponState.couponMetaData;
    try {
      if (couponListData![status] == null) couponListData[status!] = [];
      if (couponMetaData![status] == null) couponMetaData[status!] = Map<String, dynamic>();

      var result;

      result = await CouponsApiProvider.getCouponList(
        storeId: storeId,
        userId: userId,
        status: status,
        productCategories: productCategories,
        serviceCategories: serviceCategories,
        productIds: productIds,
        serviceIds: serviceIds,
        searchKey: searchKey,
        page: couponMetaData[status].isEmpty ? 1 : (couponMetaData[status]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          couponListData[status].add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        couponMetaData[status!] = result["data"];

        _couponState = _couponState.update(
          progressState: 2,
          couponListData: couponListData,
          couponMetaData: couponMetaData,
        );
      } else {
        _couponState = _couponState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _couponState = _couponState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }
}
