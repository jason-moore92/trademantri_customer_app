import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/helpers/store_time_validation.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class StoreWidget extends StatefulWidget {
  final StoreModel? storeModel;
  final bool? loadingStatus;
  final String buttonString;
  final Function()? callback;

  StoreWidget({
    @required this.storeModel,
    @required this.loadingStatus,
    this.buttonString = "",
    this.callback,
  });

  @override
  _StoreWidgetState createState() => _StoreWidgetState();
}

class _StoreWidgetState extends State<StoreWidget> {
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
      color: Colors.transparent,
      child: widget.loadingStatus! ? _shimmerWidget() : _storeWidget(),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.loadingStatus!,
      period: Duration(milliseconds: 1000),
      child: Row(
        children: [
          Container(
            width: widthDp * 80,
            height: widthDp * 80,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(heightDp * 6)),
          ),
          SizedBox(width: widthDp * 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: widthDp * 100,
                  color: Colors.white,
                  child: Text(
                    "Loading ...",
                    style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.bold, color: Colors.transparent),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  width: widthDp * 140,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Text(
                        'storeModel city',
                        style: TextStyle(fontSize: fontSp * 11, color: Colors.transparent),
                      ),
                      SizedBox(width: widthDp * 15),
                      Text(
                        'Km',
                        style: TextStyle(fontSize: fontSp * 11, color: Colors.transparent),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  width: widthDp * 200,
                  color: Colors.white,
                  child: Text(
                    "storeModel address",
                    style: TextStyle(fontSize: fontSp * 11, color: Colors.transparent),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  width: widthDp * 100,
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 5), color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, size: heightDp * 15, color: Colors.white),
                      SizedBox(width: widthDp * 5),
                      Text(
                        "type",
                        style: TextStyle(fontSize: fontSp * 11, color: Colors.transparent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _storeWidget() {
    Color storeTypeColor = Colors.white;
    if (widget.storeModel!.type != null) {
      switch (widget.storeModel!.type) {
        case "Retailer":
          storeTypeColor = Colors.blue;
          break;
        case "Wholesaler":
          storeTypeColor = Colors.green;
          break;
        case "Service":
          storeTypeColor = Colors.red;
          break;
        default:
          storeTypeColor = Colors.white;
      }
    }
    var distance;
    distance = Geolocator.distanceBetween(
      AppDataProvider.of(context).appDataState.currentLocation!["location"]["lat"],
      AppDataProvider.of(context).appDataState.currentLocation!["location"]["lng"],
      widget.storeModel!.location!.latitude,
      widget.storeModel!.location!.longitude,
    );

    bool openStatus = StoreTimeValidation.validate(dateTime: DateTime.now(), storeModel: widget.storeModel);

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: [
          KeicyAvatarImage(
            url: widget.storeModel!.profile!["image"],
            width: widthDp * 80,
            height: widthDp * 80,
            backColor: Colors.grey.withOpacity(0.4),
            borderRadius: heightDp * 6,
            shimmerEnable: widget.loadingStatus,
            errorWidget: ClipRRect(
              borderRadius: BorderRadius.circular(heightDp * 6),
              child: Image.asset(
                "img/store-icon/${widget.storeModel!.subType.toString().toLowerCase()}-store.png",
                width: widthDp * 80,
                height: widthDp * 80,
              ),
            ),
          ),
          SizedBox(width: widthDp * 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.storeModel!.name} Store",
                            style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          SizedBox(height: heightDp * 5),
                          Row(
                            children: [
                              Text(
                                '${widget.storeModel!.city}',
                                style: TextStyle(fontSize: fontSp * 11, color: Colors.black),
                              ),
                              SizedBox(width: widthDp * 15),
                              Text(
                                '${((distance ?? 0) / 1000).toStringAsFixed(3)}Km',
                                style: TextStyle(fontSize: fontSp * 11, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: widthDp * 5),
                      child: Image.asset(
                        openStatus ? "img/store_open.png" : "img/store_close.png",
                        width: heightDp * 30,
                        height: heightDp * 30,
                        fit: BoxFit.cover,
                        color: openStatus ? config.Colors().mainColor(1) : Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 5),
                Row(
                  children: [
                    InkWell(
                      child: Icon(Icons.map),
                      onTap: () {
                        FullAddressDialog.show(
                          context,
                          content: widget.storeModel!.address!,
                          location: widget.storeModel!.location,
                        );
                      },
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: Text(
                        "${widget.storeModel!.address}",
                        style: TextStyle(
                          fontSize: fontSp * 11,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: widthDp * 105,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 5), color: storeTypeColor.withOpacity(0.4)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, size: heightDp * 15, color: storeTypeColor),
                          SizedBox(width: widthDp * 5),
                          Text(
                            "${widget.storeModel!.type}",
                            style: TextStyle(fontSize: fontSp * 11, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    widget.buttonString == ""
                        ? SizedBox()
                        : GestureDetector(
                            onTap: widget.callback,
                            child: Container(
                              width: widthDp * 100,
                              padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 5), color: config.Colors().mainColor(1)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.buttonString,
                                    style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
