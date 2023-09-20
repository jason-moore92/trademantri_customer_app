// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:trapp/config/config.dart';
// import 'package:trapp/src/dialogs/index.dart';
// import 'package:trapp/src/elements/keicy_raised_button.dart';
// import 'package:trapp/src/helpers/price_functions.dart';
// import 'package:trapp/src/models/store_model.dart';
// import 'package:trapp/src/pages/CheckOutPage/index.dart';
// import 'package:trapp/src/pages/OrderConfirmationPage/index.dart';
// import 'package:trapp/src/pages/SearchPage/index.dart';
// import 'package:trapp/src/pages/LoginAskPage/index.dart';
// import 'package:trapp/src/providers/index.dart';
// import 'package:trapp/config/app_config.dart' as config;

// import 'index.dart';
// import '../../elements/keicy_progress_dialog.dart';

// class OrderAssistantView extends StatefulWidget {
//   final Map<String, dynamic>? orderAssistantData;
//   StoreModel? storeModel;
//   final bool haveAppBar;
//   final bool haveProducts;
//   final bool haveServices;

//   OrderAssistantView({
//     Key? key,
//     this.orderAssistantData,
//     this.storeModel,
//     this.haveAppBar = true,
//     this.haveProducts = true,
//     this.haveServices = true,
//   }) : super(key: key);

//   @override
//   _OrderAssistantViewState createState() => _OrderAssistantViewState();
// }

// class _OrderAssistantViewState extends State<OrderAssistantView> {
//   /// Responsive design variables
//   double deviceWidth = 0;
//   double deviceHeight = 0;
//   double statusbarHeight = 0;
//   double bottomBarHeight = 0;
//   double appbarHeight = 0;
//   double widthDp = 0;
//   double heightDp = 0;
//   double fontSp = 0;

//   ///////////////////////////////

//   DeliveryAddressProvider? _deliveryAddressProvider;
//   OrderProvider? _orderProvider;
//   PromocodeProvider? _promocodeProvider;
//   CategoryProvider? _categoryProvider;

//   AppDataProvider? _appDataProvider;
//   KeicyProgressDialog? _keicyProgressDialog;

//   Map<String, dynamic> _orderAssistantData = Map<String, dynamic>();

//   GlobalKey<FormState>? _formkey;
//   SharedPreferences? _preferences;

//   @override
//   void initState() {
//     super.initState();

//     /// Responsive design variables
//     deviceWidth = 1.sw;
//     deviceHeight = 1.sh;
//     statusbarHeight = ScreenUtil().statusBarHeight;
//     bottomBarHeight = ScreenUtil().bottomBarHeight;
//     appbarHeight = AppBar().preferredSize.height;
//     widthDp = ScreenUtil().setWidth(1);
//     heightDp = ScreenUtil().setWidth(1);
//     fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
//     ///////////////////////////////

//     _deliveryAddressProvider = DeliveryAddressProvider.of(context);
//     _orderProvider = OrderProvider.of(context);
//     _appDataProvider = AppDataProvider.of(context);
//     _promocodeProvider = PromocodeProvider.of(context);
//     _categoryProvider = CategoryProvider.of(context);

//     _orderAssistantData = widget.orderAssistantData ?? Map<String, dynamic>();

//     /// orderDat initValue
//     _orderAssistantData["noContactDelivery"] = true;
//     _orderAssistantData["orderType"] = "Pickup";

//     _deliveryAddressProvider!.setDeliveryAddressState(
//       _deliveryAddressProvider!.deliveryAddressState.update(selectedDeliveryAddress: Map<String, dynamic>()),
//       isNotifiable: false,
//     );

//     _orderProvider!.setOrderState(
//       _orderProvider!.orderState.update(progressState: 0, newOrderData: Map<String, dynamic>()),
//       isNotifiable: false,
//     );

//     _promocodeProvider!.setPromocodeState(_promocodeProvider!.promocodeState.update(progressState: 0), isNotifiable: false);

//     SharedPreferences.getInstance().then((value) => _preferences = value);

//     DeliveryPartnerProvider.of(context).setDeliveryPartnerState(
//       DeliveryPartnerState.init(),
//       isNotifiable: false,
//     );

//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//       _orderProvider!.addListener(_orderProviderListener);
//       if (widget.orderAssistantData != null && widget.orderAssistantData!.isNotEmpty) {
//         _promocodeProvider!.getPromocodeData(category: widget.orderAssistantData!["subType"]);
//         getAssistantOnLocal();
//       }
//       if (_categoryProvider!.categoryState.progressState != 2) {
//         _categoryProvider!.getCategoryAll();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _orderProvider!.removeListener(_orderProviderListener);
//     storeAssistantOnLocal();
//     super.dispose();
//   }

