import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/pages/CartForAllStoresPage/index.dart';
import 'package:trapp/src/providers/AuthProvider/auth_provider.dart';
import 'package:trapp/src/providers/AuthProvider/auth_state.dart';
import 'package:trapp/src/providers/CartProvider/cart_provider.dart';
import 'package:trapp/config/app_config.dart' as config;

class CartOfAllStoresWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
    ///

    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
      bool isEmpty = true;

      int count = 0;

      cartProvider.cartState.cartData!.forEach((storeId, cartData) {
        if (cartData["products"].length != 0 || cartData["services"].length != 0) {
          isEmpty = false;
          count++;
        }
      });

      return GestureDetector(
        onTap: () {
          if (AuthProvider.of(context).authState.loginState != LoginState.IsLogin) {
            LoginAskDialog.show(context, callback: () {
              //TODO:: Here it should be CartForAllStoresPage page, that page depends on Pages page
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/Pages',
                ModalRoute.withName('/'),
                arguments: {"currentTab": 2},
              );
            });
          } else {
            // if (isEmpty) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => CartForAllStoresPage(),
              ),
            );
          }
        },
        child: Row(
          children: [
            Stack(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: heightDp! * 30,
                  color: Colors.black,
                ),
                isEmpty
                    ? SizedBox()
                    : Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: heightDp! * 17,
                          height: heightDp! * 17,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp! * 10),
                            color: config.Colors().mainColor(1),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            count.toString(),
                            style: TextStyle(fontSize: fontSp! * 10, color: Colors.white),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
