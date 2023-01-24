enum AppLanguages {
  vi,
  en;

  String get localeName {
    switch (this) {
      case AppLanguages.vi:
        return 'Tiếng Việt';
      case AppLanguages.en:
        return 'English';
    }
  }
}