//   void storeAssistantOnLocal() async {
//     if (_preferences == null) _preferences = await SharedPreferences.getInstance();
//     if (_orderAssistantData["categoryId"] != null && widget.storeModel != null) {
//       bool haveProduct = false;
//       bool haveService = false;

//       if (_orderAssistantData["products"] != null) {
//         for (var i = 0; i < _orderAssistantData["products"].length; i++) {
//           if (_orderAssistantData["products"][i].isNotEmpty) {
//             haveService = true;
//             break;
//           }
//         }
//       }

//       if (_orderAssistantData["services"] != null) {
//         for (var i = 0; i < _orderAssistantData["services"].length; i++) {
//           if (_orderAssistantData["services"][i].isNotEmpty) {
//             haveService = true;
//             break;
//           }
//         }
//       }

//       if (haveProduct || haveService) {
//         _preferences!.setString(
//           "Assistant-Order_${widget.storeModel!.id}",
//           json.encode({
//             "businessType": _orderAssistantData["businessType"],
//             "categoryId": _orderAssistantData["categoryId"],
//             "store": widget.storeModel,
//             "products": _orderAssistantData["products"],
//             "services": _orderAssistantData["services"],
//           }),
//         );
//       } else {
//         _preferences!.setString(
//           "Assistant-Order_${widget.storeModel!.id}",
//           json.encode(null),
//         );
//       }
//     }
//   }

//   void getAssistantOnLocal() async {
//     if (_preferences == null) _preferences = await SharedPreferences.getInstance();
//     if (_orderAssistantData["categoryId"] != null && widget.storeModel != null) {
//       var result = _preferences!.getString("Assistant-Order_${widget.storeModel!.id}");
//       if (result != null && result.toString().toLowerCase() != "null") {
//         var isLoad = await showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               content: Text(
//                 "you have previous items with the same store you added.  Do you want to populate previous items",
//                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                 textAlign: TextAlign.center,
//               ),
//               actions: [
//                 FlatButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(true);
//                   },
//                   child: Text(
//                     "OK",
//                     style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 FlatButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(false);
//                   },
//                   child: Text(
//                     "Cancel",
//                     style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             );
//           },
//         );

//         if (isLoad != null && isLoad) {
//           _orderAssistantData = json.decode(result);
//           _orderAssistantData["noContactDelivery"] = true;
//           _orderAssistantData["orderType"] = "Pickup";
//         }

//         setState(() {});
//       } else {
//         setState(() {});
//       }
//     }
//   }

//   void _orderProviderListener() async {
//     if (_orderProvider!.orderState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
//       await _keicyProgressDialog!.hide();
//     }

//     if (_orderProvider!.orderState.progressState == 2) {
//       Map<String, dynamic> newOrderData = json.decode(json.encode(_orderProvider!.orderState.newOrderData));
//       newOrderData["store"] = widget.storeModel;
//       _preferences!.setString(
//         "Assistant-Order_${widget.storeModel!.id}",
//         "null",
//       );

//       _orderAssistantData = Map<String, dynamic>();
//       _orderAssistantData["noContactDelivery"] = true;
//       _orderAssistantData["orderType"] = "Pickup";
//       setState(() {});

