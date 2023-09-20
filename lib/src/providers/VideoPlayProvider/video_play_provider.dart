import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'index.dart';

class VideoPlayProvider extends ChangeNotifier {
  static VideoPlayProvider of(BuildContext context, {bool listen = false}) => Provider.of<VideoPlayProvider>(context, listen: listen);

  VideoPlayState _videoPlayState = VideoPlayState.init();
  VideoPlayState get videoPlayState => _videoPlayState;

  void setVideoPlayState(VideoPlayState videoPlayState, {bool isNotifiable = true}) {
    if (_videoPlayState != videoPlayState) {
      _videoPlayState = videoPlayState;
      if (isNotifiable) notifyListeners();
    }
  }

  void refresh() {
    notifyListeners();
  }
}
