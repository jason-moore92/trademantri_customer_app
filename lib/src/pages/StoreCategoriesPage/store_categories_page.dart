import 'package:flutter/material.dart';

import 'index.dart';

class StoreCategoriesPage extends StatelessWidget {
  final bool? forSelection;
  final bool? onlyStore;

  StoreCategoriesPage({
    this.forSelection = false,
    @required this.onlyStore,
  });
  @override
  Widget build(BuildContext context) {
    return StoreCategoriesView(forSelection: forSelection, onlyStore: onlyStore);
  }
}
