import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:json_diff/json_diff.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/environment.dart';
import 'package:trapp/src/elements/tip_panel.dart';
import 'package:trapp/src/helpers/price_functions.dart';
import 'package:trapp/src/helpers/price_functions1.dart';
import 'package:trapp/src/helpers/store_time_validation.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/DeliveryPickupPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/elements/cash_on_delivery_option_panel.dart';

import '../pages/CheckOutPage/index.dart';
import 'delivery_address_bottomsheet.dart';
import 'delivery_option_panel.dart';

class DeliveryPanel extends StatefulWidget {
  final OrderModel? orderModel;
  final Map<String, dynamic>? deliveryPartner;
  final bool? checkMinAmount;
  final Function()? refreshCallback;

  DeliveryPanel({
    @required this.orderModel,
    @required this.deliveryPartner,
    @required this.refreshCallback,
    this.checkMinAmount = true,
  });

  @override
  _DeliveryPanelState createState() => _DeliveryPanelState();
}

class _DeliveryPanelState extends State<DeliveryPanel> {
  /// Responsive design variables
  double? deviceWidth;
  double? deviceHeight;
  double? statusbarHeight;
  double? bottomBarHeight;
  double? appbarHeight;
  double? widthDp;
  double? heightDp;
  double? heightDp1;
  double? fontSp;
  ///////////////////////////////

  DeliveryAddressProvider? _deliveryAddressProvider;
  DeliveryPartnerProvider? _deliveryPartnerProvider;

