import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/elements/bargain_count_widget.dart';
import 'package:trapp/src/elements/order_dashboard_widget.dart';
import 'package:trapp/src/elements/order_graph_widget.dart';
import 'package:trapp/src/elements/reverse_auction_count_widget.dart';
import 'package:trapp/src/elements/category_total_orders_widget.dart';
import 'package:trapp/src/providers/fb_analytics.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/pages/category_dashboard.dart';
import 'package:trapp/environment.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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

    // if (Environment.enableFBEvents!) {
    //   getFBAppEvents().logViewContent(
    //     type: "page",
    //     id: "dashboard",
    //     content: {},
    //     currency: "INR",
    //     price: 0,
    //   );
    // }

    // if (Environment.enableFreshChatEvents!) {
    //   Freshchat.trackEvent(
    //     "navigation",
    //     properties: {
    //       "page": "dashboard",
    //     },
    //   );
    // }
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
        title: Text("Dashboard", style: TextStyle(fontSize: fontSp * 20, color: Colors.black)),
      ),
      body: Consumer<OrderProvider>(builder: (context, orderProvider, _) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: heightDp * 20),
              OrderGraphWidget(),
              StreamBuilder<dynamic>(
                stream: Stream.fromFuture(
                  OrderApiProvider.getDashboardDataByUser(
                    userId: AuthProvider.of(context).authState.userModel!.id,
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
                              dashboardOrderData: ((!snapshot.hasData || snapshot.data == null) ? Map<String, dynamic>() : snapshot.data["data"]),
                              fieldName: "totalOrderCount",
                              description: "Total Orders",
                            ),
                            OrderDashboardWidget(
                              dashboardOrderData: ((!snapshot.hasData || snapshot.data == null) ? Map<String, dynamic>() : snapshot.data["data"]),
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
                              dashboardOrderData: ((!snapshot.hasData || snapshot.data == null) ? Map<String, dynamic>() : snapshot.data["data"]),
                              fieldName: "totalCancelledOrderCount",
                              description: "Cancelled Orders",
                            ),
                            OrderDashboardWidget(
                              dashboardOrderData: ((!snapshot.hasData || snapshot.data == null) ? Map<String, dynamic>() : snapshot.data["data"]),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BargainCountWidget(userId: AuthProvider.of(context).authState.userModel!.id),
                    ReverseAuctionCountWidget(userId: AuthProvider.of(context).authState.userModel!.id),
                  ],
                ),
              ),
              SizedBox(height: heightDp * 20),
              _categoryList(),
              SizedBox(height: heightDp * 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _categoryList() {
    return StreamBuilder<dynamic>(
      stream: Stream.fromFuture(
        OrderApiProvider.getCategoryOrderDataByUser(userId: AuthProvider.of(context).authState.userModel!.id),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null)
          return Center(
            child: Padding(
              padding: EdgeInsets.all(heightDp * 50),
              child: CupertinoActivityIndicator(),
            ),
          );
        if (snapshot.data["data"].length == 0) {
          return SizedBox();
        }

        return Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 30),
                child: Text(
                  "Do You Want To See Category Wise Breakdown",
                  style: TextStyle(fontSize: fontSp * 20, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: heightDp * 20),
            Column(
              children: List.generate(
                snapshot.data["data"].length,
                (index) {
                  return CategoryTotalOrdersWidget(
                    categoryData: snapshot.data["data"][index],
                    onTapHandler: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => CategoryDashboardPage(
                            categoryData: snapshot.data["data"][index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
