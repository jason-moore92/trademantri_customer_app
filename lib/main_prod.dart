import 'package:trapp/bootstrap.dart';
import 'package:trapp/environment.dart';

void main() async {
  Environment(
    debug: false,
    envName: "production",
    apiBaseUrl: "https://api.tm.user.trademantri.in/api/v1/",
    googleApiKey: "AIzaSyBfkIHqXazhle5rR1znrtxCU53cpHgVFkQ",
    checkUpdates: true,
    enableFBEvents: true,
    enableFirebaseEvents: true,
    freshChatId: "0f4a3e09-8291-4bc6-a857-4590c167a41d",
    freshChatKey: "810d2f29-cfcc-434e-b63b-692a1199dbcb",
    freshChatDomain: "msdk.in.freshchat.com",
    enableFreshChatEvents: true,
    vapidKey: "BEceWxyRTl3ns2Ic7I0sC-n3_HeP03c0bL50SYYFJbzYf4pVxVIo74yuCwcw-FcGl7UG9lgJywQ9rM1As8Uiras",
    razorPayKey: "rzp_live_F1YZ230Mtm4kQN",
    dynamicLinkBase: "https://trademantri.page.link",
    infoUrl: "https://trademantri.in",
    rootStoreId: "5f773bc1f52d450024907b11",
    logsEncryptionKey: "UkXp2s5v8y/B?E(H+KbPeShVmYq3t6w9",
  );

  bootstrap();
}
