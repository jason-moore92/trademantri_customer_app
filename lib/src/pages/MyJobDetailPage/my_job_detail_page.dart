import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class MyJobDetailPage extends StatefulWidget {
  Map<String, dynamic>? appliedJobData;
  String? jobId;

  MyJobDetailPage({@required this.appliedJobData, this.jobId});

  @override
  _MyJobDetailPageState createState() => _MyJobDetailPageState();
}

class _MyJobDetailPageState extends State<MyJobDetailPage> {
  @override
  Widget build(BuildContext context) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double heightDp = ScreenUtil().setWidth(1);

    if (widget.appliedJobData == null && widget.jobId != "") {
      return StreamBuilder<dynamic>(
        stream: Stream.fromFuture(
          AppliedJobApiProvider.getAppliedJob(jobId: widget.jobId),
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.hasData && snapshot.data["success"] && snapshot.data["data"].isNotEmpty) {
                return MyJobDetailView(appliedJobData: snapshot.data["data"][0]);
              } else if (snapshot.hasData && snapshot.data["success"] && snapshot.data["data"].isEmpty) {
                return Scaffold(
                  body: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: heightDp * 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Your Job Detail is not part of this order",
                            style: TextStyle(fontSize: fontSp * 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: heightDp * 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
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
        },
      );
    }
    return MyJobDetailView(appliedJobData: widget.appliedJobData);
  }
}
