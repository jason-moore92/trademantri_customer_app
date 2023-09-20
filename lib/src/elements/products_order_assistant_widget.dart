import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/OrderAssistantPage/index.dart';
import 'package:trapp/src/providers/index.dart';

class ProductsOrderAssistantWidget extends StatefulWidget {
  final StoreModel? storeModel;
  final EdgeInsetsGeometry? margin;

  ProductsOrderAssistantWidget({@required this.storeModel, this.margin});

  @override
  _BargainRequestWidgetState createState() => _BargainRequestWidgetState();
}

class _BargainRequestWidgetState extends State<ProductsOrderAssistantWidget> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: widget.margin ?? EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 5),
      color: Color(0xFFFFF5C1),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 8)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 8)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Have some specific things in mind?", style: TextStyle(fontSize: fontSp * 13, color: Colors.black)),
                  SizedBox(height: heightDp * 5),
                  Text("Make a list of items you need", style: TextStyle(fontSize: fontSp * 13, color: Colors.black, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            KeicyRaisedButton(
              width: widthDp * 100,
              height: heightDp * 35,
              borderRadius: heightDp * 40,
              color: Color(0xFFEA5151),
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text("Create list", style: TextStyle(fontSize: fontSp * 13, color: Colors.white)),
              onPressed: () {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsNotLogin ||
                    AuthProvider.of(context).authState.userModel!.id == null) {
                  LoginAskDialog.show(
                    context,
                    callback: () {
                      _assistantHandler();
                    },
                  );
                } else {
                  _assistantHandler();
                }
              },
            ),
          ],
        ),
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

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => OrderAssistantPage(
          orderModel: orderModel,
          selectedStoreData: selectedStoreData,
          haveProducts: true,
          haveServices: true,
        ),
      ),
    );
  }
}
