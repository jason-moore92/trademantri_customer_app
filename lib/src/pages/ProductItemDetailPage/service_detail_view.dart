import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/bottom_cart_widget.dart';
import 'package:trapp/src/elements/favorite_icon_widget.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/review_and_rating_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ProductItemReviewPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/services/dynamic_link_service.dart';

class ServiceDetailView extends StatefulWidget {
  final StoreModel? storeModel;
  final String? type;
  final ServiceModel? serviceModel;
  final bool isForCart;

  ServiceDetailView({
    Key? key,
    this.storeModel,
    this.type,
    this.serviceModel,
    this.isForCart = false,
  }) : super(key: key);

  @override
  _ServiceDetailViewState createState() => _ServiceDetailViewState();
}

class _ServiceDetailViewState extends State<ServiceDetailView> {
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

  int _selectedImageIndex = 0;
  int _selectedAddtionalInfoCategory = 0;

  var numFormat = NumberFormat.currency(symbol: "", name: "");

  AuthProvider? _authProvider;
  ProductItemReviewProvider? _productItemReviewProvider;
  CartProvider? _cartProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  String? reviewKey;
  int? selectedCount;

  bool? isNew;

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

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    _productItemReviewProvider = ProductItemReviewProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _cartProvider = CartProvider.of(context);

    reviewKey = "${_authProvider!.authState.userModel!.id}_${widget.serviceModel!.id}_${widget.type}";

