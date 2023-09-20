import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsProvider {
  static final FirebaseAnalyticsProvider _instance = FirebaseAnalyticsProvider._internal();
  static FirebaseAnalytics? _analytics;

  factory FirebaseAnalyticsProvider() {
    return _instance;
  }

  FirebaseAnalyticsProvider._internal() {
    _analytics = FirebaseAnalytics();
  }

  FirebaseAnalytics get analytics => _analytics!;
}

FirebaseAnalytics getFirebaseAnalytics() {
  return FirebaseAnalyticsProvider().analytics;
}
