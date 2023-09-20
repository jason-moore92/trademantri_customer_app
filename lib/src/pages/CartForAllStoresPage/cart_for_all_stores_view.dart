import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/product_for_carts_widget.dart';
import 'package:trapp/src/elements/service_for_carts_widget.dart';
import 'package:trapp/src/elements/store_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/CheckOutPage/index.dart';
import 'package:trapp/src/pages/OrderListPage/index.dart';
import 'package:trapp/src/pages/StorePage/index.dart';

import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class CartForAllStoresView extends StatefulWidget {
  CartForAllStoresView({Key? key}) : super(key: key);

  @override
  _CartForAllStoresViewState createState() => _CartForAllStoresViewState();
}

class _CartForAllStoresViewState extends State<CartForAllStoresView> with SingleTickerProviderStateMixin {
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

  CartProvider? _cartProvider;

  Map<String, dynamic> _openState = Map<String, dynamic>();

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

    _cartProvider = CartProvider.of(context);

    _openState = Map<String, dynamic>();
    _cartProvider!.cartState.cartData!.forEach((storeId, cartData) {
      _openState[storeId] = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Individual Store Carts",
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<CartProvider>(builder: (context, cartProvider, _) {
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _descriptionPanel(),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
                  child: InkWell(
                    onTap: () {
                      if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => OrderListPage(haveAppBar: true)),
                        );
                      } else {
                        LoginAskDialog.show(context, callback: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) => OrderListPage(haveAppBar: true)),
                          );
                        });
                      }
                    },
                    child: Text(
                      "My Orders",
                      style: TextStyle(
                        fontSize: fontSp * 16,
                        color: config.Colors().mainColor(1),
                        decoration: TextDecoration.underline,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                if (_cartProvider!.cartState.cartData!.length == 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
                    child: Center(
                      child: Text(
                        "You havn't added items to cart",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                Column(
                  children: List.generate(_cartProvider!.cartState.cartData!.length, (index) {
                    String storeId = _cartProvider!.cartState.cartData!.keys.toList()[index];
                    var cartData = _cartProvider!.cartState.cartData![storeId];

                    if (cartData["products"].isEmpty && cartData["services"].isEmpty) {
                      return SizedBox();
                    }

                    return _cartPanel(storeId, cartData);
                  }),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _descriptionPanel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
      child: Text(
        "These are the items you have from different stores, you will be able to checkout one single store at a time, please checkout the store from which you want to order.",
        style: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1.5),
      ),
    );
  }

  Widget _cartPanel(String storeId, Map<String, dynamic> cartData) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
      child: Card(
        color: Colors.white,
        elevation: 5,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: heightDp * 10),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => StorePage(storeModel: StoreModel.fromJson(cartData["store"])),
                        ),
                      );
                    },
                    child: StoreWidget(
                      storeModel: StoreModel.fromJson(cartData["store"]),
                      loadingStatus: false,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        OrderModel orderModel = OrderModel.fromJson(cartData);
                        orderModel.storeModel = StoreModel.fromJson(cartData["store"]);
                        orderModel.category = AppConfig.orderCategories["cart"];

                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => CheckoutPage(orderModel: orderModel),
                          ),
                        );
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: heightDp * 10),
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(heightDp * 6),
                          color: config.Colors().mainColor(1),
                        ),
                        child: Text(
                          "Checkout",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: heightDp * 10,
              thickness: 1,
              color: Colors.grey.withOpacity(0.6),
              indent: widthDp * 15,
              endIndent: widthDp * 15,
            ),
            cartData["products"].length == 0
                ? SizedBox()
                : Column(
                    children: [
                      ...List.generate(
                          _openState[storeId]
                              ? cartData["products"].length
                              : cartData["products"].length >= 2 - (cartData["services"].length == 0 ? 0 : 1)
                                  ? 2 - (cartData["services"].length == 0 ? 0 : 1)
                                  : cartData["products"].length, (index) {
                        Map<String, dynamic> productData = cartData["products"][index]["data"];

                        return ProductForCartsWidget(
                          productData: productData,
                          storeData: cartData["store"],
                          isLoading: cartData.isEmpty,
                        );
                      }),
                      ...[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (BuildContext context) => StorePage(
                                  storeModel: StoreModel.fromJson(cartData["store"]),
                                ),
                              ),
                              (route) {
                                if (route.settings.name == "home_page") return true;
                                return false;
                              },
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: widthDp * 10,
                              top: heightDp * 10,
                              bottom: heightDp * 10,
                            ),
                            child: Text(
                              "+ Add More",
                              style: TextStyle(
                                fontSize: fontSp * 14,
                                color: config.Colors().mainColor(1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
            cartData["services"].length == 0
                ? SizedBox()
                : Column(
                    children: List.generate(
                        _openState[storeId]
                            ? cartData["services"].length
                            : cartData["services"].length >= 2 - (cartData["products"].length == 0 ? 0 : 1)
                                ? 2 - (cartData["products"].length == 0 ? 0 : 1)
                                : cartData["services"].length, (index) {
                      Map<String, dynamic> serviceData = cartData["services"][index]["data"];

                      return ServiceForCartsWidget(
                        serviceData: serviceData,
                        storeData: cartData["store"],
                        isLoading: cartData.isEmpty,
                      );
                    }),
                  ),
            cartData["products"].length + cartData["services"].length <= 2
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 6)),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 0),
                          onPressed: () {
                            setState(() {
                              _openState[storeId] = !_openState[storeId];
                            });
                          },
                          color: Colors.grey.withOpacity(0.3),
                          child: Text(
                            _openState[storeId] ? "Show Less Items" : "Show More Items",
                            style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
            SizedBox(height: heightDp * 10),
          ],
        ),
      ),
    );
  }
}
