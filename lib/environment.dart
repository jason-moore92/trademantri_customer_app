import 'package:meta/meta.dart';

class Environment {
  static bool debug = true;
  static String? envName;
  static String? apiBaseUrl;
  static String? googleApiKey;
  static bool checkUpdates = false;
  static bool? enableFBEvents;
  static bool? enableFirebaseEvents;
  static String? freshChatId;
  static String? freshChatKey;
  static String? freshChatDomain;
  static bool? enableFreshChatEvents;
  static String? vapidKey;
  static String? razorPayKey;
  static String dynamicLinkBase = "https://example.com";
  static String infoUrl = "https://qa.trademantri.in";
  static String rootStoreId = "5f773bc1f52d450024907b11";
  static String? logsEncryptionKey;

  Environment({
    bool debug = true,
    @required String? envName,
    @required String? apiBaseUrl,
    @required String? googleApiKey,
    bool checkUpdates = false,
    @required bool? enableFBEvents,
    @required bool? enableFirebaseEvents,
    @required String? freshChatId,
    @required String? freshChatKey,
    @required String? freshChatDomain,
    @required bool? enableFreshChatEvents,
    @required String? vapidKey,
    @required String? razorPayKey,
    String dynamicLinkBase = "https://example.com",
    String infoUrl = "https://qa.trademantri.in",
    String rootStoreId = "5f773bc1f52d450024907b11",
    String? logsEncryptionKey,
  }) {
    Environment.debug = debug;
    Environment.envName = envName;
    Environment.apiBaseUrl = apiBaseUrl;
    Environment.googleApiKey = googleApiKey;
    Environment.checkUpdates = checkUpdates;
    Environment.enableFBEvents = enableFBEvents;
    Environment.enableFirebaseEvents = enableFirebaseEvents;
    Environment.freshChatId = freshChatId;
    Environment.freshChatKey = freshChatKey;
    Environment.freshChatDomain = freshChatDomain;
    Environment.enableFreshChatEvents = enableFreshChatEvents;
    Environment.vapidKey = vapidKey;
    Environment.razorPayKey = razorPayKey;
    Environment.dynamicLinkBase = dynamicLinkBase;
    Environment.infoUrl = infoUrl;
    Environment.rootStoreId = rootStoreId;
    Environment.logsEncryptionKey = logsEncryptionKey;
  }
}
