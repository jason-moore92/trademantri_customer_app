import 'package:facebook_app_events/facebook_app_events.dart';

class FBAnalytics {
  static final FBAnalytics _instance = FBAnalytics._internal();
  static FacebookAppEvents? _facebookAppEvents;

  factory FBAnalytics() {
    return _instance;
  }

  FBAnalytics._internal() {
    _facebookAppEvents = new FacebookAppEvents();
  }

  FacebookAppEvents get appEvents => _facebookAppEvents!;
}

FacebookAppEvents getFBAppEvents() {
  return FBAnalytics().appEvents;
}
