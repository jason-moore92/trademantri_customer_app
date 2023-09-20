import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/dialogs/maps_sheet.dart';

class FullAddressDialog {
  static show(
    BuildContext context, {
    String title = "Address",
    String content = "",
    LatLng? location,
  }) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // backgroundColor: Colors.white,
          title: Text(
            title,
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          titlePadding: title == "" ? EdgeInsets.zero : EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
          content: Text(
            content,
            style: TextStyle(fontSize: fontSp * 14, color: Colors.black, height: 1.5),
            textAlign: TextAlign.center,
          ),
          contentPadding: content == "" ? EdgeInsets.zero : EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          actions: [
            if (location != null)
              FlatButton(
                color: config.Colors().mainColor(1),
                onPressed: () {
                  Navigator.of(context).pop();
                  MapsSheet.show(
                    context: context,
                    onMapTap: (map) {
                      map.showMarker(
                        coords: Coords(location.latitude, location.longitude),
                        title: "",
                      );
                    },
                  );
                },
                child: Text(
                  "Open in map",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            FlatButton(
              color: config.Colors().mainColor(1),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}