    _productItemReviewProvider!.setProductItemReviewState(
      _productItemReviewProvider!.productItemReviewState.update(
        topReviewList: [],
        isLoadMore: false,
        averateRatingData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (_authProvider!.authState.loginState == LoginState.IsLogin && _authProvider!.authState.userModel!.id != null) {
        _initHandler();
      }

      _productItemReviewProvider!.getAverageRating(itemId: widget.serviceModel!.id, type: widget.type);

      _productItemReviewProvider!.getTopReviewList(
        itemId: widget.serviceModel!.id,
        type: widget.type,
      );
    });
  }

  void _initHandler() {
    if (_productItemReviewProvider!.productItemReviewState.productItemReviewData![reviewKey] == null) {
      _productItemReviewProvider!.getProductItemReview(
        userId: _authProvider!.authState.userModel!.id,
        itemId: widget.serviceModel!.id,
        type: widget.type,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addCartHandler() async {
    if (_cartProvider!.cartState.progressState == 1) return;
    _cartProvider!.setCartState(_cartProvider!.cartState.update(progressState: 1));

    _cartProvider!.setCartData(
      storeModel: widget.storeModel,
      storeId: widget.storeModel!.id,
      userId: AuthProvider.of(context).authState.userModel!.id,
      objectData: widget.serviceModel!.toJson(),
      category: widget.type,
      orderQuantity: selectedCount,
      lastDeviceToken: AuthProvider.of(context).authState.userModel!.fcmToken,
    );

    if (isNew!) {
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "Added to cart",
      );
      isNew = false;
    } else {
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "Cart Updated",
      );
      isNew = false;
      if (selectedCount == 0) {
        isNew = true;
        selectedCount = 1;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    // List<dynamic> attributes = [];
    // for (var i = 0; i < widget.serviceModel!.attributes!.length; i++) {
    //   if (widget.serviceModel!.attributes![i]["type"] != "" && widget.serviceModel!.attributes![i]["type"] != null) {
    //     attributes.add(widget.serviceModel!.attributes![i]);
    //   }
    // }
    // widget.serviceModel!.attributes = attributes;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
          onPressed: () {
            if (AuthProvider.of(context).authState.loginState != LoginState.IsLogin || AuthProvider.of(context).authState.userModel!.id == null) {
              Navigator.of(context).pop();
            }

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

            bool updated = FavoriteProvider.of(context).favoriteState.isUpdated!;
            if (FavoriteProvider.of(context).favoriteState.isUpdated!) {
              FavoriteApiProvider.backup(favoriteData: FavoriteProvider.of(context).favoriteState.favoriteData);
              FavoriteProvider.of(context).setFavoriteState(
                FavoriteProvider.of(context).favoriteState.update(isUpdated: false),
              );
            }

            Navigator.of(context).pop(updated);
          },
        ),
        centerTitle: true,
        title: Text(
          widget.type == "products" ? "Product Details" : "Service Detials",
          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<ProductItemReviewProvider>(builder: (context, productItemReviewProvider, _) {
        if (productItemReviewProvider.productItemReviewState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notifiation) {
            notifiation.disallowGlow();
            return true;
          },
          child: Container(
            width: deviceWidth,
            height: deviceHeight - statusbarHeight - appbarHeight,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: deviceWidth,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
                      child: Column(
                        children: [
                          _productImagePanel(),
                          SizedBox(height: heightDp * 20),
                          _productInfoPanel(),
                        ],
                      ),
                    ),
                  ),
                ),
                BottomCartWidget(storeModel: widget.storeModel),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _productImagePanel() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: widthDp * 200,
              height: heightDp * 200,
              child: KeicyAvatarImage(
                url: widget.serviceModel!.images!.isNotEmpty ? widget.serviceModel!.images![_selectedImageIndex] : "",
                width: widthDp * 200,
                height: heightDp * 200,
                backColor: Colors.grey.withOpacity(0.3),
              ),
            ),
            !widget.serviceModel!.isAvailable! ? Image.asset("img/unavailable.png", width: widthDp * 100, fit: BoxFit.fitWidth) : SizedBox(),
          ],
        ),
        if (widget.serviceModel!.images!.isNotEmpty) SizedBox(height: heightDp * 20),
        if (widget.serviceModel!.images!.isNotEmpty)
          Container(
            height: heightDp * 60,
            child: Row(
              children: [
                Expanded(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (notification) {
                      notification.disallowGlow();
                      return true;
                    },
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.serviceModel!.images!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_selectedImageIndex != index) {
                                _selectedImageIndex = index;
                              }
                            });
                          },
                          child: Container(
                            width: widthDp * 70,
                            height: heightDp * 70,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedImageIndex == index ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                                width: 2,
                              ),
                            ),
                            child: KeicyAvatarImage(
                              url: widget.serviceModel!.images![index],
                              width: widthDp * 70,
                              height: heightDp * 70,
                              backColor: Colors.white,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(width: widthDp * 10);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _productInfoPanel() {
    return Container(
      width: deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.serviceModel!.name!,
                  style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(width: widthDp * 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[200],
                  borderRadius: BorderRadius.circular(heightDp * 6),
                ),
                padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _productItemReviewProvider!.productItemReviewState.averateRatingData!.isEmpty
                          ? "0"
                          : (_productItemReviewProvider!.productItemReviewState.averateRatingData!["totalRating"] /
                                  _productItemReviewProvider!.productItemReviewState.averateRatingData!["totalCount"])
                              .toStringAsFixed(1),
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: widthDp * 5),
                    Icon(Icons.star, size: heightDp * 17, color: Colors.green),
                  ],
                ),
              ),
            ],
          ),

          if (widget.serviceModel!.provided != null)
            Column(
              children: [
                SizedBox(height: heightDp * 5),
                Text(
                  "${widget.serviceModel!.provided}",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ],
            ),

          ///
          SizedBox(height: heightDp * 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _priceWidget(),
              Row(
                children: [
                  FavoriteIconWidget(
                    category: widget.type,
                    id: widget.serviceModel!.id,
                    storeId: widget.storeModel!.id,
                    size: heightDp * 30,
                  ),
                  SizedBox(width: widthDp * 10),
                  GestureDetector(
                    onTap: () async {
                      Uri dynamicUrl = await DynamicLinkService.createProductDynamicLink(
                        itemData: widget.serviceModel!.toJson(),
                        storeModel: widget.storeModel,
                        type: widget.type,
                        isForCart: widget.isForCart,
                      );
                      Share.share(dynamicUrl.toString());
                    },
                    child: Icon(Icons.share, size: heightDp * 30, color: config.Colors().mainColor(1)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: heightDp * 20),
          if (widget.serviceModel!.attributes!.isNotEmpty) _attributesDetail(),
          if (widget.isForCart)
            Column(
              children: [
                Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                SizedBox(height: heightDp * 20),
                _cartPanel(),
              ],
            ),

          SizedBox(height: heightDp * 20),
          Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
          SizedBox(height: heightDp * 20),
          _additionalInfoPanel(),
        ],
      ),
    );
  }

  Widget _attributesDetail() {
    return Container(
      width: deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "Custom Fields",
          //   style: TextStyle(fontSize: fontSp * 18, fontWeight: FontWeight.w600, color: Colors.black),
          // ),
          // SizedBox(height: heightDp * 10),
          Column(
            children: List.generate(
              widget.serviceModel!.attributes!.length,
              (index) {
                Map<String, dynamic> attributes = widget.serviceModel!.attributes![index];

                if (attributes["type"] == null) return SizedBox();

                return Column(
                  children: [
                    Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: heightDp * 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "${attributes["type"]}" + (attributes["units"] != null && attributes["units"] != "" ? "(${attributes["units"]})" : ""),
                              style: TextStyle(
                                fontSize: fontSp * 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: widthDp * 5),
                          Expanded(
                            child: Text(
                              "${attributes["value"]}",
                              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceWidget() {
    return widget.serviceModel!.discount == 0
        ? Text(
            "₹ ${numFormat.format(widget.serviceModel!.price)}",
            style: TextStyle(fontSize: fontSp * 20, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "₹ ${numFormat.format(widget.serviceModel!.price! - widget.serviceModel!.discount!)}",
                    style: TextStyle(fontSize: fontSp * 20, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: widthDp * 10),
                  Text(
                    "₹ ${numFormat.format(widget.serviceModel!.price)}",
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 2,
                    ),
                  ),
                ],
              ),
              Text(
                "Saved ₹ ${numFormat.format(widget.serviceModel!.discount)}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
          );
  }

  Widget _cartPanel() {
    if (selectedCount == null) {
      if (widget.type == "products") {
        List<dynamic> cartData = (_cartProvider!.cartState.cartData![widget.serviceModel!.storeId] == null ||
                _cartProvider!.cartState.cartData![widget.serviceModel!.storeId]["products"] == null)
            ? []
            : _cartProvider!.cartState.cartData![widget.serviceModel!.storeId]["products"];

        selectedCount = 1;
        isNew = true;
        for (var i = 0; i < cartData.length; i++) {
          if (cartData[i]["data"]["_id"] == widget.serviceModel!.id) {
            selectedCount = cartData[i]["orderQuantity"];
            isNew = false;
            break;
          }
        }
      } else {
        List<dynamic> cartData = (_cartProvider!.cartState.cartData![widget.serviceModel!.storeId] == null ||
                _cartProvider!.cartState.cartData![widget.serviceModel!.storeId]["services"] == null)
            ? []
            : _cartProvider!.cartState.cartData![widget.serviceModel!.storeId]["services"];

        selectedCount = 1;
        isNew = true;
        for (var i = 0; i < cartData.length; i++) {
          if (cartData[i]["data"]["_id"] == widget.serviceModel!.id) {
            selectedCount = cartData[i]["orderQuantity"];
            isNew = false;
            break;
          }
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text("Quantity: $selectedCount", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
            SizedBox(width: widthDp * 20),
            Column(
              children: [
                GestureDetector(
                  onTap: !widget.serviceModel!.isAvailable!
                      ? null
                      : () {
                          setState(() {
                            selectedCount = selectedCount! + 1;
                          });
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: !widget.serviceModel!.isAvailable! ? Colors.grey.withOpacity(0.5) : config.Colors().mainColor(1),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(heightDp * 40),
                        topRight: Radius.circular(heightDp * 40),
                      ),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      size: heightDp * 30,
                      color: !widget.serviceModel!.isAvailable! ? Colors.grey.withOpacity(0.5) : config.Colors().mainColor(1),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: !widget.serviceModel!.isAvailable!
                      ? null
                      : () {
                          if ((isNew! && selectedCount == 1) || (!isNew! && selectedCount == 0)) return;
                          setState(() {
                            selectedCount = selectedCount! - 1;
                          });
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: (isNew! && selectedCount == 1) || (!isNew! && selectedCount == 0) || !widget.serviceModel!.isAvailable!
                            ? Colors.grey.withOpacity(0.5)
                            : config.Colors().mainColor(1),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(heightDp * 40),
                        bottomRight: Radius.circular(heightDp * 40),
                      ),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: heightDp * 30,
                      color: (isNew! && selectedCount == 1) || (!isNew! && selectedCount == 0) || !widget.serviceModel!.isAvailable!
                          ? Colors.grey.withOpacity(0.5)
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        KeicyRaisedButton(
          width: widthDp * 190,
          height: heightDp * 40,
          color: widget.serviceModel!.isAvailable! ? config.Colors().mainColor(1) : Colors.transparent,
          borderRadius: heightDp * 40,
          borderWidth: 1,
          borderColor: widget.serviceModel!.isAvailable! ? Colors.transparent : Colors.grey,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: heightDp * 25,
                color: widget.serviceModel!.isAvailable! ? Colors.white : Colors.grey,
              ),
              SizedBox(width: widthDp * 10),
              Text(
                isNew! ? "Add to Cart" : "Update Cart",
                style: TextStyle(
                  fontSize: fontSp * 14,
                  color: widget.serviceModel!.isAvailable! ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
          onPressed: !widget.serviceModel!.isAvailable!
              ? null
              : () {
                  if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin &&
                      AuthProvider.of(context).authState.userModel!.id != null) {
                    _addCartHandler();
                  } else {
                    LoginAskDialog.show(context, callback: () {
                      _initHandler();
                    });
                  }
                },
        ),
      ],
    );
  }

  Widget _additionalInfoPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _additionalInfoCategoryTab(),
        SizedBox(height: heightDp * 20),
        if (_selectedAddtionalInfoCategory == 0) _descriptionPanel(),
        if (_selectedAddtionalInfoCategory == 1) _reviewPanel(),
      ],
    );
  }

  Widget _additionalInfoCategoryTab() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedAddtionalInfoCategory = 0;
            });
          },
          child: Container(
            width: widthDp * 120,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 10),
            decoration: BoxDecoration(
              color: _selectedAddtionalInfoCategory == 0 ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.4),
              borderRadius: BorderRadius.circular(heightDp * 6.0),
            ),
            alignment: Alignment.center,
            child: Text(
              "Description",
              style: TextStyle(
                fontSize: fontSp * 16,
                color: _selectedAddtionalInfoCategory == 0 ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedAddtionalInfoCategory = 1;
            });
          },
          child: Container(
            width: widthDp * 120,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 10),
            decoration: BoxDecoration(
              color: _selectedAddtionalInfoCategory == 1 ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(heightDp * 6.0),
            ),
            alignment: Alignment.center,
            child: Text(
              "Reviews",
              style: TextStyle(
                fontSize: fontSp * 16,
                color: _selectedAddtionalInfoCategory == 1 ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _descriptionPanel() {
    return Container(
      child: Text(
        widget.serviceModel!.description == "" ? "No Description" : widget.serviceModel!.description!,
        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
      ),
    );
  }

  Widget _reviewPanel() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            !_productItemReviewProvider!.productItemReviewState.isLoadMore!
                ? SizedBox()
                : GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => ProductItemReviewPage(
                            itemData: widget.serviceModel!.toJson(),
                            type: widget.type!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: heightDp * 15),
                      color: Colors.transparent,
                      child: Text(
                        "Show all reviews",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid,
                          decorationColor: Colors.black,
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                  ),
            KeicyRaisedButton(
              width: widthDp * 150,
              height: heightDp * 30,
              borderRadius: heightDp * 6,
              color: config.Colors().mainColor(1),
              child: Text(
                _authProvider!.authState.loginState == LoginState.IsNotLogin ||
                        _productItemReviewProvider!.productItemReviewState.productItemReviewData![reviewKey].isEmpty
                    ? "Add Review"
                    : "Edit Review",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white, fontWeight: FontWeight.w500),
              ),
              onPressed: () async {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin && AuthProvider.of(context).authState.userModel!.id != null) {
                  _reviewHandler();
                } else {
                  LoginAskDialog.show(context, callback: () async {
                    if (_productItemReviewProvider!.productItemReviewState.productItemReviewData![reviewKey] == null) {
                      await _keicyProgressDialog!.show();
                      await _productItemReviewProvider!.getProductItemReview(
                        userId: _authProvider!.authState.userModel!.id,
                        itemId: widget.serviceModel!.id,
                        type: widget.type,
                      );
                      await _keicyProgressDialog!.hide();
                    }

                    _reviewHandler();
                  });
                }
              },
            ),
          ],
        ),
        SizedBox(height: heightDp * 10),

        /// top 3 review list
        Column(
          children: List.generate(
            _productItemReviewProvider!.productItemReviewState.topReviewList!.length,
            (index) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: heightDp * 20),
                    child: ReviewAndRatingWidget(
                      reviewAndRatingData: _productItemReviewProvider!.productItemReviewState.topReviewList![index],
                      isLoading: _productItemReviewProvider!.productItemReviewState.topReviewList![index].isEmpty,
                    ),
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.4))
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _reviewHandler() async {
    bool isNew = _productItemReviewProvider!.productItemReviewState.productItemReviewData![reviewKey].isEmpty;
    ReviewAndRatingDialog.show(
      context,
      _productItemReviewProvider!.productItemReviewState.productItemReviewData![reviewKey] ?? Map<String, dynamic>(),
      callback: (Map<String, dynamic> reviewAndRating) async {
        try {
          _productItemReviewProvider!.setProductItemReviewState(
            _productItemReviewProvider!.productItemReviewState.update(progressState: 1),
            isNotifiable: false,
          );
          await _keicyProgressDialog!.show();
          reviewAndRating["userId"] = _authProvider!.authState.userModel!.id;
          reviewAndRating["itemId"] = widget.serviceModel!.id;
          reviewAndRating["type"] = widget.type;
          reviewAndRating["approve"] = false;

          if (_productItemReviewProvider!.productItemReviewState.productItemReviewData![reviewKey].isEmpty) {
            await _productItemReviewProvider!.createProductItemReview(productItemReview: reviewAndRating);
          } else {
            await _productItemReviewProvider!.updateProductItemReview(productItemReview: reviewAndRating);
          }
          await _productItemReviewProvider!.getTopReviewList(
            itemId: widget.serviceModel!.id,
            type: widget.type,
          );
          _keicyProgressDialog!.hide();

          if (isNew) {
            SuccessDialog.show(
              context,
              heightDp: heightDp,
              fontSp: fontSp,
              text: "Your review is added. It will have to go through approval process. Once it's approved, you will be able to see it",
            );
          } else {
            SuccessDialog.show(
              context,
              heightDp: heightDp,
              fontSp: fontSp,
              text: "Your review is updated. It will have to go through approval process. Once it's approved, you will be able to see it",
            );
          }
        } catch (e) {
          FlutterLogs.logThis(
            tag: "service_detail_view",
            level: LogLevel.ERROR,
            subTag: "_reviewHandler",
            exception: e is Exception ? e : null,
            error: e is Error ? e : null,
            errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
          );
        }
      },
    );
  }
}
