import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class BookAppointmentView extends StatefulWidget {
  final BookAppointmentModel? bookAppointmentModel;

  BookAppointmentView({Key? key, this.bookAppointmentModel}) : super(key: key);

  @override
  _BookAppointmentViewState createState() => _BookAppointmentViewState();
}

class _BookAppointmentViewState extends State<BookAppointmentView> with SingleTickerProviderStateMixin {
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

  AuthProvider? _authProvider;
  BookAppointmentProvider? _bookAppointmentProvider;
  KeicyProgressDialog? _keicyProgressDialog;

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

    _authProvider = AuthProvider.of(context);
    _bookAppointmentProvider = BookAppointmentProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _bookAppointmentProvider!.setBookAppointmentState(
      _bookAppointmentProvider!.bookAppointmentState.update(
        step: 1,
        completedStep: 0,
        slotsProgressState: 0,
        slots: Map<String, dynamic>(),
        bookAppointmentModel: BookAppointmentModel.copy(widget.bookAppointmentModel!),
      ),
      isNotifiable: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Book Appointment", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
        elevation: 0,
      ),
      body: Consumer<BookAppointmentProvider>(builder: (context, bookAppointmentProvider, _) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _tabBar(),
              IndexedStack(
                index: bookAppointmentProvider.bookAppointmentState.step! - 1,
                children: [
                  DatePickerPanel(),
                  TimePickerPanel(),
                  DetailsPanel(),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _tabBar() {
    return Container(
      width: deviceWidth,
      height: heightDp * 40,
      // padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1)),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_bookAppointmentProvider!.bookAppointmentState.step != 1 && _bookAppointmentProvider!.bookAppointmentState.completedStep! >= 0) {
                  _bookAppointmentProvider!.setBookAppointmentState(
                    _bookAppointmentProvider!.bookAppointmentState.update(step: 1),
                  );
                }
              },
              child: Container(
                height: heightDp * 40,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: _bookAppointmentProvider!.bookAppointmentState.step == 1 ? config.Colors().mainColor(1) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.date == null
                          ? "Date"
                          : _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.date!,
                      style: TextStyle(fontSize: fontSp * 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_bookAppointmentProvider!.bookAppointmentState.step != 2 && _bookAppointmentProvider!.bookAppointmentState.completedStep! >= 1) {
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
              },
              child: Container(
                height: heightDp * 40,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: _bookAppointmentProvider!.bookAppointmentState.step == 2 ? config.Colors().mainColor(1) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.starttime == ""
                          ? "Time"
                          : "${_bookAppointmentProvider!.bookAppointmentState.bookAppointmentModel!.starttime}",
                      style: TextStyle(fontSize: fontSp * 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_bookAppointmentProvider!.bookAppointmentState.step != 3 && _bookAppointmentProvider!.bookAppointmentState.completedStep! >= 2) {
                  _bookAppointmentProvider!.setBookAppointmentState(
                    _bookAppointmentProvider!.bookAppointmentState.update(step: 3),
                  );
                }
              },
              child: Container(
                height: heightDp * 40,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: _bookAppointmentProvider!.bookAppointmentState.step == 3 ? config.Colors().mainColor(1) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Details", style: TextStyle(fontSize: fontSp * 16)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
