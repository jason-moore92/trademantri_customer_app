import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/maps_sheet.dart';
import 'package:trapp/src/elements/bottom_cart_widget.dart';
import 'package:trapp/src/elements/favorite_icon_widget.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/products_order_assistant_widget.dart';
import 'package:trapp/src/elements/review_and_rating_widget.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/store_time_validation.dart';
import 'package:trapp/src/models/chat_room_model.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/AnnouncementListForALLPage/announcement_list_for_all_page.dart';
import 'package:trapp/src/pages/AppointmentListPage/index.dart';
import 'package:trapp/src/pages/ChatPage/index.dart';
import 'package:trapp/src/pages/CouponListPage/coupon_list_page.dart';
import 'package:trapp/src/pages/OrderAssistantPage/index.dart';
import 'package:trapp/src/pages/CreateBargainRequestPage/index.dart';
import 'package:trapp/src/pages/ServiceListPage/index.dart';
import 'package:trapp/src/pages/StoreGalleryPage/store_gallery_page.dart';
import 'package:trapp/src/pages/StoreJobPostingsListPage/index.dart';
import 'package:trapp/src/pages/StoreReviewPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:map_launcher/map_launcher.dart';
import 'package:trapp/src/services/dynamic_link_service.dart';

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';
import '../ProductListPage/index.dart';

class StoreView extends StatefulWidget {
  final StoreModel? storeModel;
  final String? immediateAction;

  StoreView({
    Key? key,
    this.storeModel,
    this.immediateAction,
  }) : super(key: key);

  @override
  _StoreViewState createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
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

  AuthProvider? _authProvider;
  StorePageProvider? _storePageProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  String? reviewKey;

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

    _storePageProvider = StorePageProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    reviewKey = "${_authProvider!.authState.userModel!.id}_${widget.storeModel!.id}";

    _storePageProvider!.setStorePageState(
      _storePageProvider!.storePageState.update(
        progressState: 1,
        topReviewList: [],
        averateRatingData: Map<String, dynamic>(),
        isLoadMore: false,
      ),
      isNotifiable: false,
    );

    if (widget.storeModel!.settings == null) widget.storeModel!.settings = AppConfig.initialSettings;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      // _showSaveCartAskDialog();

      if (_storePageProvider!.storePageState.averateRatingData![widget.storeModel!.id] == null) {
        await _storePageProvider!.getAverageRating(storeId: widget.storeModel!.id);
      }

      if (_storePageProvider!.storePageState.topReviewList!.isEmpty) {
        await _storePageProvider!.getTopReviewList(storeId: widget.storeModel!.id);
      }

      if (_storePageProvider!.storePageState.storeGalleryData![widget.storeModel!.id] == null) {
        await _storePageProvider!.getStoreGallery(storeId: widget.storeModel!.id);
      }

      if (_authProvider!.authState.loginState == LoginState.IsLogin && _authProvider!.authState.userModel!.id != null) {
        _initHandler();
      } else {
        _storePageProvider!.setStorePageState(
          _storePageProvider!.storePageState.update(progressState: 2),
        );
      }

