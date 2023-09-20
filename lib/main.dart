import 'package:trapp/bootstrap.dart';
import 'package:trapp/environment.dart';

void main() async {
  Environment(
    debug: true,
    envName: "development",
    // apiBaseUrl: "http://192.168.43.57:7000/api/v1/",
    // apiBaseUrl: "http://192.168.0.136:7000/api/v1/",
    apiBaseUrl: "http://192.168.1.24:7000/api/v1/",
    // apiBaseUrl: "http://192.168.1.103:7000/api/v1/",
    // apiBaseUrl: "http://192.168.100.17:7000/api/v1/",
    // apiBaseUrl: "http://192.168.1.198:7000/api/v1/",
    // apiBaseUrl: "https://qa.api.tm.user.trademantri.in/api/v1/",
    googleApiKey: "AIzaSyBfkIHqXazhle5rR1znrtxCU53cpHgVFkQ",
    checkUpdates: true,
    enableFBEvents: false,
    enableFirebaseEvents: false,
    freshChatId: "0f4a3e09-8291-4bc6-a857-4590c167a41d",
    freshChatKey: "810d2f29-cfcc-434e-b63b-692a1199dbcb",
    freshChatDomain: "msdk.in.freshchat.com",
    enableFreshChatEvents: false,
    vapidKey: "BE8QNT4FPufcL-ZCdDR7VMHsIuBPCG8_Mzn0uHYffPnYgMQVuO3-1KoJra9a9bvSTldKhTNejUHXRiTGYk2Ggqw",
    razorPayKey: "rzp_test_VLO6ykQK3Nu5TE",
    dynamicLinkBase: "https://trademantriqa.page.link",
    infoUrl: "https://qa.trademantri.in",
    rootStoreId: "5f773bc1f52d450024907b11",
    // logsEncryptionKey: "QfTjWnZr4u7x!A%D*F-JaNdRgUkXp2s5",
  );

  bootstrap();
}
