import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/elements/pay_at_store_option_panel.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/helpers/store_time_validation.dart';
import 'package:trapp/src/models/index.dart';

class PickupPanel extends StatefulWidget {
  final OrderModel? orderModel;
  final Function? refreshCallback;

  PickupPanel({
    @required this.orderModel,
    @required this.refreshCallback,
  });

  @override
  _PickupPanelState createState() => _PickupPanelState();
}

class _PickupPanelState extends State<PickupPanel> {
  /// Responsive design variables
  double? deviceWidth;
  double? deviceHeight;
  double? statusbarHeight;
  double? bottomBarHeight;
  double? appbarHeight;
  double? widthDp;
  double? heightDp;
  double? heightDp1;
  double? fontSp;
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
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(
        // horizontal: widthDp * 15,
        vertical: heightDp! * 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pickup Address:",
            style: TextStyle(fontSize: fontSp! * 18, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: heightDp! * 5),
          Text(
            widget.orderModel!.storeModel == null ? "Please choose store" : "${widget.orderModel!.storeModel!.address}",
            style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
          ),
          widget.orderModel!.storeModel == null
              ? SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: heightDp! * 15),
                      child: Row(
                        children: [
                          Text(
                            widget.orderModel!.pickupDateTime == null
                                ? "Please select date"
                                : "${KeicyDateTime.convertDateTimeToDateString(
                                    dateTime: widget.orderModel!.pickupDateTime!,
                                    formats: 'Y-m-d',
                                    isUTC: false,
                                  )}",
                            style: TextStyle(fontSize: fontSp! * 16, color: Colors.black),
                          ),
                          widget.orderModel!.pickupDateTime == null
                              ? Text(
                                  " *",
                                  style: TextStyle(fontSize: fontSp! * 18, color: Colors.red, fontWeight: FontWeight.bold),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _selectPickupDateTimeHandler,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: widthDp! * 10, vertical: heightDp! * 10),
                        decoration: BoxDecoration(color: config.Colors().mainColor(1), borderRadius: BorderRadius.circular(heightDp! * 6)),
                        child: Text(
                          "Pick a date",
                          style: TextStyle(fontSize: fontSp! * 12, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
          PayAtStorePanel(orderModel: widget.orderModel),
        ],
      ),
    );
  }

  void _selectPickupDateTimeHandler() async {
    DateTime initialTime = DateTime.now();
    while (!_decideDate(initialTime)) {
      initialTime = initialTime.add(Duration(days: 1));
    }

    DateTime pickupDateTime = widget.orderModel!.pickupDateTime != null ? widget.orderModel!.pickupDateTime!.toLocal() : initialTime;

    DateTime? selecteDate = await showDatePicker(
      context: context,
      initialDate: pickupDateTime,
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
      widget.orderModel!.pickupDateTime = selecteDate!.toUtc();
      // widget.orderModel.pickupDateTime = selecteDate.toString();
      widget.refreshCallback!();
    });
  }

  bool _decideDate(DateTime dateTime) {
    if (dateTime.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) return false;
    if (dateTime.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day))) return false;
    return StoreTimeValidation.validate(dateTime: dateTime, storeModel: widget.orderModel!.storeModel);
  }
}
