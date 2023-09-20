import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/announcement_widget.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/AnnouncementDetailPage/index.dart';
import 'package:trapp/src/pages/ErrorPage/error_page.dart';
import 'package:trapp/src/pages/StorePage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class AnnouncementListForALLView extends StatefulWidget {
  final String? storeId;

  AnnouncementListForALLView({Key? key, this.storeId}) : super(key: key);

  @override
  _AnnouncementListForALLViewState createState() => _AnnouncementListForALLViewState();
}

class _AnnouncementListForALLViewState extends State<AnnouncementListForALLView> with SingleTickerProviderStateMixin {
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

  AnnouncementListProvider? _announcementListProvider;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  KeicyProgressDialog? _keicyProgressDialog;

  String? _selectedCity;

  String? _selectedCategory;

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

    _announcementListProvider = AnnouncementListProvider.of(context);

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    if (widget.storeId == null) {
      _selectedCity = AppDataProvider.of(context).appDataState.currentLocation!["city"];
    }

    _announcementListProvider!.setAnnouncementListState(
      _announcementListProvider!.announcementState.update(
        progressState: 0,
        announcementListData: Map<String, dynamic>(),
        announcementMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _announcementListProvider!.addListener(_announcementListProviderListener);

      if (widget.storeId == null) {
        await _announcementListProvider!.getCategories();
        if (_announcementListProvider!.announcementState.categories == null || _announcementListProvider!.announcementState.categories!.isEmpty)
          return;
      }

      _announcementListProvider!.setAnnouncementListState(
        _announcementListProvider!.announcementState.update(progressState: 1),
      );

      _announcementListProvider!.getAnnouncements(
        storeId: widget.storeId,
        category: _selectedCategory,
        city: _selectedCity,
        searchKey: _controller.text.trim(),
      );
    });
  }

  @override
  void dispose() {
    _announcementListProvider!.removeListener(_announcementListProviderListener);

    super.dispose();
  }

  void _announcementListProviderListener() async {
    if (_announcementListProvider!.announcementState.progressState == -1) {
      if (_announcementListProvider!.announcementState.isRefresh!) {
        _refreshController.refreshFailed();
        _announcementListProvider!.setAnnouncementListState(
          _announcementListProvider!.announcementState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController.loadFailed();
      }
    } else if (_announcementListProvider!.announcementState.progressState == 2) {
      if (_announcementListProvider!.announcementState.isRefresh!) {
        _refreshController.refreshCompleted();
        _announcementListProvider!.setAnnouncementListState(
          _announcementListProvider!.announcementState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic>? announcementListData = _announcementListProvider!.announcementState.announcementListData;
    Map<String, dynamic>? announcementMetaData = _announcementListProvider!.announcementState.announcementMetaData;

    announcementListData!["ALL"] = [];
    announcementMetaData!["ALL"] = Map<String, dynamic>();
    _announcementListProvider!.setAnnouncementListState(
      _announcementListProvider!.announcementState.update(
        progressState: 1,
        announcementListData: announcementListData,
        announcementMetaData: announcementMetaData,
        isRefresh: true,
      ),
    );

    _announcementListProvider!.getAnnouncements(
      storeId: widget.storeId,
      category: _selectedCategory,
      city: _selectedCity,
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _announcementListProvider!.setAnnouncementListState(
      _announcementListProvider!.announcementState.update(progressState: 1),
    );
    _announcementListProvider!.getAnnouncements(
      storeId: widget.storeId,
      category: _selectedCategory,
      city: _selectedCity,
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyAnnouncementListHandler() {
    Map<String, dynamic>? announcementListData = _announcementListProvider!.announcementState.announcementListData;
    Map<String, dynamic>? announcementMetaData = _announcementListProvider!.announcementState.announcementMetaData;

    announcementListData!["ALL"] = [];
    announcementMetaData!["ALL"] = Map<String, dynamic>();
    _announcementListProvider!.setAnnouncementListState(
      _announcementListProvider!.announcementState.update(
        progressState: 1,
        announcementListData: announcementListData,
        announcementMetaData: announcementMetaData,
      ),
    );

    _announcementListProvider!.getAnnouncements(
      storeId: widget.storeId,
      category: _selectedCategory,
      city: _selectedCity,
      searchKey: _controller.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FavoriteProvider.of(context).favoriteUpdateHandler();

        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              FavoriteProvider.of(context).favoriteUpdateHandler();

              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            "Announcements",
            style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
          ),
          elevation: 0,
        ),
        body: Consumer<AnnouncementListProvider>(builder: (context, announcementListProvider, _) {
          if (announcementListProvider.announcementState.progressState == -1) {
            return ErrorPage(
              message: announcementListProvider.announcementState.message,
              callback: () async {
                _announcementListProvider!.setAnnouncementListState(
                  _announcementListProvider!.announcementState.update(progressState: 0),
                );
                await _announcementListProvider!.getCategories();

                if (_announcementListProvider!.announcementState.categories == null ||
                    _announcementListProvider!.announcementState.categories!.isEmpty) return;

                _announcementListProvider!.setAnnouncementListState(
                  _announcementListProvider!.announcementState.update(progressState: 1),
                );

                _announcementListProvider!.getAnnouncements(
                  storeId: widget.storeId,
                  category: _selectedCategory,
                  city: _selectedCity,
                  searchKey: _controller.text.trim(),
                );
              },
            );
          }

          if (announcementListProvider.announcementState.progressState == 0 && announcementListProvider.announcementState.categories == null) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (widget.storeId == null && announcementListProvider.announcementState.categories!.isEmpty) {
            return Center(
              child: Text("No Announcement", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
            );
          }

          return Container(
            width: deviceWidth,
            height: deviceHeight,
            child: Column(
              children: [
                _searchField(),
                if (widget.storeId == null) SizedBox(height: heightDp * 10),
                if (widget.storeId == null) _filterPanel(),
                SizedBox(height: heightDp * 10),
                Expanded(child: _productListPanel()),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Row(
        children: [
          Expanded(
            child: KeicyTextFormField(
              controller: _controller,
              focusNode: _focusNode,
              width: null,
              height: heightDp * 40,
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              errorBorder: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: heightDp * 6,
              contentHorizontalPadding: widthDp * 10,
              contentVerticalPadding: heightDp * 8,
              textStyle: TextStyle(fontSize: fontSp * 12, color: Colors.black),
              hintStyle: TextStyle(fontSize: fontSp * 12, color: Colors.grey.withOpacity(0.6)),
              hintText: AnnouncementListForALLPageString.searchHint,
              prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
              suffixIcons: [
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                    _searchKeyAnnouncementListHandler();
                  },
                  child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
                ),
              ],
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(FocusNode());
                _searchKeyAnnouncementListHandler();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterPanel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                LocationResult? result = await showLocationPicker(
                  context,
                  Environment.googleApiKey!,
                  initialCenter: LatLng(31.1975844, 29.9598339),
                  myLocationButtonEnabled: true,
                  layersButtonEnabled: true,
                  necessaryField: "city",
                  // countries: ['AE', 'NG'],
                );
                if (result != null) {
                  _selectedCity = result.city;
                  _onRefresh();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                height: heightDp * 35,
                decoration: BoxDecoration(
                  color: config.Colors().mainColor(1),
                  borderRadius: BorderRadius.circular(heightDp * 6),
                  // border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_searching, size: heightDp * 25, color: Colors.white),
                    SizedBox(width: widthDp * 5),
                    Expanded(
                      child: Center(
                        child: Text(
                          "$_selectedCity",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: widthDp * 10),
          Expanded(
            child: KeicyRaisedButton(
              height: heightDp * 35,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 6,
              child: Text(
                "Select Category",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
              ),
              onPressed: () async {
                var result = await StoreCategoryBottomSheetDialog.show(
                  context,
                  _announcementListProvider!.announcementState.categories,
                  _selectedCategory,
                );

                if (result != null) {
                  if (result == "") {
                    _selectedCategory = null;
                  } else {
                    _selectedCategory = result;
                  }
                  _onRefresh();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _productListPanel() {
    List<dynamic> announcementListData = [];
    Map<String, dynamic> announcementMetaData = Map<String, dynamic>();

    if (_announcementListProvider!.announcementState.announcementListData!["ALL"] != null) {
      announcementListData = _announcementListProvider!.announcementState.announcementListData!["ALL"];
    }
    if (_announcementListProvider!.announcementState.announcementMetaData!["ALL"] != null) {
      announcementMetaData = _announcementListProvider!.announcementState.announcementMetaData!["ALL"];
    }

    int itemCount = 0;

    if (_announcementListProvider!.announcementState.announcementListData!["ALL"] != null) {
      int length = _announcementListProvider!.announcementState.announcementListData!["ALL"].length;
      itemCount += length;
    }

    if (_announcementListProvider!.announcementState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: (announcementMetaData["nextPage"] != null && _announcementListProvider!.announcementState.progressState != 1),
        header: WaterDropHeader(),
        footer: ClassicFooter(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: itemCount == 0
            ? Center(
                child: Text(
                  "No Announcements Available",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              )
            : ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  Map<String, dynamic> announcementData =
                      (index >= announcementListData.length) ? Map<String, dynamic>() : announcementListData[index];
                  return AnnouncementWidget(
                    announcementData: announcementData,
                    storeData: announcementData["store"],
                    isLoading: announcementData.isEmpty,
                    isShowStoreButton: widget.storeId == null,
                    detailHandler: () {
                      _detailHandler(announcementData);
                    },
                    goToStoreHandler: () async {
                      FavoriteProvider.of(context).favoriteUpdateHandler();

                      var result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => StorePage(
                            storeModel: StoreModel.fromJson(announcementData["store"]),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  void _detailHandler(Map<String, dynamic> announcementData) async {
    FavoriteProvider.of(context).favoriteUpdateHandler();

    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => AnnouncementDetailPage(
          announcementData: announcementData,
          storeData: announcementData["store"],
        ),
      ),
    );
  }
}
