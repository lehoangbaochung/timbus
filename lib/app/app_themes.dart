import 'package:flutter/material.dart';

import '/repositories/app_storage.dart';

enum AppThemes {
  system,
  light,
  dark;

  String get localeName {
    switch (this) {
      case AppThemes.system:
        return appStorage.localize(82);
      case AppThemes.light:
        return appStorage.localize(80);
      case AppThemes.dark:
        return appStorage.localize(81);
    }
  }
}

enum AppColors {
  blue,
  teal;
}

extension X on ThemeMode {
  String get localeName {
    switch (this) {
      case ThemeMode.system:
        return appStorage.localize(82);
      case ThemeMode.light:
        return appStorage.localize(80);
      case ThemeMode.dark:
        return appStorage.localize(81);
    }
  }
}