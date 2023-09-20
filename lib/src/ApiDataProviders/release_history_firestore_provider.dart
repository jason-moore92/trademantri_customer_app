import 'package:flutter/material.dart';
import 'package:trapp/src/services/keicy_firestore_data_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ReleaseHistoryFirestoreProvider {
  static String path = "/ReleaseHistory";

  static Future<Map<String, dynamic>> getReleaseByID({
    @required String? id,
  }) async {
    return await KeicyFireStoreDataProvider.instance.getDocumentByID(
      path: path,
      id: id,
    );
  }

  static Future<Map<String, dynamic>?> getReleaseByNumber({
    @required int? number,
  }) async {
    PackageInfo info = await PackageInfo.fromPlatform();
    Map<String, dynamic> releasesResponse = await KeicyFireStoreDataProvider.instance.getDocumentsData(
      path: path,
      wheres: [
        {
          "key": "number",
          "val": number,
        },
        {
          "key": "packageId",
          "val": info.packageName,
        }
      ],
      limit: 1,
    );

    if (!releasesResponse["success"]) {
      return null;
    }

    if (releasesResponse["data"].length == 0) {
      return null;
    }

    return releasesResponse["data"][0];
  }
}
