import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'keicy_progress_dialog.dart';

class CartMoreButtonWidget extends StatefulWidget {
  final StoreModel? storeModel;
  final Map<String, dynamic>? itemData;
  final String? category;

  CartMoreButtonWidget({
    @required this.storeModel,
    @required this.itemData,
    @required this.category,
  });

  @override
  _CartMoreButtonWidgetState createState() => _CartMoreButtonWidgetState();
}

class _CartMoreButtonWidgetState extends State<CartMoreButtonWidget> {
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;

  AuthProvider? _authProvider;
  CartProvider? _cartProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  @override
  void initState() {
    super.initState();

    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    _authProvider = AuthProvider.of(context);
    _cartProvider = CartProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _cartProvider!.addListener(_cartProviderListener);
    });
  }

  void _cartProviderListener() async {
    if (_cartProvider!.cartState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
      List<dynamic> cartData = (_cartProvider!.cartState.cartData![widget.storeModel!.id] == null ||
              _cartProvider!.cartState.cartData![widget.storeModel!.id][widget.category] == null)
          ? []
          : _cartProvider!.cartState.cartData![widget.storeModel!.id][widget.category];

      int selectedCount = 0;
      for (var i = 0; i < cartData.length; i++) {
        if (cartData[i]["data"]["_id"] == widget.itemData!["id"] || cartData[i]["data"]["_id"] == widget.itemData!["_id"]) {
          selectedCount = cartData[i]["orderQuantity"];
          break;
        }
      }

      return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () async {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                  _cartHandler(selectedCount - 1);
                } else {
                  LoginAskDialog.show(context, callback: () {});
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                color: Colors.transparent,
                child: Row(
                  children: [
                    SizedBox(width: widthDp * 10),
                    Icon(Icons.remove, color: selectedCount == 0 ? Colors.black : config.Colors().mainColor(1), size: heightDp * 20),
                    SizedBox(width: widthDp * 5),
                  ],
                ),
              ),
            ),
            Text(
              selectedCount.toString(),
              style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w700),
            ),
            GestureDetector(
              onTap: () async {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                  _cartHandler(selectedCount + 1);
                } else {
                  LoginAskDialog.show(context, callback: () {});
                }
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                child: Row(
                  children: [
                    SizedBox(width: widthDp * 5),
                    Icon(Icons.add, color: config.Colors().mainColor(1), size: heightDp * 20),
                    SizedBox(width: widthDp * 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _cartHandler(int quantity) {
    if (_cartProvider!.cartState.progressState == 1) {
      _keicyProgressDialog = KeicyProgressDialog(context, message: "Cart Data is loading...");
      _keicyProgressDialog!.show();
      return;
    }

    _cartProvider!.setCartState(_cartProvider!.cartState.update(progressState: 1));

    _cartProvider!.setCartData(
      storeModel: widget.storeModel,
      userId: AuthProvider.of(context).authState.userModel!.id,
      storeId: widget.storeModel!.id,
      objectData: widget.itemData,
      category: widget.category,
      orderQuantity: quantity,
      lastDeviceToken: AuthProvider.of(context).authState.userModel!.fcmToken,
    );
  }
}
