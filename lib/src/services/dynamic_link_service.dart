import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/config/global.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/dialogs/login_ask_dialog.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/AnnouncementDetailPage/index.dart';
import 'package:trapp/src/pages/BookAppointmentPage/index.dart';
import 'package:trapp/src/pages/CouponDetailPage/index.dart';
import 'package:trapp/src/pages/ProductItemDetailPage/index.dart';
import 'package:trapp/src/pages/StoreJobPostingDetailPage/index.dart';
import 'package:trapp/src/pages/StorePage/store_page.dart';
import 'package:trapp/src/pages/signup.dart';
import 'package:trapp/src/providers/index.dart';

class DynamicLinkService {
  static Future<Uri> createStoreDynamicLink(StoreModel? storeModel) async {
    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: Environment.dynamicLinkBase,
      link: Uri.parse('${Environment.infoUrl}/store?id=${storeModel!.id}'),
      androidParameters: AndroidParameters(
        packageName: 'com.tradilligence.TradeMantri',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.tradilligence.TradeMantri',
        minimumVersion: '1',
        appStoreId: 'your_app_store_id',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: Uri.parse(storeModel.profile!["image"] ?? ""),
        title: storeModel.name,
        description: storeModel.description,
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  static Future<Uri> createProductDynamicLink({
    @required Map<String, dynamic>? itemData,
    @required StoreModel? storeModel,
    @required String? type,
    @required bool? isForCart,
  }) async {
    String url = '${Environment.infoUrl}/product_item';
    url += '?storeId=${storeModel!.id}';
    url += '&itemId=${itemData!["_id"]}';
    url += '&type=$type';
    url += '&isForCart=$isForCart';

    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: '${Environment.dynamicLinkBase}',
      link: Uri.parse(url),
      androidParameters: AndroidParameters(
        packageName: 'com.tradilligence.TradeMantri',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.tradilligence.TradeMantri',
        minimumVersion: '1',
        appStoreId: 'your_app_store_id',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: itemData["images"] != null && itemData["images"].isNotEmpty ? Uri.parse(itemData["images"][0]) : null,
        title: itemData["name"],
        description: "Store Name: ${storeModel.name}",
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  static Future<Uri> createReferFriendLink({
    @required String? description,
    @required String? referralCode,
    @required String? referredByUserId,
    @required String? appliedFor,
  }) async {
    String url = '${Environment.infoUrl}/refer_user_to_user';
    url += '?referralCode=$referralCode';
    url += '&referredByUserId=$referredByUserId';
    url += '&appliedFor=$appliedFor';

    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: '${Environment.dynamicLinkBase}',
      link: Uri.parse(url),
      androidParameters: AndroidParameters(
        packageName: 'com.tradilligence.TradeMantri',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.tradilligence.TradeMantri',
        minimumVersion: '1',
        appStoreId: 'your_app_store_id',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "Join TradeMantri and earn reward points",
        description:
            description! + "\nDownload the TradeMantri app now and order from 1000s of local stores and service providers. Support local businesses.",
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  static Future<Uri> createReferStoreLink({
    @required String? description,
    @required String? referralCode,
    @required String? referredByUserId,
    @required String? appliedFor,
  }) async {
    String url = '${Environment.infoUrl}/refer_user_to_store';
    url += '?referralCode=$referralCode';
    url += '&referredByUserId=$referredByUserId';
    url += '&appliedFor=$appliedFor';

    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: '${Environment.dynamicLinkBase}',
      link: Uri.parse(url),
      androidParameters: AndroidParameters(
        packageName: 'com.tradilligence.tradeMantriBiz',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.tradilligence.tradeMantriBiz',
        minimumVersion: '1',
        appStoreId: 'your_app_store_id',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "Join TradeMantri and increase your sales",
        description: description! +
            "\nTradeMantri helps increase the reach of your business to wider audience and helps you grow your business in multiple ways.",
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  static Future<Uri> createCouponDynamicLink({
    @required CouponModel? couponModel,
    @required StoreModel? storeModel,
  }) async {
    String url = '${Environment.infoUrl}/coupon';
    url += '?storeId=${storeModel!.id}';
    url += '&couponId=${couponModel!.id}';

    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: '${Environment.dynamicLinkBase}',
      link: Uri.parse(url),
      androidParameters: AndroidParameters(
        packageName: 'com.tradilligence.TradeMantri',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.tradilligence.TradeMantri',
        minimumVersion: '1',
        appStoreId: 'your_app_store_id',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: Uri.parse(couponModel.images!.isNotEmpty ? couponModel.images![0] : AppConfig.discountTypeImages[couponModel.discountType]),
        title: couponModel.discountCode,
        description: "Store Name: ${storeModel.name}",
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  static Future<Uri> createAnnouncementDynamicLink({
    @required Map<String, dynamic>? announcementData,
    @required Map<String, dynamic>? storeData,
  }) async {
    String url = '${Environment.infoUrl}/announcement';
    url += '?storeId=${storeData!["_id"]}';
    url += '&announcementId=${announcementData!["_id"]}';

    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: '${Environment.dynamicLinkBase}',
      link: Uri.parse(url),
      androidParameters: AndroidParameters(
        packageName: 'com.tradilligence.TradeMantri',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.tradilligence.TradeMantri',
        minimumVersion: '1',
        appStoreId: 'your_app_store_id',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: Uri.parse(announcementData["images"].isNotEmpty ? announcementData["images"][0] : AppConfig.announcementImage[0]),
        title: announcementData["title"],
        description: "Store Name: ${storeData["name"]}",
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  static Future<Uri> createJobDynamicLink({
    @required Map<String, dynamic>? jobData,
    @required Map<String, dynamic>? storeData,
  }) async {
    String url = '${Environment.infoUrl}/job';
    url += '?storeId=${storeData!["_id"]}';
    url += '&jobId=${jobData!["_id"]}';

    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: '${Environment.dynamicLinkBase}',
      link: Uri.parse(url),
      androidParameters: AndroidParameters(
        packageName: 'com.tradilligence.TradeMantri',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.tradilligence.TradeMantri',
        minimumVersion: '1',
        appStoreId: 'your_app_store_id',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: jobData["jobTitle"],
        description: "Store Name: ${storeData["name"]}",
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  Future<void> retrieveDynamicLink(BuildContext context, {bool isFirst = false}) async {
    try {
      FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
          FlutterLogs.logInfo("dynamic_link_service", "retrieveDynamicLink", "on success called");
          _dynamicLinkHandler(context, dynamicLink, isFirst: isFirst, isFrom: "onLink");
        },
        onError: (error) async {
          FlutterLogs.logThis(
            tag: "dynamic_link_service",
            subTag: "retrieveDynamicLink:onError",
            level: LogLevel.ERROR,
            exception: error,
          );
        },
      );
    } catch (e) {
      FlutterLogs.logThis(
        tag: "dynamic_link_service",
        subTag: "retrieveDynamicLink:catch",
        level: LogLevel.ERROR,
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
    FlutterLogs.logInfo(
      "dynamic_link_service",
      "retrieveDynamicLink",
      {
        "getInitialLink": GlobalVariables.isCalledGetInitialDynamicLink,
      }.toString(),
    );

    if (GlobalVariables.isCalledGetInitialDynamicLink == null) {
      PendingDynamicLinkData? dynamicLink = await FirebaseDynamicLinks.instance.getInitialLink();
      _dynamicLinkHandler(context, dynamicLink, isFirst: isFirst);
      GlobalVariables.isCalledGetInitialDynamicLink = true;
    }
  }

  Future<void> _dynamicLinkHandler(
    BuildContext? context,
    PendingDynamicLinkData? dynamicLink, {
    bool isFirst = false,
    String isFrom = "init",
  }) async {
    if (dynamicLink == null) return;
    Uri deepLink = dynamicLink.link;

    FlutterLogs.logInfo(
      "dynamic_link_service",
      "_dynamicLinkHandler",
      {
        "deepLink": deepLink,
        "isFirst": isFirst,
        "isFrom": isFrom,
      }.toString(),
    );

    dynamic params = dynamicLink.link.queryParameters;
    switch (dynamicLink.link.pathSegments[0]) {
      case "store":
        if (isFirst) return;

        String id = params["id"].toString().split("_").first;
        Navigator.of(context!).push(
          MaterialPageRoute(
            builder: (context) => StorePage(storeId: id),
          ),
        );
        break;
      case "product_item":
        if (isFirst) return;

        Navigator.of(context!).push(
          MaterialPageRoute(
            builder: (context) => ProductItemDetailPage(
              storeId: params["storeId"],
              itemId: params["itemId"],
              type: params["type"],
              isForCart: params["isForCart"].toString() == "true",
            ),
          ),
        );
        break;
      case "coupon":
        if (isFirst) return;

        Navigator.of(context!).push(
          MaterialPageRoute(
            builder: (BuildContext context) => CouponDetailPage(
              couponId: params["couponId"],
              storeId: params["storeId"],
              storeModel: null,
            ),
          ),
        );
        break;
      case "job":
        if (isFirst) return;

        Navigator.of(context!).push(
          MaterialPageRoute(
            builder: (BuildContext context) => StoreJobPostingDetailPage(
              jobId: params["jobId"],
              storeId: params["storeId"],
              jobPostingData: null,
            ),
          ),
        );
        break;
      case "announcement":
        if (isFirst) return;

        Navigator.of(context!).push(
          MaterialPageRoute(
            builder: (BuildContext context) => AnnouncementDetailPage(
              announcementId: params["announcementId"],
              storeId: params["storeId"],
              announcementData: null,
              storeData: null,
            ),
          ),
        );
        break;
      case "refer_friend":
        if (isFirst) {
          GlobalVariables.prefs!.setString("referralData", json.encode(params));
        } else {
          Navigator.of(context!).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => SignUpWidget(
                referralCode: params["referralCode"],
                referredByUserId: params["referredByUserId"],
                appliedFor: params["appliedFor"],
              ),
            ),
            (route) => false,
          );
        }
        break;
      case "refer_user_to_user":
        if (isFirst) {
          GlobalVariables.prefs!.setString("referralData", json.encode(params));
        } else {
          Navigator.of(context!).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => SignUpWidget(
                referralCode: params["referralCode"],
                referredByUserId: params["referredByUserId"],
                appliedFor: params["appliedFor"],
              ),
            ),
            (route) => false,
          );
        }
        break;
      case "refer_store_to_user":
        if (isFirst) {
          GlobalVariables.prefs!.setString("referralData", json.encode(params));
        } else {
          Navigator.of(context!).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => SignUpWidget(
                referralCode: params["referralCode"],
                referredByUserId: params["referredByStoreId"],
                appliedFor: params["appliedFor"],
              ),
            ),
            (route) => false,
          );
        }
        break;
      case "appointment":
        if (isFirst) return;
        if (AuthProvider.of(context!).authState.loginState == LoginState.IsNotLogin) {
          LoginAskDialog.show(
            context,
            callback: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => BookAppointmentPage(
                    appointmentId: params["id"],
                  ),
                ),
              );
            },
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => BookAppointmentPage(
                appointmentId: params["id"],
              ),
            ),
          );
        }

        break;
      default:
    }
  }
}
