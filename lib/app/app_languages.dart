import 'package:flutter/material.dart';

enum AppLanguages {
  en('English'),
  vi('Tiếng Việt');

  const AppLanguages(this.localeName);

  final String localeName;

  /// The list of locales that this app has been localized for.
  static final supportedLocales = values.map((language) => Locale(language.name));
}
