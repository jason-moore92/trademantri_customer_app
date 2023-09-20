import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/search_product_widget.dart';
import 'package:trapp/src/providers/DeliveryAddressProvider/delivery_address_provider.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/app_config.dart' as config;

class NewItemWidget extends StatelessWidget {
  final String? storeId;
  final bool? isReadOnly;
  final String? category;
  Map<String, dynamic>? productData;
  final Function? callback;
  final int? index;
  final Function(int)? deleteCallback;

  NewItemWidget({
    @required this.storeId,
    @required this.isReadOnly,
    @required this.category,
    @required this.productData,
    @required this.callback,
    @required this.index,
    @required this.deleteCallback,
  });

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
  Widget build(BuildContext context) {
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

    return Container(
      height: heightDp * 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: heightDp * 10,
            height: heightDp * 10,
            decoration: BoxDecoration(
              color: productData == null ? Colors.transparent : Colors.green,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(heightDp * 10),
            ),
          ),
          SizedBox(width: widthDp * 10),
          Expanded(
            child: productData == null
                ? GestureDetector(
                    onTap: () {
                      if (isReadOnly!) return;
                      callback!(null, isNew: true);
                    },
                    child: Row(
                      children: [
                        Text(
                          "+ Add $category",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        ),
                      ],
                    ),
                  )
                : SearchProductWidget(
                    initValue: productData!.isEmpty ? "" : productData!["data"]["name"],
                    storeId: storeId,
                    category: category,
                    height: heightDp * 40,
                    textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                    hint: "Type the $category name",
                    fillColor: Colors.transparent,
                    contentHorizontalPadding: 0,
                    isReadOnly: isReadOnly!,
                    initHandler: () {
                      callback!(productData ?? Map<String, dynamic>());
                    },
                    suffixIcon: Icon(Icons.close, size: heightDp * 20, color: Colors.grey),
                    isEmpty: productData!.isEmpty,
                    suggestionPadding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                    suggestTextStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                    completeHandler: (data) {
                      if (productData == null || productData!.isEmpty) {
                        productData = {
                          "orderQuantity": 1,
                          "data": {"name": ""}
                        };
                      }
                      productData!["data"] = data;
                      callback!(productData);
                    },
                  ),
          ),
          SizedBox(width: widthDp * 10),
          productData == null || productData!.isEmpty ? SizedBox(width: widthDp * 100) : _addMoreProductButton(),
        ],
      ),
    );
  }

  Widget _addMoreProductButton() {
    return Consumer<DeliveryAddressProvider>(builder: (context, deliveryAddressProvider, _) {
      return Container(
        width: widthDp * 100,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () async {
                if (isReadOnly! || productData!.isEmpty) return;
                if (productData!["orderQuantity"] == 1) {
                  deleteCallback!(index!);
                  return;
                }
                productData!["orderQuantity"] = productData!["orderQuantity"] - 1;
                callback!(productData);
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                child: Row(
                  children: [
                    SizedBox(width: widthDp * 10),
                    Icon(
                      Icons.remove,
                      color: productData!.isEmpty || productData!["orderQuantity"] == 0 ? Colors.grey : config.Colors().mainColor(1),
                      size: heightDp * 20,
                    ),
                    SizedBox(width: widthDp * 5),
                  ],
                ),
              ),
            ),
            Text(
              productData!.isEmpty ? "0" : "${productData!["orderQuantity"]}",
              style: TextStyle(
                  fontSize: fontSp * 16, color: productData!.isEmpty ? Colors.grey : config.Colors().mainColor(1), fontWeight: FontWeight.w700),
            ),
            GestureDetector(
              onTap: () async {
                if (isReadOnly! || productData!.isEmpty) return;
                productData!["orderQuantity"] = productData!["orderQuantity"] + 1;
                callback!(productData);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                color: Colors.transparent,
                child: Row(
                  children: [
                    SizedBox(width: widthDp * 5),
                    Icon(Icons.add, color: productData!.isEmpty ? Colors.grey : config.Colors().mainColor(1), size: heightDp * 20),
                    SizedBox(width: widthDp * 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
