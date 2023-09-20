import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class ServiceListPageProvider extends ChangeNotifier {
  static ServiceListPageProvider of(BuildContext context, {bool listen = false}) => Provider.of<ServiceListPageProvider>(context, listen: listen);

  ServiceListPageState _serviceListPageState = ServiceListPageState.init();
  ServiceListPageState get serviceListPageState => _serviceListPageState;

  void setServiceListPageState(ServiceListPageState serviceListPageState, {bool isNotifiable = true}) {
    if (_serviceListPageState != serviceListPageState) {
      _serviceListPageState = serviceListPageState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getServiceCategories({@required List<String>? storeIds}) async {
    try {
      var result = await ServiceApiProvider.getServiceCategories(storeIds: storeIds);

      if (result["success"] && result["data"].isNotEmpty) {
        Map<String, dynamic> serviceCategoryData = _serviceListPageState.serviceCategoryData!;
        List<dynamic> serviceCategories = [
          {"category": "ALL", "serviceCount": 0}
        ];
        double totalCount = 0;
        for (var i = 0; i < result["data"].length; i++) {
          totalCount += result["data"][i]["serviceCount"];
          serviceCategories.add({
            "category": result["data"][i]["_id"],
            "serviceCount": result["data"][i]["serviceCount"],
          });
        }
        serviceCategories[0]["serviceCount"] = totalCount;
        serviceCategoryData[storeIds!.join(',')] = serviceCategories;

        _serviceListPageState = _serviceListPageState.update(
          progressState: 2,
          message: "",
          serviceCategoryData: serviceCategoryData,
        );
      } else if (result["success"] && result["data"].isEmpty) {
        _serviceListPageState = _serviceListPageState.update(
          progressState: 3,
          message: "No Data",
        );
      } else {
        _serviceListPageState = _serviceListPageState.update(
          progressState: -1,
          message: result["messsage"],
        );
      }

      notifyListeners();
    } catch (e) {
      FlutterLogs.logThis(
        tag: "service_list_page_provider",
        level: LogLevel.ERROR,
        subTag: "getServiceCategories",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  Future<void> getServiceList({@required List<String>? storeIds, @required List<String>? categories, String searchKey = ""}) async {
    Map<String, dynamic> serviceListData = _serviceListPageState.serviceListData!;
    Map<String, dynamic> serviceMetaData = _serviceListPageState.serviceMetaData!;

    String category = categories!.isNotEmpty ? categories.join("_") : "ALL";

    if (serviceListData[category] == null) serviceListData[category] = [];
    if (serviceMetaData[category] == null) serviceMetaData[category] = Map<String, dynamic>();

    try {
      var result = await ServiceApiProvider.getServiceList(
        storeIds: storeIds,
        categories: categories,
        searchKey: searchKey,
        page: serviceMetaData[category].isEmpty ? 1 : (serviceMetaData[category]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
      );

      if (result["success"]) {
        serviceListData[category].addAll(result["data"]["docs"]);
        result["data"].remove("docs");
        serviceMetaData[category] = result["data"];

        _serviceListPageState = _serviceListPageState.update(
          progressState: 2,
          message: "",
          serviceListData: serviceListData,
          serviceMetaData: serviceMetaData,
        );
      } else {
        _serviceListPageState = _serviceListPageState.update(
          progressState: 2,
          message: result["messsage"],
        );
      }
    } catch (e) {
      _serviceListPageState = _serviceListPageState.update(
        progressState: 2,
        message: e.toString(),
      );
    }

    notifyListeners();
  }
}
