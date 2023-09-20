import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/store_time_validation.dart';
import 'package:trapp/src/models/index.dart';

class ServiceTimePanel extends StatefulWidget {
  final OrderModel? orderModel;
  final Function()? refreshCallback;

  ServiceTimePanel({
    @required this.orderModel,
    @required this.refreshCallback,
  });

  @override
  _ServiceTimePanelState createState() => _ServiceTimePanelState();
}

class _ServiceTimePanelState extends State<ServiceTimePanel> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "When would you like the professional to serve you?",
          //   style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
          // ),
          // SizedBox(height: heightDp * 5),
          Text(
            "When would you like your service",
            // style: TextStyle(fontSize: fontSp * 12, color: Colors.grey.withOpacity(1)),
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: heightDp * 15),
                child: Row(
                  children: [
                    Text(
                      widget.orderModel!.serviceDateTime == null
                          ? "Please select Date of service"
                          : "${KeicyDateTime.convertDateTimeToDateString(
                              dateTime: widget.orderModel!.serviceDateTime,
                              formats: 'Y-m-d',
                              isUTC: false,
                            )}",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    widget.orderModel!.serviceDateTime == null
                        ? Text(
                            " *",
                            style: TextStyle(fontSize: fontSp * 18, color: Colors.red, fontWeight: FontWeight.bold),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _selectPickupDateTimeHandler,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                  decoration: BoxDecoration(color: config.Colors().mainColor(1), borderRadius: BorderRadius.circular(heightDp * 6)),
                  child: Text(
                    "Service Date",
                    style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _selectPickupDateTimeHandler() async {
    DateTime initialTime = DateTime.now();
    while (!_decideDate(initialTime)) {
      initialTime = initialTime.add(Duration(days: 1));
    }

    DateTime serviceDateTime = widget.orderModel!.serviceDateTime != null ? widget.orderModel!.serviceDateTime! : initialTime;
    if (serviceDateTime.isUtc) serviceDateTime = serviceDateTime.toLocal();

    DateTime? selecteDate = await showDatePicker(
      context: context,
      initialDate: serviceDateTime,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3, 1).subtract(Duration(days: 1)),
      selectableDayPredicate: _decideDate,
    );
    if (selecteDate == null) return;

    // Map<String, DateTime> openCloseTime = _getOpenColseTime(selecteDate);

    // TimeOfDay time = await showCustomTimePicker(
    //   context: context,
    //   onFailValidation: (context) => print('Unavailable selection'),
    //   initialTime: openCloseTime["openTime"] != null
    //       ? TimeOfDay(hour: openCloseTime["openTime"].hour, minute: openCloseTime["openTime"].minute)
    //       : TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
    //   selectableTimePredicate: (time) {
    //     if (openCloseTime["openTime"] == null || openCloseTime["closeTime"] == null) return true;
    //     if (selecteDate.add(Duration(hours: time.hour, minutes: time.minute)).difference(openCloseTime["openTime"]).inSeconds >= 0 &&
    //         selecteDate.add(Duration(hours: time.hour, minutes: time.minute)).difference(openCloseTime["closeTime"]).inSeconds <= 0) {
    //       return true;
    //     }
    //     return false;
    //   },
    // );

    // if (time == null) return;
    // selecteDate = selecteDate.add(Duration(hours: time.hour, minutes: time.minute));
    setState(() {
      if (!selecteDate!.isUtc) selecteDate = selecteDate!.toUtc();
      widget.orderModel!.serviceDateTime = selecteDate!.toUtc();
      widget.refreshCallback!();
    });
  }

  bool _decideDate(DateTime dateTime) {
    if (dateTime.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) return false;
    if (dateTime.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day))) return false;

    return StoreTimeValidation.validate(dateTime: dateTime, storeModel: widget.orderModel!.storeModel);
  }
}