//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(
//           builder: (BuildContext context) => OrderConfirmationPage(
//             orderData: newOrderData,
//           ),
//         ),
//         (route) {
//           if (route.settings.name == "home_page") return true;
//           return false;
//         },
//       );
//     } else if (_orderProvider!.orderState.progressState == -1) {
//       ErrorDialog.show(
//         context,
//         widthDp: widthDp,
//         heightDp: heightDp,
//         fontSp: fontSp,
//         text: _orderProvider!.orderState.message!,
//         callBack: _placeOrderHandler,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: !widget.haveAppBar
//           ? null
//           : AppBar(
//               centerTitle: true,
//               title: Text("Assistant Order", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
//               elevation: 0,
//             ),
//       body: AuthProvider.of(context).authState.userModel!.id == null
//           ? LoginAskPage(
//               callback: () => Navigator.of(context).pushNamed('/Pages', arguments: {"currentTab": 0}),
//             )
//           : NotificationListener<OverscrollIndicatorNotification>(
//               onNotification: (notification) {
//                 notification.disallowGlow();
//                 return true;
//               },
//               child: SingleChildScrollView(
//                 child: Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
//                         child: Card(
//                           margin: EdgeInsets.zero,
//                           elevation: 5,
//                           child: Container(
//                             child: Image.asset(
//                               "img/assistant_store.png",
//                               width: double.infinity,
//                               fit: BoxFit.fitWidth,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: heightDp * 40),
//                       _categoryPanel(),
//                       Divider(height: heightDp * 40, thickness: 3, color: Colors.black.withOpacity(0.1)),
//                       _storePanel(),
//                       Divider(height: heightDp * 40, thickness: 3, color: Colors.black.withOpacity(0.1)),
//                       (widget.storeModel == null || widget.storeModel!.type == "Retailer" || widget.storeModel!.type == "Wholesaler")
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 if (widget.haveProducts) _productsItemsPanel(),
//                                 if (widget.haveServices)
//                                   Column(
//                                     children: [
//                                       SizedBox(height: heightDp * 30),
//                                       _serviceItemsPanel(),
//                                     ],
//                                   ),
//                               ],
//                             )
//                           : Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 if (widget.haveServices) _serviceItemsPanel(),
//                                 SizedBox(height: heightDp * 30),
//                                 if (widget.haveProducts)
//                                   Column(
//                                     children: [
//                                       SizedBox(height: heightDp * 30),
//                                       _productsItemsPanel(),
//                                     ],
//                                   ),
//                               ],
//                             ),
//                       SizedBox(height: heightDp * 15),
//                       Divider(height: heightDp * 15, thickness: 3, color: Colors.black.withOpacity(0.1)),
//                       InstructionPanel(
//                         orderData: _orderAssistantData,
//                         callback: (formkey) {
//                           _formkey = formkey;
//                         },
//                       ),
//                       _promoCode(),
//                       _orderAssistantData["products"] == null || _orderAssistantData["products"].isEmpty
//                           ? SizedBox()
//                           : Column(
//                               children: [
//                                 Divider(height: heightDp * 15, thickness: 3, color: Colors.black.withOpacity(0.1)),
//                                 PickupDeliveryOptionPanel(
//                                   storeModel: widget.storeModel,
//                                   orderData: _orderAssistantData,
//                                   deliveryPartner: null,
//                                   isReadOnly: widget.storeModel == null,
//                                   pickupCallback: () {
//                                     setState(() {
//                                       _orderAssistantData["orderType"] = "Pickup";
//                                       _orderAssistantData["deliveryAddress"] = Map<String, dynamic>();
//                                       _deliveryAddressProvider!.setDeliveryAddressState(
//                                         _deliveryAddressProvider!.deliveryAddressState.update(selectedDeliveryAddress: Map<String, dynamic>()),
//                                         isNotifiable: false,
//                                       );
//                                     });
//                                   },
//                                   deliveryCallback: () {
//                                     setState(() {
//                                       _orderAssistantData["orderType"] = "Delivery";
//                                       _orderAssistantData["pickupDateTime"] = null;
//                                     });
//                                   },
//                                   refreshCallback: () {
//                                     setState(() {});
//                                   },
//                                 ),
//                               ],
//                             ),
//                       _orderAssistantData["services"] == null || _orderAssistantData["services"].isEmpty
//                           ? SizedBox()
//                           : Column(
//                               children: [
//                                 Divider(height: heightDp * 15, thickness: 3, color: Colors.black.withOpacity(0.1)),
//                                 ServiceTimePanel(
//                                   storeModel: widget.storeModel,
//                                   orderData: _orderAssistantData,
//                                   refreshCallback: () {
//                                     setState(() {});
//                                   },
//                                 ),
//                               ],
//                             ),
//                       SizedBox(height: heightDp * 20),
//                       _placeOrderButton(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _categoryPanel() {
//     List<dynamic> _categories;

//     String categoryDesc = "";
//     _categories = _orderAssistantData["businessType"] == "store"
//         ? _categoryProvider!.categoryState.categoryData!["store"]
//         : _categoryProvider!.categoryState.categoryData!["services"];

