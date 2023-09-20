import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LocationProvider extends ChangeNotifier {
  static LocationProvider of(BuildContext context, {bool listen = false}) => Provider.of<LocationProvider>(context, listen: listen);

  // LatLng _lastIdleLocation;
  // LatLng get lastIdleLocation => _lastIdleLocation;

  Map<String, dynamic>? _lastDeliveryAddress;
  Map<String, dynamic>? get lastDeliveryAddress => _lastDeliveryAddress;

  int _progressStatus = 0; // 0: init, 1: progressing, 2: successs, 3: over distance,4: can't find addrsss
  int get progressStatus => _progressStatus;

  // void setLastIdleLocation(LatLng lastIdleLocation) {
  //   if (_lastIdleLocation != lastIdleLocation) {
  //     _lastIdleLocation = lastIdleLocation;
  //     notifyListeners();
  //   }
  // }

  String _statusString = "";
  String get statusString => _statusString;

  void setlastDeliveryAddress(Map<String, dynamic> lastDeliveryAddress, {bool isNotifable = true}) {
    if (_lastDeliveryAddress != lastDeliveryAddress) {
      _lastDeliveryAddress = lastDeliveryAddress;
      if (isNotifable) notifyListeners();
    }
  }

  void setProgressStatus(int progressStatus, {bool isNotifable = true}) {
    if (_progressStatus != progressStatus) {
      _progressStatus = progressStatus;
      if (isNotifable) notifyListeners();
    }
  }

  void setStatusString(String statusString, {bool isNotifable = true}) {
    if (_statusString != statusString) {
      _statusString = statusString;
      if (isNotifable) notifyListeners();
    }
  }
}
