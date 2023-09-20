import 'package:flutter/material.dart';

import 'index.dart';

class StoreGalleryPage extends StatelessWidget {
  final Map<String, dynamic>? galleryData;

  StoreGalleryPage({Key? key, @required this.galleryData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreGalleryView(galleryData: galleryData);
  }
}