//     for (var i = 0; i < _categories.length; i++) {
//       if (_categories[i]["categoryId"] == _orderAssistantData["categoryId"]) {
//         categoryDesc = _categories[i]["categoryDesc"];
//         break;
//       }
//     }

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Choose Category",
//             style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: heightDp * 10),
//           GestureDetector(
//             onTap: () {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return SimpleDialog(
//                     backgroundColor: Colors.transparent,
//                     insetPadding: EdgeInsets.zero,
//                     titlePadding: EdgeInsets.zero,
//                     contentPadding: EdgeInsets.zero,
//                     elevation: 0,
//                     children: [
//                       CategoryBottomSheet(
//                         categoryId: _orderAssistantData["categoryId"],
//                         callback: (categoryId, businessType) {
//                           if (_orderAssistantData["categoryId"] != categoryId) {
//                             setState(() {
//                               _orderAssistantData = Map<String, dynamic>();
//                               _orderAssistantData["categoryId"] = categoryId;
//                               _orderAssistantData["businessType"] = businessType;

//                               // _deliveryPartnerProvider.setDeliveryPartnerState(
//                               //   DeliveryPartnerState.init(),
//                               //   isNotifiable: false,
//                               // );

//                               _deliveryAddressProvider!.setDeliveryAddressState(
//                                 _deliveryAddressProvider!.deliveryAddressState.update(
//                                   selectedDeliveryAddress: Map<String, dynamic>(),
//                                 ),
//                                 isNotifiable: false,
//                               );
//                             });
//                           }
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
//               decoration: BoxDecoration(color: Color(0xFFECECEC), borderRadius: BorderRadius.circular(heightDp * 4)),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     _orderAssistantData["categoryId"] == null ? "Please choose category" : categoryDesc,
//                     style: TextStyle(
//                       fontSize: fontSp * 16,
//                       color: _orderAssistantData["categoryId"] == null ? Colors.black.withOpacity(0.5) : Colors.black,
//                     ),
//                   ),
//                   Icon(Icons.arrow_forward_ios, size: heightDp * 20),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _storePanel() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Enter Store/Pickup Address",
//             style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: heightDp * 10),
//           GestureDetector(
//             onTap: () async {
//               if (_orderAssistantData["categoryId"] == null) return;
//               Map<String, dynamic> categoryData = Map<String, dynamic>();
//               for (var i = 0; i < _appDataProvider!.appDataState.categoryList!.length; i++) {
//                 if (_appDataProvider!.appDataState.categoryList![i]["categoryId"] == _orderAssistantData["categoryId"]) {
//                   categoryData = _appDataProvider!.appDataState.categoryList![i];
//                 }
//               }
//               var result = await Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => SearchPage(
//                     step: 1,
//                     categoryData: categoryData,
//                     forSelection: true,
//                   ),
//                 ),
//               );

//               if (result != null) {
//                 if (widget.storeModel != null && widget.storeModel!.id == result["_id"]) return;

//                 widget.storeModel = StoreModel.fromJson(result);
//                 _orderAssistantData["products"] = null;
//                 _orderAssistantData["services"] = null;

//                 setState(() {});
//                 WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//                   if (widget.storeModel!.type == "Retailer" || widget.storeModel!.type == "Wholesaler") {
//                     _orderAssistantData["products"] = [
//                       {
//                         "orderQuantity": 1,
//                         "data": {"name": ""}
//                       }
//                     ];
//                     _orderAssistantData["services"] = null;
//                     _orderAssistantData["noContactDelivery"] = true;
//                     _orderAssistantData["orderType"] = "Pickup";
//                   } else {
//                     _orderAssistantData["products"] = null;
//                     _orderAssistantData["services"] = [
//                       {
//                         "orderQuantity": 1,
//                         "data": {"name": ""}
//                       }
//                     ];
//                     _orderAssistantData["noContactDelivery"] = true;
//                     _orderAssistantData["orderType"] = "Pickup";
//                   }

//                   // _deliveryPartnerProvider.setDeliveryPartnerState(
//                   //   _deliveryPartnerProvider.deliveryPartnerState.update(
//                   //     progressState: 1,
//                   //     deliveryPartnerData: [],
//                   //   ),
//                   //   isNotifiable: false,
//                   // );

//                   _deliveryAddressProvider!.setDeliveryAddressState(
//                     _deliveryAddressProvider!.deliveryAddressState.update(
//                       selectedDeliveryAddress: Map<String, dynamic>(),
//                     ),
//                     isNotifiable: false,
//                   );

//                   _promocodeProvider!.getPromocodeData(category: result["subType"]);

//                   // _deliveryPartnerProvider.getDeliveryPartnerData(
//                   //   zipCode: widget.storeModel["zipCode"],
//                   // );

