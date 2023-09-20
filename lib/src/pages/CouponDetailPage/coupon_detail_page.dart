import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class CouponDetailPage extends StatefulWidget {
  final CouponModel? couponModel;
  final StoreModel? storeModel;

  final String? couponId;
  final String? storeId;

  CouponDetailPage({this.storeModel, this.couponModel, this.couponId, this.storeId});

  @override
  _CouponDetailPageState createState() => _CouponDetailPageState();
}

class _CouponDetailPageState extends State<CouponDetailPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.couponModel == null && widget.couponId != null) {
      return StreamBuilder<dynamic>(
        stream: Stream.fromFuture(
          CouponsApiProvider.getCoupon(couponId: widget.couponId),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(body: Center(child: CupertinoActivityIndicator()));
          }

          if (snapshot.hasError || !snapshot.data["success"] || snapshot.data["data"].isEmpty) {
            return ErrorPage(
              message: "Something Wrong",
              callback: () {
                setState(() {});
              },
            );
          }

          return CouponDetailView(
            storeModel: StoreModel.fromJson(snapshot.data["data"][0]["store"]),
            couponModel: CouponModel.fromJson(snapshot.data["data"][0]),
          );
        },
      );
    }
    return CouponDetailView(storeModel: widget.storeModel, couponModel: widget.couponModel);
  }
}
