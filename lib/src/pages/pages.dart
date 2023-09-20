import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/global.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/DrawerWidget.dart';
import 'package:trapp/src/elements/cart_of_all_store_widget.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/pages/FavoriteListPage/index.dart';
import 'package:trapp/src/pages/SearchLocationPage/search_location_page.dart';
import 'package:trapp/src/pages/home.dart';
import 'package:trapp/src/pages/lucky_draw_winners.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/services/dynamic_link_service.dart';
import 'BargainRequestListPage/index.dart';
import 'OrderAssistantPage/index.dart';
import 'ReverseAuctionListPage/index.dart';

// ignore: must_be_immutable
class PagesTestWidget extends StatefulWidget {
  int? currentTab = 2;
  String currentTitle = 'Home';
  Widget currentPage = HomeWidget();
  Map<String, dynamic>? categoryData;

  PagesTestWidget({
    Key? key,
    this.currentTab,
    this.categoryData,
  }) : super(key: key);

  @override
  _PagesTestWidgetState createState() {
    return _PagesTestWidgetState();
  }
}

class _PagesTestWidgetState extends State<PagesTestWidget> with WidgetsBindingObserver {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  Timer? _timerLink;

  LuckyDrawProvider? _luckyDrawProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  @override
  void initState() {
    super.initState();

    _selectTab(widget.currentTab!);

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    _keicyProgressDialog = KeicyProgressDialog(
      context,
      message: "Hang on!\nAwesomeness is Loading...",
    );

    _luckyDrawProvider = LuckyDrawProvider.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      GlobalVariables.dynamicLinkService.retrieveDynamicLink(context);
      WidgetsBinding.instance!.addObserver(this);

      _luckyDrawProvider!.addListener(_luckyDrawProviderListener);
      await Future.delayed(
        Duration(
          seconds: 3,
        ),
      );
      _luckyDrawProvider!.checkLatestWinners();
    });
  }

  void _luckyDrawProviderListener() async {
    if (_luckyDrawProvider!.luckyDrawState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_luckyDrawProvider!.luckyDrawState.progressState == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => LuckyDrawWinnersWidget(
            luckyDrawConfig: _luckyDrawProvider!.luckyDrawState.luckyDrawConfig,
          ),
        ),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {
          // _dynamicLinkService.retrieveDynamicLink(context);
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    if (_timerLink != null) {
      _timerLink!.cancel();
    }
    _luckyDrawProvider!.removeListener(_luckyDrawProviderListener);
    super.dispose();
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentTitle = 'Assistant Order';
          widget.currentPage = OrderAssistantPage(haveAppBar: false);

          break;
        case 1:
          widget.currentTitle = 'Bargain Request';
          widget.currentPage = BargainRequestListPage(haveAppBar: false);

          break;
        case 2:
          widget.currentTitle = 'Home';
          widget.currentPage = HomeWidget();
          break;
        case 3:
          widget.currentTitle = 'Reverse Auction';
          widget.currentPage = ReverseAuctionListPage(haveAppBar: false);
          break;
        case 4:
          widget.currentTitle = 'Favorites';
          widget.currentPage = FavoriteListPage();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, AppDataProvider>(builder: (context, authProvider, appDataProvider, _) {
      return Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          centerTitle: true,
          title: widget.currentTitle != "Home"
              ? Center(
                  child: Text(
                    widget.currentTitle,
                    style: Theme.of(context).textTheme.headline6!.merge(TextStyle(letterSpacing: 1.3)),
                  ),
                )
              : GestureDetector(
                  onTap: () async {
                    var result = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SearchLocationPage()));
                    if (result != null && result) {
                      SearchProvider.of(context).setSearchState(SearchState.init());
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, color: Color(0xFF07AF72)),
                      Expanded(
                        child: Text(
                          "${appDataProvider.appDataState.currentLocation == null ? "" : appDataProvider.appDataState.currentLocation!["nickName"] ?? appDataProvider.appDataState.currentLocation!["name"] ?? appDataProvider.appDataState.currentLocation!["address"]}",
                          style: Theme.of(context).textTheme.bodyText1!.merge(
                                TextStyle(letterSpacing: 0.5, color: config.Colors().mainColor(1)),
                              ),
                        ),
                      )
                    ],
                  ),
                ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                  Navigator.of(context).pushNamed("/Notifications");
                } else {
                  LoginAskDialog.show(context, callback: () {
                    Navigator.of(context).pushNamed("/Notifications");
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                color: Colors.transparent,
                child: Icon(
                  Icons.notifications_outlined,
                  size: heightDp * 25,
                  color: Colors.black,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                  Navigator.of(context).pushNamed('/Profile');
                } else {
                  LoginAskDialog.show(context, callback: () {
                    Navigator.of(context).pushNamed('/Profile');
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                color: Colors.transparent,
                child: Icon(
                  Icons.person,
                  size: heightDp * 25,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(width: widthDp * 5),
            CartOfAllStoresWidget(),
            SizedBox(width: widthDp * 15),
          ],
        ),
        body: widget.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 22,
          elevation: 6,
          // backgroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          selectedIconTheme: IconThemeData(size: 28),
          unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
          currentIndex: widget.currentTab!,
          onTap: (int i) {
            widget.categoryData = null;
            this._selectTab(i);
          },
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                "img/Assistant-icon.png",
                width: IconTheme.of(context).size! * 0.8,
                height: IconTheme.of(context).size! * 0.8,
                fit: BoxFit.cover,
                // color: Theme.of(context).iconTheme.color,
              ),
              activeIcon: Image.asset(
                "img/Assistant-icon.png",
                width: IconTheme.of(context).size,
                height: IconTheme.of(context).size,
                fit: BoxFit.cover,
                color: config.Colors().mainColor(1),
              ),
              title: new Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "img/bargain-icon.png",
                width: IconTheme.of(context).size! * 0.8,
                height: IconTheme.of(context).size! * 0.8,
                fit: BoxFit.cover,
                // color: Theme.of(context).iconTheme.color,
              ),
              activeIcon: Image.asset(
                "img/bargain-icon.png",
                width: IconTheme.of(context).size,
                height: IconTheme.of(context).size,
                fit: BoxFit.cover,
                color: config.Colors().mainColor(1),
              ),
              title: new Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              title: new Container(height: 5.0),
              icon: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    // BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 40, offset: Offset(0, 15)),
                    BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 13, offset: Offset(0, 3))
                  ],
                ),
                child: new Icon(Icons.home, color: Theme.of(context).primaryColor),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "img/reverse_auction-icon.png",
                width: IconTheme.of(context).size,
                height: IconTheme.of(context).size,
                fit: BoxFit.cover,
                // color: Theme.of(context).iconTheme.color,
              ),
              activeIcon: Image.asset(
                "img/reverse_auction-icon.png",
                width: IconTheme.of(context).size! * 1.2,
                height: IconTheme.of(context).size! * 1.2,
                fit: BoxFit.cover,
                color: config.Colors().mainColor(1),
              ),
              title: new Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.favorite,
              ),
              // icon: new Icon(
              //   Icons.favorite,
              //   size: IconTheme.of(context).size,
              //   color: Theme.of(context).iconTheme.color,
              // ),
              // activeIcon: new Icon(
              //   Icons.favorite,
              //   size: IconTheme.of(context).size,
              //   color: config.Colors().mainColor(1),
              // ),
              title: new Container(height: 0.0),
            ),
          ],
        ),
      );
    });
  }
}
