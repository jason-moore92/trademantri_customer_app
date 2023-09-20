import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/pages/ProductListPage/index.dart';
import 'package:trapp/src/pages/ServiceListPage/index.dart';
import 'package:trapp/src/pages/CustomProductPage/index.dart';
import 'package:trapp/src/pages/StorePage/index.dart';

class ProductItemBottomSheet {
  static void show(
    context, {
    @required List<String>? storeIds,
    @required Function(String, Map<String, dynamic>)? callback,
    bool? bargainAvailable,
  }) {
    /// Responsive design variables
    double deviceWidth = 0;
    double widthDp = 0;
    double heightDp = 0;
    double fontSp = 0;

    ///////////////////////////////
    /// Responsive design variables
    deviceWidth = 1.sw;

    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    ///////////////////////////////
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return new Wrap(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(heightDp * 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(heightDp * 30),
                  topRight: Radius.circular(heightDp * 30),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    width: deviceWidth,
                    padding: EdgeInsets.all(heightDp * 10.0),
                    child: Text(
                      "Choose Option",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ProductListPage(
                                storeIds: storeIds!,
                                storeModel: null,
                                isForSelection: true,
                                bargainAvailable: bargainAvailable,
                              ),
                            ),
                          );

                          if (result != null) {
                            Navigator.of(context).pop();
                            callback!("products", result);
                          }
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                          color: Colors.white,
                          elevation: 4,
                          child: Container(
                            width: heightDp * 110,
                            height: heightDp * 130,
                            padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
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
                                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ServiceListPage(
                                storeIds: storeIds!,
                                storeModel: null,
                                isForSelection: true,
                              ),
                            ),
                          );

                          if (result != null) {
                            Navigator.of(context).pop();
                            callback!("services", result);
                          }
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                          color: Colors.white,
                          elevation: 4,
                          child: Container(
                            width: heightDp * 110,
                            height: heightDp * 130,
                            padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
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
                                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => CustomProductPage(callback: callback!),
                            ),
                          );

                          if (result != null) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                          color: Colors.white,
                          elevation: 4,
                          child: Container(
                            width: heightDp * 110,
                            height: heightDp * 130,
                            padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                            alignment: Alignment.center,
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  "img/custom.png",
                                  width: heightDp * 70,
                                  height: heightDp * 70,
                                ),
                                Text(
                                  StorePageString.customItem,
                                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
