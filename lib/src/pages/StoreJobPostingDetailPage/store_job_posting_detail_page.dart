import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/pages/ErrorPage/error_page.dart';

import 'index.dart';

class StoreJobPostingDetailPage extends StatefulWidget {
  final Map<String, dynamic>? jobPostingData;
  final String? jobId;
  final String? storeId;

  StoreJobPostingDetailPage({@required this.jobPostingData, this.jobId, this.storeId});

  @override
  _StoreJobPostingDetailPageState createState() => _StoreJobPostingDetailPageState();
}

class _StoreJobPostingDetailPageState extends State<StoreJobPostingDetailPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.jobPostingData == null && widget.jobId != null) {
      return StreamBuilder<dynamic>(
        stream: Stream.fromFuture(
          StoreJobPostingsApiProvider.getStoreJob(jobId: widget.jobId, storeId: widget.storeId),
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

          return StoreJobPostingDetailView(jobPostingData: snapshot.data["data"][0]);
        },
      );
    }
    return StoreJobPostingDetailView(jobPostingData: widget.jobPostingData);
  }
}
