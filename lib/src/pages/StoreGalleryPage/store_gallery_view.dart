import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/youtube_video_widget.dart';
import 'package:trapp/src/pages/StoreGalleryPage/index.dart';
import 'package:trapp/src/providers/index.dart';

class StoreGalleryView extends StatefulWidget {
  final Map<String, dynamic>? galleryData;

  StoreGalleryView({Key? key, @required this.galleryData}) : super(key: key);

  @override
  _StoreGalleryViewState createState() => _StoreGalleryViewState();
}

class _StoreGalleryViewState extends State<StoreGalleryView> with SingleTickerProviderStateMixin {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  TabController? _tabController;
  Map<String, dynamic>? _selectedVideoData;

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
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Store Gallery",
            style: TextStyle(fontSize: fontSp * 16),
          ),
        ),
        body: Column(
          children: [
            _tabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ImageGallaryPanel(galleryData: widget.galleryData),
                  VideoGallaryPanel(galleryData: widget.galleryData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      width: deviceWidth,
      height: heightDp * 40,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      // decoration: BoxDecoration(
      //   border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1)),
      // ),
      alignment: Alignment.center,
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.zero,
        indicatorWeight: 1,
        indicator: BoxDecoration(
          color: config.Colors().mainColor(1),
          borderRadius: BorderRadius.circular(heightDp * 50),
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: widthDp * 0),
        labelStyle: TextStyle(fontSize: fontSp * 14),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: [
          Tab(
            text: "Images",
          ),
          Tab(
            text: "Videos",
          ),
        ],
      ),
    );
  }
}
