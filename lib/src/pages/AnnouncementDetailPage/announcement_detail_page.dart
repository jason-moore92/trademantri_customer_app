import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class AnnouncementDetailPage extends StatefulWidget {
  final Map<String, dynamic>? announcementData;
  final Map<String, dynamic>? storeData;
  final String? announcementId;
  final String? storeId;

  AnnouncementDetailPage({@required this.storeData, this.announcementData, this.announcementId, this.storeId});

  @override
  _AnnouncementDetailPageState createState() => _AnnouncementDetailPageState();
}

class _AnnouncementDetailPageState extends State<AnnouncementDetailPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.announcementData == null && widget.announcementId != null) {
      return StreamBuilder<dynamic>(
        stream: Stream.fromFuture(
          AnnouncementsApiProvider.getAnnouncement(announcementId: widget.announcementId),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(body: Center(child: CupertinoActivityIndicator()));
          }

          if (snapshot.hasError || !snapshot.data["success"] || snapshot.data["data"].isEmpty) {
            return ErrorPage(
              message: "Something Wrong",
              callback: () {
                setState(() {});
              },
            );
          }

          return AnnouncementDetailView(
            storeData: snapshot.data["data"][0]["store"],
            announcementData: snapshot.data["data"][0],
          );
        },
      );
    }
    return AnnouncementDetailView(storeData: widget.storeData, announcementData: widget.announcementData);
  }
}
