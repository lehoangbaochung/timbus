import 'package:flutter/material.dart';

import '/repositories/app_storage.dart';

extension ThemeModeX on ThemeMode {
  String getLocaleName() {
    switch (this) {
      case ThemeMode.system:
        return appStorage.localize(82);
      case ThemeMode.light:
        return appStorage.localize(80);
      case ThemeMode.dark:
        return appStorage.localize(81);
    }
  }

  /// Returns the current brightness mode of the host platform.
  Brightness getPlatformBrightness() {
    switch (this) {
      case ThemeMode.system:
        return MediaQueryData.fromWindow(
          WidgetsBinding.instance.window,
        ).platformBrightness;
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
    }
  }

  /// Returns a [ThemeData] based on the current brightness mode of the host platform.
  ThemeData getThemeData() {
    final brightness = getPlatformBrightness();
    final swatch = brightness.toSwatch();
    return ThemeData.from(
      colorScheme: ColorScheme.fromSwatch(
        brightness: brightness,
        primarySwatch: swatch[0] as MaterialColor,
        backgroundColor: swatch[2],
      ),
    );
  }
}

extension BrightnessX on Brightness {
  Map<int, Color> toSwatch() {
    switch (this) {
      case Brightness.dark:
        return {
          0: Colors.teal,
          1: Colors.orangeAccent,
          2: Colors.grey,
          3: Colors.white,
        };
      case Brightness.light:
        return {
          0: Colors.blue,
          1: Colors.orangeAccent,
          2: Colors.white,
          3: Colors.black,
        };
    }
  }
}
