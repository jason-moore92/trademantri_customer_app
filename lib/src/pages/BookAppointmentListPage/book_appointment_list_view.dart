import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/book_appointment_widget.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/BookAppointmentDetailPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import '../../elements/keicy_progress_dialog.dart';

class BookAppointmentListView extends StatefulWidget {
  BookAppointmentListView({Key? key}) : super(key: key);

  @override
  _BookAppointmentListViewState createState() => _BookAppointmentListViewState();
}

class _BookAppointmentListViewState extends State<BookAppointmentListView> with SingleTickerProviderStateMixin {
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

  AuthProvider? _authProvider;
  BookAppointmentProvider? _bookAppointmentProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  List<RefreshController> _refreshControllerList = [];

  TabController? _tabController;
  ScrollController? _controller;

  TextEditingController _textController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  int? _oldTabIndex;

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

    _bookAppointmentProvider = BookAppointmentProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _refreshControllerList = [];

    for (var i = 0; i < AppConfig.bookAppointmentStatus.length; i++) {
      _refreshControllerList.add(RefreshController(initialRefresh: false));
    }

    _oldTabIndex = 0;

    _tabController = TabController(length: AppConfig.bookAppointmentStatus.length, vsync: this);

    _tabController!.addListener(_tabControllerListener);
    _controller = ScrollController();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _bookAppointmentProvider!.addListener(_bookAppointmentProviderListener);