  double _maxDeliveryDistance = 0;

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
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    DeliveryPartnerProvider.of(context).setDeliveryPartnerState(
      DeliveryPartnerState.init(),
      isNotifiable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool validate = StoreTimeValidation.validate(dateTime: DateTime.now(), storeModel: widget.orderModel!.storeModel);
    if (!validate) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp! * 10, vertical: heightDp! * 10),
        child: Text(
          "We dont offer delivery service at this time as the store is closed. Please choose pick up option.",
          style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
        ),
      );
    }
    return Consumer2<DeliveryAddressProvider, DeliveryPartnerProvider>(
      builder: (context, deliveryAddressProvider, deliveryPartnerProvider, _) {
        _deliveryAddressProvider = DeliveryAddressProvider.of(context);
        _deliveryPartnerProvider = DeliveryPartnerProvider.of(context);

        Map<String, dynamic> oldDeliveryPartnerDetails = json.decode(json.encode(widget.orderModel!.deliveryPartnerDetails));
        Map<String, dynamic>? oldDeliveryAddress =
            widget.orderModel!.deliveryAddress != null ? json.decode(json.encode(widget.orderModel!.deliveryAddress)) : null;

        // init setting
        if (widget.orderModel!.storeModel!.deliveryInfo == null) {
          widget.orderModel!.storeModel!.deliveryInfo!.mode = "NO_DELIVERY_CHOICE";
        }

        if (widget.orderModel!.storeModel!.deliveryInfo != null && widget.orderModel!.storeModel!.deliveryInfo!.mode == "") {
          widget.orderModel!.storeModel!.deliveryInfo!.mode = "NO_DELIVERY_CHOICE";
        }

        /// if mode is DELIVERY_BY_PARTNER and deliveryPartner is available
        if (widget.orderModel!.storeModel!.deliveryInfo!.mode == "DELIVERY_BY_PARTNER" &&
            widget.deliveryPartner != null &&
            widget.deliveryPartner!.isNotEmpty &&
            widget.deliveryPartner!["enabled"]) {
          double totalOriginPrice = PriceFunctions1.getTotalOrignPrice(orderModel: widget.orderModel);

          /// compare with totalOrigianlPrice and minAmountForDelivery
          if (widget.checkMinAmount!) {
            if (totalOriginPrice < double.parse(widget.orderModel!.storeModel!.deliveryInfo!.minAmountForDelivery.toString())) {
              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                widget.orderModel!.deliveryPartnerDetails = Map<String, dynamic>();
                _deliveryAddressProvider!.setDeliveryAddressState(
                  _deliveryAddressProvider!.deliveryAddressState.update(selectedDeliveryAddress: Map<String, dynamic>()),
                );
              });

              return Container(
                padding: EdgeInsets.symmetric(horizontal: widthDp! * 10, vertical: heightDp! * 10),
                child: Text(
                  "The Minimum amount for delivery is ${widget.orderModel!.storeModel!.deliveryInfo!.minAmountForDelivery}",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
              );
            }
          }

          _maxDeliveryDistance = double.parse(widget.deliveryPartner!["charges"].last["maxKm"].toString());

          _deliveryAddressProvider!.setDeliveryAddressState(
            _deliveryAddressProvider!.deliveryAddressState.update(maxDeliveryDistance: _maxDeliveryDistance),
            isNotifiable: false,
          );

          /// calculate the partnerDetials
          if (deliveryAddressProvider.deliveryAddressState.selectedDeliveryAddress!.isNotEmpty) {
            FlutterLogs.logInfo(
              "delivery_panel",
              "selectedDeliveryAddress",
              deliveryAddressProvider.deliveryAddressState.selectedDeliveryAddress.toString(),
            );
            widget.orderModel!.deliveryAddress =
                DeliveryAddressModel.fromJson(_deliveryAddressProvider!.deliveryAddressState.selectedDeliveryAddress!);

            Map<String, dynamic>? deliveryPartnerDetails = DeliveryPartnerProvider.of(context).getDeliveryPartnerDetail1(
              deliveryAddressProvider.deliveryAddressState.selectedDeliveryAddress!,
              widget.deliveryPartner!,
            );

            if (deliveryPartnerDetails != null) {
              widget.orderModel!.deliveryAddress =
                  DeliveryAddressModel.fromJson(_deliveryAddressProvider!.deliveryAddressState.selectedDeliveryAddress!);
              widget.orderModel!.deliveryPartnerDetails = deliveryPartnerDetails;
              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                _deliveryPartnerProvider!.setDeliveryPartnerState(
                  _deliveryPartnerProvider!.deliveryPartnerState.update(noDeliveryPartner: false),
                  // isNotifiable: false,
                );
              });
            } else {
              widget.orderModel!.deliveryAddress = null;
              widget.orderModel!.deliveryPartnerDetails = Map<String, dynamic>();

              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                _deliveryPartnerProvider!.setDeliveryPartnerState(
                  _deliveryPartnerProvider!.deliveryPartnerState.update(noDeliveryPartner: true),
                  isNotifiable: false,
                );
                _deliveryAddressProvider!.setDeliveryAddressState(
                  _deliveryAddressProvider!.deliveryAddressState.update(
                    selectedDeliveryAddress: Map<String, dynamic>(),
                  ),
                );
              });
            }
          }

          //TODO:: go to tm parters if zipcode not available. if selected address is not empty.
        }

        if (widget.orderModel!.storeModel!.deliveryInfo!.mode == "DELIVERY_BY_OWN") {
          _maxDeliveryDistance = double.parse(
            widget.orderModel!.storeModel!.deliveryInfo!.deliveryDistance.toString().toLowerCase().replaceAll("km", ""),
          );

          _deliveryAddressProvider!.setDeliveryAddressState(
            _deliveryAddressProvider!.deliveryAddressState.update(maxDeliveryDistance: _maxDeliveryDistance),
            isNotifiable: false,
          );

          widget.orderModel!.deliveryAddress = DeliveryAddressModel.fromJson(_deliveryAddressProvider!.deliveryAddressState.selectedDeliveryAddress!);
          widget.orderModel!.deliveryPartnerDetails = Map<String, dynamic>();
        }

        if (widget.orderModel!.storeModel!.deliveryInfo!.mode == "NO_DELIVERY_CHOICE") {
          /// find delivery Partners in this ared
          if (_deliveryPartnerProvider!.deliveryPartnerState.progressState == 0) {
            _deliveryPartnerProvider!.getDeliveryPartnerData(zipCode: widget.orderModel!.storeModel!.zipCode);
          }

          if (deliveryPartnerProvider.deliveryPartnerState.progressState == 0 || deliveryPartnerProvider.deliveryPartnerState.progressState == 1) {
            return Center(
              child: Padding(padding: EdgeInsets.symmetric(vertical: heightDp! * 20), child: CupertinoActivityIndicator()),
            );
          }

          if (deliveryPartnerProvider.deliveryPartnerState.progressState == -1) {
            return _noDeliveryPartnersPanel();
          }

          /// if there are delivery partners in this area
          if (deliveryPartnerProvider.deliveryPartnerState.deliveryPartnerData!.isNotEmpty) {
            /// get MaxDdelivery distance
            for (var i = 0; i < deliveryPartnerProvider.deliveryPartnerState.deliveryPartnerData!.length; i++) {
              Map<String, dynamic> deliveryPartner = deliveryPartnerProvider.deliveryPartnerState.deliveryPartnerData![i];
              if (_maxDeliveryDistance < double.parse(deliveryPartner["charges"].last["maxKm"].toString())) {
                _maxDeliveryDistance = double.parse(deliveryPartner["charges"].last["maxKm"].toString());
              }
            }

            _deliveryAddressProvider!.setDeliveryAddressState(
              _deliveryAddressProvider!.deliveryAddressState.update(maxDeliveryDistance: _maxDeliveryDistance),
              isNotifiable: false,
            );

            if (_deliveryAddressProvider!.deliveryAddressState.selectedDeliveryAddress!.isNotEmpty) {
              Map<String, dynamic> deliveryPartnerDetails = deliveryPartnerProvider.getDeliveryPartnerDetail(
                _deliveryAddressProvider!.deliveryAddressState.selectedDeliveryAddress!,
                _maxDeliveryDistance,
              );

              if (deliveryPartnerDetails.isNotEmpty) {
                widget.orderModel!.deliveryAddress =
                    DeliveryAddressModel.fromJson(_deliveryAddressProvider!.deliveryAddressState.selectedDeliveryAddress!);
                widget.orderModel!.deliveryPartnerDetails = deliveryPartnerDetails;
                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                  _deliveryPartnerProvider!.setDeliveryPartnerState(
                    _deliveryPartnerProvider!.deliveryPartnerState.update(noDeliveryPartner: false),
                    // isNotifiable: false,
                  );
                });
              } else {
                widget.orderModel!.deliveryAddress = null;
                widget.orderModel!.deliveryPartnerDetails = Map<String, dynamic>();

                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                  _deliveryPartnerProvider!.setDeliveryPartnerState(
                    _deliveryPartnerProvider!.deliveryPartnerState.update(noDeliveryPartner: true),
                    isNotifiable: false,
                  );
                  _deliveryAddressProvider!.setDeliveryAddressState(
                    _deliveryAddressProvider!.deliveryAddressState.update(
                      selectedDeliveryAddress: Map<String, dynamic>(),
                    ),
                  );
                });
              }
            } else {
              widget.orderModel!.deliveryAddress = null;
              widget.orderModel!.deliveryPartnerDetails = Map<String, dynamic>();
            }
          }

          /// if there are not delivery partners in this area, will check  NO_DELIVERY_CHOICE
          else if (widget.orderModel!.storeModel!.deliveryInfo!.mode == "NO_DELIVERY_CHOICE") {
            return _noDeliveryService();
          } else if (deliveryPartnerProvider.deliveryPartnerState.progressState == 2 &&
              deliveryPartnerProvider.deliveryPartnerState.deliveryPartnerData!.length == 0) {
            return _noDeliveryPartnersPanel();
          }
        }

        ///////
        String? oldDeliveryPartnerId;
        String? deliveryPartnerId;

        if (oldDeliveryPartnerDetails != null && oldDeliveryPartnerDetails.isNotEmpty) {
          oldDeliveryPartnerId = oldDeliveryPartnerDetails["deliveryPartnerId"];
        }
        if (widget.orderModel!.deliveryPartnerDetails != null && widget.orderModel!.deliveryPartnerDetails!.isNotEmpty) {
          deliveryPartnerId = widget.orderModel!.deliveryPartnerDetails!["deliveryPartnerId"];
        }

        String? oldAddressPlaceId;
        String? addressPlaceId;
        if (oldDeliveryAddress != null && oldDeliveryAddress["address"] != null) {
          oldAddressPlaceId = oldDeliveryAddress["address"]["placeId"];
        }
        if (widget.orderModel!.deliveryAddress != null && widget.orderModel!.deliveryAddress!.address != null) {
          addressPlaceId = widget.orderModel!.deliveryAddress!.address!.placeId;
        }

        if (oldDeliveryPartnerId != deliveryPartnerId || oldAddressPlaceId != addressPlaceId) {
          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            widget.refreshCallback!();
          });
        }

        // if (((oldDeliveryPartnerDetails.isNotEmpty || widget.orderModel!.deliveryPartnerDetails!.isNotEmpty) &&
        //         !(JsonDiffer.fromJson(oldDeliveryPartnerDetails, widget.orderModel!.deliveryPartnerDetails ?? Object()).diff().hasNothing)) ||
        //     ((oldDeliveryAddress != null || (widget.orderModel!.deliveryAddress != null && widget.orderModel!.deliveryAddress!.address != null)) &&
        //         !(JsonDiffer.fromJson(oldDeliveryAddress ?? Object(), widget.orderModel!.deliveryAddress ?? Object()).diff().hasNothing))) {
        //   // if (oldDeliveryPartnerDetails.toString() != widget.orderModel.deliveryPartnerDetails.toString()) {
        //   WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        //     widget.refreshCallback!();
        //   });
        // }

        return Container(
          padding: EdgeInsets.symmetric(vertical: heightDp! * 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _deliveryAddressPanel(),
              widget.orderModel!.deliveryAddress == null
                  ? SizedBox()
                  : Column(
                      children: [
                        SizedBox(height: heightDp! * 20),
                        Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
                        DeliveryOptionPanel(orderModel: widget.orderModel),
                        Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
                        CashOnDeliveryPanel(orderModel: widget.orderModel),
                        Divider(height: 3, thickness: 3, color: Colors.black.withOpacity(0.1)),
                        TipPanel(
                          orderModel: widget.orderModel!,
                          refreshCallback: widget.refreshCallback!,
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _noDeliveryPartnersPanel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp! * 10, vertical: heightDp! * 10),
      child: Text(
        "We don’t offer delivery service. Please choose pickup.",
        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
      ),
    );
  }

  Widget _noDeliveryService() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp! * 10, vertical: heightDp! * 10),
      child: Text(
        "We don't delivery to this area yet, please choose pickup.",
        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
      ),
    );
  }

  Widget _deliveryAddressPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined, size: heightDp! * 25, color: config.Colors().mainColor(1)),
              SizedBox(width: widthDp! * 10),
              Expanded(
                child: _deliveryPartnerProvider!.deliveryPartnerState.noDeliveryPartner!
                    ? Text(
                        "We dont deliver to this address, please choose a different address or pickup option",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                      )
                    : widget.orderModel!.deliveryAddress == null || widget.orderModel!.deliveryAddress!.address == null
                        ? Row(
                            children: [
                              Text(
                                "Add an address to proceed",
                                style: TextStyle(fontSize: fontSp! * 16, color: Colors.black, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                " *",
                                style: TextStyle(fontSize: fontSp! * 18, color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${widget.orderModel!.deliveryAddress!.addressType}",
                                    style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(width: widthDp! * 10),
                                  Text(
                                    "${(widget.orderModel!.deliveryAddress!.distance! / 1000).toStringAsFixed(3)} Km",
                                    style: TextStyle(fontSize: fontSp! * 12, color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: heightDp! * 5),
                              widget.orderModel!.deliveryAddress!.building == ""
                                  ? SizedBox()
                                  : Column(
                                      children: [
                                        Text(
                                          "${widget.orderModel!.deliveryAddress!.building}",
                                          style: TextStyle(fontSize: fontSp! * 12, color: Colors.black),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: heightDp! * 5),
                                      ],
                                    ),
                              Text(
                                "${widget.orderModel!.deliveryAddress!.address!.address}",
                                style: TextStyle(fontSize: fontSp! * 12, color: Colors.black),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
              ),
            ],
          ),
        ),
        SizedBox(width: widthDp! * 10),
        GestureDetector(
          onTap: () async {
            if (_deliveryAddressProvider!.deliveryAddressState.deliveryAddressData![AuthProvider.of(context).authState.userModel!.id] != null &&
                _deliveryAddressProvider!.deliveryAddressState.deliveryAddressData![AuthProvider.of(context).authState.userModel!.id].isEmpty) {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => DeliveryPickupPage(
                    orderModel: widget.orderModel!,
                  ),
                ),
              );
            } else {
              await DeliveryAddressBottomSheet.show(context, orderModel: widget.orderModel);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: widthDp! * 10, vertical: heightDp! * 10),
            decoration: BoxDecoration(color: config.Colors().mainColor(1), borderRadius: BorderRadius.circular(heightDp! * 6)),
            child: Text(
              widget.orderModel!.deliveryAddress == null && !_deliveryPartnerProvider!.deliveryPartnerState.noDeliveryPartner! ? "Add" : "Change",
              style: TextStyle(fontSize: fontSp! * 12, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
