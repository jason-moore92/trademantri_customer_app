import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/video_media_widget.dart';
import 'package:trapp/src/elements/youtube_video_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

class VideoGallaryPanel extends StatefulWidget {
  final Map<String, dynamic>? galleryData;

  VideoGallaryPanel({Key? key, @required this.galleryData}) : super(key: key);

  @override
  _VideoGallaryPanelState createState() => _VideoGallaryPanelState();
}

class _VideoGallaryPanelState extends State<VideoGallaryPanel> with SingleTickerProviderStateMixin {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  AuthProvider? _authProvider;

  KeicyProgressDialog? _keicyProgressDialog;

  double galleryWidth = 0;
  double galleryHeight = 0;
  double galleryPadding = 0;

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
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    galleryPadding = widthDp * 5;
    galleryWidth = ((deviceWidth - widthDp * 40) - galleryPadding * 2) / 3;
    galleryHeight = galleryWidth;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoPlayProvider()),
      ],
      child: Scaffold(
        body: Container(
          width: deviceWidth,
          child: _mainPanel(),
        ),
      ),
    );
  }

  Widget _mainPanel() {
    return Column(
      children: [
        Expanded(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowGlow();
              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: deviceWidth,
                    child: Column(
                      children: List.generate(widget.galleryData!["videos"].length, (index) {
                        String date = widget.galleryData!["videos"].keys.toList()[widget.galleryData!["videos"].length - 1 - index];
                        List<dynamic> videoList = widget.galleryData!["videos"][date];

                        return Column(
                          children: List.generate(videoList.length, (index) {
                            Map<String, dynamic> videoData = videoList[videoList.length - 1 - index];

                            return Column(
                              children: [
                                if (videoData["type"] == "youtube")
                                  YoutubeVideoWidget(
                                    videoData: videoData,
                                    index: index,
                                  )
                                else
                                  VideoMediaWidget(
                                    videoData: videoData,
                                    index: index,
                                  ),
                              ],
                            );
                          }),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
