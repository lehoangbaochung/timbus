part of 'app_storage.dart';

class _LocalStorage implements _LocalRepository {
  late Map<String, String> _localizations;
  late final SharedPreferences _preferences;

  static const themeMode = 'theme_mode';
  static const languageCode = 'language_code';
  static const favoriteStops = 'favorite_stops';
  static const favoriteRoutes = 'favorite_routes';

  @override
  String localize(int id) => _localizations['$id'] ?? '$id';

  @override
  Future<Iterable<Stop>> getFavoriteStops() async {
    final stopIds = _preferences.getStringList(favoriteStops) ?? [];
    if (stopIds.isEmpty) return [];
    final stops = await appStorage.getAllStops();
    return stops.where((stop) => stopIds.contains(stop.id));
  }

  @override
  Future<bool> setFavoriteStops(Iterable<Stop> stops) async {
    final stopIds = stops.map((stop) => stop.id).toList();
    return _preferences.setStringList(favoriteStops, stopIds);
  }

  @override
  Future<bool> setFavoriteRoutes(Iterable<Route> routes) async {
    final routeIds = routes.map((route) => route.id).toList();
    return _preferences.setStringList(favoriteRoutes, routeIds);
  }

  @override
  Future<Iterable<Route>> getFavoriteRoutes() async {
    final routeIds = _preferences.getStringList(favoriteRoutes) ?? [];
    if (routeIds.isEmpty) return [];
    final routes = await appStorage.getAllRoutes();
    return routes.where((route) => routeIds.contains(route.id));
  }

  @override
  String getLanguageCode() {
    return _preferences.getString(languageCode) ?? AppLanguages.vi.name;
  }

  @override
  bool getThemeMode() {
    return _preferences.getBool(themeMode) ?? true;
  }

  @override
  Future<bool> setLanguageCode(String code) async {
    _localizations = Map.from(
      jsonDecode(
        await rootBundle.loadString(
          'assets/locales/$code.json',
        ),
      ),
    );
    return _preferences.setString(languageCode, code);
  }

  @override
  Future<bool> setThemeMode(bool mode) {
    return _preferences.setBool(themeMode, mode);
  }
}
