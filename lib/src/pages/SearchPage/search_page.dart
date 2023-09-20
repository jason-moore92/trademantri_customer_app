import 'package:flutter/material.dart';

import 'index.dart';

class SearchPage extends StatelessWidget {
  final Map<String, dynamic>? categoryData;
  final bool isFromCategory;
  final bool forSelection;
  final bool? onlyStore;

  SearchPage({
    @required this.categoryData,
    this.isFromCategory = false,
    this.forSelection = false,
    @required this.onlyStore,
  });

  @override
  Widget build(BuildContext context) {
    return SearchView(
      categoryData: categoryData,
      forSelection: forSelection,
      isFromCategory: isFromCategory,
      onlyStore: onlyStore,
    );
  }
}
