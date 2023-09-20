import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/delivery_partner_api_provider.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/instruction_panel.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/pickup_delivery_option_panel.dart';
import 'package:trapp/src/elements/promocode_panel.dart';
import 'package:trapp/src/elements/service_time_panel.dart';
import 'package:trapp/src/helpers/price_functions.dart';
import 'package:trapp/src/helpers/price_functions1.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/models/store_model.dart';
import 'package:trapp/src/pages/CheckOutPage/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/src/pages/OrderConfirmationPage/index.dart';
import 'package:trapp/src/pages/SearchPage/index.dart';
import 'package:trapp/src/pages/LoginAskPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class OrderAssistantView extends StatefulWidget {
  final OrderModel? orderModel;
  final Map<String, dynamic>? selectedStoreData;
  final bool haveAppBar;
  final bool haveProducts;
  final bool haveServices;

  OrderAssistantView({
    Key? key,
    this.orderModel,
    this.selectedStoreData,
    this.haveAppBar = true,
    this.haveProducts = true,
    this.haveServices = true,
  }) : super(key: key);

  @override
  _OrderAssistantViewState createState() => _OrderAssistantViewState();
}

class _OrderAssistantViewState extends State<OrderAssistantView> {
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

  DeliveryAddressProvider? _deliveryAddressProvider;
  OrderProvider? _orderProvider;
  PromocodeProvider? _promocodeProvider;
  CategoryProvider? _categoryProvider;

  AppDataProvider? _appDataProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  OrderModel? _orderModel;

  GlobalKey<FormState>? _formkey;
  SharedPreferences? _preferences;

  Map<String, dynamic> _selectedStoreData = Map<String, dynamic>();

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

    _deliveryAddressProvider = DeliveryAddressProvider.of(context);
    _orderProvider = OrderProvider.of(context);
    _appDataProvider = AppDataProvider.of(context);
    _promocodeProvider = PromocodeProvider.of(context);
    _categoryProvider = CategoryProvider.of(context);

    _orderModel = widget.orderModel != null ? OrderModel.copy(widget.orderModel!) : OrderModel();

    /// orderDat initValue
    if (widget.orderModel != null) _orderModel!.storeModel = widget.orderModel!.storeModel;
    _orderModel!.userModel = AuthProvider.of(context).authState.userModel;
    _orderModel!.noContactDelivery = true;
    _orderModel!.orderType = "Pickup";

    if (_orderModel!.redeemRewardData!.isEmpty) {
      _orderModel!.redeemRewardData = Map<String, dynamic>();
      _orderModel!.redeemRewardData!["sumRewardPoint"] = 0;
      _orderModel!.redeemRewardData!["redeemRewardValue"] = 0;
      _orderModel!.redeemRewardData!["redeemRewardPoint"] = 0;
      _orderModel!.redeemRewardData!["tradeSumRewardPoint"] = 0;
      _orderModel!.redeemRewardData!["tradeRedeemRewardPoint"] = 0;
      _orderModel!.redeemRewardData!["tradeRedeemRewardValue"] = 0;
    }

    _selectedStoreData = widget.selectedStoreData!;

    _deliveryAddressProvider!.setDeliveryAddressState(
      _deliveryAddressProvider!.deliveryAddressState.update(selectedDeliveryAddress: Map<String, dynamic>()),
      isNotifiable: false,
    );

    _orderProvider!.setOrderState(
      _orderProvider!.orderState.update(progressState: 0, newOrderModel: null),
      isNotifiable: false,
    );

    _promocodeProvider!.setPromocodeState(
      _promocodeProvider!.promocodeState.update(progressState: 0),
      isNotifiable: false,
    );

    SharedPreferences.getInstance().then((value) => _preferences = value);

