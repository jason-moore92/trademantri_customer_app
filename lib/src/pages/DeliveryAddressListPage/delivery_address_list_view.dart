import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/ApiDataProviders/delivery_address_api_provider.dart';
import 'package:trapp/src/dialogs/error_dialog.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/pages/DeliveryPickupPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class DeliveryAddressListView extends StatefulWidget {
  DeliveryAddressListView({
    Key? key,
  }) : super(key: key);

  @override
  _DeliveryAddressListViewState createState() => _DeliveryAddressListViewState();
}

class _DeliveryAddressListViewState extends State<DeliveryAddressListView> with SingleTickerProviderStateMixin {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  DeliveryAddressProvider? _deliveryAddressProvider;

  KeicyProgressDialog? _keicyProgressDialog;

  List<dynamic> _deliveryAddresses = [];

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

    _deliveryAddressProvider = DeliveryAddressProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _deliveryAddresses = _deliveryAddressProvider!.deliveryAddressState.deliveryAddressData![AuthProvider.of(context).authState.userModel!.id] ?? [];

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    _deliveryAddressProvider!.removeListener(_deliveryAddressProviderListener);

    super.dispose();
  }

  void _deliveryAddressProviderListener() async {}

  void _deleteHandler(Map<String, dynamic> deliveryAddress, int index) async {
    await _keicyProgressDialog!.show();

    var result = await DeliveryAddressApiProvider.delete(id: deliveryAddress["_id"]);
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _deliveryAddresses.removeAt(index);
      _deliveryAddressProvider!.deliveryAddressState.deliveryAddressData![AuthProvider.of(context).authState.userModel!.id!] = _deliveryAddresses;

      _deliveryAddressProvider!.setDeliveryAddressState(
        _deliveryAddressProvider!.deliveryAddressState.update(
          deliveryAddressData: _deliveryAddressProvider!.deliveryAddressState.deliveryAddressData,
        ),
      );

      setState(() {});
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
      );
    }
  }

  void _editHandler(Map<String, dynamic> deliveryAddress, int index) async {
    var NewDeliveryAddress = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => DeliveryPickupPage(
          deliveryAddress: deliveryAddress,
          forEdit: true,
        ),
      ),
    );

    if (NewDeliveryAddress != null) {
      await _keicyProgressDialog!.show();

      var result = await DeliveryAddressApiProvider.updateDeliveryAddress(
        id: NewDeliveryAddress["_id"],
        deliveryAddressData: NewDeliveryAddress,
      );
      await _keicyProgressDialog!.hide();

      if (result["success"]) {
        _deliveryAddresses[index] = NewDeliveryAddress;
        _deliveryAddressProvider!.deliveryAddressState.deliveryAddressData![AuthProvider.of(context).authState.userModel!.id!] = _deliveryAddresses;

        _deliveryAddressProvider!.setDeliveryAddressState(
          _deliveryAddressProvider!.deliveryAddressState.update(
            deliveryAddressData: _deliveryAddressProvider!.deliveryAddressState.deliveryAddressData,
          ),
        );

        setState(() {});
      } else {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: result["message"],
        );
      }
    }
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
        appBar: AppBar(
          title: Text(
            "My Delivery Address",
            style: TextStyle(fontSize: fontSp * 18),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          width: deviceWidth,
          height: deviceHeight,
          child: ListView.builder(
            itemCount: _deliveryAddresses.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 8),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${_deliveryAddresses[index]["addressType"]}",
                            style: TextStyle(
                              fontSize: fontSp * 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _editHandler(_deliveryAddresses[index], index);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                                  color: Colors.transparent,
                                  child: Icon(Icons.edit, size: heightDp * 25),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _deleteHandler(_deliveryAddresses[index], index);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                                  color: Colors.transparent,
                                  child: Icon(Icons.delete, size: heightDp * 25),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp * 5),
                      if (_deliveryAddresses[index]["building"] != null && _deliveryAddresses[index]["building"] != "")
                        Column(
                          children: [
                            Text(
                              "${_deliveryAddresses[index]["building"]}",
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: heightDp * 5),
                          ],
                        ),
                      Text(
                        "${_deliveryAddresses[index]["address"]["address"]}",
                        style: TextStyle(
                          fontSize: fontSp * 14,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
