import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class VideoType {
  static const youtube = "youtube";
  static const normal = "normal";
}

class VideoPlayState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final dynamic selectedVideo;
  final int? playIndex;
  final int? stopIndex;

  VideoPlayState({
    @required this.progressState,
    @required this.message,
    @required this.selectedVideo,
    @required this.playIndex,
    @required this.stopIndex,
  });

  factory VideoPlayState.init() {
    return VideoPlayState(
      progressState: 0,
      message: "",
      selectedVideo: null,
      playIndex: -1,
      stopIndex: -1,
    );
  }

  VideoPlayState copyWith({
    int? progressState,
    String? message,
    dynamic selectedVideo,
    int? playIndex,
    int? stopIndex,
  }) {
    return VideoPlayState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      selectedVideo: selectedVideo ?? this.selectedVideo,
      playIndex: playIndex ?? this.playIndex,
      stopIndex: stopIndex ?? this.stopIndex,
    );
  }

  VideoPlayState update({
    int? progressState,
    String? message,
    dynamic selectedVideo,
    int? playIndex,
    int? stopIndex,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      selectedVideo: selectedVideo,
      playIndex: playIndex,
      stopIndex: stopIndex,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "selectedVideo": selectedVideo,
      "playIndex": playIndex,
      "stopIndex": stopIndex,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        selectedVideo ?? Object(),
        playIndex!,
        stopIndex!,
      ];

  @override
  bool get stringify => true;
}