//                   getAssistantOnLocal();
//                 });
//               }
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
//               decoration: BoxDecoration(color: Color(0xFFECECEC), borderRadius: BorderRadius.circular(heightDp * 4)),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     widget.storeModel == null ? "Please choose store" : widget.storeModel!.name!,
//                     style: TextStyle(
//                       fontSize: fontSp * 16,
//                       color: widget.storeModel == null ? Colors.black.withOpacity(0.5) : Colors.black,
//                     ),
//                   ),
//                   Icon(Icons.arrow_forward_ios, size: heightDp * 20),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _productsItemsPanel() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
//       child: widget.storeModel != null && _orderAssistantData["products"] == null
//           ? GestureDetector(
//               onTap: () {
//                 if (widget.storeModel == null) return;
//                 _orderAssistantData["products"] = [];
//                 setState(() {});
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Do you want any products from this store?",
//                     style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 2),
//                     decoration: BoxDecoration(
//                       color: widget.storeModel != null ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
//                     ),
//                     child: Text(
//                       "+",
//                       style: TextStyle(fontSize: fontSp * 18, color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Make a product order list",
//                   style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: heightDp * 10),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
//                   decoration: BoxDecoration(color: Color(0xFFECECEC), borderRadius: BorderRadius.circular(heightDp * 4)),
//                   child: Column(
//                     children: List.generate(_orderAssistantData["products"] == null ? 1 : _orderAssistantData["products"].length + 1, (index) {
//                       var productData = _orderAssistantData["products"] == null || _orderAssistantData["products"].length == index
//                           ? null
//                           : _orderAssistantData["products"][index];

//                       return Padding(
//                         padding: EdgeInsets.symmetric(vertical: heightDp * 8),
//                         child: NewItemWidget(
//                           storeId: widget.storeModel != null ? widget.storeModel!.id : "",
//                           category: "products",
//                           isReadOnly: widget.storeModel == null,
//                           productData: productData,
//                           index: index,
//                           callback: (data, {bool isNew = false}) {
//                             if (widget.storeModel == null) return;
//                             if (_orderAssistantData["products"] == null) _orderAssistantData["products"] = [];
//                             if (isNew) {
//                               _orderAssistantData["products"].add({
//                                 "orderQuantity": 1,
//                                 "data": {"name": ""}
//                               });
//                               setState(() {});
//                               return;
//                             }
//                             if (productData == null) return;
//                             _orderAssistantData["products"][index] = data;
//                             setState(() {});
//                           },
//                           deleteCallback: (index) {
//                             _orderAssistantData["products"].removeAt(index);
//                             setState(() {});
//                           },
//                         ),
//                       );
//                     }),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _serviceItemsPanel() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
//       child: _orderAssistantData["services"] == null
//           ? GestureDetector(
//               onTap: () {
//                 if (widget.storeModel == null) return;
//                 _orderAssistantData["services"] = [];
//                 setState(() {});
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Do you want any services from this store?",
//                     style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 2),
//                     color: widget.storeModel != null ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
//                     child: Text(
//                       "+",
//                       style: TextStyle(fontSize: fontSp * 18, color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Make a service order list",
//                   style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: heightDp * 10),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
//                   decoration: BoxDecoration(color: Color(0xFFECECEC), borderRadius: BorderRadius.circular(heightDp * 4)),
//                   child: Column(
//                     children: List.generate(_orderAssistantData["services"] == null ? 1 : _orderAssistantData["services"].length + 1, (index) {
//                       var productData = _orderAssistantData["services"] == null || _orderAssistantData["services"].length == index
//                           ? null
//                           : _orderAssistantData["services"][index];

//                       return Padding(
//                         padding: EdgeInsets.symmetric(vertical: heightDp * 8),
//                         child: NewItemWidget(
//                           storeId: widget.storeModel != null ? widget.storeModel!.id : "",
//                           category: "services",
//                           isReadOnly: widget.storeModel == null,
//                           productData: productData,
//                           index: index,
//                           callback: (data, {bool isNew = false}) {
//                             if (widget.storeModel == null) return;
//                             if (_orderAssistantData["services"] == null) _orderAssistantData["services"] = [];
//                             if (isNew) {
//                               _orderAssistantData["services"].add({
//                                 "orderQuantity": 1,
//                                 "data": {"name": ""}
//                               });
//                               setState(() {});
//                               return;
//                             }
//                             if (productData == null) return;
//                             _orderAssistantData["services"][index] = data;
//                             setState(() {});
//                           },
//                           deleteCallback: (index) {
//                             _orderAssistantData["services"].removeAt(index);
//                             setState(() {});
//                           },
//                         ),
//                       );
//                     }),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _promoCode() {
//     return Consumer<PromocodeProvider>(builder: (context, promocodeProvider, _) {
//       if (promocodeProvider.promocodeState.progressState == 0 || promocodeProvider.promocodeState.progressState == 1) {
//         return SizedBox();
//       }
//       return Column(
//         children: [
//           Divider(height: heightDp * 15, thickness: 3, color: Colors.black.withOpacity(0.1)),
//           PromocodePanel(
//             storeModel: widget.storeModel,
//             orderData: _orderAssistantData,
//             isReadOnly: widget.storeModel == null,
//             typeList: ["Delivery"],
//             isForAssistant: true,
//             refreshCallback: () {
//               setState(() {});
//             },
//           ),
//         ],
//       );
//     });
//   }

