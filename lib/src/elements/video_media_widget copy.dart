import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/providers/VideoPlayProvider/video_play_state.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:video_player/video_player.dart';

class VideoMediaWidget extends StatefulWidget {
  final Map<String, dynamic>? videoData;
  final int? index;

  VideoMediaWidget({
    Key? key,
    @required this.videoData,
    @required this.index,
  }) : super(key: key);

  @override
  _VideoMediaWidgetState createState() => _VideoMediaWidgetState();
}

class _VideoMediaWidgetState extends State<VideoMediaWidget> {
  double widthDp = ScreenUtil().setWidth(1);
  double heightDp = ScreenUtil().setWidth(1);
  double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

  VideoPlayerController? _videoPlayerController;
  VoidCallback? _videoPlayerListener;

  VideoPlayProvider? _videoPlayProvider;

  Timer? _timer;

  double _maxDuration = 1.0;
  double _sliderCurrentPosition = 0.0;
  String _playerTxt = '00:00:00';

  Timer? uploadTimer;

  @override
  void initState() {
    super.initState();

    _videoPlayProvider = VideoPlayProvider.of(context);

    _init();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _videoPlayProvider!.addListener(_videoPlayProviderListener);
    });
  }

  void _videoPlayProviderListener() async {
    if (widget.index == _videoPlayProvider!.videoPlayState.stopIndex &&
        ((widget.videoData!["path"] != null && _videoPlayProvider!.videoPlayState.selectedVideo != widget.videoData!["path"]) ||
            (widget.videoData!["file"] != null && _videoPlayProvider!.videoPlayState.selectedVideo != widget.videoData!["file"]))) {
      if (_videoPlayerController!.value.isPlaying) {
        await _seekToPlayer(0);
        _sliderCurrentPosition = 0;
        await _onStopPlay();
      } else {
        await _seekToPlayer(0);
        _sliderCurrentPosition = 0;
      }
      setState(() {});
    }
  }

  void _init() {
    if (widget.videoData!["path"] != null) {
      _videoPlayerController = VideoPlayerController.network(widget.videoData!["path"])
        ..initialize().then(
          (_) {
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              _maxDuration = _videoPlayerController!.value.duration.inMilliseconds.toDouble();
              if (_maxDuration <= 0) _maxDuration = 0.0;
              if (mounted) setState(() {});
            });
          },
        ).onError((error, stackTrace) {
          print(error);
        });
    } else if (widget.videoData!["file"] != null) {
      _videoPlayerController = VideoPlayerController.file(widget.videoData!["file"])
        ..initialize().then(
          (_) {
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              _maxDuration = _videoPlayerController!.value.duration.inMilliseconds.toDouble();
              if (_maxDuration <= 0) _maxDuration = 0.0;
              if (mounted) setState(() {});
            });
          },
        ).onError((error, stackTrace) {
          print(error);
        });
    }
  }

  @override
  void dispose() {
    if (uploadTimer != null) uploadTimer!.cancel();
    _videoPlayProvider!.removeListener(_videoPlayProviderListener);
    _videoPlayerController!.dispose();
    super.dispose();
  }

  void _onStartPlay() async {
    if (_videoPlayerController == null || !_videoPlayerController!.value.isInitialized) return;
    try {
      if ((widget.videoData!["path"] != null && _videoPlayProvider!.videoPlayState.selectedVideo != widget.videoData!["path"]) ||
          (widget.videoData!["file"] != null && _videoPlayProvider!.videoPlayState.selectedVideo != widget.videoData!["file"])) {
        _videoPlayProvider!.setVideoPlayState(
          _videoPlayProvider!.videoPlayState.update(
            playIndex: widget.index,
            stopIndex: _videoPlayProvider!.videoPlayState.playIndex,
            selectedVideo: widget.videoData!["path"] != null
                ? widget.videoData!["path"]
                : widget.videoData!["file"] != null
                    ? widget.videoData!["file"]
                    : null,
          ),
        );
      }

      await _videoPlayerController!.play();
      _timer = Timer.periodic(Duration(milliseconds: 1), (timer) async {
        if ((await _videoPlayerController!.position) == null) return;
        _sliderCurrentPosition = (await _videoPlayerController!.position)!.inMilliseconds.toDouble();
        if (_sliderCurrentPosition >= _maxDuration) {
          _onStopPlay();
        } else {
          if (mounted) setState(() {});
        }
      });
    } catch (e) {
      FlutterLogs.logThis(
        tag: "video_media_widget copy",
        level: LogLevel.ERROR,
        subTag: "_onStartPlay",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  Future<void> _seekToPlayer(int milliSecs) async {
    if (_videoPlayerController == null || !_videoPlayerController!.value.isInitialized) return;
    try {
      await _videoPlayerController!.seekTo(Duration(milliseconds: milliSecs));
      if (_timer != null) _timer!.cancel();
      _timer = Timer.periodic(Duration(milliseconds: 1), (timer) async {
        Duration? duration = await _videoPlayerController!.position;
        if (duration == null) return;
        _sliderCurrentPosition = duration.inMilliseconds.toDouble();
        if (_sliderCurrentPosition >= _maxDuration) {
          _onStopPlay();
        } else {
          if (mounted) setState(() {});
        }
      });
    } on Exception catch (err) {
      print('error: $err');
    }
    if (mounted) setState(() {});
  }

  Future<void> _onStopPlay() async {
    if (_videoPlayerController == null || !_videoPlayerController!.value.isInitialized) return;
    if (!_videoPlayerController!.value.isPlaying) return;

    if (_timer != null) _timer!.cancel();
    await _videoPlayerController!.pause();

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_videoPlayerController == null || !_videoPlayerController!.value.isInitialized) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        direction: ShimmerDirection.ltr,
        enabled: true,
        period: Duration(milliseconds: 1000),
        child: Container(
          width: (MediaQuery.of(context).size.width - widthDp * 60),
          height: heightDp * 200,
          margin: EdgeInsets.symmetric(vertical: heightDp * 5),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(heightDp * 0),
          ),
        ),
      );
    }

    var maxTime = DateTime.fromMillisecondsSinceEpoch(_maxDuration.toInt(), isUtc: true);
    var maxTimeString = DateFormat('mm:ss').format(maxTime);
    var currentTime = DateTime.fromMillisecondsSinceEpoch(_sliderCurrentPosition.toInt(), isUtc: true);
    var currentTimeString = DateFormat('mm:ss').format(currentTime);

    return Consumer<VideoPlayProvider>(builder: (context, videoPlayProvider, _) {
      return Card(
        margin: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
        elevation: 6,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
          color: Colors.white,
          child: Column(
            children: [
              Text(
                "${widget.videoData!["description"]}",
                style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: heightDp * 5),
              Stack(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - widthDp * 60),
                    height: _videoPlayerController!.value.aspectRatio < 1
                        ? (MediaQuery.of(context).size.width - widthDp * 60) * _videoPlayerController!.value.aspectRatio
                        : (MediaQuery.of(context).size.width - widthDp * 60) / _videoPlayerController!.value.aspectRatio,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(heightDp * 0),
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(heightDp * 0),
                        child: AspectRatio(
                          // aspectRatio: (MediaQuery.of(context).size.width - widthDp * 60) / heightDp * 200,
                          aspectRatio: _videoPlayerController!.value.size != null ? _videoPlayerController!.value.aspectRatio : 1.0,
                          child: VideoPlayer(_videoPlayerController!),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: heightDp * 5,
                    child: Container(
                      width: (MediaQuery.of(context).size.width - widthDp * 60),
                      color: Colors.black.withOpacity(0.3),
                      child: Row(
                        children: [
                          if (!_videoPlayerController!.value.isPlaying)
                            GestureDetector(
                              onTap: _onStartPlay,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: widthDp * 3, vertical: heightDp * 5),
                                child: Icon(Icons.play_arrow, size: heightDp * 25, color: Colors.white),
                              ),
                            ),
                          if (_videoPlayerController!.value.isPlaying)
                            GestureDetector(
                              onTap: _onStopPlay,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                                child: Icon(Icons.stop, size: heightDp * 25, color: Colors.white),
                              ),
                            ),
                          Expanded(
                            child: Container(
                              height: heightDp * 20,
                              child: Slider(
                                value: min(_sliderCurrentPosition, _maxDuration),
                                min: 0.0,
                                max: _maxDuration,
                                activeColor: Colors.white,
                                inactiveColor: Colors.white,
                                onChanged: (value) async {
                                  await _seekToPlayer(value.toInt());
                                },
                                divisions: _maxDuration == 0.0 ? 1 : _maxDuration.toInt(),
                              ),
                            ),
                          ),
                          Text(
                            "$currentTimeString/$maxTimeString",
                            style: Theme.of(context).textTheme.overline!.copyWith(color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await _onStopPlay();
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => VideoPlayFullScreen(
                                    videoPlayerController: _videoPlayerController,
                                    path: widget.videoData!["path"],
                                    file: widget.videoData!["file"],
                                  ),
                                ),
                              );
                              // pushNewScreen(
                              //   context,
                              //   screen: VideoPlayFullScreen(
                              //     mediaModel: widget.mediaModel!,
                              //   ),
                              //   withNavBar: false,
                              //   pageTransitionAnimation: PageTransitionAnimation.fade,
                              // );
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                left: widthDp * 5,
                                right: widthDp * 5,
                                top: heightDp * 5,
                                bottom: heightDp * 5,
                              ),
                              child: Icon(Icons.fullscreen, size: heightDp * 25, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class VideoPlayFullScreen extends StatefulWidget {
  final VideoPlayerController? videoPlayerController;
  final String? path;
  final File? file;

  VideoPlayFullScreen({
    @required this.videoPlayerController,
    this.path,
    this.file,
  });

  @override
  _VideoPlayFullScreenState createState() => _VideoPlayFullScreenState();
}

class _VideoPlayFullScreenState extends State<VideoPlayFullScreen> {
  Timer? _timer;

  double _maxDuration = 1.0;
  double _sliderCurrentPosition = 0.0;
  String _playerTxt = '00:00:00';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _maxDuration = widget.videoPlayerController!.value.duration.inMilliseconds.toDouble();
      if (_maxDuration <= 0) _maxDuration = 0.0;
      if (mounted) setState(() {});
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark, //status bar brigtness
      ));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = 1.sw;
    double deviceHeight = 1.sh;
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double statusbarHeight = ScreenUtil().statusBarHeight;

    var maxTime = DateTime.fromMillisecondsSinceEpoch(_maxDuration.toInt(), isUtc: true);
    var maxTimeString = DateFormat('mm:ss').format(maxTime);
    var currentTime = DateTime.fromMillisecondsSinceEpoch(_sliderCurrentPosition.toInt(), isUtc: true);
    var currentTimeString = DateFormat('mm:ss').format(currentTime);

    return WillPopScope(
      onWillPop: () async {
        await _onStopPlay();
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          padding: EdgeInsets.only(top: statusbarHeight),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(heightDp * 0),
          ),
          child: RotatedBox(
            quarterTurns: widget.videoPlayerController!.value.aspectRatio < 1 ? 0 : 1,
            child: Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: widget.videoPlayerController!.value.size != null ? widget.videoPlayerController!.value.aspectRatio : 1.0,
                    child: VideoPlayer(widget.videoPlayerController!),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_outlined, color: Colors.white, size: heightDp * 30),
                  onPressed: () async {
                    await _onStopPlay();
                    Navigator.of(context).pop();
                  },
                ),
                Positioned(
                  bottom: heightDp * 5,
                  child: Container(
                    width: widget.videoPlayerController!.value.aspectRatio < 1 ? deviceWidth : deviceHeight - statusbarHeight,
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                    color: Colors.black.withOpacity(0.3),
                    child: Row(
                      children: [
                        SizedBox(width: widthDp * 10),
                        if (!widget.videoPlayerController!.value.isPlaying)
                          GestureDetector(
                            onTap: _onStartPlay,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: widthDp * 3, vertical: heightDp * 5),
                              child: Icon(Icons.play_arrow, size: heightDp * 25, color: Colors.white),
                            ),
                          ),
                        if (widget.videoPlayerController!.value.isPlaying)
                          GestureDetector(
                            onTap: _onStopPlay,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                              child: Icon(Icons.stop, size: heightDp * 25, color: Colors.white),
                            ),
                          ),
                        Expanded(
                          child: Container(
                            height: heightDp * 20,
                            child: Slider(
                              value: min(_sliderCurrentPosition, _maxDuration),
                              min: 0.0,
                              max: _maxDuration,
                              activeColor: Colors.white,
                              inactiveColor: Colors.white,
                              onChanged: (value) async {
                                await _seekToPlayer(value.toInt());
                              },
                              divisions: _maxDuration == 0.0 ? 1 : _maxDuration.toInt(),
                            ),
                          ),
                        ),
                        Text(
                          "$currentTimeString/$maxTimeString",
                          style: Theme.of(context).textTheme.overline!.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onStartPlay() async {
    if (widget.videoPlayerController == null || !widget.videoPlayerController!.value.isInitialized) return;
    try {
      await widget.videoPlayerController!.play();
      _timer = Timer.periodic(Duration(milliseconds: 1), (timer) async {
        if ((await widget.videoPlayerController!.position) == null) return;
        _sliderCurrentPosition = (await widget.videoPlayerController!.position)!.inMilliseconds.toDouble();
        if (_sliderCurrentPosition >= _maxDuration) {
          _onStopPlay();
        } else {
          if (mounted) setState(() {});
        }
      });
    } catch (e) {}
  }

  Future<void> _seekToPlayer(int milliSecs) async {
    if (widget.videoPlayerController == null || !widget.videoPlayerController!.value.isInitialized || _timer == null) return;
    try {
      await widget.videoPlayerController!.seekTo(Duration(milliseconds: milliSecs));
      if (_timer != null) _timer!.cancel();
      _timer = Timer.periodic(Duration(milliseconds: 1), (timer) async {
        Duration? duration = await widget.videoPlayerController!.position;
        if (duration == null) return;
        _sliderCurrentPosition = duration.inMilliseconds.toDouble();
        if (_sliderCurrentPosition >= _maxDuration) {
          _onStopPlay();
        } else {
          if (mounted) setState(() {});
        }
      });
    } on Exception catch (err) {
      print('error: $err');
    }
    if (mounted) setState(() {});
  }

  Future<void> _onStopPlay() async {
    if (widget.videoPlayerController == null || !widget.videoPlayerController!.value.isInitialized) return;
    if (!widget.videoPlayerController!.value.isPlaying) return;

    if (_timer != null) _timer!.cancel();
    await widget.videoPlayerController!.pause();
    if (mounted) setState(() {});
  }
}