    DeliveryPartnerProvider.of(context).setDeliveryPartnerState(
      DeliveryPartnerState.init(),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _orderProvider!.addListener(_orderProviderListener);

      if (_orderModel!.storeModel != null) {
        _promocodeProvider!.getPromocodeData(category: _orderModel!.storeModel!.subType);
        getAssistantOnLocal();
      }
      if (_categoryProvider!.categoryState.progressState != 2) {
        _categoryProvider!.getCategoryAll();
      }
    });
  }

  @override
  void dispose() {
    _orderProvider!.removeListener(_orderProviderListener);
    storeAssistantOnLocal();
    super.dispose();
  }

  void storeAssistantOnLocal() async {
    if (_preferences == null) _preferences = await SharedPreferences.getInstance();
    if (_selectedStoreData["categoryId"] != null && _orderModel!.storeModel != null) {
      // bool haveProduct = _orderModel!.products!.isNotEmpty;
      // bool haveService = _orderModel!.services!.isNotEmpty;

      List<dynamic> productOrderData = [];
      for (var i = 0; i < _orderModel!.products!.length; i++) {
        if (_orderModel!.products![i].productModel!.name != null && _orderModel!.products![i].productModel!.name != "") {
          productOrderData.add(_orderModel!.products![i].toJson());
        }
      }

      List<dynamic> serviceOrderData = [];
      for (var i = 0; i < _orderModel!.services!.length; i++) {
        if (_orderModel!.services![i].serviceModel!.name != null && _orderModel!.services![i].serviceModel!.name != "") {
          serviceOrderData.add(_orderModel!.services![i].toJson());
        }
      }

      bool haveProduct = productOrderData.isNotEmpty;
      bool haveService = serviceOrderData.isNotEmpty;

      _selectedStoreData["products"] = productOrderData;
      _selectedStoreData["services"] = serviceOrderData;
      _selectedStoreData["store"] = _orderModel!.storeModel!.toJson();

      if (haveProduct || haveService) {
        _preferences!.setString(
          "Assistant-Order_${_orderModel!.storeModel!.id}",
          json.encode(_selectedStoreData),
        );
      } else {
        _preferences!.setString(
          "Assistant-Order_${_orderModel!.storeModel!.id}",
          json.encode(null),
        );
      }
    }
  }

  void getAssistantOnLocal() async {
    if (_preferences == null) _preferences = await SharedPreferences.getInstance();
    if (_orderModel!.storeModel != null) {
      var result = _preferences!.getString("Assistant-Order_${_orderModel!.storeModel!.id}");
      if (result != null && result.toString().toLowerCase() != "null") {
        // _selectedStoreData = json.decode(result);

        // if (_selectedStoreData["products"].length == 1 && _selectedStoreData["products"][0]['data']["id"] == null) {
        //   setState(() {});

        //   return;
        // }

        // if (_selectedStoreData["services"].length == 1 && _selectedStoreData["services"][0]['data']["id"] == null) {
        //   setState(() {});

        //   return;
        // }

        var isLoad = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: Text(
                "you have previous items with the same store you added.  Do you want to populate previous items",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          },
        );

        if (isLoad != null && isLoad) {
          _selectedStoreData = json.decode(result);

          List<ProductOrderModel> productOrderModels = [];
          for (var i = 0; i < _selectedStoreData["products"].length; i++) {
            productOrderModels.add(ProductOrderModel.fromJson(_selectedStoreData["products"][i]));
          }

          List<ServiceOrderModel> serviceOrderModels = [];
          for (var i = 0; i < _selectedStoreData["services"].length; i++) {
            serviceOrderModels.add(ServiceOrderModel.fromJson(_selectedStoreData["services"][i]));
          }

          _orderModel!.storeModel = StoreModel.fromJson(_selectedStoreData["store"]);
          _orderModel!.userModel = AuthProvider.of(context).authState.userModel;
          _orderModel!.paymentDetail = PaymentDetailModel();
          _orderModel!.noContactDelivery = true;
          _orderModel!.orderType = "Pickup";

          _orderModel!.products = productOrderModels;
          _orderModel!.services = serviceOrderModels;
        } else {
          _orderModel!.userModel = AuthProvider.of(context).authState.userModel;
          _orderModel!.products = [];
          _orderModel!.services = [];
          _orderModel!.paymentDetail = PaymentDetailModel();
          _orderModel!.noContactDelivery = true;
          _orderModel!.orderType = "Pickup";

          if (_orderModel!.storeModel!.type == "Retailer" || _orderModel!.storeModel!.type == "Wholesaler") {
            _orderModel!.products = [
              ProductOrderModel(
                orderQuantity: 1,
                couponQuantity: 1,
                productModel: ProductModel(name: ""),
              ),
            ];
            _orderModel!.services = [];
          } else {
            _orderModel!.products = [];
            _orderModel!.services = [
              ServiceOrderModel(
                orderQuantity: 1,
                couponQuantity: 1,
                serviceModel: ServiceModel(name: ""),
              ),
            ];
          }
        }
      } else {
        _orderModel!.userModel = AuthProvider.of(context).authState.userModel;
        _orderModel!.products = [];
        _orderModel!.services = [];
        _orderModel!.paymentDetail = PaymentDetailModel();
        _orderModel!.noContactDelivery = true;
        _orderModel!.orderType = "Pickup";

        if (_orderModel!.storeModel!.type == "Retailer" || _orderModel!.storeModel!.type == "Wholesaler") {
          _orderModel!.products = [
            ProductOrderModel(
              orderQuantity: 1,
              couponQuantity: 1,
              productModel: ProductModel(name: ""),
            ),
          ];
          _orderModel!.services = [];
        } else {
          _orderModel!.products = [];
          _orderModel!.services = [
            ServiceOrderModel(
              orderQuantity: 1,
              couponQuantity: 1,
              serviceModel: ServiceModel(name: ""),
            ),
          ];
        }
      }
    }
    setState(() {});
  }

  void _orderProviderListener() async {
    if (_orderProvider!.orderState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_orderProvider!.orderState.progressState == 2) {
      OrderModel newOrderModel = _orderProvider!.orderState.newOrderModel!;
      newOrderModel.storeModel = _orderModel!.storeModel;
      _preferences!.setString(
        "Assistant-Order_${newOrderModel.storeModel!.id}",
        "null",
      );

      _orderModel = OrderModel();
      _orderModel!.noContactDelivery = true;
      _orderModel!.orderType = "Pickup";
      setState(() {});

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => OrderConfirmationPage(
            orderModel: newOrderModel,
          ),
        ),
        (route) {
          if (route.settings.name == "home_page") return true;
          return false;
        },
      );
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
    return Scaffold(
      appBar: !widget.haveAppBar
          ? null
          : AppBar(
              centerTitle: true,
              title: Text("Assistant Order", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
              elevation: 0,
            ),
      body: AuthProvider.of(context).authState.userModel!.id == null
          ? LoginAskPage(
              callback: () => Navigator.of(context).pushNamed('/Pages', arguments: {"currentTab": 0}),
            )
          : _mainPanel(),
    );
  }

  Widget _mainPanel() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 5,
                  child: Container(
                    child: Image.asset(
                      "img/assistant_store.png",
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),

              ///
              SizedBox(height: heightDp * 40),
              _categoryPanel(),

              ///
              Divider(height: heightDp * 40, thickness: 3, color: Colors.black.withOpacity(0.1)),
              _storePanel(),

              ///
              if (_orderModel!.storeModel != null) Divider(height: heightDp * 40, thickness: 3, color: Colors.black.withOpacity(0.1)),
              if (_orderModel!.storeModel != null && (_orderModel!.storeModel!.type == "Retailer" || _orderModel!.storeModel!.type == "Wholesaler"))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _productsItemsPanel(),
                    Column(
                      children: [
                        SizedBox(height: heightDp * 30),
                        _serviceItemsPanel(),
                      ],
                    ),
                  ],
                ),
              if (_orderModel!.storeModel != null && _orderModel!.storeModel!.type == "Service")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _serviceItemsPanel(),
                    // SizedBox(height: heightDp * 30),
                    Column(
                      children: [
                        SizedBox(height: heightDp * 30),
                        _productsItemsPanel(),
                      ],
                    ),
                  ],
                ),

              ///
              if (_orderModel!.storeModel != null)
                Column(
                  children: [
                    SizedBox(height: heightDp * 15),
                    Divider(height: heightDp * 15, thickness: 3, color: Colors.black.withOpacity(0.1)),
                    InstructionPanel(
                      orderModel: _orderModel,
                      callback: (formkey) {
                        _formkey = formkey;
                      },
                    ),
                  ],
                ),

              ///
              // if (_orderModel!.storeModel != null) _promoCodePanel(),

              ///
              ///
              _travelPanel(),

              ///
              if (_orderModel!.storeModel != null && _orderModel!.services!.isNotEmpty)
                Column(
                  children: [
                    Divider(height: heightDp * 15, thickness: 3, color: Colors.black.withOpacity(0.1)),
                    ServiceTimePanel(
                      orderModel: _orderModel,
                      refreshCallback: () {
                        setState(() {});
                      },
                    ),
                  ],
                ),

              ///
              if (_orderModel!.storeModel != null)
                Column(
                  children: [
                    SizedBox(height: heightDp * 20),
                    _placeOrderButton(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _travelPanel() {
    if (_orderModel!.storeModel != null && _orderModel!.products!.isNotEmpty) {
      if (_orderModel!.storeModel!.deliveryInfo != null &&
          _orderModel!.storeModel!.deliveryInfo!.mode == "DELIVERY_BY_PARTNER" &&
          _orderModel!.storeModel!.deliveryInfo!.deliveryPartnerId != null) {
        return StreamBuilder<dynamic>(
          stream: Stream.fromFuture(DeliveryPartnerApiProvider.getDeliveryPartner(id: _orderModel!.storeModel!.deliveryInfo!.deliveryPartnerId)),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(body: Center(child: CupertinoActivityIndicator()));
            }

            if (!snapshot.data["success"]) {
              return ErrorPage(
                message: snapshot.data["message"],
                callback: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => CheckoutPage(
                        orderModel: _orderModel,
                      ),
                    ),
                  );
                },
              );
            }

            return _pickupDeliveryProxy(deliveryPartner: snapshot.data["data"]);
          },
        );
      }

      return _pickupDeliveryProxy();
    }

    return Container();
  }

  Widget _pickupDeliveryProxy({Map<String, dynamic>? deliveryPartner}) {
    return Column(
      children: [
        Divider(height: heightDp * 15, thickness: 3, color: Colors.black.withOpacity(0.1)),
        PickupDeliveryOptionPanel(
          orderModel: _orderModel,
          deliveryPartner: deliveryPartner,
          isReadOnly: _orderModel!.storeModel == null,
          checkMinAmount: false,
          pickupCallback: () {
            setState(() {
              _orderModel!.orderType = "Pickup";
              _orderModel!.payAtStore = false;
              _orderModel!.cashOnDelivery = false;
              _orderModel!.pickupDateTime = null;
              _orderModel!.deliveryAddress = null;
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
    );
  }

  Widget _categoryPanel() {
    List<dynamic> _categories;

    String categoryDesc = "";

    if (_selectedStoreData["categoryId"] != null) {
      _categories = _selectedStoreData["businessType"] == "store"
          ? _categoryProvider!.categoryState.categoryData!["store"]
          : _categoryProvider!.categoryState.categoryData!["services"];

      for (var i = 0; i < _categories.length; i++) {
        if (_categories[i]["categoryId"] == _selectedStoreData["categoryId"]) {
          categoryDesc = _categories[i]["categoryDesc"];
          break;
        }
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose Category",
            style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: heightDp * 10),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.zero,
                    titlePadding: EdgeInsets.zero,
                    contentPadding: EdgeInsets.zero,
                    elevation: 0,
                    children: [
                      CategoryBottomSheet(
                        categoryId: _selectedStoreData["categoryId"],
                        callback: (categoryId, businessType) {
                          if (_selectedStoreData["categoryId"] != categoryId) {
                            setState(() {
                              _selectedStoreData = Map<String, dynamic>();
                              _selectedStoreData["categoryId"] = categoryId;
                              _selectedStoreData["businessType"] = businessType;
                              _orderModel!.storeModel = null;

                              // _deliveryPartnerProvider.setDeliveryPartnerState(
                              //   DeliveryPartnerState.init(),
                              //   isNotifiable: false,
                              // );

                              _deliveryAddressProvider!.setDeliveryAddressState(
                                _deliveryAddressProvider!.deliveryAddressState.update(
                                  selectedDeliveryAddress: Map<String, dynamic>(),
                                ),
                                isNotifiable: false,
                              );
                            });
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
              decoration: BoxDecoration(color: Color(0xFFECECEC), borderRadius: BorderRadius.circular(heightDp * 4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedStoreData["categoryId"] == null ? "Please choose category" : categoryDesc,
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: _selectedStoreData["categoryId"] == null ? Colors.black.withOpacity(0.5) : Colors.black,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: heightDp * 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _storePanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Store/Pickup Address",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: heightDp * 10),
          GestureDetector(
            onTap: () async {
              if (_selectedStoreData["categoryId"] == null) return;
              Map<String, dynamic> categoryData = Map<String, dynamic>();
              for (var i = 0; i < _appDataProvider!.appDataState.categoryList!.length; i++) {
                if (_appDataProvider!.appDataState.categoryList![i]["categoryId"] == _selectedStoreData["categoryId"]) {
                  categoryData = _appDataProvider!.appDataState.categoryList![i];
                }
              }
              var result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SearchPage(
                    categoryData: categoryData,
                    forSelection: true,
                    onlyStore: true,
                  ),
                ),
              );

              if (result != null) {
                if (_orderModel!.storeModel != null && _orderModel!.storeModel!.id == result["_id"]) return;

                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                  _orderModel!.storeModel = StoreModel.fromJson(result);

                  getAssistantOnLocal();

                  _deliveryAddressProvider!.setDeliveryAddressState(
                    _deliveryAddressProvider!.deliveryAddressState.update(
                      selectedDeliveryAddress: Map<String, dynamic>(),
                    ),
                    isNotifiable: false,
                  );

                  _promocodeProvider!.getPromocodeData(category: _orderModel!.storeModel!.subType);

                  // _deliveryPartnerProvider.setDeliveryPartnerState(
                  //   _deliveryPartnerProvider.deliveryPartnerState.update(
                  //     progressState: 1,
                  //     deliveryPartnerData: [],
                  //   ),
                  //   isNotifiable: false,
                  // );

                  // _deliveryPartnerProvider.getDeliveryPartnerData(
                  //   zipCode: _orderModel!.storeModel["zipCode"],
                  // );
                });
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
              decoration: BoxDecoration(color: Color(0xFFECECEC), borderRadius: BorderRadius.circular(heightDp * 4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _orderModel!.storeModel == null ? "Please choose store" : _orderModel!.storeModel!.name!,
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: _orderModel!.storeModel == null ? Colors.black.withOpacity(0.5) : Colors.black,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: heightDp * 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productsItemsPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: _orderModel!.storeModel != null && _orderModel!.products == []
          ? GestureDetector(
              onTap: () {
                if (_orderModel!.storeModel == null) return;
                _orderModel!.products = [];
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Do you want any products from this store?",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 2),
                    decoration: BoxDecoration(
                      color: _orderModel!.storeModel != null ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                    ),
                    child: Text(
                      "+",
                      style: TextStyle(fontSize: fontSp * 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Make a product order list",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: heightDp * 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                  decoration: BoxDecoration(color: Color(0xFFECECEC), borderRadius: BorderRadius.circular(heightDp * 4)),
                  child: Column(
                    children: List.generate(_orderModel!.products!.length + 1, (index) {
                      ProductOrderModel? productOrderModel = _orderModel!.products!.length == index ? null : _orderModel!.products![index];

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: heightDp * 8),
                        child: NewItemWidget(
                          storeId: _orderModel!.storeModel != null ? _orderModel!.storeModel!.id : "",
                          category: "products",
                          isReadOnly: _orderModel!.storeModel == null,
                          itemData: productOrderModel != null ? productOrderModel.toJson() : null,
                          index: index,
                          length: _orderModel!.products!.length,
                          callback: (data, {bool isNew = false}) {
                            if (_orderModel!.storeModel == null) return;
                            if (_orderModel!.products == null) _orderModel!.products = [];
                            if (isNew) {
                              _orderModel!.products!.add(
                                ProductOrderModel(
                                  orderQuantity: 1,
                                  couponQuantity: 1,
                                  productModel: ProductModel(name: ""),
                                ),
                              );
                              setState(() {});
                              return;
                            }
                            if (productOrderModel == null) return;
                            _orderModel!.products![index] = ProductOrderModel.fromJson(data);
                            setState(() {});
                          },
                          deleteCallback: (index) {
                            _orderModel!.products!.removeAt(index);
                            setState(() {});
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _serviceItemsPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: _orderModel!.services == null
          ? GestureDetector(
              onTap: () {
                if (_orderModel!.storeModel == null) return;
                _orderModel!.services = [];
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Do you want any services from this store?",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 2),
                    color: _orderModel!.storeModel != null ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                    child: Text(
                      "+",
                      style: TextStyle(fontSize: fontSp * 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Make a service order list",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: heightDp * 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                  decoration: BoxDecoration(color: Color(0xFFECECEC), borderRadius: BorderRadius.circular(heightDp * 4)),
                  child: Column(
                    children: List.generate(_orderModel!.services!.length + 1, (index) {
                      ServiceOrderModel? serviceOrderModel = _orderModel!.services!.length == index ? null : _orderModel!.services![index];

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: heightDp * 8),
                        child: NewItemWidget(
                          storeId: _orderModel!.storeModel != null ? _orderModel!.storeModel!.id : "",
                          category: "services",
                          isReadOnly: _orderModel!.storeModel == null,
                          itemData: serviceOrderModel != null ? serviceOrderModel.toJson() : null,
                          index: index,
                          length: _orderModel!.services!.length,
                          callback: (data, {bool isNew = false}) {
                            if (_orderModel!.storeModel == null) return;
                            if (_orderModel!.services == null) _orderModel!.services = [];
                            if (isNew) {
                              _orderModel!.services!.add(
                                ServiceOrderModel(
                                  orderQuantity: 1,
                                  couponQuantity: 1,
                                  serviceModel: ServiceModel(name: ""),
                                ),
                              );
                              setState(() {});
                              return;
                            }
                            if (serviceOrderModel == null) return;
                            _orderModel!.services![index] = ServiceOrderModel.fromJson(data);
                            setState(() {});
                          },
                          deleteCallback: (index) {
                            _orderModel!.services!.removeAt(index);
                            setState(() {});
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _promoCodePanel() {
    return Consumer<PromocodeProvider>(builder: (context, promocodeProvider, _) {
      if (promocodeProvider.promocodeState.progressState == 0 || promocodeProvider.promocodeState.progressState == 1) {
        return SizedBox();
      }
      return Column(
        children: [
          Divider(height: heightDp * 15, thickness: 3, color: Colors.black.withOpacity(0.1)),
          PromocodePanel(
            orderModel: _orderModel,
            isReadOnly: _orderModel!.storeModel == null,
            typeList: ["Delivery"],
            isForAssistant: true,
            refreshCallback: () {
              setState(() {});
            },
          ),
        ],
      );
    });
  }

  Widget _placeOrderButton() {
    return Consumer2<DeliveryAddressProvider, DeliveryPartnerProvider>(builder: (context, deliveryAddressProvider, deliveryPartnerProvider, _) {
      // if (_deliveryAddressProvider!.deliveryAddressState.selectedDeliveryAddress != null &&
      //     _deliveryAddressProvider!.deliveryAddressState.selectedDeliveryAddress.isNotEmpty) {
      //   _orderModel!.deliveryAddress = _deliveryAddressProvider!.deliveryAddressState.selectedDeliveryAddress;
      // } else {
      //   _orderModel!.deliveryAddress = Map<String, dynamic>();
      // }

      bool isEnable = _orderModel!.storeModel != null;

      if (_orderModel!.products!.isNotEmpty) {
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

      if (_orderModel!.services!.isNotEmpty) {
        if (_orderModel!.serviceDateTime == null) {
          isEnable = false;
        }
      }

      if (_orderModel!.products!.length == 0 && _orderModel!.services!.length == 0) {
        isEnable = false;
      }

      return Container(
        color: Colors.grey.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      // "Pay after once store person confirms the items available at store",
                      "Pay after store representative confirms the items or service is available",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    ),
                  ),
                  SizedBox(width: widthDp * 30),
                  KeicyRaisedButton(
                    width: widthDp * 140,
                    height: heightDp * 40,
                    borderRadius: heightDp * 40,
                    color: isEnable ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.4),
                    child: Text(
                      "Place Order",
                      style: TextStyle(fontSize: fontSp * 13, color: isEnable ? Colors.white : Colors.black),
                    ),
                    onPressed: isEnable ? _warnStoreAvailability : null,
                  ),
                ],
              ),
            ],
          ),
        ),
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
    if (_keicyProgressDialog == null) _keicyProgressDialog = KeicyProgressDialog.of(context);
    if (!_formkey!.currentState!.validate()) return;
    _formkey!.currentState!.save();

    /////////////////

    bool isEmpty = false;
    int count = 0;
    for (var i = 0; i < _orderModel!.products!.length; i++) {
      if (_orderModel!.products![i].productModel!.name == "") {
        isEmpty = true;
        count++;
      }
    }

    for (var i = 0; i < _orderModel!.services!.length; i++) {
      if (_orderModel!.services![i].serviceModel!.name == "") {
        isEmpty = true;
        count++;
      }
    }

    if (isEmpty == true) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "You didn't enter $count product / service names, please enter names to place order",
        callBack: null,
        isTryButton: false,
      );

      return;
    }

    ///////////////////

    if (_orderProvider!.orderState.progressState == 1) return;

    _orderProvider!.setOrderState(_orderProvider!.orderState.update(progressState: 1), isNotifiable: false);
    await _keicyProgressDialog!.show();

    PriceFunctions1.calculateDiscount(orderModel: _orderModel);
    _orderModel!.paymentDetail = PriceFunctions1.calclatePaymentDetail(orderModel: _orderModel);

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
    _orderModel!.category = "Assistant";
    _orderModel!.deliveryDetail = {
      "ongoing": false,
      "assignedDeliveryUserId": "",
      "status": "",
    };

    _orderProvider!.addOrder(
      orderModel: _orderModel,
      category: "Assistant",
      status: AppConfig.orderStatusData[1]["id"],
    );
  }
}