//   Widget _placeOrderButton() {
//     return Consumer2<DeliveryAddressProvider, DeliveryPartnerProvider>(builder: (context, deliveryAddressProvider, deliveryPartnerProvider, _) {
//       // if (_deliveryAddressProvider!.deliveryAddressState.selectedDeliveryAddress != null &&
//       //     _deliveryAddressProvider!.deliveryAddressState.selectedDeliveryAddress.isNotEmpty) {
//       //   _orderAssistantData["deliveryAddress"] = _deliveryAddressProvider!.deliveryAddressState.selectedDeliveryAddress;
//       // } else {
//       //   _orderAssistantData["deliveryAddress"] = Map<String, dynamic>();
//       // }

//       bool isEnable = widget.storeModel != null;

//       if (_orderAssistantData["products"] != null && _orderAssistantData["products"].isNotEmpty) {
//         if (_orderAssistantData["orderType"] == "Pickup") {
//           if (_orderAssistantData["pickupDateTime"] == null) {
//             isEnable = false;
//           }
//         } else {
//           if (_orderAssistantData["deliveryAddress"] == null || _orderAssistantData["deliveryAddress"].isEmpty) {
//             isEnable = false;
//           }
//         }
//       }

//       if (_orderAssistantData["services"] != null && _orderAssistantData["services"].isNotEmpty) {
//         if (_orderAssistantData["serviceDateTime"] == null) {
//           isEnable = false;
//         }
//       }

//       if ((_orderAssistantData["products"] == null || _orderAssistantData["products"].length == 0) &&
//           (_orderAssistantData["services"] == null || _orderAssistantData["services"].length == 0)) {
//         isEnable = false;
//       }

//       return Container(
//         color: Colors.grey.withOpacity(0.2),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       "Pay after once store person confirms the items available at store",
//                       style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                     ),
//                   ),
//                   SizedBox(width: widthDp * 30),
//                   KeicyRaisedButton(
//                     width: widthDp * 140,
//                     height: heightDp * 40,
//                     borderRadius: heightDp * 40,
//                     color: isEnable ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.4),
//                     child: Text(
//                       "Place Order",
//                       style: TextStyle(fontSize: fontSp * 13, color: isEnable ? Colors.white : Colors.black),
//                     ),
//                     onPressed: isEnable ? _warnStoreAvailability : null,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   bool _storeAvailability() {
//     bool? openStatus;

//     try {
//       if (widget.storeModel!.profile!["holidays"] == null || widget.storeModel!.profile!["holidays"].isEmpty) {
//         openStatus = null;
//       } else {
//         for (var i = 0; i < widget.storeModel!.profile!["holidays"].length; i++) {
//           DateTime holiday = DateTime.tryParse(widget.storeModel!.profile!["holidays"][i])!.toLocal();

//           if (holiday.year == DateTime.now().year && holiday.month == DateTime.now().month && holiday.day == DateTime.now().day) {
//             openStatus = false;

//             break;
//           }
//         }
//       }
//     } catch (e) {
//       openStatus = null;
//     }

//     try {
//       if (openStatus == null && (widget.storeModel!.profile!["hours"] == null || widget.storeModel!.profile!["hours"].isEmpty)) {
//         openStatus = null;
//       } else {
//         var selectedHoursData;

//         for (var i = 0; i < widget.storeModel!.profile!["hours"].length; i++) {
//           var hoursData = widget.storeModel!.profile!["hours"][i];

