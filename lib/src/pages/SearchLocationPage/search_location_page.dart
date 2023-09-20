import 'package:flutter/material.dart';

import 'index.dart';

class SearchLocationPage extends StatelessWidget {
  final bool isGettingLocation;
  final bool isPopup;

  SearchLocationPage({
    this.isGettingLocation = false,
    this.isPopup = true,
  });

  @override
  Widget build(BuildContext context) {
    return SearchLocationView(
      isGettingLocation: isGettingLocation,
      isPopup: isPopup,
    );
  }
}
