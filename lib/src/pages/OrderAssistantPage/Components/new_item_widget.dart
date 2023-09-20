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
  Map<String, dynamic>? itemData;
  final Function? callback;
  final int? index;
  final Function(int)? deleteCallback;

  final int? length;

  NewItemWidget({
    @required this.storeId,
    @required this.isReadOnly,
    @required this.category,
    @required this.itemData,
    @required this.callback,
    @required this.index,
    @required this.deleteCallback,
    @required this.length,
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
      key: Key("NewItemWidget_${index.toString()}"),
      height: heightDp * 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: heightDp * 10,
            height: heightDp * 10,
            decoration: BoxDecoration(
              color: itemData == null ? Colors.transparent : Colors.green,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(heightDp * 10),
            ),
          ),
          SizedBox(width: widthDp * 10),
          Expanded(
            child: itemData == null
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
                    initValue: itemData!.isEmpty ? "" : itemData!["data"]["name"],
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
                      callback!(itemData ?? Map<String, dynamic>());
                    },
                    suffixIcon: Icon(Icons.close, size: heightDp * 20, color: Colors.grey),
                    isEmpty: itemData!.isEmpty,
                    suggestionPadding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                    suggestTextStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                    completeHandler: (data) {
                      if (itemData == null || itemData!.isEmpty) {
                        itemData = {
                          "orderQuantity": 1,
                          "couponQuantity": 1,
                          "data": {"name": ""}
                        };
                      }
                      itemData!["data"] = data;
                      callback!(itemData);
                    },
                  ),
          ),
          SizedBox(width: widthDp * 10),
          itemData == null || itemData!.isEmpty ? SizedBox(width: widthDp * 100) : _addMoreProductButton(),
          SizedBox(width: widthDp * 10),
          itemData == null || itemData!.isEmpty ? SizedBox(width: widthDp * 100) : _deleteRowButton(),
        ],
      ),
    );
  }

  Widget _deleteRowButton() {
    return InkWell(
      onTap: length! > 1
          ? () {
              deleteCallback!(index!);
            }
          : null,
      child: Icon(
        Icons.delete,
        color: length! > 1 ? null : Colors.grey,
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
                if (isReadOnly! || itemData!.isEmpty) return;
                if (itemData!["orderQuantity"] == 1) {
                  deleteCallback!(index!);
                  return;
                }
                itemData!["orderQuantity"] = itemData!["orderQuantity"] - 1;
                itemData!["couponQuantity"] = itemData!["couponQuantity"] - 1;
                callback!(itemData);
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                child: Row(
                  children: [
                    SizedBox(width: widthDp * 10),
                    Icon(
                      Icons.remove,
                      color: itemData!.isEmpty || itemData!["orderQuantity"] == 0 ? Colors.grey : config.Colors().mainColor(1),
                      size: heightDp * 20,
                    ),
                    SizedBox(width: widthDp * 5),
                  ],
                ),
              ),
            ),
            Text(
              itemData!.isEmpty ? "0" : "${itemData!["orderQuantity"]}",
              style: TextStyle(
                  fontSize: fontSp * 16, color: itemData!.isEmpty ? Colors.grey : config.Colors().mainColor(1), fontWeight: FontWeight.w700),
            ),
            GestureDetector(
              onTap: () async {
                if (isReadOnly! || itemData!.isEmpty) return;
                itemData!["orderQuantity"] = itemData!["orderQuantity"] + 1;
                itemData!["couponQuantity"] = itemData!["couponQuantity"] + 1;
                callback!(itemData);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                color: Colors.transparent,
                child: Row(
                  children: [
                    SizedBox(width: widthDp * 5),
                    Icon(Icons.add, color: itemData!.isEmpty ? Colors.grey : config.Colors().mainColor(1), size: heightDp * 20),
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