//           if (hoursData["day"].toString().toLowerCase() == "monday" && DateTime.now().weekday == DateTime.monday) {
//             selectedHoursData = hoursData;
//           } else if (hoursData["day"].toString().toLowerCase() == "tuesday" && DateTime.now().weekday == DateTime.tuesday) {
//             selectedHoursData = hoursData;
//           } else if (hoursData["day"].toString().toLowerCase() == "wednesday" && DateTime.now().weekday == DateTime.wednesday) {
//             selectedHoursData = hoursData;
//           } else if (hoursData["day"].toString().toLowerCase() == "thursday" && DateTime.now().weekday == DateTime.thursday) {
//             selectedHoursData = hoursData;
//           } else if (hoursData["day"].toString().toLowerCase() == "friday" && DateTime.now().weekday == DateTime.friday) {
//             selectedHoursData = hoursData;
//           } else if (hoursData["day"].toString().toLowerCase() == "saturday" && DateTime.now().weekday == DateTime.saturday) {
//             selectedHoursData = hoursData;
//           } else if (hoursData["day"].toString().toLowerCase() == "sunday" && DateTime.now().weekday == DateTime.sunday) {
//             selectedHoursData = hoursData;
//           }
//         }

//         if (selectedHoursData["isWorkingDay"]) {
//           DateTime openTime = DateTime(
//             DateTime.now().year,
//             DateTime.now().month,
//             DateTime.now().day,
//             DateTime.tryParse(selectedHoursData["openingTime"])!.toLocal().hour,
//             DateTime.tryParse(selectedHoursData["openingTime"])!.toLocal().minute,
//           );

//           DateTime closeTime = DateTime(
//             DateTime.now().year,
//             DateTime.now().month,
//             DateTime.now().day,
//             DateTime.tryParse(selectedHoursData["closingTime"])!.toLocal().hour,
//             DateTime.tryParse(selectedHoursData["closingTime"])!.toLocal().minute,
//           );

//           if (DateTime.now().isAfter(openTime) && DateTime.now().isBefore(closeTime)) {
//             openStatus = true;
//           } else {
//             openStatus = false;
//           }
//         } else {
//           openStatus = false;
//         }
//       }
//     } catch (e) {
//       openStatus = null;
//     }

//     return openStatus!;
//   }

//   _warnStoreAvailability() async {
//     bool storeAvailability = _storeAvailability();

//     if (storeAvailability != null && storeAvailability == false) {
//       StoreClosedDialog.show(context, cancelCallback: () {}, proceedCallback: () {
//         _placeOrderHandler();
//       });

//       return;
//     }

//     return _placeOrderHandler();
//   }

//   void _placeOrderHandler() async {
//     if (_keicyProgressDialog == null) _keicyProgressDialog = KeicyProgressDialog.of(context);
//     if (!_formkey!.currentState!.validate()) return;
//     _formkey!.currentState!.save();

//     /////////////////

//     bool isEmpty = false;
//     int count = 0;
//     if (_orderAssistantData["products"] != null && _orderAssistantData["products"].isNotEmpty) {
//       for (var i = 0; i < _orderAssistantData["products"].length; i++) {
//         if (_orderAssistantData["products"][i]["data"]["name"] == "") {
//           isEmpty = true;
//           count++;
//         }
//       }
//     }
//     if (_orderAssistantData["services"] != null && _orderAssistantData["services"].isNotEmpty) {
//       for (var i = 0; i < _orderAssistantData["services"].length; i++) {
//         if (_orderAssistantData["services"][i]["data"]["name"] == "") {
//           isEmpty = true;
//           count++;
//         }
//       }
//     }

//     if (isEmpty == true) {
//       ErrorDialog.show(
//         context,
//         widthDp: widthDp,
//         heightDp: heightDp,
//         fontSp: fontSp,
//         text: "You didn't enter $count product / service names, please enter names to place order",
//         callBack: null,
//         isTryButton: false,
//       );

//       return;
//     }

//     ///////////////////

//     if (_orderProvider!.orderState.progressState == 1) return;

//     _orderProvider!.setOrderState(_orderProvider!.orderState.update(progressState: 1), isNotifiable: false);
//     await _keicyProgressDialog!.show();

//     double totalQuantity = 0;
//     double totalPrice = 0;
//     double totalOriginPrice = 0;
//     double totalTax = 0;
//     double deliveryPrice = 0;
//     double deliveryDiscount = 0;
//     double tip = 0;

//     Map<String, dynamic> orderAssistantData = json.decode(json.encode(_orderAssistantData));

//     var result = PriceFunctions.getTotalPriceOfCart(orderData: orderAssistantData);
//     totalQuantity = result["totalQuantity"];
//     totalPrice = result["totalPrice"];
//     totalOriginPrice = result["totalOriginPrice"];
//     totalTax = result["totalTax"];

