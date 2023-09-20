import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/book_appointment_api_provider.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class BookAppointmentDetailView extends StatefulWidget {
  final BookAppointmentModel? bookAppointmentModel;
  final bool? isPast;

  BookAppointmentDetailView({Key? key, this.bookAppointmentModel, this.isPast}) : super(key: key);

  @override
  _BookAppointmentDetailViewState createState() => _BookAppointmentDetailViewState();
}

class _BookAppointmentDetailViewState extends State<BookAppointmentDetailView> with SingleTickerProviderStateMixin {
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

  KeicyProgressDialog? _keicyProgressDialog;

  BookAppointmentModel? _bookAppointmentModel;
  bool? _isUpdated;

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

    _bookAppointmentModel = BookAppointmentModel.copy(widget.bookAppointmentModel!);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _isUpdated = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String status = "Created";
    for (var i = 0; i < AppConfig.bookAppointmentStatus.length; i++) {
      if (_bookAppointmentModel!.status == AppConfig.bookAppointmentStatus[i]["id"]) {
        status = AppConfig.bookAppointmentStatus[i]["name"];
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
          onPressed: () {
            if (_isUpdated!)
              Navigator.of(context).pop(_bookAppointmentModel!.toJson());
            else
              Navigator.of(context).pop();
          },
        ),
        title: Text("Booking Appointment Details", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
        elevation: 0,
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (_isUpdated!)
            Navigator.of(context).pop(_bookAppointmentModel!.toJson());
          else
            Navigator.of(context).pop();
          return false;
        },
        child: SingleChildScrollView(
          child: Container(
            width: deviceWidth,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 15),
            child: Column(
              children: [
                SizedBox(height: heightDp * 10),
                Icon(Icons.event, size: heightDp * 40, color: config.Colors().mainColor(1)),
                ////
                SizedBox(height: heightDp * 20),
                Text(
                  "Thank You ${_bookAppointmentModel!.userModel!.firstName}",
                  style: TextStyle(fontSize: fontSp * 22),
                ),

                ///
                SizedBox(height: heightDp * 30),
                Text(
                  "${_bookAppointmentModel!.bookingNumber}",
                  style: TextStyle(fontSize: fontSp * 18),
                ),
                SizedBox(height: heightDp * 5),
                Text(
                  "Booking Number",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                ),

                ///
                SizedBox(height: heightDp * 20),
                Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.7)),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: heightDp * 15),
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                        child: Column(
                          children: [
                            Text(
                              "${_bookAppointmentModel!.date}",
                              style: TextStyle(fontSize: fontSp * 18),
                            ),
                            SizedBox(height: heightDp * 5),
                            Text(
                              "Date",
                              style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: heightDp * 15),
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.grey.withOpacity(0.7)),
                            right: BorderSide(color: Colors.grey.withOpacity(0.7)),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "${_bookAppointmentModel!.starttime}",
                              style: TextStyle(fontSize: fontSp * 18),
                            ),
                            SizedBox(height: heightDp * 5),
                            Text(
                              "Time",
                              style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: heightDp * 15),
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                        child: Column(
                          children: [
                            Text(
                              "${_bookAppointmentModel!.slottime} min",
                              style: TextStyle(fontSize: fontSp * 18),
                            ),
                            SizedBox(height: heightDp * 5),
                            Text(
                              "Time Slot",
                              style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.7)),

                ///
                SizedBox(height: heightDp * 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Icon(Icons.event, size: heightDp * 25),
                        // SizedBox(width: widthDp * 5),
                        Text(
                          "Event Name",
                          style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Text(
                      "${_bookAppointmentModel!.appointmentModel!.name}",
                      style: TextStyle(fontSize: fontSp * 16),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Icon(Icons.notes, size: heightDp * 25),
                        // SizedBox(width: widthDp * 5),
                        Text(
                          "Event Description",
                          style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Text(
                      "${_bookAppointmentModel!.appointmentModel!.description}",
                      style: TextStyle(fontSize: fontSp * 16),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Icon(Icons.store, size: heightDp * 25),
                        // SizedBox(width: widthDp * 5),
                        Text(
                          "User Name",
                          style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Text(
                      "${_bookAppointmentModel!.name}",
                      style: TextStyle(fontSize: fontSp * 16),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Icon(Icons.store, size: heightDp * 25),
                        // SizedBox(width: widthDp * 5),
                        Text(
                          "User Email",
                          style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Text(
                      "${_bookAppointmentModel!.email}",
                      style: TextStyle(fontSize: fontSp * 16),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Icon(Icons.store, size: heightDp * 25),
                        // SizedBox(width: widthDp * 5),
                        Text(
                          "User Mobile",
                          style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Text(
                      "${_bookAppointmentModel!.mobile}",
                      style: TextStyle(fontSize: fontSp * 16),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Icon(Icons.store, size: heightDp * 25),
                        // SizedBox(width: widthDp * 5),
                        Text(
                          "Store Name",
                          style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Text(
                      "${_bookAppointmentModel!.storeModel!.name}",
                      style: TextStyle(fontSize: fontSp * 16),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Icon(Icons.location_on, size: heightDp * 25),
                        // SizedBox(width: widthDp * 5),
                        Text(
                          "Location",
                          style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Text(
                      "${_bookAppointmentModel!.appointmentModel!.address}",
                      style: TextStyle(fontSize: fontSp * 16),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Icon(Icons.people, size: heightDp * 25),
                        // SizedBox(width: widthDp * 5),
                        Text(
                          "Number of Guests",
                          style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Text(
                      "${_bookAppointmentModel!.noOfGuests}",
                      style: TextStyle(fontSize: fontSp * 16),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),

                ///
                if (!widget.isPast! && (_bookAppointmentModel!.status == "created" || _bookAppointmentModel!.status == "accepted"))
                  Column(
                    children: [
                      SizedBox(height: heightDp * 40),
                      KeicyRaisedButton(
                        width: heightDp * 100,
                        height: heightDp * 40,
                        color: config.Colors().mainColor(1),
                        borderRadius: heightDp * 6,
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white, fontSize: fontSp * 14),
                        ),
                        onPressed: _cancelBookHandler,
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: heightDp * 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Book Status',
                            style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "$status",
                            style: TextStyle(fontSize: fontSp * 16),
                          )
                        ],
                      ),
                      if (_bookAppointmentModel!.commentForCancelled != "")
                        Column(
                          children: [
                            SizedBox(height: heightDp * 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cancelled Reason',
                                  style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: heightDp * 5),
                                Text(
                                  "${_bookAppointmentModel!.commentForCancelled}",
                                  style: TextStyle(fontSize: fontSp * 16),
                                )
                              ],
                            ),
                          ],
                        ),
                      if (_bookAppointmentModel!.commentForRejected != "")
                        Column(
                          children: [
                            SizedBox(height: heightDp * 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rejected Reason',
                                  style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: heightDp * 5),
                                Text(
                                  "${_bookAppointmentModel!.commentForRejected}",
                                  style: TextStyle(fontSize: fontSp * 16),
                                )
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),

                ///
                SizedBox(height: heightDp * 30),
                Text(
                  "Your reservation request confirmation has been sent to store for review. You will get a notification once your request is accepted",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _cancelBookHandler() {
    ReasonDialog.show(
      context,
      tilte: "Book Appointment Cancel",
      content: "Do you want to cancel this book appointment?",
      callback: (reason) async {
        await _keicyProgressDialog!.show();
        var result = await BookAppointmentApiProvider.cancelBook(
          bookAppointmentId: _bookAppointmentModel!.id,
          commentForCancelled: reason,
        );
        await _keicyProgressDialog!.hide();

        if (result['success']) {
          _bookAppointmentModel!.status = AppConfig.bookAppointmentStatus[3]['id'];
          _bookAppointmentModel!.commentForCancelled = reason;
          _isUpdated = true;
          setState(() {});
        } else {
          ErrorDialog.show(
            context,
            widthDp: widthDp,
            heightDp: heightDp,
            fontSp: fontSp,
            text: result['message'] ?? "Something was wrong",
          );
        }
      },
    );
  }
}
