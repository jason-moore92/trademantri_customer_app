import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/providers/index.dart';

class DatePickerPanel extends StatefulWidget {
  DatePickerPanel({Key? key}) : super(key: key);

  @override
  _DatePickerPanelState createState() => _DatePickerPanelState();
}

class _DatePickerPanelState extends State<DatePickerPanel> {
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;

  BookAppointmentProvider? _bookAppointmentProvider;

  @override
  void initState() {
    super.initState();

    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    _bookAppointmentProvider = BookAppointmentProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight - statusbarHeight - appbarHeight - heightDp * 40,
      child: Column(
        children: [
          ///
          Container(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 15),
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              todayHighlightColor: Colors.transparent,
              minDate: _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.appointmentModel!.startDate,
              maxDate: _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.appointmentModel!.endDate,
              monthViewSettings: DateRangePickerMonthViewSettings(),
              monthCellStyle: DateRangePickerMonthCellStyle(
                textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                disabledDatesTextStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.8)),
                specialDatesTextStyle: TextStyle(fontSize: fontSp * 14, color: config.Colors().mainColor(1)),
                todayTextStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                cellDecoration: BoxDecoration(
                  color: config.Colors().mainColor(0.2),
                  // border: Border.all(color: config.Colors().mainColor(0.2), width: 1),
                  shape: BoxShape.circle,
                ),
              ),
              initialSelectedDate: _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.date == null
                  ? null
                  : KeicyDateTime.convertDateStringToDateTime(
                      dateString: _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.date,
                      isUTC: false,
                    ),
              selectionTextStyle: TextStyle(fontSize: fontSp * 16, color: Colors.white),
              selectionRadius: heightDp * 20,
              selectableDayPredicate: (DateTime date) {
                if (date.isBefore(DateTime.now().subtract(Duration(days: 1)))) return false;

                if (date.weekday == DateTime.monday &&
                    _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.appointmentModel!.monday!.open!) {
                  return true;
                }
                if (date.weekday == DateTime.tuesday &&
                    _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.appointmentModel!.tuesday!.open!) {
                  return true;
                }
                if (date.weekday == DateTime.wednesday &&
                    _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.appointmentModel!.wednesday!.open!) {
                  return true;
                }
                if (date.weekday == DateTime.thursday &&
                    _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.appointmentModel!.thursday!.open!) {
                  return true;
                }
                if (date.weekday == DateTime.friday &&
                    _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.appointmentModel!.friday!.open!) {
                  return true;
                }
                if (date.weekday == DateTime.saturday &&
                    _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.appointmentModel!.saturday!.open!) {
                  return true;
                }
                if (date.weekday == DateTime.sunday &&
                    _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.appointmentModel!.sunday!.open!) {
                  return true;
                }
                return false;
              },
              onViewChanged: (DateRangePickerViewChangedArgs args) {},
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  // final DateTime rangeStartDate = args.value.startDate;
                  // final DateTime rangeEndDate = args.value.endDate;
                } else if (args.value is DateTime) {
                  BookAppointmentModel? bookAppointmentModel = BookAppointmentModel.copy(
                    _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!,
                  );
                  bookAppointmentModel.date = KeicyDateTime.convertDateTimeToDateString(dateTime: args.value, isUTC: false);

                  _bookAppointmentProvider!.setBookAppointmentState(
                    _bookAppointmentProvider!.bookAppointmentState.update(
                      bookAppointmentModel: bookAppointmentModel,
                      completedStep: 1,
                    ),
                  );
                } else if (args.value is List<DateTime>) {
                  // final List<DateTime> selectedDates = args.value;
                } else {
                  // final List<PickerDateRange> selectedRanges = args.value;
                }
              },
            ),
          ),

          ///
          SizedBox(height: heightDp * 40),
          KeicyRaisedButton(
            width: heightDp * 100,
            height: heightDp * 40,
            color: _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.date != null
                ? config.Colors().mainColor(1)
                : Colors.grey.withOpacity(0.5),
            borderRadius: heightDp * 6,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              'Next',
              style: TextStyle(color: Colors.white, fontSize: fontSp * 16),
            ),
            onPressed:
                (_bookAppointmentProvider!.bookAppointmentState.step != 2 && _bookAppointmentProvider!.bookAppointmentState.completedStep! >= 1)
                    ? () {
                        _bookAppointmentProvider!.setBookAppointmentState(
                          _bookAppointmentProvider!.bookAppointmentState.update(
                            step: 2,
                            slotsProgressState: 1,
                          ),
                        );

                        _bookAppointmentProvider!.getAvailableSlots(
                          appointmentId: _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.appointmentModel!.id,
                          userId: _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.userModel!.id,
                          storeId: _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.storeModel!.id,
                          date: _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.date,
                        );
                      }
                    : null,
          ),
        ],
      ),
    );
  }
}
