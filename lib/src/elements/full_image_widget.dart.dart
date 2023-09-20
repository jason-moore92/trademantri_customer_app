import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;
import 'package:extended_image/extended_image.dart';

class FullImageWidget extends StatefulWidget {
  final Uint8List? bytes;

  FullImageWidget({
    Key? key,
    this.bytes,
  }) : super(key: key);

  @override
  _FullImageWidgetState createState() => _FullImageWidgetState();
}

class _FullImageWidgetState extends State<FullImageWidget> {
  double widthDp = ScreenUtil().setWidth(1);
  double heightDp = ScreenUtil().setWidth(1);
  double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
  double statusbarHeight = ScreenUtil().statusBarHeight;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Image image = new Image.memory(widget.bytes!);
    Completer<ui.Image> completer = new Completer<ui.Image>();
    image.image.resolve(new ImageConfiguration()).addListener(
          ImageStreamListener((ImageInfo info, bool _) => completer.complete(info.image)),
        );

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: FutureBuilder<ui.Image>(
          future: completer.future,
          builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.width > snapshot.data!.height) {
                ExtendedImage imageWidget = ExtendedImage.memory(
                  widget.bytes!,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                  mode: ExtendedImageMode.gesture,
                  enableMemoryCache: true,
                  loadStateChanged: (ExtendedImageState state) {
                    if (state.extendedImageLoadState == LoadState.loading) {
                      return Center(
                          child: Theme(
                        data: Theme.of(context).copyWith(brightness: Brightness.dark),
                        child: Center(child: CupertinoActivityIndicator()),
                      ));
                    }
                  },
                  initGestureConfigHandler: (state) {
                    return GestureConfig(
                      minScale: 0.9,
                      animationMinScale: 0.7,
                      maxScale: 3.0,
                      animationMaxScale: 3.5,
                      speed: 1.0,
                      inertialSpeed: 100.0,
                      initialScale: 1.0,
                      inPageView: false,
                      initialAlignment: InitialAlignment.center,
                    );
                  },
                );

                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: imageWidget,
                        ),
                      ),
                      Container(
                        height: statusbarHeight,
                        color: Colors.black,
                      ),
                      Positioned(
                        top: statusbarHeight,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.close_outlined, size: heightDp * 30, color: Colors.white),
                              ),
                              SizedBox(width: widthDp * 5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                ExtendedImage imageWidget = ExtendedImage.memory(
                  widget.bytes!,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                  mode: ExtendedImageMode.gesture,
                  enableMemoryCache: true,
                  initGestureConfigHandler: (state) {
                    return GestureConfig(
                      minScale: 0.9,
                      animationMinScale: 0.7,
                      maxScale: 3.0,
                      animationMaxScale: 3.5,
                      speed: 1.0,
                      inertialSpeed: 100.0,
                      initialScale: 1.0,
                      inPageView: false,
                      initialAlignment: InitialAlignment.center,
                    );
                  },
                );

                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: imageWidget,
                      ),
                      Container(
                        height: statusbarHeight,
                        color: Colors.black,
                      ),
                      Positioned(
                        top: statusbarHeight,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.close_outlined, size: heightDp * 30, color: Colors.white),
                              ),
                              SizedBox(width: widthDp * 5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else {
              return Material(
                color: Colors.transparent,
                child: Wrap(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Theme(
                        data: Theme.of(context).copyWith(brightness: Brightness.dark),
                        child: Center(child: CupertinoActivityIndicator()),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
