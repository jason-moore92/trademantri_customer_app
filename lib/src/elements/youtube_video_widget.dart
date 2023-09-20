import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/helpers/validators.dart';
import 'package:trapp/src/providers/VideoPlayProvider/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeVideoWidget extends StatefulWidget {
  final Map<String, dynamic>? videoData;
  final int? index;

  YoutubeVideoWidget({
    Key? key,
    @required this.videoData,
    @required this.index,
  }) : super(key: key);

  @override
  _YoutubeVideoWidgetState createState() => _YoutubeVideoWidgetState();
}

class _YoutubeVideoWidgetState extends State<YoutubeVideoWidget> {
  double widthDp = ScreenUtil().setWidth(1);
  double heightDp = ScreenUtil().setWidth(1);
  double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

  YoutubePlayerController? _youtubePlayerController;

  VideoPlayProvider? _videoPlayProvider;

  bool _isPlayerReady = false;

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
      if (_youtubePlayerController!.value.playerState == PlayerState.playing ||
          _youtubePlayerController!.value.playerState == PlayerState.paused ||
          _youtubePlayerController!.value.position != Duration.zero) {
        _youtubePlayerController!.reset();
        _youtubePlayerController!.seekTo(Duration.zero);
        _youtubePlayerController!.pause();
        setState(() {});
      }
    }
  }

  void _init() {
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: KeicyValidators.getYoutubeVideoId(widget.videoData!["path"])!,
      params: YoutubePlayerParams(
        autoPlay: false,
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    _youtubePlayerController!.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    };
    _youtubePlayerController!.onExitFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    };
    _youtubePlayerController!.listen((event) {
      if (event.playerState == PlayerState.playing && widget.index != _videoPlayProvider!.videoPlayState.stopIndex) {
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
      }
    });
  }

  @override
  void dispose() {
    _videoPlayProvider!.removeListener(_videoPlayProviderListener);
    _youtubePlayerController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            Container(
              width: MediaQuery.of(context).size.width - widthDp * 40,
              height: (MediaQuery.of(context).size.width - widthDp * 40) * 9 / 16,
              child: YoutubePlayerIFrame(
                controller: _youtubePlayerController,
                aspectRatio: 16 / 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
