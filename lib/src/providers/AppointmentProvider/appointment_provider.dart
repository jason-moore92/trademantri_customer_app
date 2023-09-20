import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class AppointmentProvider extends ChangeNotifier {
  static AppointmentProvider of(BuildContext context, {bool listen = false}) => Provider.of<AppointmentProvider>(context, listen: listen);

  AppointmentState _appointmentState = AppointmentState.init();
  AppointmentState get appointmentState => _appointmentState;

  void setAppointmentState(AppointmentState appointmentState, {bool isNotifiable = true}) {
    if (_appointmentState != appointmentState) {
      _appointmentState = appointmentState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getAppointments({
    @required String? storeId,
    @required String? status,
    String searchKey = "",
  }) async {
    Map<String, dynamic>? appointmentsData = _appointmentState.appointmentsData;
    Map<String, dynamic>? appointmentsMetaData = _appointmentState.appointmentsMetaData;
    try {
      if (appointmentsData![status] == null) appointmentsData[status!] = [];
      if (appointmentsMetaData![status] == null) appointmentsMetaData[status!] = Map<String, dynamic>();

      var result;

      result = await AppointmentApiProvider.getAppointments(
        storeId: storeId,
        searchKey: searchKey,
        page: appointmentsMetaData[status].isEmpty ? 1 : (appointmentsMetaData[status]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          appointmentsData[status].add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        appointmentsMetaData[status!] = result["data"];

        _appointmentState = _appointmentState.update(
          progressState: 2,
          appointmentsData: appointmentsData,
          appointmentsMetaData: appointmentsMetaData,
        );
      } else {
        _appointmentState = _appointmentState.update(
          progressState: -1,
          message: result["message"] ?? "Something was wrong",
        );
      }
    } catch (e) {
      _appointmentState = _appointmentState.update(
        progressState: -2,
        message: "Something was wrong",
      );
    }
    notifyListeners();
  }
}
