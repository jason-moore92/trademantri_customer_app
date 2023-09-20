import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/services/dynamic_link_service.dart';

class GlobalVariables {
  static final DynamicLinkService dynamicLinkService = DynamicLinkService();
  static SharedPreferences? prefs;
  static bool? isCalledGetInitialDynamicLink;
}
