// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:multiple_stream_builder/multiple_stream_builder.dart';
// import 'package:trapp/src/ApiDataProviders/index.dart';
// import 'package:trapp/src/models/index.dart';

// import 'index.dart';

// class ProductItemDetailPage extends StatelessWidget {
//   final StoreModel? storeModel;
//   final Map<String, dynamic>? itemData;
//   final String? storeId;
//   final String? itemId;
//   final String? type;
//   final bool isForCart;

//   ProductItemDetailPage({
//     this.storeModel,
//     this.itemData,
//     this.storeId,
//     this.itemId,
//     @required this.type,
//     this.isForCart = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (itemData == null && itemId != null && storeModel == null && storeId != null) {
//       Stream<dynamic> storeStream = Stream.fromFuture(StoreApiProvider.getStoreData(id: storeId));
//       Stream<dynamic> itemStream;
//       if (type == "products") {
//         itemStream = Stream.fromFuture(ProductApiProvider.getProduct(id: itemId));
//       } else {
//         itemStream = Stream.fromFuture(ServiceApiProvider.getService(id: itemId));
//       }

//       return StreamBuilder2<dynamic, dynamic>(
//         streams: Tuple2(storeStream, itemStream),
//         builder: (context, snapshots) {
//           if (!snapshots.item1.hasData || !snapshots.item2.hasData) {
//             return Scaffold(body: Center(child: CupertinoActivityIndicator()));
//           }

//           return ProductItemDetailView(
//             storeModel: StoreModel.fromJson(snapshots.item1.data["data"]),
//             itemData: snapshots.item2.data["data"],
//             type: type,
//             isForCart: isForCart,
//           );
//         },
//       );
//     } else {
//       return ProductItemDetailView(
//         storeModel: storeModel,
//         itemData: itemData,
//         type: type,
//         isForCart: isForCart,
//       );
//     }
//   }
// }
