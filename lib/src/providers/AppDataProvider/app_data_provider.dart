import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/ApiDataProviders/lucky_draw_api_provider.dart';
import 'package:trapp/src/ApiDataProviders/release_history_firestore_provider.dart';
import 'package:trapp/src/entities/lucky_draw_config.dart';
import 'package:trapp/src/entities/promo_code.dart';
import 'package:trapp/src/entities/maintenance.dart';
import 'package:trapp/src/models/coupon_model.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class AppDataProvider extends ChangeNotifier {
  static AppDataProvider of(BuildContext context, {bool listen = false}) => Provider.of<AppDataProvider>(context, listen: listen);

  AppDataState _appDataState = AppDataState.init();
  AppDataState get appDataState => _appDataState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setAppDataState(AppDataState appDataState, {bool isNotifiable = true}) {
    if (_appDataState != appDataState) {
      _appDataState = appDataState;
      if (isNotifiable) notifyListeners();
    }
  }

  void init() async {
    try {
      _prefs = await SharedPreferences.getInstance();

      int distance = prefs!.getInt("distance") == null ? AppConfig.distances[0]["value"] : prefs!.getInt("distance");
      List<dynamic> savedLocationList = prefs!.getString("saved_location_list") == null ? [] : json.decode(prefs!.getString("saved_location_list")!);
      List<dynamic> recentLocationList =
          prefs!.getString("recent_location_list") == null ? [] : json.decode(prefs!.getString("recent_location_list")!);

      _appDataState = _appDataState.update(
        distance: distance,
        savedLocationList: savedLocationList,
        recentLocationList: recentLocationList,
      );
    } catch (e) {
      FlutterLogs.logThis(
        tag: "app_data_provider",
        level: LogLevel.ERROR,
        subTag: "init",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  Future<Position?> getCurrentPosition() async {
    Position position;
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      position = await Geolocator.getCurrentPosition();
      return position;
    } else {
      return null;
    }
  }

  Future<Position?> getCurrentPositionWithReq() async {
    Position position;
    var permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      position = await Geolocator.getCurrentPosition();
      return position;
    } else {
      return null;
    }
  }

  /// get store list
  Future<void> getCategoryList({
    @required int? distance,
    @required Map<String, dynamic>? currentLocation,
    String searchKey = "",
  }) async {
    List<dynamic> categoryList = await getCategoryListData(
      distance: distance!,
      currentLocation: currentLocation!,
      searchKey: searchKey,
    );

    if (categoryList.isNotEmpty) {
      _appDataState = _appDataState.update(
        categoryList: categoryList,
        currentLocation: currentLocation,
        isCategoryRequest: true,
        progressState: 2,
      );
    } else {
      _appDataState = _appDataState.update(
        progressState: 2,
        currentLocation: currentLocation,
        isCategoryRequest: true,
        categoryList: [],
      );
    }
    notifyListeners();
  }

  Future<void> getCouponsInArea({
    @required int? distance,
    @required Map<String, dynamic>? currentLocation,
  }) async {
    List<CouponModel> couponsList = await getCouponsListData(
      distance: distance!,
      currentLocation: currentLocation!,
    );

    if (couponsList.isNotEmpty) {
      _appDataState = _appDataState.update(
        couponsList: couponsList,
        isCategoryRequest: false,
        // currentLocation: currentLocation,
        // progressState: 2,
      );
      notifyListeners();
    }
    // else {
    //   _appDataState = _appDataState.update(
    //     progressState: 2,
    //     currentLocation: currentLocation,
    //     couponsList: [],
    //   );
    // }
  }

  Future<void> getActiveLuckyDraw() async {
    Map<String, dynamic> result = await LuckyDrawApiProvider.getActive();

    if (result["success"]) {
      LuckyDrawConfig activeLuckyDraw = LuckyDrawConfig.fromJson(result["data"]);
      _appDataState = _appDataState.update(
        activeLuckyDraw: activeLuckyDraw,
        isCategoryRequest: false,
        // progressState: 2,
      );
      notifyListeners();
    }
  }

  Future<void> getActivePromoCodes() async {
    Map<String, dynamic> result = await PromocodeApiProvider.getActive();

    if (result["success"]) {
      List<PromoCode> list = [];
      for (var i = 0; i < result["data"].length; i++) {
        list.add(PromoCode.fromJson(result["data"][i]));
      }
      _appDataState = _appDataState.update(
        promoCodes: list,
        isCategoryRequest: false,
        // progressState: 2,
      );
      notifyListeners();
    }
  }

  Future<List<CouponModel>> getCouponsListData({
    @required int? distance,
    @required Map<String, dynamic>? currentLocation,
  }) async {
    try {
      var result = await CouponsApiProvider.getCouponsInArea(
        lat: currentLocation!["location"]["lat"],
        lng: currentLocation["location"]["lng"],
        distance: distance!,
      );
      if (result["success"]) {
        List<CouponModel> couponsList = [];
        for (var i = 0; i < result["data"].length; i++) {
          couponsList.add(CouponModel.fromJson(result["data"][i]));
        }

        return couponsList;
      } else {
        // _appDataState = _appDataState.update(
        //   progressState: -1,
        //   message: result["message"],
        // );
        return [];
      }
    } catch (e) {
      // _appDataState = _appDataState.update(
      //   progressState: -1,
      //   message: e.toString(),
      // );
      notifyListeners();
      return [];
    }
  }

  /// get store list
  Future<List<dynamic>> getCategoryListData({
    @required int? distance,
    @required Map<String, dynamic>? currentLocation,
    String searchKey = "",
  }) async {
    // List<dynamic> categoryDataList = prefs.getString("category_data") == null ? [] : json.decode(prefs.getString("category_data"));

    // /// if the categoryData which datetime,distance and location info are the same on local is exist,
    // if (categoryDataList.isNotEmpty) {
    //   for (var i = 0; i < categoryDataList.length; i++) {
    //     Map<String, dynamic> categoryData = categoryDataList[i];
    //     if (categoryData["distance"] == distance &&
    //         categoryData["location"].toString() == currentLocation.toString() &&
    //         categoryData["searchKey"] == searchKey) {
    //       if (categoryData["date"] == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).millisecondsSinceEpoch) {
    //         return categoryData["categoryList"];
    //       } else {
    //         categoryDataList.removeAt(i);
    //         return categoryData["categoryList"];
    //       }
    //     }
    //   }
    // }

    try {
      var result = await CategoryApiProvider.getCategoryList(
        location: currentLocation!["location"],
        distance: distance,
        searchKey: searchKey,
      );
      if (result["success"]) {
        List<Map<String, dynamic>> categoryList = [];
        for (var i = 0; i < result["data"].length; i++) {
          if (result["data"][i]["category"].isEmpty) continue;
          Map<String, dynamic> categoryData = result["data"][i]["category"][0];
          categoryData["storeCount"] = result["data"][i]["storeCount"];
          categoryList.add(categoryData);
        }
        if (categoryList.isNotEmpty) {
          await _storeDistance(distance!);
          await _storeRecentLocationList(currentLocation: currentLocation);
        }

        // await _storeCategoryData({
        //   "date": DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).millisecondsSinceEpoch,
        //   "location": currentLocation,
        //   "distance": distance,
        //   "categoryList": categoryList,
        //   "searchKey": searchKey,
        // });
        return categoryList;
      } else {
        _appDataState = _appDataState.update(
          progressState: -1,
          message: result["message"],
        );
        return [];
      }
    } catch (e) {
      _appDataState = _appDataState.update(
        progressState: -1,
        message: e.toString(),
      );
      notifyListeners();
      return [];
    }
  }

  /// store current location Info and recent location list to the localstorage.
  Future<void> _storeRecentLocationList({@required Map<String, dynamic>? currentLocation}) async {
    try {
      List<dynamic> recentLocationList = prefs!.getString("recent_location_list") == null
          ? []
          : json.decode(
              prefs!.getString("recent_location_list")!,
            );

      var index = recentLocationList.indexWhere((location) => location["placeID"] == currentLocation!["placeID"]);
      if (index != -1) {
        recentLocationList.removeAt(index);
      }

      if (recentLocationList.length >= 10) {
        recentLocationList.removeRange(0, recentLocationList.length - 9);
      }
      recentLocationList.add(currentLocation);
      prefs!.setString("recent_location_list", json.encode(recentLocationList));

      _appDataState = _appDataState.update(
        recentLocationList: recentLocationList,
      );
    } catch (e) {
      FlutterLogs.logThis(
        tag: "app_data_provider",
        level: LogLevel.ERROR,
        subTag: "_storeRecentLocationList",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

/**
 * @deprecated Not using because AlertUpdate also not using
 */
  checkForUpdatesProxy({int delay = 10, String? forceResult}) async {
    _appDataState = _appDataState.update(
      appUpdateResult: "checking",
    );
    notifyListeners();

    String result = await checkForUpdates(
      delay: delay,
      forceResult: forceResult,
    );
    _appDataState = _appDataState.update(
      appUpdateResult: result,
    );
    notifyListeners();
  }

  Future<String> checkForUpdates({
    int delay = 10,
    String? forceResult,
  }) async {
    try {
      AppUpdateInfo info = await InAppUpdate.checkForUpdate();
      FlutterLogs.logInfo(
        "app_data_provider",
        "checkForUpdates",
        info.toString(),
      );

      if (forceResult != null) {
        await Future.delayed(
          Duration(
            seconds: delay,
          ),
        );
        return forceResult;
      }
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        int latestNumber = info.availableVersionCode!;
        Map<String, dynamic>? releaseData = await ReleaseHistoryFirestoreProvider.getReleaseByNumber(
          number: latestNumber,
        );
        FlutterLogs.logInfo(
          "app_data_provider",
          "onupdateAvailable",
          releaseData.toString(),
        );
        bool forceupdate = true;
        if (releaseData != null) {
          forceupdate = releaseData["forceUpdate"];
        }

        if (forceupdate) {
          return "do_immediate_update";
        } else {
          return "do_flexible_update";
        }
      }

      if (info.updateAvailability == UpdateAvailability.developerTriggeredUpdateInProgress) {
        if (info.immediateUpdateAllowed) {
          return "do_immediate_update";
        } else {
          return "complete_flexible_update";
        }
      }

      return "navigate_walkthrough";
    } catch (e) {
      FlutterLogs.logThis(
        tag: "app_data_provider",
        level: LogLevel.ERROR,
        subTag: "checkForUpdates",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
      return "navigate_walkthrough";
    }
  }

  Future<Maintenance?> checkForMaintenance() async {
    dynamic maintenanceResponse = await UserApiProvider.getMaintenance();
    if (maintenanceResponse["status"]) {
      return Maintenance.fromJson(maintenanceResponse["data"]);
    }
    return null;
  }

  Future<void> _storeDistance(int distance) async {
    await prefs!.setInt("distance", distance);
    _appDataState = _appDataState.update(
      distance: distance,
    );
  }

  Future<void> _storeCategoryData(Map<String, dynamic> categoryData) async {
    List<dynamic> categoryDataList = prefs!.getString("category_data") == null ? [] : json.decode(prefs!.getString("category_data")!);
    categoryDataList.add(categoryData);
    await prefs!.setString("category_data", json.encode(categoryDataList));
  }

  Future<void> saveSavedLocation({@required Map<String, dynamic>? currentLocation}) async {
    List<dynamic> savedLocationList = prefs!.getString("saved_location_list") == null
        ? []
        : json.decode(
            prefs!.getString("saved_location_list")!,
          );
    var index = savedLocationList.indexWhere((location) => location["placeID"] == currentLocation!["placeID"]);
    if (index != -1) {
      savedLocationList[index] = currentLocation;
    } else {
      savedLocationList.add(currentLocation);
    }
    prefs!.setString("saved_location_list", json.encode(savedLocationList));

    _appDataState = _appDataState.update(
      savedLocationList: savedLocationList,
    );
    notifyListeners();
  }

  void initProviderHandler(BuildContext context) {
    try {
      AppDataProvider.of(context).setAppDataState(
        AppDataProvider.of(context).appDataState.update(currentLocation: Map<String, dynamic>()),
        isNotifiable: false,
      );
      AuthProvider.of(context).setAuthState(AuthState.init(), isNotifiable: false);
      StorePageProvider.of(context).setStorePageState(StorePageState.init(), isNotifiable: false);
      CartProvider.of(context).setCartState(CartState.init(), isNotifiable: false);
      FavoriteProvider.of(context).setFavoriteState(FavoriteState.init(), isNotifiable: false);
      DeliveryAddressProvider.of(context).setDeliveryAddressState(DeliveryAddressState.init(), isNotifiable: false);
      PromocodeProvider.of(context).setPromocodeState(PromocodeState.init(), isNotifiable: false);
      OrderProvider.of(context).setOrderState(OrderState.init(), isNotifiable: false);
      ContactUsRequestProvider.of(context).setContactUsRequestState(ContactUsRequestState.init(), isNotifiable: false);
      NotificationProvider.of(context).setNotificationState(NotificationState.init(), isNotifiable: false);
      RewardPointProvider.of(context).setRewardPointState(RewardPointState.init(), isNotifiable: false);
      ReverseAuctionProvider.of(context).setReverseAuctionState(ReverseAuctionState.init(), isNotifiable: false);
      BargainRequestProvider.of(context).setBargainRequestState(BargainRequestState.init(), isNotifiable: false);
      DeliveryPartnerProvider.of(context).setDeliveryPartnerState(DeliveryPartnerState.init(), isNotifiable: false);
      ProductItemReviewProvider.of(context).setProductItemReviewState(ProductItemReviewState.init(), isNotifiable: false);
      ReferralRewardU2UOffersProvider.of(context).setReferralRewardU2UOffersState(ReferralRewardU2UOffersState.init(), isNotifiable: false);
      ReferralRewardU2SOffersProvider.of(context).setReferralRewardU2SOffersState(ReferralRewardU2SOffersState.init(), isNotifiable: false);
      PaymentLinkProvider.of(context).setPaymentLinkState(PaymentLinkState.init(), isNotifiable: false);
      StoreJobPostingsProvider.of(context).setStoreJobPostingsState(StoreJobPostingsState.init(), isNotifiable: false);
      AppliedJobProvider.of(context).setAppliedJobState(AppliedJobState.init(), isNotifiable: false);
      InvoicesProvider.of(context).setInvoicesState(InvoicesState.init(), isNotifiable: false);
      StoreCategoriesProvider.of(context).setStoreCategoriesState(StoreCategoriesState.init(), isNotifiable: false);
      SearchProvider.of(context).setSearchState(SearchState.init(), isNotifiable: false);
      AppointmentProvider.of(context).setAppointmentState(AppointmentState.init(), isNotifiable: false);
      BookAppointmentProvider.of(context).setBookAppointmentState(BookAppointmentState.init(), isNotifiable: false);
    } catch (e) {
      FlutterLogs.logThis(
        tag: "app_data_provider",
        level: LogLevel.ERROR,
        subTag: "initProviderHandler",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }
}
