import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/pages/BookAppointmentListPage/index.dart';

class BookAppointmentConfirmView extends StatefulWidget {
  final BookAppointmentModel? bookAppointmentModel;

  BookAppointmentConfirmView({Key? key, this.bookAppointmentModel}) : super(key: key);

  @override
  _BookAppointmentConfirmViewState createState() => _BookAppointmentConfirmViewState();
}

class _BookAppointmentConfirmViewState extends State<BookAppointmentConfirmView> with SingleTickerProviderStateMixin {
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Booking Confirmation", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: deviceWidth,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 15),
          child: Column(
            children: [
              Icon(Icons.event, size: heightDp * 40, color: config.Colors().mainColor(1)),
              ////
              SizedBox(height: heightDp * 20),
              Text(
                "Thank You ${widget.bookAppointmentModel!.userModel!.firstName}",
                style: TextStyle(fontSize: fontSp * 22),
              ),

              ///
              SizedBox(height: heightDp * 30),
              Text(
                "${widget.bookAppointmentModel!.bookingNumber}",
                style: TextStyle(fontSize: fontSp * 18),
              ),
              SizedBox(height: heightDp * 5),
              Text(
                "Booking Number",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
              ),

              ///
              SizedBox(height: heightDp * 30),
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
                            "${widget.bookAppointmentModel!.date}",
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
                            "${widget.bookAppointmentModel!.starttime}",
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
                            "${widget.bookAppointmentModel!.slottime} min",
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
                    "${widget.bookAppointmentModel!.appointmentModel!.name}",
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
                    "${widget.bookAppointmentModel!.appointmentModel!.description}",
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
                    "${widget.bookAppointmentModel!.name}",
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
                    "${widget.bookAppointmentModel!.email}",
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
                    "${widget.bookAppointmentModel!.mobile}",
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
                    "${widget.bookAppointmentModel!.storeModel!.name}",
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
                    "${widget.bookAppointmentModel!.appointmentModel!.address}",
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
                    "${widget.bookAppointmentModel!.noOfGuests}",
                    style: TextStyle(fontSize: fontSp * 16),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),

              ///
              SizedBox(height: heightDp * 20),
              KeicyRaisedButton(
                width: heightDp * 100,
                height: heightDp * 40,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 6,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => BookAppointmentListPage(),
                    ),
                  );
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white, fontSize: fontSp * 14),
                ),
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
    );
  }
}
