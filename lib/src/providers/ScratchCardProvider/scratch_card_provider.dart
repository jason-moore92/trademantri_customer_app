import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class ScratchCardProvider extends ChangeNotifier {
  static ScratchCardProvider of(BuildContext context, {bool listen = false}) => Provider.of<ScratchCardProvider>(context, listen: listen);

  ScratchCardState _scratchCardState = ScratchCardState.init();
  ScratchCardState get scratchCardState => _scratchCardState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setScratchCardState(ScratchCardState scratchCardState, {bool isNotifiable = true}) {
    if (_scratchCardState != scratchCardState) {
      _scratchCardState = scratchCardState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getScratchCard({@required String? scratchCardId, bool isNotifiable = true}) async {
    try {
      var result = await ScratchCardApiProvider.scratch(scratchCardId: scratchCardId);

      if (result["success"]) {
        _scratchCardState = _scratchCardState.update(
          progressState: 2,
          message: "",
          scratchCardData: result["data"],
        );
      } else {
        _scratchCardState = _scratchCardState.update(
          progressState: -1,
          message: "",
        );
      }
    } catch (e) {
      _scratchCardState = _scratchCardState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    if (isNotifiable) notifyListeners();
  }
}
