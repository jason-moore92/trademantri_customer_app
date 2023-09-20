import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/order_dashboard_widget.dart';
import 'package:trapp/src/elements/order_graph_widget.dart';
import 'package:trapp/src/elements/order_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'OrderDetailNewPage/index.dart';

class CategoryDashboardPage extends StatefulWidget {
  Map<String, dynamic>? categoryData;

  CategoryDashboardPage({@required this.categoryData});

  @override
  _CategoryDashboardPageState createState() => _CategoryDashboardPageState();
}

class _CategoryDashboardPageState extends State<CategoryDashboardPage> {
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

  List<dynamic> _orderList = [];
  int _page = 1;
  bool _isloading = false;
  bool _haveNextPage = false;

  RefreshProvider? _refreshProvider;

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

    _orderList = [];
    _page = 1;
    _isloading = false;
    _haveNextPage = false;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _getOrderListdata();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "${widget.categoryData!["category"]["categoryDesc"]} Dashboard",
          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
        ),
      ),
      body: Consumer<OrderProvider>(builder: (context, orderProvider, _) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: heightDp * 20),
              OrderGraphWidget(
                storeCategoryId: widget.categoryData!["category"]["categoryId"],
              ),
              StreamBuilder<dynamic>(
                stream: Stream.fromFuture(
                  OrderApiProvider.getDashboardDataByUser(
                    userId: AuthProvider.of(context).authState.userModel!.id,
                    storeCategoryId: widget.categoryData!["category"]["categoryId"],
                  ),
                ),
                builder: (context, snapshot) {
                  return Column(
                    children: <Widget>[
                      SizedBox(height: heightDp * 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OrderDashboardWidget(
                              dashboardOrderData: !snapshot.hasData || snapshot.data == null ? Map<String, dynamic>() : snapshot.data["data"],
                              fieldName: "totalOrderCount",
                              description: "Total Orders",
                            ),
                            OrderDashboardWidget(
                              dashboardOrderData: !snapshot.hasData || snapshot.data == null ? Map<String, dynamic>() : snapshot.data["data"],
                              fieldName: "totalPrice",
                              description: "Total Value",
                              prefix: "₹",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: heightDp * 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OrderDashboardWidget(
                              dashboardOrderData: !snapshot.hasData || snapshot.data == null ? Map<String, dynamic>() : snapshot.data["data"],
                              fieldName: "totalCancelledOrderCount",
                              description: "Cancelled Orders",
                            ),
                            OrderDashboardWidget(
                              dashboardOrderData: !snapshot.hasData || snapshot.data == null ? Map<String, dynamic>() : snapshot.data["data"],
                              fieldName: "totalRejectedOrderCount",
                              description: "Rejected Orders",
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: heightDp * 20),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 30),
                  child: Text(
                    "Orders",
                    style: TextStyle(fontSize: fontSp * 20, fontWeight: FontWeight.bold, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: heightDp * 20),
              _orderListWidget(),
              SizedBox(height: heightDp * 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _orderListWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RefreshProvider()),
      ],
      child: Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
        _refreshProvider = refreshProvider;

        return Column(
          children: [
            Column(
              children: List.generate(
                _orderList.length,
                (index) {
                  Map<String, dynamic> orderData = _orderList[index];
                  return OrderWidget(
                    orderData: orderData,
                    loadingStatus: orderData.isEmpty,
                    showButton: false,
                    detailCallback: () {
                      _detailCallback(orderData);
                    },
                    cancelCallback: null,
                    payCallback: null,
                  );
                },
              ),
            ),
            _isloading
                ? Center(
                    child: Padding(padding: EdgeInsets.all(heightDp * 10), child: CupertinoActivityIndicator()),
                  )
                : SizedBox(),
            _haveNextPage == false ? SizedBox() : SizedBox(height: heightDp * 20),
            _haveNextPage == false
                ? SizedBox()
                : KeicyRaisedButton(
                    width: widthDp * 150,
                    height: heightDp * 35,
                    color: config.Colors().mainColor(1),
                    borderRadius: heightDp * 6,
                    child: Text("Show More", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
                    onPressed: () {
                      _page++;
                      _getOrderListdata();
                    },
                  ),
          ],
        );
      }),
    );
  }

  void _getOrderListdata() async {
    _isloading = true;
    _haveNextPage = false;
    _refreshProvider!.refresh();
    var result = await OrderApiProvider.getOrderDataByCategory(
      userId: AuthProvider.of(context).authState.userModel!.id,
      storeCategoryId: widget.categoryData!["category"]["categoryId"],
      page: _page,
      limit: AppConfig.countLimitForList,
    );

    _orderList.addAll(result["data"]["docs"]);

    _isloading = false;
    _haveNextPage = result["data"]["hasNextPage"];
    _refreshProvider!.refresh();
  }

  void _detailCallback(Map<String, dynamic> orderData) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => OrderDetailNewPage(orderModel: OrderModel.fromJson(orderData)),
      ),
    );
    if (result != null) {
      _orderList = [];
      _page = 1;
      _isloading = false;
      _haveNextPage = false;
      _getOrderListdata();
    }
  }
}
