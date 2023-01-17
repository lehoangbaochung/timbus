import 'package:flutter/material.dart';

import '/repositories/app_storage.dart';

final appTheme = appStorage.getThemeMode() ? _AppTheme.light() : _AppTheme.dark();

class _AppTheme {
  _AppTheme._({
    required this.primaryColor,
    required this.secondaryColor,
    required this.onPrimaryColor,
    required this.onSecondaryColor,
  });

  late final Brightness brightness;

  final Color primaryColor;
  final Color secondaryColor;
  final Color onPrimaryColor;
  final Color onSecondaryColor;

  factory _AppTheme.light() {
    return _AppTheme._(
      primaryColor: Colors.blue,
      secondaryColor: Colors.orangeAccent,
      onPrimaryColor: Colors.white,
      onSecondaryColor: Colors.black,
    )..brightness = Brightness.light;
  }

  factory _AppTheme.dark() {
    return _AppTheme._(
      primaryColor: Colors.teal,
      secondaryColor: Colors.orangeAccent,
      onPrimaryColor: Colors.black,
      onSecondaryColor: Colors.white,
    )..brightness = Brightness.dark;
  }
}
