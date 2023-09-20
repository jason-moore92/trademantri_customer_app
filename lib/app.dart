import 'dart:convert';

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/route_generator.dart';
import 'package:trapp/src/helpers/analytics_observer.dart';
import 'package:trapp/src/pages/BargainRequestDetailPage/bargain_request_detail_page.dart';
import 'package:trapp/src/pages/OrderDetailNewPage/index.dart';
import 'package:trapp/src/pages/login.dart';
import 'package:trapp/src/providers/fb_analytics.dart';
import 'package:trapp/src/providers/firebase_analytics.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trapp/generated/l10n.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/services/keicy_fcm_for_mobile.dart';
import 'package:trapp/src/services/keicy_local_notification.dart';

import 'config/config.dart';
import 'src/pages/ReverseAuctionDetailPage/index.dart';
import 'src/providers/BridgeProvider/bridge_provider.dart';
import 'src/providers/BridgeProvider/bridge_state.dart';
import 'package:google_map_location_picker/generated/l10n.dart' as location_picker;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    KeicyFCMForMobile.setNavigatorey(navigatorKey);
    WidgetsBinding.instance!.addObserver(this);
    getFBAppEvents().setAutoLogAppEventsEnabled(
      true,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("img/logo.png"), context);
    precacheImage(AssetImage("img/app_update.png"), context);

    AppConfig.paymentMethods.forEach((pm) {
      precacheImage(AssetImage("img/payment_methods/${pm['image']}.png"), context);
    });
    return ScreenUtilInit(
      designSize: Size(AppConfig.mobileDesignWidth, AppConfig.mobileDesignHeight),
      builder: () {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppDataProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => StorePageProvider()),
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => FavoriteProvider()),
            ChangeNotifierProvider(create: (_) => DeliveryAddressProvider()),
            ChangeNotifierProvider(create: (_) => PromocodeProvider()),
            ChangeNotifierProvider(create: (_) => OrderProvider()),
            ChangeNotifierProvider(create: (_) => ContactUsRequestProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
            ChangeNotifierProvider(create: (_) => CategoryProvider()),
            ChangeNotifierProvider(create: (_) => RewardPointProvider()),
            ChangeNotifierProvider(create: (_) => ReverseAuctionProvider()),
            ChangeNotifierProvider(create: (_) => BargainRequestProvider()),
            ChangeNotifierProvider(create: (_) => DeliveryPartnerProvider()),
            ChangeNotifierProvider(create: (_) => RefreshProvider()),
            ChangeNotifierProvider(create: (_) => ProductItemReviewProvider()),
            ChangeNotifierProvider(create: (_) => ReferralRewardU2UOffersProvider()),
            ChangeNotifierProvider(create: (_) => ReferralRewardU2SOffersProvider()),
            ChangeNotifierProvider(create: (_) => PaymentLinkProvider()),
            ChangeNotifierProvider(create: (_) => StoreJobPostingsProvider()),
            ChangeNotifierProvider(create: (_) => AppliedJobProvider()),
            ChangeNotifierProvider(create: (_) => InvoicesProvider()),
            ChangeNotifierProvider(create: (_) => StoreCategoriesProvider()),
            ChangeNotifierProvider(create: (_) => SearchProvider()),
            ChangeNotifierProvider(create: (_) => AppointmentProvider()),
            ChangeNotifierProvider(create: (_) => BookAppointmentProvider()),
            ChangeNotifierProvider(create: (_) => LuckyDrawProvider()),
          ],
          child: MaterialApp(
            title: 'TradeMantri',
            initialRoute: '/',
            navigatorKey: navigatorKey,
            onGenerateRoute: RouteGenerator.generateRoute,
            navigatorObservers: [
              FirebaseAnalyticsObserver(
                analytics: getFirebaseAnalytics(),
              ),
              AnalyticsObserver(),
            ],
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              RefreshLocalizations.delegate,
              S.delegate,
              location_picker.S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            theme: ThemeData(
              fontFamily: 'Montserrat',
              brightness: Brightness.light,
              primaryColor: Colors.white,
              // scaffoldBackgroundColor: config.Colors().primaryColor(1),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              accentColor: config.Colors().mainColor(1),
              hintColor: config.Colors().secondColor(1),
              focusColor: config.Colors().accentColor(1),
              // iconTheme: IconThemeData(color: config.Colors().secondColor(1)),
              textTheme: TextTheme(
                headline5: TextStyle(fontSize: 20.0, color: config.Colors().secondColor(1)),
                // headline: TextStyle(fontSize: 20.0, color: config.Colors().secondColor(1)),
                headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: config.Colors().secondColor(1)),
                // display1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: config.Colors().secondColor(1)),
                headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: config.Colors().secondColor(1)),
                // display2: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: config.Colors().secondColor(1)),
                headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().mainColor(1)),
                // display3: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().mainColor(1)),
                headline1: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300, color: config.Colors().secondColor(1)),
                // display4: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300, color: config.Colors().secondColor(1)),
                subtitle1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: config.Colors().secondColor(1)),
                // subtitle1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: config.Colors().secondColor(1)),
                headline6: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: config.Colors().mainColor(1)),
                // title: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: config.Colors().mainColor(1)),
                bodyText2: TextStyle(fontSize: 12.0, color: config.Colors().secondColor(1)),
                // body1: TextStyle(fontSize: 12.0, color: config.Colors().secondColor(1)),
                bodyText1: TextStyle(fontSize: 14.0, color: config.Colors().secondColor(1)),
                // body2: TextStyle(fontSize: 14.0, color: config.Colors().secondColor(1)),
                caption: TextStyle(fontSize: 12.0, color: config.Colors().accentColor(1)),
              ),
            ),
            // themeMode: EasyDynamicTheme.of(context).themeMode,
            builder: (context, child) {
              return StreamBuilder<String>(
                stream: KeicyLocalNotification.instance.selectNotificationSubject,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null && snapshot.data != "") {
                    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                      if (snapshot.data != null) {
                        var data = json.decode(snapshot.data!);
                        if (AuthProvider.of(context).authState.userModel!.id == data["userId"]) {
                          notificationHandler(context, data);
                        } else if (AuthProvider.of(context).authState.userModel!.id == null) {
                          navigatorKey.currentState!
                            ..push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => LoginWidget(
                                  callback: () {
                                    if (AuthProvider.of(context).authState.userModel!.id == data["userId"]) {
                                      notificationHandler(context, data);
                                    }
                                  },
                                ),
                              ),
                            );
                        }
                      }
                    });

                    KeicyLocalNotification.instance.selectNotificationSubject.add("");
                  }

                  return StreamBuilder<BridgeState>(
                    stream: BridgeProvider().getStream(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        FlutterLogs.logInfo(
                          "app",
                          "BridgeProvider:stream",
                          snapshot.data.toString(),
                        );
                      }
                      if (snapshot.hasData && snapshot.data != null && snapshot.data!.event == "log_out") {
                        AuthProvider.of(context).clearAuthState();
                        AppDataProvider.of(context).initProviderHandler(context);
                        BridgeProvider().update(
                          BridgeState(
                            event: "init",
                            data: {
                              "message": "init",
                            },
                          ),
                        );

                        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                          navigatorKey.currentState!
                            ..pushAndRemoveUntil(
                              MaterialPageRoute(builder: (BuildContext context) => LoginWidget()),
                              ModalRoute.withName('/'),
                            );
                        });
                      }
                      return child!;
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void notificationHandler(BuildContext context, Map<String, dynamic> data) {
    switch (data["type"]) {
      case "order":
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (BuildContext context) => OrderDetailNewPage(
              orderId: data["data"]["orderId"],
              storeId: data["data"]["storeId"],
              userId: data["data"]["userId"],
            ),
          ),
        );
        break;
      case "bargain":
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (BuildContext context) => BargainRequestDetailPage(
              bargainRequestId: data["data"]["bargainRequestId"],
              storeId: data["storeId"],
              userId: data["userId"],
            ),
          ),
        );
        break;
      case "reverse_auction":
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (BuildContext context) => ReverseAuctionDetailPage(
              reverseAuctionId: data["data"]["reverseAuctionId"],
              storeId: data["storeId"],
              userId: data["userId"],
            ),
          ),
        );
        break;
      case "scratch_card":
        if (data["data"]["status"] == "create") {
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (BuildContext context) => OrderDetailNewPage(
                orderId: data["data"]["orderId"],
                storeId: data["data"]["storeId"],
                userId: data["data"]["userId"],
                scratchStatus: "scratch_card_create",
              ),
            ),
          );
        }
        break;
      default:
    }
  }
}
