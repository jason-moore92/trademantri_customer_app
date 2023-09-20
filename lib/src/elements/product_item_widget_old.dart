import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ProductItemDetailPage/index.dart';
import 'package:trapp/src/pages/StorePage/index.dart';
import 'package:trapp/src/providers/CartProvider/cart_provider.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/services/dynamic_link_service.dart';

import 'cart_one_button_widget.dart';
import 'favorite_icon_widget.dart';
import 'keicy_avatar_image.dart';

class ProductItemWidget extends StatefulWidget {
  final ProductModel? productModel;
  final StoreModel? storeModel;
  final bool? isLoading;
  final bool? isShowGoToStore;
  final bool? isShowFavorite;
  final bool? isShowQuantity;
  final bool? isShowStoreName;
  final Function? tapCallback;

  ProductItemWidget({
    @required this.productModel,
    @required this.storeModel,
    this.isLoading = true,
    this.isShowGoToStore = true,
    this.isShowFavorite = true,
    this.isShowQuantity = true,
    this.isShowStoreName = false,
    this.tapCallback,
  });

  @override
  _ProductItemWidgetState createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  bool? isAdded;
  int? selectedCount;

  CartProvider? _cartProvider;

  var numFormat = NumberFormat.currency(symbol: "", name: "");

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
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    _cartProvider = CartProvider.of(context);

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        left: widthDp * 15,
        right: widthDp * 15,
        top: heightDp * 5,
        bottom: heightDp * 10,
      ),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
        color: Colors.transparent,
        child: widget.isLoading! ? _shimmerWidget() : _productWidget(),
      ),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.isLoading!,
      period: Duration(milliseconds: 1000),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: widthDp * 80,
                height: widthDp * 80,
                color: Colors.white,
              ),
              SizedBox(width: widthDp * 15),
              Container(
                height: widthDp * 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "product name",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "10 unites",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "price",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: widthDp * 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(heightDp * 20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "ADD",
                    style: TextStyle(fontSize: fontSp * 14, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _productWidget() {
    List<dynamic> cartData = (_cartProvider!.cartState.cartData![widget.productModel!.storeId] == null ||
            _cartProvider!.cartState.cartData![widget.productModel!.storeId]["products"] == null)
        ? []
        : _cartProvider!.cartState.cartData![widget.productModel!.storeId]["products"];

    isAdded = false;
    selectedCount = 0;
    for (var i = 0; i < cartData.length; i++) {
      if (cartData[i]["data"]["_id"] == widget.productModel!.id) {
        isAdded = true;
        selectedCount = cartData[i]["orderQuantity"];
        break;
      }
    }

    return GestureDetector(
      onTap: () {
        if (widget.tapCallback != null) widget.tapCallback!();
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    KeicyAvatarImage(
                      url: (widget.productModel!.images == null || widget.productModel!.images!.isEmpty) ? "" : widget.productModel!.images![0],
                      width: widthDp * 80,
                      height: widthDp * 80,
                      backColor: Colors.grey.withOpacity(0.4),
                    ),
                    !widget.productModel!.isAvailable! ? Image.asset("img/unavailable.png", width: widthDp * 60, fit: BoxFit.fitWidth) : SizedBox(),
                  ],
                ),
                SizedBox(width: widthDp * 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.productModel!.name}",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: heightDp * 3),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${widget.productModel!.description}",
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp * 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: widget.productModel!.quantity == null || widget.productModel!.quantityType == null
                                ? SizedBox()
                                : Text(
                                    "${widget.productModel!.quantity} ${widget.productModel!.quantityType}",
                                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                                  ),
                          ),
                          if (widget.isShowQuantity! && widget.productModel!.showPriceToUsers!)
                            isAdded!
                                ? _addMoreProductButton()
                                : CartOneButtonWidget(
                                    storeModel: widget.storeModel,
                                    itemData: widget.productModel!.toJson(),
                                    category: "products",
                                  ),
                        ],
                      ),
                      SizedBox(height: heightDp * 5),
                      Row(
                        children: [
                          Expanded(child: !widget.productModel!.showPriceToUsers! ? _disablePriceDiaplayWidget() : _priceWidget()),
                        ],
                      ),
                      SizedBox(height: heightDp * 5),
                      Wrap(
                        spacing: widthDp * 10,
                        runSpacing: heightDp * 5,
                        children: [
                          widget.productModel!.bargainAvailable! ? _availableBargainWidget() : SizedBox(),
                          widget.productModel!.acceptBulkOrder! ? _availableBulkOrder() : SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: heightDp * 10),
            _bottomToolbar(),
          ],
        ),
      ),
    );
  }

  Widget _bottomToolbar() {
    return Container(
      width: deviceWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isShowStoreName!)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Store : ",
                          style: TextStyle(fontSize: fontSp * 13, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: widget.storeModel!.name!,
                          style: TextStyle(fontSize: fontSp * 13, color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          SizedBox(width: widthDp * 5),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: widthDp * 10,
            children: [
              if (widget.isShowGoToStore!)
                GestureDetector(
                  onTap: () {
                    _cartAndFavoriteUpdateHandler();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => StorePage(
                          storeModel: widget.storeModel,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 5), color: config.Colors().mainColor(1)),
                    child: Text(
                      "Go to Store",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                    ),
                  ),
                ),
              if (widget.isShowFavorite!)
                FavoriteIconWidget(
                  category: "products",
                  id: widget.productModel!.id,
                  storeId: widget.storeModel!.id,
                  size: heightDp * 25,
                ),
              GestureDetector(
                onTap: () async {
                  Uri dynamicUrl = await DynamicLinkService.createProductDynamicLink(
                    itemData: widget.productModel!.toJson(),
                    storeModel: widget.storeModel,
                    type: "products",
                    isForCart: true,
                  );
                  Share.share(dynamicUrl.toString());
                },
                child: Icon(Icons.share, size: heightDp * 30, color: config.Colors().mainColor(1)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categoryButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(heightDp * 20),
        border: Border.all(color: Colors.blue),
      ),
      child: Text(
        "Product",
        style: TextStyle(fontSize: fontSp * 12, color: Colors.blue),
      ),
    );
  }

  // Widget _addOneProductButton() {
  //   return Container(
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         GestureDetector(
  //           onTap: () async {
  //             try {
  //               if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
  //                 if (_cartProvider!.cartState.progressState == 1) return;
  //                 _cartProvider!.setCartState(_cartProvider!.cartState.update(progressState: 1));
  //                 _cartProvider!.setCartData(
  //                   storeModel: widget.storeModel,
  //                   userId: AuthProvider.of(context).authState.userModel!.id,
  //                   storeId: widget.storeModel!.id,
  //                   objectData: widget.productModel!.toJson(),
  //                   category: "products",
  //                   orderQuantity: 1,
  //                   lastDeviceToken: AuthProvider.of(context).authState.userModel!.fcmToken,
  //                 );
  //                 setState(() {});
  //               } else {
  //                 LoginAskDialog.show(context, callback: () {
  //                   if (_cartProvider!.cartState.progressState == 1) return;
  //                   _cartProvider!.setCartState(_cartProvider!.cartState.update(progressState: 1));

  //                   _cartProvider!.setCartData(
  //                     storeModel: widget.storeModel,
  //                     userId: AuthProvider.of(context).authState.userModel!.id,
  //                     storeId: widget.storeModel!.id,
  //                     objectData: widget.productModel!.toJson(),
  //                     category: "products",
  //                     orderQuantity: 1,
  //                     lastDeviceToken: AuthProvider.of(context).authState.userModel!.fcmToken,
  //                   );
  //                   setState(() {});
  //                 });
  //               }
  //             } catch (e) {
  //               print(e);
  //             }
  //           },
  //           child: Container(
  //             padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
  //             decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
  //             alignment: Alignment.center,
  //             child: Text(
  //               "ADD",
  //               style: TextStyle(fontSize: fontSp * 14, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _addMoreProductButton() {
    return Container(
      width: widthDp * 100,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                if (_cartProvider!.cartState.progressState == 1) return;
                _cartProvider!.setCartState(_cartProvider!.cartState.update(progressState: 1));
                _cartProvider!.setCartData(
                  storeModel: widget.storeModel,
                  userId: AuthProvider.of(context).authState.userModel!.id,
                  storeId: widget.storeModel!.id,
                  objectData: widget.productModel!.toJson(),
                  category: "products",
                  orderQuantity: selectedCount! - 1,
                  lastDeviceToken: AuthProvider.of(context).authState.userModel!.fcmToken,
                );
                setState(() {});
              } else {
                LoginAskDialog.show(context, callback: () {
                  if (_cartProvider!.cartState.progressState == 1) return;
                  _cartProvider!.setCartState(_cartProvider!.cartState.update(progressState: 1));
                  _cartProvider!.setCartData(
                    storeModel: widget.storeModel,
                    userId: AuthProvider.of(context).authState.userModel!.id,
                    storeId: widget.storeModel!.id,
                    objectData: widget.productModel!.toJson(),
                    category: "products",
                    orderQuantity: selectedCount! - 1,
                    lastDeviceToken: AuthProvider.of(context).authState.userModel!.fcmToken,
                  );
                  setState(() {});
                });
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
                if (_cartProvider!.cartState.progressState == 1) return;
                _cartProvider!.setCartState(_cartProvider!.cartState.update(progressState: 1));

                _cartProvider!.setCartData(
                  storeModel: widget.storeModel,
                  userId: AuthProvider.of(context).authState.userModel!.id,
                  storeId: widget.storeModel!.id,
                  objectData: widget.productModel!.toJson(),
                  category: "products",
                  orderQuantity: selectedCount! + 1,
                  lastDeviceToken: AuthProvider.of(context).authState.userModel!.fcmToken,
                );

                setState(() {});
              } else {
                LoginAskDialog.show(context, callback: () {
                  if (_cartProvider!.cartState.progressState == 1) return;
                  _cartProvider!.setCartState(_cartProvider!.cartState.update(progressState: 1));

                  _cartProvider!.setCartData(
                    storeModel: widget.storeModel,
                    userId: AuthProvider.of(context).authState.userModel!.id,
                    storeId: widget.storeModel!.id,
                    objectData: widget.productModel!.toJson(),
                    category: "products",
                    orderQuantity: selectedCount! + 1,
                    lastDeviceToken: AuthProvider.of(context).authState.userModel!.fcmToken,
                  );

                  setState(() {});
                });
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
  }

  Widget _disablePriceDiaplayWidget() {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: widthDp * 5,
            right: widthDp * 2,
            bottom: heightDp * 5,
            top: heightDp * 5,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFF8C888),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(heightDp * 4),
              bottomLeft: Radius.circular(heightDp * 4),
            ),
          ),
          child: Icon(Icons.remove_moderator, size: widthDp * 12, color: Colors.black),
        ),
        Container(
          padding: EdgeInsets.only(
            left: widthDp * 2,
            right: widthDp * 5,
            bottom: heightDp * 5,
            top: heightDp * 5,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFF8C888),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(heightDp * 4),
              bottomRight: Radius.circular(heightDp * 4),
            ),
          ),
          child: Text(
            "Price Disabled By Store Owner",
            style: TextStyle(fontSize: fontSp * 10, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _priceWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.productModel!.discount == null || widget.productModel!.discount == 0
            ? Text(
                "₹ ${numFormat.format(widget.productModel!.price)}",
                style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "₹ ${numFormat.format(widget.productModel!.price! - widget.productModel!.discount!)}",
                        style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: widthDp * 10),
                      Text(
                        "₹ ${numFormat.format(widget.productModel!.price)}",
                        style: TextStyle(
                          fontSize: fontSp * 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 2,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Saved ₹ ${numFormat.format(double.parse(widget.productModel!.discount.toString()))}",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
        Text(
          "* Inclusive of all taxes",
          style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
        ),
      ],
    );
  }

  Widget _availableBargainWidget() {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: widthDp * 5,
            right: widthDp * 2,
            bottom: heightDp * 5,
            top: heightDp * 5,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFE7F16E),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(heightDp * 4),
              bottomLeft: Radius.circular(heightDp * 4),
            ),
          ),
          child: Icon(Icons.star, size: widthDp * 12, color: Colors.black),
        ),
        Container(
          padding: EdgeInsets.only(
            left: widthDp * 2,
            right: widthDp * 5,
            bottom: heightDp * 5,
            top: heightDp * 5,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFE7F16E),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(heightDp * 4),
              bottomRight: Radius.circular(heightDp * 4),
            ),
          ),
          child: Text(
            "Bargain Available",
            style: TextStyle(fontSize: fontSp * 10, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _availableBulkOrder() {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: widthDp * 5,
            right: widthDp * 2,
            bottom: heightDp * 5,
            top: heightDp * 5,
          ),
          decoration: BoxDecoration(
            color: Color(0xFF6EF174),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(heightDp * 4),
              bottomLeft: Radius.circular(heightDp * 4),
            ),
          ),
          child: Icon(Icons.star, size: widthDp * 12, color: Colors.black),
        ),
        Container(
          padding: EdgeInsets.only(
            left: widthDp * 2,
            right: widthDp * 5,
            bottom: heightDp * 5,
            top: heightDp * 5,
          ),
          decoration: BoxDecoration(
            color: Color(0xFF6EF174),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(heightDp * 4),
              bottomRight: Radius.circular(heightDp * 4),
            ),
          ),
          child: Text(
            "Bulk Order Available",
            style: TextStyle(fontSize: fontSp * 10, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
