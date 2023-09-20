import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeWidget extends StatelessWidget {
  final String? code;
  final double? size;

  QrCodeWidget({
    Key? key,
    @required this.code,
    @required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QrImage(
      data: code!,
      version: QrVersions.auto,
      size: size,
      gapless: true,
    );
  }
}
