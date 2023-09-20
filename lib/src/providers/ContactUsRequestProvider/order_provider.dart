import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class ContactUsRequestProvider extends ChangeNotifier {
  static ContactUsRequestProvider of(BuildContext context, {bool listen = false}) => Provider.of<ContactUsRequestProvider>(context, listen: listen);

  ContactUsRequestState _contactUsRequestState = ContactUsRequestState.init();
  ContactUsRequestState get contactUsRequestState => _contactUsRequestState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setContactUsRequestState(ContactUsRequestState contactUsRequestState, {bool isNotifiable = true}) {
    if (_contactUsRequestState != contactUsRequestState) {
      _contactUsRequestState = contactUsRequestState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> addContactUsRequest({@required Map<String, dynamic>? contactUsRequestData}) async {
    try {
      var result = await ContactUsRequestApiProvider.addContactUsRequest(contactUsRequestData: contactUsRequestData);

      if (result["success"]) {
        _contactUsRequestState = _contactUsRequestState.update(
          progressState: 2,
          contactUsRequestListData: result["data"],
        );
      } else {
        _contactUsRequestState = _contactUsRequestState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _contactUsRequestState = _contactUsRequestState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    notifyListeners();
  }
}
