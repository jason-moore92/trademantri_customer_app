import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/pages/ErrorPage/index.dart';

import 'index.dart';

class BookAppointmentDetailPage extends StatefulWidget {
  final BookAppointmentModel? bookAppointmentModel;
  final String? id;
  final bool? isPast;

  BookAppointmentDetailPage({@required this.bookAppointmentModel, this.id, this.isPast = false});

  @override
  _BookAppointmentDetailPageState createState() => _BookAppointmentDetailPageState();
}

class _BookAppointmentDetailPageState extends State<BookAppointmentDetailPage> {
  @override
  Widget build(BuildContext context) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double heightDp = ScreenUtil().setWidth(1);

    if (widget.bookAppointmentModel == null && widget.id != null) {
      return StreamBuilder<dynamic>(
          stream: Stream.fromFuture(
            BookAppointmentApiProvider.get(id: widget.id),
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                if (snapshot.hasData && snapshot.data["success"] && snapshot.data["data"].isNotEmpty) {
                  BookAppointmentModel bookAppointmentModel = BookAppointmentModel.fromJson(snapshot.data["data"][0]);
                  DateTime? date = KeicyDateTime.convertDateStringToDateTime(dateString: bookAppointmentModel.date!, isUTC: false);

                  if (date!.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
                    return BookAppointmentDetailView(
                      bookAppointmentModel: bookAppointmentModel,
                      isPast: true,
                    );
                  } else {
                    return BookAppointmentDetailView(
                      bookAppointmentModel: bookAppointmentModel,
                      isPast: widget.isPast,
                    );
                  }
                } else if (snapshot.hasData && snapshot.data["success"] && snapshot.data["data"].isEmpty) {
                  return Scaffold(
                    body: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: heightDp * 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Your store is not part of this appointment",
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
                                padding: EdgeInsets.symmetric(horizontal: heightDp * 15, vertical: heightDp * 5),
                                alignment: Alignment.center,
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

    return BookAppointmentDetailView(
      bookAppointmentModel: widget.bookAppointmentModel,
      isPast: widget.isPast,
    );
  }
}
