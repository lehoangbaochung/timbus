import 'dart:convert';

import 'package:bus/repositories/app_storage.dart';
import 'package:flutter/services.dart';

typedef Localization = Map<String, String>;

class AppLocalizations {
  const AppLocalizations._();

  static late final Localization _localization;

  static String localize(int id) => _localization['$id'] ?? '$id';

  static Future<Localization> initialize() async {
    await appStorage.initialize();
    final languageCode = appStorage.getLanguageCode();
    return _localization = Map.from(
      jsonDecode(
        await rootBundle.loadString(
          'assets/locales/$languageCode.json',
        ),
      ),
    );
  }
}
