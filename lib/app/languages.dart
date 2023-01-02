import 'package:flutter/material.dart';

enum AppLanguages {
  /// Vietnamese
  vi('Tiếng Việt'),
  
  /// English
  en('English');

  final String fullname;

  const AppLanguages(this.fullname);

  /// The list of locales that this app has been localized for.
  static final supportedLocales = values.map((language) => Locale(language.name));
}
