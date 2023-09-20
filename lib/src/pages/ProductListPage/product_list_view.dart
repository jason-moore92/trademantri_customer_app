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
import 'package:trapp/src/elements/product_item_for_selection_widget.dart';
import 'package:trapp/src/elements/product_item_widget.dart';
import 'package:trapp/src/elements/products_order_assistant_widget.dart';
import 'package:trapp/src/models/index.dart';

import 'package:trapp/src/pages/ErrorPage/error_page.dart';
import 'package:trapp/src/pages/OrderAssistantPage/index.dart';
import 'package:trapp/src/pages/ProductItemDetailPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class ProductListView extends StatefulWidget {
  final List<String>? storeIds;
  final StoreModel? storeModel;
  final bool isForSelection;
  final bool? bargainAvailable;

  ProductListView({
    Key? key,
    this.storeIds,
    this.storeModel,
    this.isForSelection = false,
    this.bargainAvailable,
  }) : super(key: key);

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> with SingleTickerProviderStateMixin {
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

  List<dynamic>? _productCategoryData;

  ProductListPageProvider? _productListPageProvider;

  List<RefreshController> _refreshControllerList = [];

  TabController? _tabController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  int? _oldTabIndex;

  Map<String, dynamic>? selectedProduct;

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

    _productListPageProvider = ProductListPageProvider.of(context);

    _refreshControllerList = [];

    _oldTabIndex = 0;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _productListPageProvider!.addListener(_productListPageProviderListener);

      _productListPageProvider!.getProductCategories(
        storeIds: widget.storeIds!,
      );
    });
  }

  void _tabControllerListener() {
    if ((_productListPageProvider!.productListPageState.progressState != 1) &&
        (_controller.text.isNotEmpty ||
            _productListPageProvider!.productListPageState.productListData![_productCategoryData![_tabController!.index]["category"]] == null ||
            _productListPageProvider!.productListPageState.productListData![_productCategoryData![_tabController!.index]["category"]].isEmpty)) {
      Map<String, dynamic> productListData = _productListPageProvider!.productListPageState.productListData!;
      Map<String, dynamic> productMetaData = _productListPageProvider!.productListPageState.productMetaData!;

      if (_oldTabIndex != _tabController!.index && _controller.text.isNotEmpty) {
        productListData[_productCategoryData![_oldTabIndex!]["category"]] = [];
        productMetaData[_productCategoryData![_oldTabIndex!]["category"]] = Map<String, dynamic>();
      }

      _productListPageProvider!.setProductListPageState(
        _productListPageProvider!.productListPageState.update(
          progressState: 1,
          productListData: productListData,
          productMetaData: productMetaData,
        ),
      );

      _controller.clear();
      _oldTabIndex = _tabController!.index;

      _productListPageProvider!.setProductListPageState(
        _productListPageProvider!.productListPageState.update(progressState: 1),
        isNotifiable: false,
      );

      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _productListPageProvider!.getProductList(
          storeIds: widget.storeIds!,
          categories: [_productCategoryData![_tabController!.index]["category"]],
          searchKey: _controller.text.trim(),
          bargainAvailable: widget.bargainAvailable,
        );
      });
    }
    _oldTabIndex = _tabController!.index;
    setState(() {});
  }

  @override
  void dispose() {
    _productListPageProvider!.removeListener(_productListPageProviderListener);

    super.dispose();
  }

  void _productListPageProviderListener() async {
    if (_tabController == null) return;
    if (_productListPageProvider!.productListPageState.progressState == -1) {
      if (_productListPageProvider!.productListPageState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshFailed();
        _productListPageProvider!.setProductListPageState(
          _productListPageProvider!.productListPageState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadFailed();
      }
    } else if (_productListPageProvider!.productListPageState.progressState == 2) {
      if (_productListPageProvider!.productListPageState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshCompleted();
        _productListPageProvider!.setProductListPageState(
          _productListPageProvider!.productListPageState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic> productListData = _productListPageProvider!.productListPageState.productListData!;
    Map<String, dynamic> productMetaData = _productListPageProvider!.productListPageState.productMetaData!;

    productListData[_productCategoryData![_tabController!.index]["category"]] = [];
    productMetaData[_productCategoryData![_tabController!.index]["category"]] = Map<String, dynamic>();
    _productListPageProvider!.setProductListPageState(
      _productListPageProvider!.productListPageState.update(
        progressState: 1,
        productListData: productListData,
        productMetaData: productMetaData,
        isRefresh: true,
      ),
    );

    _productListPageProvider!.getProductList(
      storeIds: widget.storeIds!,
      categories: [_productCategoryData![_tabController!.index]["category"]],
      searchKey: _controller.text.trim(),
      bargainAvailable: widget.bargainAvailable,
    );
  }

  void _onLoading() async {
    _productListPageProvider!.setProductListPageState(
      _productListPageProvider!.productListPageState.update(progressState: 1),
    );
    _productListPageProvider!.getProductList(
      storeIds: widget.storeIds!,
      categories: [_productCategoryData![_tabController!.index]["category"]],
      searchKey: _controller.text.trim(),
      bargainAvailable: widget.bargainAvailable,
    );
  }

  void _searchKeyProductListHandler() {
    Map<String, dynamic> productListData = _productListPageProvider!.productListPageState.productListData!;
    Map<String, dynamic> productMetaData = _productListPageProvider!.productListPageState.productMetaData!;

    productListData[_productCategoryData![_tabController!.index]["category"]] = [];
    productMetaData[_productCategoryData![_tabController!.index]["category"]] = Map<String, dynamic>();
    _productListPageProvider!.setProductListPageState(
      _productListPageProvider!.productListPageState.update(
        progressState: 1,
        productListData: productListData,
        productMetaData: productMetaData,
      ),
    );

    _productListPageProvider!.getProductList(
      storeIds: widget.storeIds!,
      categories: [_productCategoryData![_tabController!.index]["category"]],
      searchKey: _controller.text.trim(),
      bargainAvailable: widget.bargainAvailable,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _cartAndFavoriteUpdateHandler();
        return true;
      },
      child: Scaffold(
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
            "Products",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
          elevation: 0,
        ),
        body: Consumer<ProductListPageProvider>(builder: (context, productListPageProvider, _) {
          _productCategoryData = productListPageProvider.productListPageState.productCategoryData![widget.storeIds!.join(',')];

          if (productListPageProvider.productListPageState.progressState == 0 && _productCategoryData == null) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (productListPageProvider.productListPageState.progressState == -1) {
            return ErrorPage(
              message: productListPageProvider.productListPageState.message,
              callback: () {
                _productListPageProvider!.setProductListPageState(
                  _productListPageProvider!.productListPageState.update(progressState: 0),
                );
                _productListPageProvider!.getProductCategories(
                  storeIds: widget.storeIds!,
                );
              },
            );
          }
          if (productListPageProvider.productListPageState.progressState == 3) {
            return Container(
              height: deviceHeight,
              child: Column(
                children: [
                  if (!widget.isForSelection)
                    ProductsOrderAssistantWidget(
                      storeModel: widget.storeModel,
                    ),

                  ///
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 30),
                      child: Center(
                        child: Image.asset(
                          "img/NoProducts.png",
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
              length: _productCategoryData!.length,
              vsync: this,
            );

            _tabController!.addListener(_tabControllerListener);
            _productListPageProvider!.setProductListPageState(
              _productListPageProvider!.productListPageState.update(progressState: 1),
              isNotifiable: false,
            );

            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              _productListPageProvider!.getProductList(
                storeIds: widget.storeIds!,
                categories: [_productCategoryData![0]["category"]],
                bargainAvailable: widget.bargainAvailable,
              );
            });
          }

          if (_refreshControllerList.isEmpty) {
            for (var i = 0; i < _productCategoryData!.length; i++) {
              _refreshControllerList.add(RefreshController(initialRefresh: false));
            }
          }

          return DefaultTabController(
            length: _productCategoryData!.length,
            child: Container(
              width: deviceWidth,
              height: deviceHeight,
              child: Column(
                children: [
                  _searchField(),
                  SizedBox(height: heightDp * 5),
                  if (!widget.isForSelection)
                    ProductsOrderAssistantWidget(
                      storeModel: widget.storeModel,
                    ),
                  SizedBox(height: heightDp * 5),
                  _tabBar(),
                  Expanded(child: _productListPanel()),
                  widget.isForSelection
                      ? _selectedProductPanel()
                      : BottomCartWidget(
                          storeModel: widget.storeModel,
                        ),
                ],
              ),
            ),
          );
        }),
      ),
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
        textStyle: TextStyle(fontSize: fontSp * 12, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 12, color: Colors.grey.withOpacity(0.6)),
        hintText: ProductListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyProductListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyProductListHandler();
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
        indicatorColor: config.Colors().mainColor(1),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.zero,
        labelPadding: EdgeInsets.symmetric(horizontal: widthDp * 15),
        labelStyle: TextStyle(fontSize: fontSp * 12),
        labelColor: config.Colors().mainColor(1),
        unselectedLabelColor: Colors.black,
        tabs: List.generate(_productCategoryData!.length, (index) {
          return Tab(
            text: "${_productCategoryData![index]["category"]}",
          );
        }),
      ),
    );
  }

  Widget _productListPanel() {
    int index = _tabController!.index;
    String category = _productCategoryData![index]["category"];

    List<dynamic> productList = [];
    Map<String, dynamic> productMetaData = Map<String, dynamic>();

    if (_productListPageProvider!.productListPageState.productListData![category] != null) {
      productList = _productListPageProvider!.productListPageState.productListData![category];
    }
    if (_productListPageProvider!.productListPageState.productMetaData![category] != null) {
      productMetaData = _productListPageProvider!.productListPageState.productMetaData![category];
    }

    int itemCount = 0;

    if (_productListPageProvider!.productListPageState.productListData![category] != null) {
      List<dynamic> data = _productListPageProvider!.productListPageState.productListData![category];
      itemCount += data.length;
    }

    if (_productListPageProvider!.productListPageState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: (productMetaData["nextPage"] != null && _productListPageProvider!.productListPageState.progressState != 1),
        header: WaterDropHeader(),
        footer: ClassicFooter(),
        controller: _refreshControllerList[index],
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: itemCount == 0
            ? Center(
                child: Text(
                  "No Product Available",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              )
            : ListView.separated(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  Map<String, dynamic> productData = (index >= productList.length) ? Map<String, dynamic>() : productList[index];

                  if (!widget.isForSelection) {
                    return ProductItemWidget(
                      productModel: productData.isNotEmpty ? ProductModel.fromJson(productData) : null,
                      storeModel: widget.storeModel,
                      isLoading: productData.isEmpty,
                      isShowGoToStore: false,
                      showBargainAvailable: (widget.bargainAvailable != null && widget.bargainAvailable!) ? false : true,
                      tapCallback: () async {
                        _cartAndFavoriteUpdateHandler();

                        var result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => ProductItemDetailPage(
                              storeModel: widget.storeModel,
                              productModel: ProductModel.fromJson(productData),
                              type: "products",
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
                        if (productData.isEmpty) return;
                        if (!widget.isForSelection) return;
                        selectedProduct = productData;
                        setState(() {});
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: ProductItemForSelectionWidget(
                          productModel: productData.isEmpty ? null : ProductModel.fromJson(productData),
                          isLoading: productData.isEmpty,
                          showBargainAvailable: (widget.bargainAvailable != null && widget.bargainAvailable!) ? false : true,
                          isSelected: (selectedProduct != null && productData["_id"] == selectedProduct!["_id"]),
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

  Widget _selectedProductPanel() {
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
          Expanded(
            child: Text(
              selectedProduct == null ? "Please choose Product" : selectedProduct!["name"],
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          KeicyRaisedButton(
            width: widthDp * 100,
            height: heightDp * 35,
            color: selectedProduct == null ? Colors.grey.withOpacity(0.6) : config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            child: Text("OK", style: TextStyle(fontSize: fontSp * 16, color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop(selectedProduct);
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