      if (_bookAppointmentProvider!.bookAppointmentState.progressState != 2) {
        _bookAppointmentProvider!.setBookAppointmentState(_bookAppointmentProvider!.bookAppointmentState.update(progressState: 1));
        _bookAppointmentProvider!.getBookData(
          userId: _authProvider!.authState.userModel!.id,
          status: AppConfig.bookAppointmentStatus[0]["id"],
        );
      }
    });
  }

  @override
  void dispose() {
    _bookAppointmentProvider!.removeListener(_bookAppointmentProviderListener);

    super.dispose();
  }

  void _bookAppointmentProviderListener() async {
    if (_bookAppointmentProvider!.bookAppointmentState.progressState == -1) {
      if (_bookAppointmentProvider!.bookAppointmentState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshFailed();
        _bookAppointmentProvider!.setBookAppointmentState(
          _bookAppointmentProvider!.bookAppointmentState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadFailed();
      }
    } else if (_bookAppointmentProvider!.bookAppointmentState.progressState == 2) {
      if (_bookAppointmentProvider!.bookAppointmentState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshCompleted();
        _bookAppointmentProvider!.setBookAppointmentState(
          _bookAppointmentProvider!.bookAppointmentState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadComplete();
      }
    }
  }

  void _tabControllerListener() {
    if ((_bookAppointmentProvider!.bookAppointmentState.progressState != 1) &&
        (_textController.text.isNotEmpty ||
            _bookAppointmentProvider!.bookAppointmentState.bookListData![AppConfig.bookAppointmentStatus[_tabController!.index]["id"]] == null ||
            _bookAppointmentProvider!.bookAppointmentState.bookListData![AppConfig.bookAppointmentStatus[_tabController!.index]["id"]].isEmpty)) {
      Map<String, dynamic> bookListData = _bookAppointmentProvider!.bookAppointmentState.bookListData!;
      Map<String, dynamic> bookListMetaData = _bookAppointmentProvider!.bookAppointmentState.bookListMetaData!;

      if (_oldTabIndex != _tabController!.index && _textController.text.isNotEmpty) {
        bookListData[AppConfig.bookAppointmentStatus[_oldTabIndex!]["id"]] = [];
        bookListMetaData[AppConfig.bookAppointmentStatus[_oldTabIndex!]["id"]] = Map<String, dynamic>();
      }

      _bookAppointmentProvider!.setBookAppointmentState(
        _bookAppointmentProvider!.bookAppointmentState.update(
          progressState: 1,
          bookListData: bookListData,
          bookListMetaData: bookListMetaData,
        ),
        isNotifiable: false,
      );

      _oldTabIndex = _tabController!.index;

      _bookAppointmentProvider!.getBookData(
        userId: _authProvider!.authState.userModel!.id,
        status: AppConfig.bookAppointmentStatus[_tabController!.index]["id"],
        searchKey: _textController.text.trim(),
      );
    } else {
      _oldTabIndex = _tabController!.index;
      setState(() {});
    }
  }

  void _onRefresh() async {
    Map<String, dynamic> bookListData = _bookAppointmentProvider!.bookAppointmentState.bookListData!;
    Map<String, dynamic> bookListMetaData = _bookAppointmentProvider!.bookAppointmentState.bookListMetaData!;

    bookListData[AppConfig.bookAppointmentStatus[_tabController!.index]["id"]] = [];
    bookListMetaData[AppConfig.bookAppointmentStatus[_tabController!.index]["id"]] = Map<String, dynamic>();
    _bookAppointmentProvider!.setBookAppointmentState(
      _bookAppointmentProvider!.bookAppointmentState.update(
        progressState: 1,
        bookListData: bookListData,
        bookListMetaData: bookListMetaData,
        isRefresh: true,
      ),
    );

    _bookAppointmentProvider!.getBookData(
      userId: _authProvider!.authState.userModel!.id,
      status: AppConfig.bookAppointmentStatus[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  void _onLoading() async {
    _bookAppointmentProvider!.setBookAppointmentState(
      _bookAppointmentProvider!.bookAppointmentState.update(progressState: 1),
    );
    _bookAppointmentProvider!.getBookData(
      userId: _authProvider!.authState.userModel!.id,
      status: AppConfig.bookAppointmentStatus[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  void _searchKeyBookAppointmentListHandler() {
    Map<String, dynamic> bookListData = _bookAppointmentProvider!.bookAppointmentState.bookListData!;
    Map<String, dynamic> bookListMetaData = _bookAppointmentProvider!.bookAppointmentState.bookListMetaData!;

    bookListData[AppConfig.bookAppointmentStatus[_tabController!.index]["id"]] = [];
    bookListMetaData[AppConfig.bookAppointmentStatus[_tabController!.index]["id"]] = Map<String, dynamic>();
    _bookAppointmentProvider!.setBookAppointmentState(
      _bookAppointmentProvider!.bookAppointmentState.update(
        progressState: 1,
        bookListData: bookListData,
        bookListMetaData: bookListMetaData,
      ),
    );

    _bookAppointmentProvider!.getBookData(
      userId: _authProvider!.authState.userModel!.id,
      status: AppConfig.bookAppointmentStatus[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Appointments",
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<BookAppointmentProvider>(builder: (context, bookAppointmentProvider, _) {
        if (bookAppointmentProvider.bookAppointmentState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return DefaultTabController(
          length: AppConfig.bookAppointmentStatus.length,
          child: Container(
            width: deviceWidth,
            height: deviceHeight,
            child: Column(
              children: [
                _searchField(),
                _tabBar(),
                Expanded(child: _orderListPanel()),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _searchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: KeicyTextFormField(
        controller: _textController,
        focusNode: _focusNode,
        width: null,
        height: heightDp * 50,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        errorBorder: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: heightDp * 6,
        contentHorizontalPadding: widthDp * 10,
        textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
        hintText: "Search for event name",
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _textController.clear();
              _onRefresh();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyBookAppointmentListHandler();
        },
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.only(top: heightDp * 10, bottom: heightDp * 0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1)),
      ),
      alignment: Alignment.center,
      child: TabBar(
        controller: _tabController,
        indicatorColor: config.Colors().mainColor(1),
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: EdgeInsets.symmetric(horizontal: widthDp * 20),
        labelStyle: TextStyle(fontSize: fontSp * 14),
        labelColor: config.Colors().mainColor(1),
        isScrollable: true,
        // indicator: BoxDecoration(
        //   color: config.Colors().mainColor(1),
        //   borderRadius: BorderRadius.circular(heightDp * 40),
        // ),
        unselectedLabelColor: Colors.black,
        tabs: List.generate(AppConfig.bookAppointmentStatus.length, (index) {
          return Tab(
            height: heightDp * 40,
            text: "${AppConfig.bookAppointmentStatus[index]["name"]}",
          );
        }),
      ),
    );
  }

  // Widget _tabBar() {
  //   return Container(
  //     width: deviceWidth,
  //     decoration: BoxDecoration(
  //       border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1)),
  //     ),
  //     alignment: Alignment.center,
  //     child: TabBar(
  //       controller: _tabController,
  //       isScrollable: true,
  //       indicatorColor: Colors.transparent,
  //       indicatorSize: TabBarIndicatorSize.tab,
  //       indicatorPadding: EdgeInsets.zero,
  //       indicatorWeight: 1,
  //       labelPadding: EdgeInsets.symmetric(horizontal: widthDp * 5),
  //       labelStyle: TextStyle(fontSize: fontSp * 14),
  //       labelColor: Colors.white,
  //       unselectedLabelColor: Colors.black,
  //       tabs: List.generate(AppConfig.bookAppointmentStatus.length, (index) {
  //         return Tab(
  //           child: Container(
  //             width: widthDp * 110,
  //             height: heightDp * 35,
  //             padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 0),
  //             alignment: Alignment.center,
  //             decoration: BoxDecoration(
  //               color: _tabController!.index == index ? config.Colors().mainColor(1) : Colors.white,
  //               borderRadius: BorderRadius.circular(heightDp * 30),
  //             ),
  //             child: Text(
  //               "${AppConfig.bookAppointmentStatus[index]["name"]}",
  //             ),
  //           ),
  //         );
  //       }),
  //     ),
  //   );
  // }

  Widget _orderListPanel() {
    String status = AppConfig.bookAppointmentStatus[_tabController!.index]["id"];

    List<dynamic> bookList = [];
    Map<String, dynamic> bookListMetaData = Map<String, dynamic>();

    if (_bookAppointmentProvider!.bookAppointmentState.bookListData![status] != null) {
      bookList = _bookAppointmentProvider!.bookAppointmentState.bookListData![status];
    }
    if (_bookAppointmentProvider!.bookAppointmentState.bookListMetaData![status] != null) {
      bookListMetaData = _bookAppointmentProvider!.bookAppointmentState.bookListMetaData![status];
    }

    int itemCount = 0;

    if (_bookAppointmentProvider!.bookAppointmentState.bookListData![status] != null) {
      List<dynamic> data = _bookAppointmentProvider!.bookAppointmentState.bookListData![status];
      itemCount += data.length;
    }

    if (_bookAppointmentProvider!.bookAppointmentState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    return Column(
      children: [
        Expanded(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowGlow();
              return true;
            },
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: (bookListMetaData["nextPage"] != null && _bookAppointmentProvider!.bookAppointmentState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshControllerList[_tabController!.index],
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No Book Appointment Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      controller: _controller,
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> bookData = (index >= bookList.length) ? Map<String, dynamic>() : bookList[index];
                        if (bookData.isNotEmpty && bookData["user"] == null) {
                          bookData["user"] = AuthProvider.of(context).authState.userModel;
                        }
                        return BookAppointmentWidget(
                          bookAppointmentModel: bookData.isNotEmpty ? BookAppointmentModel.fromJson(bookData) : null,
                          loadingStatus: bookData.isEmpty,
                          detailHandler: () {
                            _detailHandler(index, BookAppointmentModel.fromJson(bookData));
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }

  void _detailHandler(int index, BookAppointmentModel bookAppointmentModel) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => BookAppointmentDetailPage(
          bookAppointmentModel: bookAppointmentModel,
          isPast: _tabController!.index == AppConfig.bookAppointmentStatus.length - 1,
        ),
      ),
    );
    if (result != null) {
      for (var i = 0; i < AppConfig.bookAppointmentStatus.length; i++) {
        if (result["status"] == AppConfig.bookAppointmentStatus[i]["id"]) {
          if (_tabController!.index == 0) {
            String status = AppConfig.bookAppointmentStatus[0]["id"];
            Map<String, dynamic>? bookListData = _bookAppointmentProvider!.bookAppointmentState.bookListData;
            bookListData![status][index] = result;
            _bookAppointmentProvider!.setBookAppointmentState(
              _bookAppointmentProvider!.bookAppointmentState.update(bookListData: bookListData),
            );
          } else {
            Map<String, dynamic> bookListData = _bookAppointmentProvider!.bookAppointmentState.bookListData!;
            Map<String, dynamic> bookListMetaData = _bookAppointmentProvider!.bookAppointmentState.bookListMetaData!;

            bookListData[AppConfig.bookAppointmentStatus[_tabController!.index]["id"]] = [];
            bookListMetaData[AppConfig.bookAppointmentStatus[_tabController!.index]["id"]] = Map<String, dynamic>();
            _bookAppointmentProvider!.setBookAppointmentState(
              _bookAppointmentProvider!.bookAppointmentState.update(
                bookListData: bookListData,
                bookListMetaData: bookListMetaData,
                isRefresh: true,
              ),
            );
          }
          _tabController!.animateTo(i);

          return;
        }
      }
    }
  }
}
