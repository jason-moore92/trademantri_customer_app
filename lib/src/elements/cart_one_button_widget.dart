import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'keicy_progress_dialog.dart';

class CartOneButtonWidget extends StatefulWidget {
  final StoreModel? storeModel;
  final Map<String, dynamic>? itemData;
  final String? category;

  CartOneButtonWidget({
    @required this.storeModel,
    @required this.itemData,
    @required this.category,
  });

  @override
  _CartOneButtonWidgetState createState() => _CartOneButtonWidgetState();
}

class _CartOneButtonWidgetState extends State<CartOneButtonWidget> {
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
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                  _cartHandler();
                } else {
                  LoginAskDialog.show(context, callback: () {});
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
                alignment: Alignment.center,
                child: Text(
                  "ADD",
                  style: TextStyle(fontSize: fontSp * 14, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _cartHandler() {
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
      orderQuantity: 1,
      lastDeviceToken: AuthProvider.of(context).authState.userModel!.fcmToken,
    );
  }
}
