import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';

import 'index.dart';

class StorePage extends StatefulWidget {
  final StoreModel? storeModel;
  final String? storeId;

  StorePage({this.storeModel, this.storeId});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    if (widget.storeModel == null && widget.storeId != null) {
      return StreamBuilder<dynamic>(
          stream: Stream.fromFuture(StoreApiProvider.getStoreData(id: widget.storeId)),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                if (snapshot.hasData && snapshot.data["success"]) {
                  return StoreView(storeModel: StoreModel.fromJson(snapshot.data["data"]));
                } else {
                  return ErrorPage(
                    message: snapshot.hasData ? snapshot.data["message"] ?? "" : "No order data",
                    callback: () {
                      setState(() {});
                    },
                  );
                }
              default:
            }
            return Scaffold(body: Center(child: CupertinoActivityIndicator()));
          });
    } else {
      return StoreView(storeModel: widget.storeModel);
    }
  }
}
