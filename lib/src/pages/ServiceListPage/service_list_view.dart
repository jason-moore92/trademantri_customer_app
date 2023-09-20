import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/elements/bottom_cart_widget.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/service_item_for_selection_widget.dart';
import 'package:trapp/src/elements/service_item_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/src/pages/OrderAssistantPage/index.dart';
import 'package:trapp/src/pages/ProductItemDetailPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/products_order_assistant_widget.dart';

import 'index.dart';

class ServiceListView extends StatefulWidget {
  final List<String>? storeIds;
  final StoreModel? storeModel;
  final bool isForSelection;

  ServiceListView({
    Key? key,
    @required this.storeIds,
    @required this.storeModel,
    this.isForSelection = false,
  }) : super(key: key);

  @override
  _ServiceListViewState createState() => _ServiceListViewState();
}

class _ServiceListViewState extends State<ServiceListView> with SingleTickerProviderStateMixin {
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

  List<dynamic>? _serviceCategoryData;

  ServiceListPageProvider? _serviceListPageProvider;

  List<RefreshController> _refreshControllerList = [];

  TabController? _tabController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  int _oldTabIndex = 0;

  Map<String, dynamic>? selectedService;

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

    _serviceListPageProvider = ServiceListPageProvider.of(context);

    _refreshControllerList = [];

