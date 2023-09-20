import 'package:flutter/material.dart';
import 'package:trapp/src/models/store_model.dart';

class StoreTimeValidation {
  static bool validate({@required DateTime? dateTime, StoreModel? storeModel}) {
    if (storeModel!.profile!["hours"] == null || storeModel.profile!["hours"].isEmpty) return true;

    /// holiday validation
    if (storeModel.profile!["holidays"] != null && storeModel.profile!["holidays"].isNotEmpty) {
      for (var i = 0; i < storeModel.profile!["holidays"].length; i++) {
        DateTime holiday = DateTime.tryParse(storeModel.profile!["holidays"][i])!.toLocal();
        if (holiday.year == DateTime.now().year && holiday.month == DateTime.now().month && holiday.day == DateTime.now().day) {
          return false;
        }
      }
    }

    bool? enable;
    String? week;
    bool isToday = false;

    switch (dateTime!.weekday) {
      case 1:
        week = "monday";
        break;
      case 2:
        week = "tuesday";
        break;
      case 3:
        week = "wednesday";
        break;
      case 4:
        week = "thursday";
        break;
      case 5:
        week = "friday";
        break;
      case 6:
        week = "saturday";
        break;
      case 7:
        week = "sunday";
        break;
      default:
    }

    if (dateTime.year == DateTime.now().year && dateTime.month == DateTime.now().month && dateTime.day == DateTime.now().day) {
      isToday = true;
    }

    for (var i = 0; i < storeModel.profile!["hours"].length; i++) {
      if (storeModel.profile!["hours"][i]["day"].toString().toLowerCase() == week) {
        enable = storeModel.profile!["hours"][i]["isWorkingDay"];
        if (isToday && enable!) {
          /// closingTime validation
          DateTime closingTime = DateTime.parse(storeModel.profile!["hours"][i]["closingTime"]);
          if (closingTime.isUtc) closingTime = closingTime.toLocal();
          closingTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, closingTime.hour, closingTime.minute);
          if (DateTime.now().add(Duration(hours: 1)).isBefore(closingTime)) {
            enable = true;
          } else {
            enable = false;
          }
          if (!enable) break;

          /// opentime validation
          DateTime openingTime = DateTime.parse(storeModel.profile!["hours"][i]["openingTime"]);
          if (openingTime.isUtc) openingTime = openingTime.toLocal();
          openingTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, openingTime.hour, openingTime.minute);
          if (DateTime.now().isAfter(openingTime)) {
            enable = true;
          } else {
            enable = false;
          }

          if (!enable) break;

          if (storeModel.profile!["hours"][i]["hoursBreakdown"] != null && storeModel.profile!["hours"][i]["hoursBreakdown"].isNotEmpty) {
            for (var k = 0; k < storeModel.profile!["hours"][i]["hoursBreakdown"].length; k++) {
              if (storeModel.profile!["hours"][i]["hoursBreakdown"][k]["type"] == "MorningTime") {
                /// MorningTime validation
                DateTime fromTime = DateTime.parse(storeModel.profile!["hours"][i]["hoursBreakdown"][k]["fromTime"]);
                if (fromTime.isUtc) fromTime = fromTime.toLocal();
                fromTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, fromTime.hour, fromTime.minute);
                DateTime toTime = DateTime.parse(storeModel.profile!["hours"][i]["hoursBreakdown"][k]["toTime"]);
                if (toTime.isUtc) toTime = toTime.toLocal();
                toTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, toTime.hour, toTime.minute);
                if (DateTime.now().isAfter(fromTime) && DateTime.now().isBefore(toTime)) {
                  enable = true;
                } else {
                  enable = false;
                }
              }

              if (enable!) break;

              if (storeModel.profile!["hours"][i]["hoursBreakdown"][k]["type"] == "EveningTime") {
                /// EveningTime validation
                DateTime fromTime = DateTime.parse(storeModel.profile!["hours"][i]["hoursBreakdown"][k]["fromTime"]);
                if (fromTime.isUtc) fromTime = fromTime.toLocal();
                fromTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, fromTime.hour, fromTime.minute);
                DateTime toTime = DateTime.parse(storeModel.profile!["hours"][i]["hoursBreakdown"][k]["toTime"]);
                if (toTime.isUtc) toTime = toTime.toLocal();
                toTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, toTime.hour, toTime.minute);
                if (DateTime.now().isAfter(fromTime) && DateTime.now().isBefore(toTime)) {
                  enable = true;
                } else {
                  enable = false;
                }
              }
              if (enable) break;
            }
          }
        }
        break;
      }
    }

    return enable ?? true;
  }
}
