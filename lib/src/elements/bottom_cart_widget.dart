import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/CheckOutPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class BottomCartWidget extends StatefulWidget {
  final StoreModel? storeModel;
  final Function? storeInitHandler;

  BottomCartWidget({@required this.storeModel, this.storeInitHandler});

  @override
  _BottomCartWidgetState createState() => _BottomCartWidgetState();
}

class _BottomCartWidgetState extends State<BottomCartWidget> {
  /// Responsive design variables
  double? deviceWidth;
  double? deviceHeight;
  double? statusbarHeight;
  double? appbarHeight;
  double? widthDp;
  double? heightDp;
  double? heightDp1;
  double? fontSp;
  ///////////////////////////////

  @override
  void initState() {
    super.initState();

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
  }

  void _onPressedHandler() async {
    if (CartProvider.of(context).cartState.isUpdated!) {
      CartApiProvider.backup(
        cartData: CartProvider.of(context).cartState.cartData,
        lastDeviceToken: AuthProvider.of(context).authState.userModel!.fcmToken,
        userId: AuthProvider.of(context).authState.userModel!.id,
      );
      CartProvider.of(context).setCartState(
        CartProvider.of(context).cartState.update(isUpdated: false),
      );
    }

    if (FavoriteProvider.of(context).favoriteState.isUpdated!) {
      FavoriteApiProvider.backup(favoriteData: FavoriteProvider.of(context).favoriteState.favoriteData);
      FavoriteProvider.of(context).setFavoriteState(
        FavoriteProvider.of(context).favoriteState.update(isUpdated: false),
      );
    }

    OrderModel orderModel = OrderModel.fromJson(CartProvider.of(context).cartState.cartData![widget.storeModel!.id]);
    orderModel.storeModel = widget.storeModel;
    orderModel.category = AppConfig.orderCategories["cart"];

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => CheckoutPage(orderModel: orderModel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        int itemCount = 0;
        double totalPice = 0;
        if (cartProvider.cartState.cartData![widget.storeModel!.id] != null && cartProvider.cartState.cartData![widget.storeModel!.id].isNotEmpty) {
          for (var i = 0; i < cartProvider.cartState.cartData![widget.storeModel!.id]["products"].length; i++) {
            var productData = cartProvider.cartState.cartData![widget.storeModel!.id]["products"][i];
            itemCount += 1;
            double discount = 0;
            if (productData["data"]["discount"] != null) {
              discount = double.parse(productData["data"]["discount"].toString());
            }
            totalPice += productData["orderQuantity"] * (double.parse(productData["data"]["price"].toString()) - discount);
          }

          for (var i = 0; i < cartProvider.cartState.cartData![widget.storeModel!.id]["services"].length; i++) {
            var serviceData = cartProvider.cartState.cartData![widget.storeModel!.id]["services"][i];
            itemCount += 1;
            double discount = 0;
            if (serviceData["data"]["discount"] != null) {
              discount = double.parse(serviceData["data"]["discount"].toString());
            }
            totalPice += serviceData["orderQuantity"] * (double.parse(serviceData["data"]["price"].toString()) - discount);
          }
        }

        return itemCount == 0
            ? SizedBox()
            : Container(
                padding: EdgeInsets.symmetric(horizontal: widthDp! * 20, vertical: heightDp! * 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.4), offset: Offset(0, -1), blurRadius: 2),
                  ],
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.add_shopping_cart_outlined, size: heightDp! * 20, color: Colors.black.withOpacity(0.4)),
                        SizedBox(width: widthDp! * 10),
                        Text(
                          "$itemCount Items",
                          style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: widthDp! * 20),
                        Row(
                          children: [
                            Text(
                              "₹ ${totalPice.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: fontSp! * 14, color: config.Colors().mainColor(1), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    KeicyRaisedButton(
                      width: widthDp! * 120,
                      height: heightDp! * 35,
                      color: config.Colors().mainColor(1),
                      borderRadius: heightDp! * 40,
                      child: Text(
                        "View Cart",
                        style: TextStyle(fontSize: fontSp! * 16, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () async {
                        if (AuthProvider.of(context).authState.loginState == LoginState.IsNotLogin ||
                            AuthProvider.of(context).authState.userModel!.id == null) {
                          LoginAskDialog.show(
                            context,
                            callback: () {
                              if (widget.storeInitHandler != null) widget.storeInitHandler!();
                              _onPressedHandler();
                            },
                          );
                        } else {
                          _onPressedHandler();
                        }
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }
}
