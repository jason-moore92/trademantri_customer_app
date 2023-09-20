import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class BookAppointmentPage extends StatefulWidget {
  final BookAppointmentModel? bookAppointmentModel;
  final String? appointmentId;

  BookAppointmentPage({
    this.bookAppointmentModel,
    this.appointmentId,
  });

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  @override
  Widget build(BuildContext context) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double heightDp = ScreenUtil().setWidth(1);

    if (widget.bookAppointmentModel == null && widget.appointmentId != null) {
      return StreamBuilder<dynamic>(
          stream: Stream.fromFuture(
            AppointmentApiProvider.get(id: widget.appointmentId),
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                if (snapshot.hasData && snapshot.data["success"] && snapshot.data["data"].isNotEmpty) {
                  AppointmentModel appointmentModel = AppointmentModel.fromJson(snapshot.data["data"][0]);
                  BookAppointmentModel bookAppointmentModel = BookAppointmentModel();

                  bookAppointmentModel.appointmentId = appointmentModel.id;
                  bookAppointmentModel.appointmentModel = appointmentModel;
                  bookAppointmentModel.storeId = appointmentModel.storeModel!.id;
                  bookAppointmentModel.storeModel = appointmentModel.storeModel;
                  bookAppointmentModel.userId = AuthProvider.of(context).authState.userModel!.id;
                  bookAppointmentModel.userModel = AuthProvider.of(context).authState.userModel;

                  return BookAppointmentView(bookAppointmentModel: bookAppointmentModel);
                } else if (snapshot.hasData && snapshot.data["success"] && snapshot.data["data"].isEmpty) {
                  return Scaffold(
                    body: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: heightDp * 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Your store is not part of this bargain request",
                              style: TextStyle(fontSize: fontSp * 18),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: heightDp * 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: heightDp * 80,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: heightDp * 15, vertical: heightDp * 5),
                                decoration: BoxDecoration(
                                  color: config.Colors().mainColor(1),
                                  borderRadius: BorderRadius.circular(heightDp * 8),
                                ),
                                child: Text(
                                  "Ok",
                                  style: TextStyle(fontSize: fontSp * 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return ErrorPage(
                    message: snapshot.hasData ? snapshot.data["message"] ?? "" : "Something Wrong",
                    callback: () {
                      setState(() {});
                    },
                  );
                }
              default:
            }
            return Scaffold(body: Center(child: CupertinoActivityIndicator()));
          });
    }
    return BookAppointmentView(bookAppointmentModel: widget.bookAppointmentModel);
  }
}