//     //////////// Delivery Price ////////////////////
//     if (orderAssistantData["deliveryPartnerDetails"] != null) {
//       deliveryPrice = orderAssistantData["deliveryPartnerDetails"]["charge"]["deliveryPrice"];

//       if (orderAssistantData["promocode"] != null &&
//           orderAssistantData["promocode"].isNotEmpty &&
//           orderAssistantData["promocode"]["promocodeType"] == "Delivery") {
//         deliveryDiscount = (double.parse(orderAssistantData["promocode"]["promocodeValue"].toString()) * deliveryPrice / 100);
//       }
//     }
//     //////////////////////////////////////////////////

//     orderAssistantData["paymentDetail"] = {
//       "totalQuantity": totalQuantity,
//       "promocode": orderAssistantData["promocode"] != null ? orderAssistantData["promocode"]["promocodeCode"] : "",
//       "totalOriginPrice": double.parse(totalOriginPrice.toStringAsFixed(2)),
//       "totalPrice": double.parse(totalPrice.toStringAsFixed(2)),
//       "deliveryCargeBeforeDiscount": double.parse(deliveryPrice.toStringAsFixed(2)),
//       "deliveryCargeAfterDiscount": double.parse((deliveryPrice - deliveryDiscount).toStringAsFixed(2)),
//       "deliveryDiscount": double.parse(deliveryDiscount.toStringAsFixed(2)),
//       "distance": orderAssistantData["deliveryAddress"] != null && orderAssistantData["deliveryAddress"].isNotEmpty
//           ? (orderAssistantData["deliveryAddress"]["distance"] / 1000).toStringAsFixed(3)
//           : 0,
//       "tip": double.parse((tip).toStringAsFixed(2)),
//       "totalTax": double.parse(totalTax.toStringAsFixed(2)),
//       "toPay": double.parse((totalPrice + deliveryPrice - deliveryDiscount + tip + totalTax).toStringAsFixed(2)),
//     };
//     if (orderAssistantData["products"] == null) orderAssistantData["products"] = [];
//     if (orderAssistantData["services"] == null) orderAssistantData["services"] = [];
//     List<Map<String, dynamic>> tmp = [];
//     for (var i = 0; i < orderAssistantData["products"].length; i++) {
//       if (orderAssistantData["products"][i].isNotEmpty) {
//         tmp.add(orderAssistantData["products"][i]);
//       }
//     }
//     orderAssistantData["products"] = tmp;

//     tmp = [];
//     for (var i = 0; i < orderAssistantData["services"].length; i++) {
//       if (orderAssistantData["services"][i].isNotEmpty) {
//         tmp.add(orderAssistantData["services"][i]);
//       }
//     }
//     orderAssistantData["services"] = tmp;

//     String categoryDesc = "";
//     List<dynamic> _categories;
//     _categories = orderAssistantData["store"]["businessType"] == "store"
//         ? CategoryProvider.of(context).categoryState.categoryData!["store"]
//         : CategoryProvider.of(context).categoryState.categoryData!["services"];

//     for (var i = 0; i < _categories.length; i++) {
//       if (_categories[i]["categoryId"] == orderAssistantData["store"]["subType"]) {
//         categoryDesc = _categories[i]["categoryDesc"];
//         break;
//       }
//     }
//     if (_orderAssistantData["redeemRewardData"] == null || _orderAssistantData["redeemRewardData"]["sumRewardPoint"] == null) {
//       _orderAssistantData["redeemRewardData"] = Map<String, dynamic>();
//       _orderAssistantData["redeemRewardData"]["sumRewardPoint"] = 0;
//       _orderAssistantData["redeemRewardData"]["redeemRewardValue"] = 0;
//       _orderAssistantData["redeemRewardData"]["redeemRewardPoint"] = 0;
//       _orderAssistantData["redeemRewardData"]["tradeSumRewardPoint"] = 0;
//       _orderAssistantData["redeemRewardData"]["tradeRedeemRewardPoint"] = 0;
//       _orderAssistantData["redeemRewardData"]["tradeRedeemRewardValue"] = 0;
//     }

//     orderAssistantData["email"] = AuthProvider.of(context).authState.userModel!.email;
//     orderAssistantData["userId"] = AuthProvider.of(context).authState.userModel!.id;
//     orderAssistantData["storeCategoryId"] = orderAssistantData["store"]["subType"];
//     orderAssistantData["storeCategoryDesc"] = categoryDesc;
//     _orderProvider!.addOrder(
//       orderData: orderAssistantData,
//       category: "Assistant",
//       status: AppConfig.orderStatusData[1]["id"],
//     );
//   }
// }
