import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/no_in_app_payments.dart';
import 'package:trapp/src/elements/bogo_list_panel_for_checkout_widget%20copy.dart';
import 'package:trapp/src/elements/cart_list_panel_for_checkout_widget.dart';
import 'package:trapp/src/elements/couponcode_panel.dart';
import 'package:trapp/src/elements/instruction_panel.dart';
import 'package:trapp/src/elements/payment_detail_panel.dart';
import 'package:trapp/src/elements/pickup_delivery_option_panel.dart';
import 'package:trapp/src/elements/promocode_panel.dart';
import 'package:trapp/src/elements/redeem_reward_point_panel.dart';
import 'package:trapp/src/elements/service_time_panel.dart';
import 'package:trapp/src/elements/tradeMantri_redeem_reward_point_panel.dart';
import 'package:trapp/src/helpers/price_functions1.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/OrderConfirmationPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class CheckoutView extends StatefulWidget {
  final OrderModel? orderModel;
  final Map<String, dynamic>? deliveryPartner;

  CheckoutView({
    Key? key,
    this.orderModel,
    this.deliveryPartner,
  }) : super(key: key);

  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
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
  OrderProvider? _orderProvider;
  DeliveryAddressProvider? _deliveryAddressProvider;
  // PromocodeProvider? _promocodeProvider;
  RewardPointProvider? _rewardPointProvider;

  KeicyProgressDialog? _keicyProgressDialog;

  GlobalKey<FormState>? _formkey;

  OrderModel? _orderModel;

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
    _orderProvider = OrderProvider.of(context);
    _deliveryAddressProvider = DeliveryAddressProvider.of(context);
    // _promocodeProvider = PromocodeProvider.of(context);
    _rewardPointProvider = RewardPointProvider.of(context);

    _orderModel = OrderModel.copy(widget.orderModel!);
    _orderModel!.id = null;

    _orderModel!.userModel = AuthProvider.of(context).authState.userModel;

    if (_orderModel!.redeemRewardData!.isEmpty) {
      _orderModel!.redeemRewardData = Map<String, dynamic>();
      _orderModel!.redeemRewardData!["sumRewardPoint"] = 0;
      _orderModel!.redeemRewardData!["redeemRewardValue"] = 0;
      _orderModel!.redeemRewardData!["redeemRewardPoint"] = 0;
      _orderModel!.redeemRewardData!["tradeSumRewardPoint"] = 0;
      _orderModel!.redeemRewardData!["tradeRedeemRewardPoint"] = 0;
      _orderModel!.redeemRewardData!["tradeRedeemRewardValue"] = 0;
    }

    /// orderDat initValue
    _orderModel!.noContactDelivery = true;
    _orderModel!.orderType = "Pickup";

    _deliveryAddressProvider!.setDeliveryAddressState(
      _deliveryAddressProvider!.deliveryAddressState.update(selectedDeliveryAddress: Map<String, dynamic>()),
      isNotifiable: false,
    );

    _orderProvider!.setOrderState(
      _orderProvider!.orderState.update(progressState: 0, newOrderModel: null),
      isNotifiable: false,
    );

    _rewardPointProvider!.setRewardPointState(_rewardPointProvider!.rewardPointState.update(progressState: 0), isNotifiable: false);

    DeliveryPartnerProvider.of(context).setDeliveryPartnerState(
      DeliveryPartnerState.init(),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      bool? result = await _checkItemsAvailableHandler();
      if (result != null && !result) return;

      _orderProvider!.addListener(_orderProviderListener);

      PromocodeProvider.of(context).getPromocodeData(category: _orderModel!.storeModel!.subType);
      _rewardPointProvider!.getRewardPoint(storeId: _orderModel!.storeModel!.id);
    });
  }

  @override
  void dispose() {
    _orderProvider!.removeListener(_orderProviderListener);
    super.dispose();
  }

  Future<bool?> _checkItemsAvailableHandler() async {
    var checkAvailableResult = await _orderModel!.checkItemsAvaialbe();

    if (checkAvailableResult.isNotEmpty && (checkAvailableResult["products"].isNotEmpty || checkAvailableResult["services"].isNotEmpty)) {
      /// new order products/services
      List<ProductOrderModel> newProducts = [];
      List<ServiceOrderModel> newServcies = [];
      for (var i = 0; i < _orderModel!.products!.length; i++) {
        if (!checkAvailableResult["products"].contains(_orderModel!.products![i].productModel!.id)) {
          _orderModel!.products![i].couponQuantity = _orderModel!.products![i].orderQuantity;
          newProducts.add(_orderModel!.products![i]);
        }
      }
      for (var i = 0; i < _orderModel!.services!.length; i++) {
        if (!checkAvailableResult["services"].contains(_orderModel!.services![i].serviceModel!.id)) {
          _orderModel!.services![i].couponQuantity = _orderModel!.services![i].orderQuantity;
          newServcies.add(_orderModel!.services![i]);
        }
      }

      /// bogo products check
      for (var i = 0; i < _orderModel!.bogoProducts!.length; i++) {
        if (!checkAvailableResult["products"].contains(_orderModel!.bogoProducts![i].productModel!.id)) {
          bool isExist = false;
          for (var i = 0; i < newProducts.length; i++) {
            if (newProducts[i].productModel!.id == _orderModel!.bogoProducts![i].productModel!.id) {
              isExist = true;
              break;
            }
          }
          if (!isExist) {
            _orderModel!.bogoProducts![i].couponQuantity = _orderModel!.bogoProducts![i].orderQuantity;
            newProducts.add(_orderModel!.bogoProducts![i]);
          }
        }
      }

      /// bogo services check
      for (var i = 0; i < _orderModel!.bogoServices!.length; i++) {
        if (!checkAvailableResult["services"].contains(_orderModel!.bogoServices![i].serviceModel!.id)) {
          bool isExist = false;
          for (var i = 0; i < newServcies.length; i++) {
            if (newServcies[i].serviceModel!.id == _orderModel!.bogoServices![i].serviceModel!.id) {
              isExist = true;
              break;
            }
          }
          if (!isExist) {
            _orderModel!.bogoServices![i].couponQuantity = _orderModel!.bogoServices![i].orderQuantity;
            newServcies.add(_orderModel!.bogoServices![i]);
          }
        }
      }
      _orderModel!.products = newProducts;
      _orderModel!.bogoProducts = [];
      _orderModel!.services = newServcies;
      _orderModel!.bogoServices = [];
      //////////////

      _orderModel!.coupon = null;
      _orderModel!.promocode = null;

      /// cart change
      if (_orderModel!.category == AppConfig.orderCategories["cart"]) {
        Map<String, dynamic> cartData = json.decode(json.encode(_cartProvider!.cartState.cartData!));
        List<dynamic> newCartProducts = [];
        List<dynamic> newCartServcies = [];
        for (var i = 0; i < cartData[_orderModel!.storeModel!.id]["products"].length; i++) {
          var product = cartData[_orderModel!.storeModel!.id]["products"][i];
          if (!checkAvailableResult["products"].contains(product["data"]["_id"])) {
            newCartProducts.add(product);
          }
        }
        for (var i = 0; i < cartData[_orderModel!.storeModel!.id]["services"].length; i++) {
          var service = cartData[_orderModel!.storeModel!.id]["services"][i];
          if (!checkAvailableResult["services"].contains(service["data"]["_id"])) {
            newCartServcies.add(service);
          }
        }
        cartData[_orderModel!.storeModel!.id]["products"] = newCartProducts;
        cartData[_orderModel!.storeModel!.id]["services"] = newCartServcies;

        if (cartData[_orderModel!.storeModel!.id]["products"].isEmpty && cartData[_orderModel!.storeModel!.id]["services"].isEmpty) {
          cartData.remove([_orderModel!.storeModel!.id!]);
          _cartProvider!.setCartState(
            _cartProvider!.cartState.update(
              cartData: cartData,
            ),
          );
          CartApiProvider.backup(
            cartData: cartData,
            lastDeviceToken: AuthProvider.of(context).authState.userModel!.fcmToken,
            userId: AuthProvider.of(context).authState.userModel!.id,
          );
          CartProvider.of(context).setCartState(
            CartProvider.of(context).cartState.update(isUpdated: false),
          );
          NormalDialog.show(
            context,
            title: "Order Products Changed",
            content: "All the products/services are unAvailable. Please choose any other products or services from the store",
            callback: () {
              Navigator.of(context).pop();
            },
          );
          return false;
        } else {
          _cartProvider!.setCartState(
            _cartProvider!.cartState.update(
              cartData: cartData,
            ),
          );
          CartApiProvider.backup(
            cartData: cartData,
            lastDeviceToken: AuthProvider.of(context).authState.userModel!.fcmToken,
            userId: AuthProvider.of(context).authState.userModel!.id,
          );
          CartProvider.of(context).setCartState(
            CartProvider.of(context).cartState.update(isUpdated: false),
          );
          NormalDialog.show(
            context,
            title: "Order Products Changed",
            content: "There are some un available products/services present in your cart. These products or services will be removed from your cart",
          );
          return true;
        }
      }
    }
    return null;
  }

  void _orderProviderListener() async {
    if (_orderProvider!.orderState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_orderProvider!.orderState.progressState == 2) {
      if (_orderModel!.category == AppConfig.orderCategories["bargain"]) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => OrderConfirmationPage(
              orderModel: _orderProvider!.orderState.newOrderModel,
            ),
          ),
        );
        Navigator.of(context).pop(true);
      } else if (_orderModel!.category == AppConfig.orderCategories["reverse_auction"]) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => OrderConfirmationPage(
              orderModel: _orderProvider!.orderState.newOrderModel,
            ),
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        _cartProvider!.removePlacedOrderdedCart(
          storeId: _orderModel!.storeModel!.id,
          userId: AuthProvider.of(context).authState.userModel!.id,
          lastDeviceToken: AuthProvider.of(context).authState.userModel!.fcmToken,
        );
        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => OrderConfirmationPage(
              orderModel: _orderProvider!.orderState.newOrderModel,
            ),
          ),
          (route) {
            if (route.settings.name == "home_page") return true;
            return false;
          },
        );
      }
    } else if (_orderProvider!.orderState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _orderProvider!.orderState.message!,
        callBack: _placeOrderHandler,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
          onPressed: () {
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

            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text("Confirm Order", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
        elevation: 0,
      ),
      body: Consumer<RewardPointProvider>(
        builder: (context, rewardPointProvider, _) {
          if (rewardPointProvider.rewardPointState.progressState == 0) {
            return Center(child: CupertinoActivityIndicator());
          }

          return NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowGlow();
              return true;
            },
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  color: Colors.transparent,
                  child: _mainPanel(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _mainPanel() {
    if (_rewardPointProvider!.rewardPointState.rewardPointData![_orderModel!.storeModel!.id] != null &&
        _rewardPointProvider!.rewardPointState.rewardPointData![_orderModel!.storeModel!.id].isNotEmpty) {
      _orderModel!.rewardPointData = _rewardPointProvider!.rewardPointState.rewardPointData![_orderModel!.storeModel!.id];
    }
    PriceFunctions1.calculateDiscount(orderModel: _orderModel);
    _orderModel!.paymentDetail = PriceFunctions1.calclatePaymentDetail(orderModel: _orderModel);

    return Column(
      children: [
        ///
        CartListPanelForCheckoutWidget(
          orderModel: _orderModel,
          refreshPageCallback: () {
            setState(() {
              // _orderModel = json.decode(json.encode(_cartProvider!.cartState.cartData![_orderModel!.storeModel!.id]));
              List<ProductOrderModel> products = [];
              List<ServiceOrderModel> services = [];
              for (var i = 0; i < _cartProvider!.cartState.cartData![_orderModel!.storeModel!.id]["products"].length; i++) {
                products.add(ProductOrderModel.fromJson(_cartProvider!.cartState.cartData![_orderModel!.storeModel!.id]["products"][i]));
              }
              for (var i = 0; i < _cartProvider!.cartState.cartData![_orderModel!.storeModel!.id]["services"].length; i++) {
                services.add(ServiceOrderModel.fromJson(_cartProvider!.cartState.cartData![_orderModel!.storeModel!.id]["services"][i]));
              }
              _orderModel!.products = products;
              _orderModel!.services = services;
              widget.orderModel!.products = products;
              widget.orderModel!.services = services;

              /////  promocode, delivery info init
              _deliveryAddressProvider!.setDeliveryAddressState(
                _deliveryAddressProvider!.deliveryAddressState.update(
                  maxDeliveryDistance: 0,
                  selectedDeliveryAddress: Map<String, dynamic>(),
                ),
                isNotifiable: false,
              );

              _orderModel!.deliveryPartnerDetails = Map<String, dynamic>();
              _orderModel!.deliveryAddress = null;
              _orderModel!.promocode = null;
              _orderModel!.paymentDetail = null;
            });
          },
        ),
        if (_orderModel!.bogoProducts!.isNotEmpty || _orderModel!.bogoServices!.isNotEmpty)
          Column(
            children: [
              Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
              BOGOListPanelForCheckoutWidget(
                orderModel: _orderModel,
              ),
            ],
          ),

        ///
        Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
        InstructionPanel(
          orderModel: _orderModel,
          callback: (formkey) => _formkey = formkey,
        ),

        ///
        Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
        PromocodePanel(
          orderModel: _orderModel,
          refreshCallback: () {
            setState(() {});
          },
        ),

        ///
        Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
        CouponPanel(
          orderModel: _orderModel,
          refreshCallback: () {
            setState(() {});
          },
        ),

        ///
        Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
        TradeMantriRedeemRewardPointPanel(
          orderModel: _orderModel,
          refreshCallback: () {
            setState(() {});
          },
        ),

        ///
        Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
        RedeemRewardPointPanel(
          orderModel: _orderModel,
          refreshCallback: () {
            setState(() {});
          },
        ),

        ///
        if (_orderModel!.products!.isNotEmpty)
          Column(
            children: [
              Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
              PickupDeliveryOptionPanel(
                orderModel: _orderModel,
                deliveryPartner: widget.deliveryPartner,
                checkMinAmount: true,
                pickupCallback: () {
                  setState(() {
                    _orderModel!.orderType = "Pickup";
                    _orderModel!.payAtStore = false;
                    _orderModel!.cashOnDelivery = false;
                    _orderModel!.pickupDateTime = null;
                    _orderModel!.deliveryAddress = null;
                    _orderModel!.deliveryPartnerDetails = Map<String, dynamic>();
                    _orderModel!.paymentDetail!.tip = 0;
                    _deliveryAddressProvider!.setDeliveryAddressState(
                      _deliveryAddressProvider!.deliveryAddressState.update(selectedDeliveryAddress: Map<String, dynamic>()),
                      isNotifiable: false,
                    );

                    if (_orderModel!.promocode != null && _orderModel!.promocode!.promocodeType == "Delivery") {
                      _orderModel!.promocode = null;
                    }
                  });
                },
                deliveryCallback: () {
                  setState(() {
                    _orderModel!.orderType = "Delivery";
                    _orderModel!.payAtStore = false;
                    _orderModel!.cashOnDelivery = false;
                    _orderModel!.pickupDateTime = null;
                    _orderModel!.deliveryAddress = null;
                    _orderModel!.deliveryPartnerDetails = Map<String, dynamic>();
                    _orderModel!.paymentDetail!.tip = 0;
                    _deliveryAddressProvider!.setDeliveryAddressState(
                      _deliveryAddressProvider!.deliveryAddressState.update(selectedDeliveryAddress: Map<String, dynamic>()),
                      isNotifiable: false,
                    );
                  });
                },
                refreshCallback: () {
                  setState(() {});
                },
              ),
            ],
          ),

        ///
        if (_orderModel!.services!.isNotEmpty)
          Column(
            children: [
              Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
              ServiceTimePanel(
                orderModel: _orderModel,
                refreshCallback: () {
                  setState(() {});
                },
              ),
            ],
          ),

        ///
        Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
        PaymentDetailPanel(orderModel: _orderModel),

        ///
        Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
        SizedBox(height: heightDp * 20),
        _placeOrderButton(),
        SizedBox(height: heightDp * 20),
      ],
    );
  }

  Widget _placeOrderButton() {
    return Consumer<DeliveryAddressProvider>(builder: (context, deliveryAddressProvider, _) {
      // if (_deliveryAddressProvider!.deliveryAddressState.selectedDeliveryAddress != null &&
      //     _deliveryAddressProvider!.deliveryAddressState.selectedDeliveryAddress!.isNotEmpty) {
      //   _orderModel!.deliveryAddress = DeliveryAddressModel.fromJson(_deliveryAddressProvider!.deliveryAddressState.selectedDeliveryAddress!);
      // } else {
      //   _orderModel!.deliveryAddress = null;
      // }

      bool isEnable = true;
      bool showMinAmountMessage = false;

      if (_orderModel!.couponVaidate != null) {
        isEnable = _orderModel!.couponVaidate!;
      }

      if (_orderModel!.products != null && _orderModel!.products!.isNotEmpty) {
        if (_orderModel!.orderType == "Pickup") {
          if (_orderModel!.pickupDateTime == null) {
            isEnable = false;
          }
        } else {
          if (_orderModel!.deliveryAddress == null) {
            isEnable = false;
          }
        }
      }

      if (_orderModel!.services != null && _orderModel!.services!.isNotEmpty) {
        if (_orderModel!.serviceDateTime == null) {
          isEnable = false;
        }
      }

      if ((_orderModel!.services == null || _orderModel!.services!.isEmpty) && (_orderModel!.products == null || _orderModel!.products!.isEmpty)) {
        isEnable = false;
      }

      double finalToPay = (_orderModel!.paymentDetail!.toPay! - (_orderModel!.redeemRewardData!["redeemRewardValue"] ?? 0)) -
          (_orderModel!.redeemRewardData!["tradeRedeemRewardValue"] ?? 0);

      if (finalToPay < 1) {
        isEnable = false;
        showMinAmountMessage = true;
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: !isEnable ? null : _warnStoreAvailability,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(heightDp * 8),
                color: isEnable ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.4),
              ),
              child: Text(
                "Place order ₹ ${finalToPay.toString()}",
                style: TextStyle(fontSize: fontSp * 16, color: isEnable ? Colors.white : Colors.black),
              ),
            ),
          ),
          if (showMinAmountMessage)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Center(
                child: Text(
                  "To Pay shoudn't be less than 1, please adjust in reward points redeem section.",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  bool? _storeAvailability() {
    bool? openStatus;

    try {
      if (_orderModel!.storeModel!.profile!["holidays"] == null || _orderModel!.storeModel!.profile!["holidays"].isEmpty) {
        openStatus = null;
      } else {
        for (var i = 0; i < _orderModel!.storeModel!.profile!["holidays"].length; i++) {
          DateTime holiday = DateTime.tryParse(_orderModel!.storeModel!.profile!["holidays"][i])!.toLocal();

          if (holiday.year == DateTime.now().year && holiday.month == DateTime.now().month && holiday.day == DateTime.now().day) {
            openStatus = false;

            break;
          }
        }
      }
    } catch (e) {
      openStatus = null;
    }

    try {
      if (openStatus == null && (_orderModel!.storeModel!.profile!["hours"] == null || _orderModel!.storeModel!.profile!["hours"].isEmpty)) {
        openStatus = null;
      } else {
        var selectedHoursData;

        for (var i = 0; i < _orderModel!.storeModel!.profile!["hours"].length; i++) {
          var hoursData = _orderModel!.storeModel!.profile!["hours"][i];

          if (hoursData["day"].toString().toLowerCase() == "monday" && DateTime.now().weekday == DateTime.monday) {
            selectedHoursData = hoursData;
          } else if (hoursData["day"].toString().toLowerCase() == "tuesday" && DateTime.now().weekday == DateTime.tuesday) {
            selectedHoursData = hoursData;
          } else if (hoursData["day"].toString().toLowerCase() == "wednesday" && DateTime.now().weekday == DateTime.wednesday) {
            selectedHoursData = hoursData;
          } else if (hoursData["day"].toString().toLowerCase() == "thursday" && DateTime.now().weekday == DateTime.thursday) {
            selectedHoursData = hoursData;
          } else if (hoursData["day"].toString().toLowerCase() == "friday" && DateTime.now().weekday == DateTime.friday) {
            selectedHoursData = hoursData;
          } else if (hoursData["day"].toString().toLowerCase() == "saturday" && DateTime.now().weekday == DateTime.saturday) {
            selectedHoursData = hoursData;
          } else if (hoursData["day"].toString().toLowerCase() == "sunday" && DateTime.now().weekday == DateTime.sunday) {
            selectedHoursData = hoursData;
          }
        }

        if (selectedHoursData["isWorkingDay"]) {
          DateTime openTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            DateTime.tryParse(selectedHoursData["openingTime"])!.toLocal().hour,
            DateTime.tryParse(selectedHoursData["openingTime"])!.toLocal().minute,
          );

          DateTime closeTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            DateTime.tryParse(selectedHoursData["closingTime"])!.toLocal().hour,
            DateTime.tryParse(selectedHoursData["closingTime"])!.toLocal().minute,
          );

          if (DateTime.now().isAfter(openTime) && DateTime.now().isBefore(closeTime)) {
            openStatus = true;
          } else {
            openStatus = false;
          }
        } else {
          openStatus = false;
        }
      }
    } catch (e) {
      openStatus = null;
    }

    return openStatus;
  }

  _warnStoreAvailability() async {
    bool? storeAvailability = _storeAvailability();

    if (storeAvailability != null && storeAvailability == false) {
      StoreClosedDialog.show(context, cancelCallback: () {}, proceedCallback: () {
        _placeOrderHandler();
      });

      return;
    }

    return _placeOrderHandler();
  }

  void _placeOrderHandler() async {
    // if (_orderModel!.orderType == "Pickup" && !_orderModel!.payAtStore!) {
    //   await NoInAppPaymentDialog.show(context, proceedCallback: () {});
    //   return;
    // }

    // if (_orderModel!.orderType == "Delivery" && !_orderModel!.cashOnDelivery!) {
    //   await NoInAppPaymentDialog.show(context, proceedCallback: () {});
    //   return;
    // }
    if (!_formkey!.currentState!.validate()) return;
    _formkey!.currentState!.save();

    if (_orderProvider!.orderState.progressState == 1) return;
    _orderProvider!.setOrderState(_orderProvider!.orderState.update(progressState: 1));
    await _keicyProgressDialog!.show();

    String categoryDesc = "";
    List<dynamic> _categories;
    _categories = _orderModel!.storeModel!.businessType == "store"
        ? CategoryProvider.of(context).categoryState.categoryData!["store"]
        : CategoryProvider.of(context).categoryState.categoryData!["services"];

    for (var i = 0; i < _categories.length; i++) {
      if (_categories[i]["categoryId"] == _orderModel!.storeModel!.subType) {
        categoryDesc = _categories[i]["categoryDesc"];
        break;
      }
    }

    _orderModel!.storeCategoryId = _orderModel!.storeModel!.subType;
    _orderModel!.storeCategoryDesc = categoryDesc;
    _orderModel!.storeLocation = _orderModel!.storeModel!.location!;
    _orderModel!.deliveryDetail = {
      "ongoing": false,
      "assignedDeliveryUserId": "",
      "status": "",
    };

    String status = "";

    if (_orderModel!.category == AppConfig.orderCategories["cart"]) {
      status = AppConfig.orderStatusData[1]["id"];
    }
    if (_orderModel!.category == AppConfig.orderCategories["assistant"]) {
      status = AppConfig.orderStatusData[1]["id"];
    }
    if (_orderModel!.category == AppConfig.orderCategories["reverse_auction"]) {
      status = AppConfig.orderStatusData[2]["id"];
    }
    if (_orderModel!.category == AppConfig.orderCategories["bargain"]) {
      status = AppConfig.orderStatusData[2]["id"];
    }

    var result = await _checkItemsAvailableHandler();
    if (result != null) {
      await _keicyProgressDialog!.hide();
      return;
    }

    _orderProvider!.addOrder(
      orderModel: _orderModel,
      category: _orderModel!.category,
      status: status,
    );
  }
}
