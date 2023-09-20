import 'package:flutter/material.dart';

class Colors {
  // Color _primaryColor = Color(0xFFFFFFFF);
  // Color _primaryDarkColor = Color(0xFF222831);
  Color _mainColor = Color(0xFFf46f2c);
  Color _mainDarkColor = Color(0xFFf46f2c);
  Color _secondColor = Color(0xFF344968);
  Color _secondDarkColor = Color(0xFFccccdd);
  // Color _secondColor = Color(0xFF000000); // main text and icon color
  // Color _secondColor = Color(0xFF344968);
  // Color _secondDarkColor = Color(0xFFFFFFFF); // main text and icon color
  // Color _secondDarkColor = Color(0xFFccccdd);
  Color _accentColor = Color(0xFF8C98A8);
  Color _accentDarkColor = Color(0xFF9999aa);

  // Color primaryColor(double opacity) {
  //   return this._primaryColor.withOpacity(opacity);
  // }

  // Color primaryDarkColor(double opacity) {
  //   return this._primaryDarkColor.withOpacity(opacity);
  // }

  Color mainColor(double opacity) {
    return this._mainColor.withOpacity(opacity);
  }

  Color secondColor(double opacity) {
    return this._secondColor.withOpacity(opacity);
  }

  Color accentColor(double opacity) {
    return this._accentColor.withOpacity(opacity);
  }

  Color mainDarkColor(double opacity) {
    return this._mainDarkColor.withOpacity(opacity);
  }

  Color secondDarkColor(double opacity) {
    return this._secondDarkColor.withOpacity(opacity);
  }

  Color accentDarkColor(double opacity) {
    return this._accentDarkColor.withOpacity(opacity);
  }
}
