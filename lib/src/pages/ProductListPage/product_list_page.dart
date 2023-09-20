import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class ProductListPage extends StatelessWidget {
  final List<String>? storeIds;
  final StoreModel? storeModel;
  final bool isForSelection;
  final bool? bargainAvailable;

  ProductListPage({
    @required this.storeIds,
    @required this.storeModel,
    this.isForSelection = false,
    this.bargainAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductListPageProvider()),
      ],
      child: ProductListView(
        storeIds: storeIds,
        storeModel: storeModel,
        isForSelection: isForSelection,
        bargainAvailable: bargainAvailable,
      ),
    );
  }
}