    _oldTabIndex = 0;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _serviceListPageProvider!.addListener(_serviceListPageProviderListener);
    });
    _serviceListPageProvider!.getServiceCategories(
      storeIds: widget.storeIds!,
    );
  }

  void _tabControllerListener() {
    if ((_serviceListPageProvider!.serviceListPageState.progressState != 1) &&
        (_controller.text.isNotEmpty ||
            _serviceListPageProvider!.serviceListPageState.serviceListData![_serviceCategoryData![_tabController!.index]["category"]] == null ||
            _serviceListPageProvider!.serviceListPageState.serviceListData![_serviceCategoryData![_tabController!.index]["category"]].isEmpty)) {
      Map<String, dynamic> serviceListData = _serviceListPageProvider!.serviceListPageState.serviceListData!;
      Map<String, dynamic> serviceMetaData = _serviceListPageProvider!.serviceListPageState.serviceMetaData!;

      if (_oldTabIndex != _tabController!.index && _controller.text.isNotEmpty) {
        serviceListData[_serviceCategoryData![_oldTabIndex]["category"]] = [];
        serviceMetaData[_serviceCategoryData![_oldTabIndex]["category"]] = Map<String, dynamic>();
      }

      _serviceListPageProvider!.setServiceListPageState(
        _serviceListPageProvider!.serviceListPageState.update(
          progressState: 1,
          serviceListData: serviceListData,
          serviceMetaData: serviceMetaData,
        ),
      );

      _controller.clear();
      _oldTabIndex = _tabController!.index;

      _serviceListPageProvider!.setServiceListPageState(
        _serviceListPageProvider!.serviceListPageState.update(progressState: 1),
        isNotifiable: false,
      );

      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _serviceListPageProvider!.getServiceList(
          storeIds: widget.storeIds!,
          categories: [_serviceCategoryData![_tabController!.index]["category"]],
          searchKey: _controller.text.trim(),
        );
      });
    }
    _oldTabIndex = _tabController!.index;
    setState(() {});
  }

  @override
  void dispose() {
    _serviceListPageProvider!.removeListener(_serviceListPageProviderListener);

    super.dispose();
  }

  void _serviceListPageProviderListener() async {
    if (_tabController == null) return;
    if (_serviceListPageProvider!.serviceListPageState.progressState == -1) {
      if (_serviceListPageProvider!.serviceListPageState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshFailed();
        _serviceListPageProvider!.setServiceListPageState(
          _serviceListPageProvider!.serviceListPageState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadFailed();
      }
    } else if (_serviceListPageProvider!.serviceListPageState.progressState == 2) {
      if (_serviceListPageProvider!.serviceListPageState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshCompleted();
        _serviceListPageProvider!.setServiceListPageState(
          _serviceListPageProvider!.serviceListPageState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic> serviceListData = _serviceListPageProvider!.serviceListPageState.serviceListData!;
    Map<String, dynamic> serviceMetaData = _serviceListPageProvider!.serviceListPageState.serviceMetaData!;

    serviceListData[_serviceCategoryData![_tabController!.index]["category"]] = [];
    serviceMetaData[_serviceCategoryData![_tabController!.index]["category"]] = Map<String, dynamic>();
    _serviceListPageProvider!.setServiceListPageState(
      _serviceListPageProvider!.serviceListPageState.update(
        progressState: 1,
        serviceListData: serviceListData,
        serviceMetaData: serviceMetaData,
        isRefresh: true,
      ),
    );

    _serviceListPageProvider!.getServiceList(
      storeIds: widget.storeIds!,
      categories: [_serviceCategoryData![_tabController!.index]["category"]],
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _serviceListPageProvider!.setServiceListPageState(
      _serviceListPageProvider!.serviceListPageState.update(progressState: 1),
    );
    _serviceListPageProvider!.getServiceList(
      storeIds: widget.storeIds!,
      categories: [_serviceCategoryData![_tabController!.index]["category"]],
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyServiceListHandler() {
    Map<String, dynamic> serviceListData = _serviceListPageProvider!.serviceListPageState.serviceListData!;
    Map<String, dynamic> serviceMetaData = _serviceListPageProvider!.serviceListPageState.serviceMetaData!;

    serviceListData[_serviceCategoryData![_tabController!.index]["category"]] = [];
    serviceMetaData[_serviceCategoryData![_tabController!.index]["category"]] = Map<String, dynamic>();
    _serviceListPageProvider!.setServiceListPageState(
      _serviceListPageProvider!.serviceListPageState.update(
        progressState: 1,
        serviceListData: serviceListData,
        serviceMetaData: serviceMetaData,
      ),
    );

    _serviceListPageProvider!.getServiceList(
      storeIds: widget.storeIds!,
      categories: [_serviceCategoryData![_tabController!.index]["category"]],
      searchKey: _controller.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
          onPressed: () {
            _cartAndFavoriteUpdateHandler();

            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "Services",
          // widget.storeData!["name"],
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer2<CartProvider, ServiceListPageProvider>(builder: (context, cartProvider, serviceListPageProvider, _) {
        _serviceCategoryData = serviceListPageProvider.serviceListPageState.serviceCategoryData![widget.storeIds!.join(',')];

        if (serviceListPageProvider.serviceListPageState.progressState == 0 && _serviceCategoryData == null) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (serviceListPageProvider.serviceListPageState.progressState == -1) {
          return ErrorPage(
            message: serviceListPageProvider.serviceListPageState.message,
            callback: () {
              _serviceListPageProvider!.setServiceListPageState(
                _serviceListPageProvider!.serviceListPageState.update(progressState: 0),
              );
              _serviceListPageProvider!.getServiceCategories(
                storeIds: widget.storeIds!,
              );
            },
          );
        }

        if (serviceListPageProvider.serviceListPageState.progressState == 3) {
          return Container(
            height: deviceHeight,
            child: Column(
              children: [
                if (!widget.isForSelection)
                  ProductsOrderAssistantWidget(
                    storeModel: widget.storeModel,
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 30),
                    child: Center(
                      child: Image.asset(
                        "img/NoServices.png",
                        height: heightDp * 150,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (_tabController == null) {
          _tabController = TabController(
            length: _serviceCategoryData!.length,
            vsync: this,
          );

          _tabController!.addListener(_tabControllerListener);
          _serviceListPageProvider!.setServiceListPageState(
            _serviceListPageProvider!.serviceListPageState.update(progressState: 1),
            isNotifiable: false,
          );

          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            _serviceListPageProvider!.getServiceList(
              storeIds: widget.storeIds!,
              categories: [_serviceCategoryData![0]["category"]],
            );
          });
        }

        if (_refreshControllerList.isEmpty) {
          for (var i = 0; i < _serviceCategoryData!.length; i++) {
            _refreshControllerList.add(RefreshController(initialRefresh: false));
          }
        }

        return DefaultTabController(
          length: _serviceCategoryData!.length,
          child: Container(
            width: deviceWidth,
            height: deviceHeight,
            child: Column(
              children: [
                _searchField(),
                if (!widget.isForSelection)
                  ProductsOrderAssistantWidget(
                    storeModel: widget.storeModel,
                  ),
                _tabBar(),
                Expanded(child: _serviceListPanel()),
                widget.isForSelection ? _selectedServicePanel() : BottomCartWidget(storeModel: widget.storeModel),
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
        controller: _controller,
        focusNode: _focusNode,
        width: null,
        height: heightDp * 50,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        errorBorder: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: heightDp * 6,
        contentHorizontalPadding: widthDp * 10,
        textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
        hintText: ServiceListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyServiceListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyServiceListHandler();
        },
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      width: deviceWidth,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1)),
      ),
      alignment: Alignment.center,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Color(0xFF15D08E),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.zero,
        labelPadding: EdgeInsets.symmetric(horizontal: widthDp * 15),
        labelStyle: TextStyle(fontSize: fontSp * 14),
        labelColor: Color(0xFF15D08E),
        unselectedLabelColor: Colors.black,
        tabs: List.generate(_serviceCategoryData!.length, (index) {
          return Tab(
            text: "${_serviceCategoryData![index]["category"]}",
          );
        }),
      ),
    );
  }

  Widget _serviceListPanel() {
    int index = _tabController!.index;
    String category = _serviceCategoryData![index]["category"];

    List<dynamic> serviceList = [];
    Map<String, dynamic> serviceMetaData = Map<String, dynamic>();

    if (_serviceListPageProvider!.serviceListPageState.serviceListData![category] != null) {
      serviceList = _serviceListPageProvider!.serviceListPageState.serviceListData![category];
    }
    if (_serviceListPageProvider!.serviceListPageState.serviceMetaData![category] != null) {
      serviceMetaData = _serviceListPageProvider!.serviceListPageState.serviceMetaData![category];
    }

    int itemCount = 0;

    if (_serviceListPageProvider!.serviceListPageState.serviceListData![category] != null) {
      List<dynamic> data = _serviceListPageProvider!.serviceListPageState.serviceListData![category];
      itemCount += data.length;
    }

    if (_serviceListPageProvider!.serviceListPageState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: (serviceMetaData["nextPage"] != null && _serviceListPageProvider!.serviceListPageState.progressState != 1),
        header: WaterDropHeader(),
        footer: ClassicFooter(),
        controller: _refreshControllerList[index],
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: itemCount == 0
            ? Center(
                child: Text(
                  "No Service Available",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              )
            : ListView.separated(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  Map<String, dynamic> serviceData = (index >= serviceList.length) ? Map<String, dynamic>() : serviceList[index];
                  if (!widget.isForSelection) {
                    return ServiceItemWidget(
                      serviceData: serviceData,
                      storeModel: widget.storeModel,
                      isLoading: serviceData.isEmpty,
                      isShowGoToStore: false,
                      tapCallback: () async {
                        _cartAndFavoriteUpdateHandler();

                        var result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => ProductItemDetailPage(
                              storeModel: widget.storeModel,
                              serviceModel: ServiceModel.fromJson(serviceData),
                              type: "services",
                              isForCart: true,
                            ),
                          ),
                        );

                        if (result != null && result) {
                          setState(() {});
                        }
                      },
                    );
                  } else {
                    return GestureDetector(
                      onTap: () {
                        if (serviceData.isEmpty) return;
                        if (!widget.isForSelection) return;
                        selectedService = serviceData;
                        setState(() {});
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: ServiceItemForSelectionWidget(
                          serviceModel: serviceData.isEmpty ? null : ServiceModel.fromJson(serviceData),
                          isLoading: serviceData.isEmpty,
                          isSelected: (selectedService != null && serviceData["_id"] == selectedService!["_id"]),
                        ),
                      ),
                    );
                  }
                },
                separatorBuilder: (context, index) {
                  return Divider(color: Colors.grey.withOpacity(0.3), height: 1, thickness: 1);
                },
              ),
      ),
    );
  }

  Widget _selectedServicePanel() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.4), offset: Offset(0, -1), blurRadius: 2),
        ],
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedService == null ? "Please choose Service" : selectedService!["name"],
            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          KeicyRaisedButton(
            width: widthDp * 100,
            height: heightDp * 35,
            color: selectedService == null ? Colors.grey.withOpacity(0.6) : config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            child: Text("OK", style: TextStyle(fontSize: fontSp * 16, color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop(selectedService);
            },
          ),
        ],
      ),
    );
  }

  void _cartAndFavoriteUpdateHandler() {
    if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin && AuthProvider.of(context).authState.userModel!.id != null) {
      CartProvider.of(context).cartUpdateHandler(
        fcmToken: AuthProvider.of(context).authState.userModel!.fcmToken,
        userId: AuthProvider.of(context).authState.userModel!.id,
      );

      FavoriteProvider.of(context).favoriteUpdateHandler();
    }
  }
}
