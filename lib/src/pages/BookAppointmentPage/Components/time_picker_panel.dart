import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/src/providers/index.dart';

class TimePickerPanel extends StatefulWidget {
  TimePickerPanel({Key? key}) : super(key: key);

  @override
  _TimePickerPanelState createState() => _TimePickerPanelState();
}

class _TimePickerPanelState extends State<TimePickerPanel> {
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
      width: MediaQuery.of(context).size.width,
      height: deviceHeight - statusbarHeight - appbarHeight - heightDp * 40,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 15),
      child: Consumer<BookAppointmentProvider>(builder: (context, bookAppointmentProvider, _) {
        if (bookAppointmentProvider.bookAppointmentState.step != 2) return SizedBox();

        if (bookAppointmentProvider.bookAppointmentState.slotsProgressState == 0 ||
            bookAppointmentProvider.bookAppointmentState.slotsProgressState == 1) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (bookAppointmentProvider.bookAppointmentState.slotsProgressState == -1) {
          return ErrorPage(
            message: bookAppointmentProvider.bookAppointmentState.message,
            callback: () {
              bookAppointmentProvider.setBookAppointmentState(
                bookAppointmentProvider.bookAppointmentState.update(slotsProgressState: 1),
              );

              bookAppointmentProvider.getAvailableSlots(
                appointmentId: bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.appointmentModel!.id,
                userId: bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.userModel!.id,
                storeId: bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.storeModel!.id,
                date: bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.date,
              );
            },
          );
        }
        AppointmentModel? appointmentModel = bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.appointmentModel;

        String slotKey = "${appointmentModel!.id}"
            "_${bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.storeModel!.id}"
            "_${bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.userModel!.id}"
            "_${bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.date}";

        if (bookAppointmentProvider.bookAppointmentState.slots![slotKey]!.length == 0) {
          return Center(
            child: Text(
              "No time slots, please choose other date",
              style: TextStyle(fontSize: fontSp * 16),
            ),
          );
        }

        if (appointmentModel.wholeday!) {
          WeekModel? weekModel;
          DateTime? date = KeicyDateTime.convertDateStringToDateTime(
            dateString: bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.date,
            isUTC: false,
          );
          if (date!.weekday == DateTime.monday) {
            weekModel = appointmentModel.monday;
          } else if (date.weekday == DateTime.tuesday) {
            weekModel = appointmentModel.tuesday;
          } else if (date.weekday == DateTime.wednesday) {
            weekModel = appointmentModel.wednesday;
          } else if (date.weekday == DateTime.thursday) {
            weekModel = appointmentModel.thursday;
          } else if (date.weekday == DateTime.friday) {
            weekModel = appointmentModel.friday;
          } else if (date.weekday == DateTime.saturday) {
            weekModel = appointmentModel.saturday;
          } else if (date.weekday == DateTime.sunday) {
            weekModel = appointmentModel.sunday;
          }

          return Column(
            children: [
              SizedBox(height: heightDp * 10),
              Text(
                "Whole day",
                style: TextStyle(fontSize: fontSp * 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: heightDp * 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.starttime == weekModel!.fromtime) return;

                      if (bookAppointmentProvider.bookAppointmentState.slots![slotKey].first["userId"] ==
                          bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.userModel!.id) {
                        NormalAskDialog.show(
                          context,
                          title: "Book Appointment",
                          content: "You already booked the same slot, do you want to book again",
                          callback: () {
                            _wholeDayHandler(weekModel);
                          },
                        );
                      } else {
                        _wholeDayHandler(weekModel);
                      }
                    },
                    child: Container(
                      width: widthDp * 150,
                      height: heightDp * 40,
                      decoration: BoxDecoration(
                        color: bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.starttime == weekModel!.fromtime
                            ? config.Colors().mainColor(1)
                            : Colors.transparent,
                        border: Border.all(color: config.Colors().mainColor(1), width: 1),
                        borderRadius: BorderRadius.circular(heightDp * 8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${weekModel.fromtime} - ${weekModel.totime}",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.starttime == weekModel.fromtime
                              ? Colors.white
                              : config.Colors().mainColor(1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              ///
              SizedBox(height: heightDp * 40),
              KeicyRaisedButton(
                width: heightDp * 100,
                height: heightDp * 40,
                color: bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.starttime != ""
                    ? config.Colors().mainColor(1)
                    : Colors.grey.withOpacity(0.5),
                borderRadius: heightDp * 6,
                padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.white, fontSize: fontSp * 16),
                ),
                onPressed:
                    (bookAppointmentProvider.bookAppointmentState.step != 3 && bookAppointmentProvider.bookAppointmentState.completedStep! >= 2)
                        ? () {
                            bookAppointmentProvider.setBookAppointmentState(
                              bookAppointmentProvider.bookAppointmentState.update(step: 3),
                            );
                          }
                        : null,
              ),
            ],
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: List.generate(bookAppointmentProvider.bookAppointmentState.slots![slotKey]!.length, (index) {
                    String starttime = bookAppointmentProvider.bookAppointmentState.slots![slotKey]![index]["starttime"];

                    return GestureDetector(
                      onTap: () {
                        if (bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.starttime == starttime) return;

                        if (bookAppointmentProvider.bookAppointmentState.slots![slotKey]![index]["userId"] ==
                            bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.userModel!.id) {
                          NormalAskDialog.show(
                            context,
                            title: "Book Appointment",
                            content: "You already booked the same slot, do you want to book again",
                            callback: () {
                              _timeSlotHandler(starttime);
                            },
                          );
                        } else {
                          _timeSlotHandler(starttime);
                        }
                      },
                      child: Container(
                        width: widthDp * 100,
                        height: heightDp * 40,
                        margin: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                        decoration: BoxDecoration(
                          color: bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.starttime == starttime
                              ? config.Colors().mainColor(1)
                              : Colors.transparent,
                          border: Border.all(color: config.Colors().mainColor(1), width: 2),
                          borderRadius: BorderRadius.circular(heightDp * 8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "$starttime",
                          style: TextStyle(
                            fontSize: fontSp * 16,
                            color: bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.starttime == starttime
                                ? Colors.white
                                : config.Colors().mainColor(1),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                ///
                SizedBox(height: heightDp * 40),
                KeicyRaisedButton(
                  width: heightDp * 100,
                  height: heightDp * 40,
                  color: bookAppointmentProvider.bookAppointmentState.bookAppointmentModel!.starttime != ""
                      ? config.Colors().mainColor(1)
                      : Colors.grey.withOpacity(0.5),
                  borderRadius: heightDp * 6,
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white, fontSize: fontSp * 16),
                  ),
                  onPressed:
                      (bookAppointmentProvider.bookAppointmentState.step != 3 && bookAppointmentProvider.bookAppointmentState.completedStep! >= 2)
                          ? () {
                              bookAppointmentProvider.setBookAppointmentState(
                                bookAppointmentProvider.bookAppointmentState.update(step: 3),
                              );
                            }
                          : null,
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  void _wholeDayHandler(WeekModel? weekModel) {
    BookAppointmentModel? bookAppointmentModel = BookAppointmentModel.copy(
      _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!,
    );
    DateTime starTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(weekModel!.fromtime!.split(":").first),
      int.parse(weekModel.fromtime!.split(":").last),
    );

    DateTime endTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(weekModel.totime!.split(":").first),
      int.parse(weekModel.totime!.split(":").last),
    );

    bookAppointmentModel.starttime = KeicyDateTime.convertDateTimeToDateString(dateTime: starTime, isUTC: false, formats: "H:i");
    bookAppointmentModel.endtime = KeicyDateTime.convertDateTimeToDateString(dateTime: endTime, isUTC: false, formats: "H:i");
    bookAppointmentModel.slottime = endTime.difference(starTime).inMinutes.toString();

    _bookAppointmentProvider!.setBookAppointmentState(
      _bookAppointmentProvider!.bookAppointmentState.update(
        bookAppointmentModel: bookAppointmentModel,
        completedStep: 2,
      ),
    );
  }

  _timeSlotHandler(String starttime) {
    BookAppointmentModel? bookAppointmentModel = BookAppointmentModel.copy(
      _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!,
    );

    DateTime starTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(starttime.split(":").first),
      int.parse(starttime.split(":").last),
    );

    DateTime endTime = starTime.add(Duration(minutes: int.parse(bookAppointmentModel.appointmentModel!.timeslot!)));

    bookAppointmentModel.starttime = starttime;
    bookAppointmentModel.endtime = KeicyDateTime.convertDateTimeToDateString(dateTime: endTime, isUTC: false, formats: "H:i");
    bookAppointmentModel.slottime = bookAppointmentModel.appointmentModel!.timeslot;

    _bookAppointmentProvider!.setBookAppointmentState(
      _bookAppointmentProvider!.bookAppointmentState.update(
        bookAppointmentModel: bookAppointmentModel,
        completedStep: 2,
      ),
    );
  }
}
