import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:map_launcher/map_launcher.dart';
import 'package:trapp/src/dialogs/maps_sheet.dart';
import 'package:trapp/src/models/index.dart';

class StoreInfoPanel extends StatefulWidget {
  final StoreModel? storeModel;

  StoreInfoPanel({@required this.storeModel});

  @override
  _StoreInfoPanelState createState() => _StoreInfoPanelState();
}

class _StoreInfoPanelState extends State<StoreInfoPanel> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Store name:   ",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Text(
                "${widget.storeModel!.name}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: heightDp * 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Store category:   ",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Text(
                "${widget.storeModel!.subType}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: heightDp * 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Store address:   ",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Expanded(
              child: Text(
                "${widget.storeModel!.address}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () {
                MapsSheet.show(
                  context: context,
                  onMapTap: (map) {
                    map.showMarker(
                      coords: Coords(widget.storeModel!.location!.latitude, widget.storeModel!.location!.longitude),
                      title: "",
                    );
                  },
                );
              },
              child: Icon(Icons.location_on, size: heightDp * 30, color: config.Colors().mainColor(1)),
            ),
          ],
        ),
      ],
    );
  }
}
