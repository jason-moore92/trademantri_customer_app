import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RefreshProvider extends ChangeNotifier {
  static RefreshProvider of(BuildContext context, {bool listen = false}) => Provider.of<RefreshProvider>(context, listen: listen);

  void refresh() {
    notifyListeners();
  }
}