      doImmediateAction();
    });
  }

  doImmediateAction() {
    if (widget.immediateAction == "go_to_coupons") {
      FavoriteProvider.of(context).favoriteUpdateHandler();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => CouponListPage(
            storeModel: widget.storeModel,
          ),
        ),
      );
    }
  }

  void _initHandler() {
    if (_storePageProvider!.storePageState.storeReviewData![reviewKey] == null ||
        _storePageProvider!.storePageState.storeReviewData![reviewKey].isEmpty) {
      _storePageProvider!.getStoreReview(
        userId: _authProvider!.authState.userModel!.id,
        storeId: widget.storeModel!.id,
      );
    } else {
      _storePageProvider!.setStorePageState(
        _storePageProvider!.storePageState.update(progressState: 2),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FavoriteProvider.of(context).favoriteUpdateHandler();

        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
            onPressed: () {
              FavoriteProvider.of(context).favoriteUpdateHandler();

              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            widget.storeModel!.name!,
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
          elevation: 0,
        ),
        body: Consumer<StorePageProvider>(builder: (context, storePageProvider, _) {
          if (storePageProvider.storePageState.progressState == 0 || storePageProvider.storePageState.progressState == 1) {
            return Center(child: CupertinoActivityIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overScroll) {
                    overScroll.disallowGlow();
                    return true;
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      width: deviceWidth,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///
                          _storeInfoPanel(),

                          ///
                          if (_storePageProvider!.storePageState.storeGalleryData![widget.storeModel!.id] != null)
                            Column(
                              children: [
                                SizedBox(height: heightDp * 15),
                                _storeGalleryPanel(),
                              ],
                            ),

                          ///
                          Column(
                            children: [
                              SizedBox(height: heightDp * 15),
                              _appointmentPanel(),
                            ],
                          ),

                          ///
                          SizedBox(height: heightDp * 15),
                          ProductsOrderAssistantWidget(
                            storeModel: widget.storeModel,
                            margin: EdgeInsets.zero,
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     if (_authProvider!.authState.loginState == LoginState.IsNotLogin || _authProvider!.authState.userModel!.id == null) {
                          //       LoginAskDialog.show(
                          //         context,
                          //         callback: () {
                          //           _initHandler();

                          //           FavoriteProvider.of(context).favoriteUpdateHandler();
                          //           _assistantHandler();
                          //         },
                          //       );
                          //     } else {
                          //       FavoriteProvider.of(context).favoriteUpdateHandler();
                          //       _assistantHandler();
                          //     }
                          //   },
                          //   child: Card(
                          //     margin: EdgeInsets.zero,
                          //     elevation: 5,
                          //     child: Container(
                          //       child: Image.asset(
                          //         "img/assistant_store.png",
                          //         width: double.infinity,
                          //         fit: BoxFit.fitWidth,
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          ///
                          SizedBox(height: heightDp * 20),
                          _availableServices(),

                          ///
                          SizedBox(height: heightDp * 30),
                          _aboutPanel(),

                          ///
                          SizedBox(height: heightDp * 30),
                          widget.storeModel!.profile!["hours"] == null || widget.storeModel!.profile!["hours"].isEmpty
                              ? SizedBox()
                              : _storeHoursLabel(),

                          ///
                          SizedBox(height: heightDp * 30),
                          _reviewPanel(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              BottomCartWidget(
                storeModel: widget.storeModel,
                storeInitHandler: (_authProvider!.authState.loginState == LoginState.IsNotLogin || _authProvider!.authState.userModel!.id == null)
                    ? _initHandler
                    : null,
              ),
            ],
          );
        }),
      ),
    );
  }

  void _assistantHandler() {
    OrderModel? orderModel = OrderModel();

    Map<String, dynamic> selectedStoreData = {
      "categoryId": widget.storeModel!.subType,
      "businessType": widget.storeModel!.businessType,
    };

    if (widget.storeModel!.type == "Retailer" || widget.storeModel!.type == "Wholesaler") {
      // orderModel.products = [
      //   ProductOrderModel(orderQuantity: 1, productModel: ProductModel(name: "")),
      // ];
      orderModel.products = [];
      orderModel.services = [];
      orderModel.noContactDelivery = true;
      orderModel.orderType = "Pickup";
    } else {
      orderModel.products = [];
      orderModel.services = [];
      // orderModel.services = [
      //   ServiceOrderModel(orderQuantity: 1, serviceModel: ServiceModel(name: "")),
      // ];
      orderModel.noContactDelivery = true;
      orderModel.orderType = "Pickup";
    }
    orderModel.storeModel = widget.storeModel;

    FavoriteProvider.of(context).favoriteUpdateHandler();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => OrderAssistantPage(
          orderModel: orderModel,
          selectedStoreData: selectedStoreData,
        ),
      ),
    );
  }

  Widget _storeInfoPanel() {
    bool openStatus = StoreTimeValidation.validate(dateTime: DateTime.now(), storeModel: widget.storeModel);

    return Column(
      children: [
        Row(
          children: [
            KeicyAvatarImage(
              url: widget.storeModel!.profile!["image"],
              width: widthDp * 80,
              height: widthDp * 80,
              backColor: Colors.grey.withOpacity(0.4),
              borderRadius: heightDp * 6,
              // userName: widget.storeModel!.name,
              textStyle: TextStyle(fontSize: fontSp * 22, color: Colors.black),
              errorWidget: ClipRRect(
                borderRadius: BorderRadius.circular(heightDp * 6),
                child: Image.asset(
                  "img/store-icon/${widget.storeModel!.subType.toString().toLowerCase()}-store.png",
                  width: widthDp * 80,
                  height: widthDp * 80,
                ),
              ),
            ),
            SizedBox(width: widthDp * 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${StorePageString.addressLabel}:",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
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
                              _storePageProvider!.storePageState.averateRatingData![widget.storeModel!.id] == null
                                  ? "0"
                                  : (_storePageProvider!.storePageState.averateRatingData![widget.storeModel!.id]["totalRating"] /
                                          _storePageProvider!.storePageState.averateRatingData![widget.storeModel!.id]["totalCount"])
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
                  SizedBox(height: heightDp * 5),
                  Row(
                    children: [
                      InkWell(
                        child: Icon(Icons.map),
                        onTap: () {
                          FullAddressDialog.show(
                            context,
                            content: widget.storeModel!.address!,
                            location: widget.storeModel!.location,
                          );
                        },
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: Text(
                          "${widget.storeModel!.address}",
                          style: TextStyle(
                            fontSize: fontSp * 11,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: widthDp * 5),
                        child: Image.asset(
                          openStatus ? "img/store_open.png" : "img/store_close.png",
                          width: heightDp * 30,
                          height: heightDp * 30,
                          fit: BoxFit.cover,
                          color: openStatus ? config.Colors().mainColor(1) : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: heightDp * 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 6,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                StorePageString.rewardsPointLabel,
                style: TextStyle(
                  fontSize: fontSp * 12,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                if (_authProvider!.authState.loginState == LoginState.IsNotLogin || _authProvider!.authState.userModel!.id == null) {
                  LoginAskDialog.show(
                    context,
                    callback: () {
                      _initHandler();
                      _rewardPointHandler();
                    },
                  );
                } else {
                  _rewardPointHandler();
                }
              },
            ),
            GestureDetector(
              onTap: () {
                MapsSheet.show(
                  context: context,
                  onMapTap: (map) {
                    map.showMarker(
                      coords: Coords(widget.storeModel!.location!.latitude, widget.storeModel!.location!.longitude),
                      title: "",
                    );
                  },
                );
              },
              child: Image.asset("img/location.png", width: heightDp * 30, height: heightDp * 30),
            ),
            FavoriteIconWidget(
              category: "stores",
              id: widget.storeModel!.id,
              storeId: widget.storeModel!.id,
              size: heightDp * 30,
              callback: () {
                _initHandler();
                setState(() {});
              },
            ),
            GestureDetector(
              onTap: () async {
                Uri dynamicUrl = await DynamicLinkService.createStoreDynamicLink(widget.storeModel!);
                Share.share(dynamicUrl.toString());
              },
              child: Icon(Icons.share, size: heightDp * 30, color: config.Colors().mainColor(1)),
            ),
            GestureDetector(
              onTap: () {
                if (_authProvider!.authState.loginState == LoginState.IsNotLogin || _authProvider!.authState.userModel!.id == null) {
                  LoginAskDialog.show(
                    context,
                    callback: () {
                      _initHandler();

                      FavoriteProvider.of(context).favoriteUpdateHandler();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => ChatPage(
                            chatRoomType: ChatRoomTypes.b2c,
                            userData: widget.storeModel!.toJson(),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  FavoriteProvider.of(context).favoriteUpdateHandler();

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => ChatPage(
                        chatRoomType: ChatRoomTypes.b2c,
                        userData: widget.storeModel!.toJson(),
                      ),
                    ),
                  );
                }
              },
              child: Icon(Icons.chat, size: heightDp * 30, color: Colors.blue),
            ),
          ],
        ),
      ],
    );
  }

  void _rewardPointHandler() async {
    if (_storePageProvider!.storePageState.rewardPointData![widget.storeModel!.id] == null) {
      await _keicyProgressDialog!.show();
      await _storePageProvider!.getRewardPoint(storeId: widget.storeModel!.id);
      await _keicyProgressDialog!.hide();
    }

    RewardPointDialog.show(context, _storePageProvider!.storePageState.rewardPointData![widget.storeModel!.id]);
  }

  Widget _storeGalleryPanel() {
    return Card(
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
        child: Row(
          children: [
            Image.asset(
              "img/video_icon.png",
              width: widthDp * 50,
              height: widthDp * 50,
              fit: BoxFit.cover,
            ),
            SizedBox(width: widthDp * 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Access Store Gallery",
                    style: TextStyle(fontSize: fontSp * 16),
                  ),
                  KeicyRaisedButton(
                    width: widthDp * 90,
                    height: heightDp * 30,
                    color: config.Colors().mainColor(1),
                    borderRadius: heightDp * 6,
                    child: Text(
                      "Gallery",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => StoreGalleryPage(
                            galleryData: _storePageProvider!.storePageState.storeGalleryData![widget.storeModel!.id],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appointmentPanel() {
    return Card(
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
        child: Row(
          children: [
            Icon(Icons.event, size: widthDp * 50, color: config.Colors().mainColor(1)),
            SizedBox(width: widthDp * 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Book An Appointment",
                    style: TextStyle(fontSize: fontSp * 16),
                  ),
                  KeicyRaisedButton(
                    width: widthDp * 90,
                    height: heightDp * 30,
                    color: config.Colors().mainColor(1),
                    borderRadius: heightDp * 6,
                    child: Text(
                      "Book",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                    ),
                    onPressed: () {
                      if (AuthProvider.of(context).authState.loginState == LoginState.IsNotLogin ||
                          AuthProvider.of(context).authState.userModel!.id == null) {
                        LoginAskDialog.show(
                          context,
                          callback: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => AppointmentListPage(
                                  storeId: widget.storeModel!.id,
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => AppointmentListPage(
                              storeId: widget.storeModel!.id,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _availableServices() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${StorePageString.availableLabel}:",
            style: TextStyle(fontSize: fontSp * 23, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: heightDp * 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FavoriteProvider.of(context).favoriteUpdateHandler();

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ProductListPage(
                          storeIds: [widget.storeModel!.id!],
                          storeModel: widget.storeModel,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                    color: Colors.white,
                    elevation: 4,
                    child: Container(
                      height: heightDp * 120,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 10),
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "img/products.png",
                            width: heightDp * 70,
                            height: heightDp * 70,
                          ),
                          Text(
                            StorePageString.productsLabel,
                            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FavoriteProvider.of(context).favoriteUpdateHandler();

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => CouponListPage(
                          storeModel: widget.storeModel,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                    color: Colors.white,
                    elevation: 4,
                    child: Container(
                      height: heightDp * 120,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 10),
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "img/coupons.png",
                            width: heightDp * 70,
                            height: heightDp * 70,
                          ),
                          Text(
                            StorePageString.couponsLabel,
                            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FavoriteProvider.of(context).favoriteUpdateHandler();

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => AnnouncementListForALLPage(
                          storeId: widget.storeModel!.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                    color: Colors.white,
                    elevation: 4,
                    child: Container(
                      height: heightDp * 120,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 10),
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "img/announcements.png",
                            width: heightDp * 70,
                            height: heightDp * 70,
                          ),
                          Text(
                            StorePageString.announcementsLabel,
                            style: TextStyle(fontSize: fontSp * 13, color: Colors.black, letterSpacing: -1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: heightDp * 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FavoriteProvider.of(context).favoriteUpdateHandler();

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ServiceListPage(
                          storeIds: [widget.storeModel!.id!],
                          storeModel: widget.storeModel,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                    color: Colors.white,
                    elevation: 4,
                    child: Container(
                      height: heightDp * 120,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 10),
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "img/services.png",
                            width: heightDp * 70,
                            height: heightDp * 70,
                          ),
                          Text(
                            StorePageString.servicesLabel,
                            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (widget.storeModel!.settings!["bargainEnable"]) {
                      if (_authProvider!.authState.loginState == LoginState.IsNotLogin || _authProvider!.authState.userModel!.id == "") {
                        LoginAskDialog.show(
                          context,
                          callback: () {
                            _initHandler();
                            FavoriteProvider.of(context).favoriteUpdateHandler();

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => CreateBargainRequestPage(storeData: widget.storeModel!.toJson()),
                              ),
                            );
                          },
                        );
                      } else {
                        FavoriteProvider.of(context).favoriteUpdateHandler();

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => CreateBargainRequestPage(storeData: widget.storeModel!.toJson()),
                          ),
                        );
                      }
                    } else {
                      NormalDialog.show(context, title: "Bargain Request", content: "Bargain option is disabled by the store");
                    }
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                    color: Colors.white,
                    elevation: 4,
                    child: Container(
                      height: heightDp * 120,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 10),
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "img/bargain.png",
                            width: heightDp * 70,
                            height: heightDp * 70,
                          ),
                          Text(
                            StorePageString.bargainLabel,
                            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FavoriteProvider.of(context).favoriteUpdateHandler();

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => StoreJobPostingsListPage(
                          storeId: widget.storeModel!.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                    color: Colors.white,
                    elevation: 4,
                    child: Container(
                      height: heightDp * 120,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 10),
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "img/jobs.png",
                            width: heightDp * 70,
                            height: heightDp * 70,
                          ),
                          Text(
                            StorePageString.jobsLabel,
                            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _aboutPanel() {
    return Container(
      width: deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "img/aboutus.png",
                width: heightDp * 30,
                height: heightDp * 30,
              ),
              SizedBox(width: widthDp * 10),
              Text(
                "${StorePageString.aboutLabel}:",
                style: TextStyle(fontSize: fontSp * 23, color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: heightDp * 10),
          Text(
            "${widget.storeModel!.description}",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _storeHoursLabel() {
    return Container(
      width: deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "img/store_time.png",
                width: heightDp * 30,
                height: heightDp * 30,
              ),
              SizedBox(width: widthDp * 10),
              Text(
                "${StorePageString.storeHoursLabel}:",
                style: TextStyle(fontSize: fontSp * 23, color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: heightDp * 10),
          Column(
            children: List.generate(
              widget.storeModel!.profile!["hours"].length,
              (index) {
                var hoursData = widget.storeModel!.profile!["hours"][index];
                String openTime = (hoursData["openingTime"] != null && hoursData["openingTime"] != "")
                    ? KeicyDateTime.convertDateTimeToDateString(
                        dateTime: DateTime.tryParse(hoursData["openingTime"]),
                        formats: "h:i A",
                        isUTC: false,
                      )
                    : "";
                String closeTime = (hoursData["closingTime"] != null && hoursData["closingTime"] != "")
                    ? KeicyDateTime.convertDateTimeToDateString(
                        dateTime: DateTime.tryParse(hoursData["closingTime"]),
                        formats: "h:i A",
                        isUTC: false,
                      )
                    : "";
                bool isToday = false;

                if (hoursData["day"] == null) {
                  String day = "";
                  switch (index) {
                    case 0:
                      day = "Moday";
                      break;
                    case 1:
                      day = "Tuesday";
                      break;
                    case 2:
                      day = "Wednesday";
                      break;
                    case 3:
                      day = "Thursday";
                      break;
                    case 4:
                      day = "Friday";
                      break;
                    case 5:
                      day = "Saturday";
                      break;
                    case 6:
                      day = "Sunday";
                      break;
                    default:
                  }

                  hoursData["day"] = day;
                }

                switch (hoursData["day"].toString().toLowerCase()) {
                  case "monday":
                    if (DateTime.now().weekday == DateTime.monday) {
                      isToday = true;
                    }

                    break;
                  case "tuesday":
                    if (DateTime.now().weekday == DateTime.tuesday) {
                      isToday = true;
                    }
                    break;
                  case "wednesday":
                    if (DateTime.now().weekday == DateTime.wednesday) {
                      isToday = true;
                    }
                    break;
                  case "thursday":
                    if (DateTime.now().weekday == DateTime.thursday) {
                      isToday = true;
                    }
                    break;
                  case "friday":
                    if (DateTime.now().weekday == DateTime.friday) {
                      isToday = true;
                    }
                    break;
                  case "saturday":
                    if (DateTime.now().weekday == DateTime.saturday) {
                      isToday = true;
                    }
                    break;
                  case "sunday":
                    if (DateTime.now().weekday == DateTime.sunday) {
                      isToday = true;
                    }
                    break;
                  default:
                }

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${hoursData["day"]}",
                          style: TextStyle(
                            fontSize: fontSp * 16,
                            color: Colors.black,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w300,
                          ),
                        ),
                        !hoursData["isWorkingDay"] || hoursData["hoursBreakdown"] == null
                            ? Column(
                                children: [
                                  Text(
                                    hoursData["isWorkingDay"] ? "$openTime ~ $closeTime" : StorePageString.restDayLabel,
                                    style: TextStyle(
                                      fontSize: fontSp * 16,
                                      color: Colors.black,
                                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w300,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: List.generate(hoursData["hoursBreakdown"].length, (index) {
                                  String fromTime = KeicyDateTime.convertDateTimeToDateString(
                                    dateTime: DateTime.tryParse(hoursData["hoursBreakdown"][index]["fromTime"]),
                                    formats: "h:i A",
                                    isUTC: false,
                                  );
                                  String toTime = KeicyDateTime.convertDateTimeToDateString(
                                    dateTime: DateTime.tryParse(hoursData["hoursBreakdown"][index]["toTime"]),
                                    formats: "h:i A",
                                    isUTC: false,
                                  );
                                  return Text(
                                    "$fromTime ~ $toTime",
                                    style: TextStyle(
                                      fontSize: fontSp * 16,
                                      color: Colors.black,
                                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w300,
                                    ),
                                  );
                                }),
                              ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "img/reviews-icon.png",
                        width: heightDp * 30,
                        height: heightDp * 30,
                      ),
                      SizedBox(width: widthDp * 10),
                      Text(
                        "${StorePageString.reviewLabel}:",
                        style: TextStyle(fontSize: fontSp * 22, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(width: widthDp * 10),
                  KeicyRaisedButton(
                    width: widthDp * 160,
                    height: heightDp * 30,
                    borderRadius: heightDp * 6,
                    color: config.Colors().mainColor(1),
                    child: Text(
                      _storePageProvider!.storePageState.storeReviewData![reviewKey] == null ||
                              _storePageProvider!.storePageState.storeReviewData![reviewKey].isEmpty
                          ? "${StorePageString.addReviewLabel}"
                          : "${StorePageString.editReviewLabel}",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      if (_authProvider!.authState.loginState == LoginState.IsNotLogin || _authProvider!.authState.userModel!.id == null) {
                        LoginAskDialog.show(
                          context,
                          callback: () {
                            _initHandler();

                            FavoriteProvider.of(context).favoriteUpdateHandler();
                            ReviewAndRatingDialog.show(
                              context,
                              _storePageProvider!.storePageState.storeReviewData![reviewKey] ?? Map<String, dynamic>(),
                              callback: (Map<String, dynamic> storeReview) async {
                                _storePageProvider!
                                    .setStorePageState(_storePageProvider!.storePageState.update(progressState: 1), isNotifiable: false);
                                await _keicyProgressDialog!.show();
                                storeReview["userId"] = _authProvider!.authState.userModel!.id;
                                storeReview["storeId"] = widget.storeModel!.id;
                                if (_storePageProvider!.storePageState.storeReviewData![reviewKey] == null ||
                                    _storePageProvider!.storePageState.storeReviewData![reviewKey].isEmpty) {
                                  await _storePageProvider!.createStoreReview(storeReview: storeReview);
                                } else {
                                  await _storePageProvider!.updateStoreReview(storeReview: storeReview);
                                }
                                await _storePageProvider!.getTopReviewList(storeId: widget.storeModel!.id);
                                _keicyProgressDialog!.hide();
                              },
                            );
                          },
                        );
                      } else {
                        FavoriteProvider.of(context).favoriteUpdateHandler();
                        ReviewAndRatingDialog.show(
                          context,
                          _storePageProvider!.storePageState.storeReviewData![reviewKey] ?? Map<String, dynamic>(),
                          callback: (Map<String, dynamic> storeReview) async {
                            _storePageProvider!.setStorePageState(_storePageProvider!.storePageState.update(progressState: 1), isNotifiable: false);
                            await _keicyProgressDialog!.show();
                            storeReview["userId"] = _authProvider!.authState.userModel!.id;
                            storeReview["storeId"] = widget.storeModel!.id;
                            if (_storePageProvider!.storePageState.storeReviewData![reviewKey] == null ||
                                _storePageProvider!.storePageState.storeReviewData![reviewKey].isEmpty) {
                              await _storePageProvider!.createStoreReview(storeReview: storeReview);
                            } else {
                              await _storePageProvider!.updateStoreReview(storeReview: storeReview);
                            }
                            await _storePageProvider!.getTopReviewList(storeId: widget.storeModel!.id);
                            _keicyProgressDialog!.hide();
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            !_storePageProvider!.storePageState.isLoadMore!
                ? SizedBox()
                : GestureDetector(
                    onTap: () {
                      FavoriteProvider.of(context).favoriteUpdateHandler();

                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) => StoreReviewPage(storeData: widget.storeModel!.toJson())),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: heightDp * 15),
                      color: Colors.transparent,
                      child: Text(
                        "Show all",
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
          ],
        ),
        SizedBox(height: heightDp * 10),

        /// top 3 review list
        Column(
          children: List.generate(
            _storePageProvider!.storePageState.topReviewList!.length,
            (index) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: heightDp * 20),
                    child: ReviewAndRatingWidget(
                      reviewAndRatingData: _storePageProvider!.storePageState.topReviewList![index],
                      isLoading: _storePageProvider!.storePageState.topReviewList![index].isEmpty,
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
}
