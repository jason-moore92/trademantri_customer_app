import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/full_image_widget.dart.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/helper.dart';

class ImageGallaryPanel extends StatefulWidget {
  final Map<String, dynamic>? galleryData;

  ImageGallaryPanel({Key? key, @required this.galleryData}) : super(key: key);

  @override
  _ImageGallaryPanelState createState() => _ImageGallaryPanelState();
}

class _ImageGallaryPanelState extends State<ImageGallaryPanel> with SingleTickerProviderStateMixin {
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

  KeicyProgressDialog? _keicyProgressDialog;

  List<File> _imageFileList = [];

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

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    galleryPadding = widthDp * 10;
    galleryWidth = ((deviceWidth - widthDp * 40) - galleryPadding * 2) / 3;
    galleryHeight = galleryWidth;

    return Scaffold(
      body: Container(
        width: deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
        child: _mainPanel(),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(widget.galleryData!["images"].length, (index) {
                        String date = widget.galleryData!["images"].keys.toList()[widget.galleryData!["images"].length - 1 - index];
                        List<dynamic> imageList = widget.galleryData!["images"][date];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(height: heightDp * 2, thickness: 2, color: Colors.grey.withOpacity(0.4)),
                            SizedBox(height: heightDp * 10),
                            Text(
                              KeicyDateTime.convertDateTimeToDateString(
                                dateTime: DateTime.tryParse(date)!.toLocal(),
                                formats: "D, d M Y",
                                isUTC: false,
                              ),
                              style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: heightDp * 15),
                            Container(
                              width: deviceWidth,
                              child: Wrap(
                                spacing: galleryPadding,
                                runSpacing: galleryPadding * 2,
                                children: List.generate(imageList.length, (index) {
                                  Map<String, dynamic> imageData = imageList[imageList.length - 1 - index];

                                  if (imageData["file"] != null) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder: (BuildContext context) => FullImageWidget(
                                                  bytes: imageData["file"].readAsBytesSync(),
                                                ),
                                              ),
                                            );
                                          },
                                          child: KeicyAvatarImage(
                                            url: "",
                                            width: galleryWidth,
                                            height: galleryHeight,
                                            imageFile: imageData["file"],
                                            backColor: Colors.grey.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            await _keicyProgressDialog!.show();
                                            Uint8List? bytes = await bytesFromImageUrl(imageData["path"]);
                                            await _keicyProgressDialog!.hide();
                                            if (bytes != null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute<void>(
                                                  builder: (BuildContext context) => FullImageWidget(
                                                    bytes: bytes,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              ErrorDialog.show(
                                                context,
                                                widthDp: widthDp,
                                                heightDp: heightDp,
                                                fontSp: fontSp,
                                                text: "Loading Image Byte Data error",
                                              );
                                            }
                                          },
                                          child: KeicyAvatarImage(
                                            url: imageData["path"],
                                            width: galleryWidth,
                                            height: galleryHeight,
                                            backColor: Colors.grey.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }),
                              ),
                            ),
                            SizedBox(height: heightDp * 10),
                          ],
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
