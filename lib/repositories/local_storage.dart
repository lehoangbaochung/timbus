part of 'app_storage.dart';

class _LocalStorage implements _LocalRepository {
  late Map<String, String> localizations;
  late final SharedPreferences preferences;

  static const themeMode = 'theme_mode';
  static const languageCode = 'language_code';
  static const favoriteStops = 'favorite_stops';
  static const favoriteRoutes = 'favorite_routes';

  @override
  String localize(int id) => localizations['$id'] ?? '$id';

  @override
  Future<Iterable<Stop>> getFavoriteStops() async {
    final stopIds = preferences.getStringList(favoriteStops) ?? [];
    if (stopIds.isEmpty) return [];
    final stops = await appStorage.getAllStops();
    return stops.where((stop) => stopIds.contains(stop.id));
  }

  @override
  Future<bool> setFavoriteStops(Iterable<Stop> stops) async {
    final stopIds = stops.map((stop) => stop.id).toList();
    return preferences.setStringList(favoriteStops, stopIds);
  }

  @override
  Future<bool> setFavoriteRoutes(Iterable<Route> routes) async {
    final routeIds = routes.map((route) => route.id).toList();
    return preferences.setStringList(favoriteRoutes, routeIds);
  }

  @override
  Future<Iterable<Route>> getFavoriteRoutes() async {
    final routeIds = preferences.getStringList(favoriteRoutes) ?? [];
    if (routeIds.isEmpty) return [];
    final routes = await appStorage.getAllRoutes();
    return routes.where((route) => routeIds.contains(route.id));
  }

  @override
  String getLanguageCode() {
    return preferences.getString(languageCode) ?? AppLanguages.vi.name;
  }

  @override
  bool getThemeMode() {
    return preferences.getBool(themeMode) ?? true;
  }

  @override
  Future<bool> setLanguageCode(String code) async {
    localizations = Map.from(
      jsonDecode(
        await rootBundle.loadString(
          'assets/locales/$code.json',
        ),
      ),
    );
    return preferences.setString(languageCode, code);
  }

  @override
  Future<bool> setThemeMode(bool mode) {
    return preferences.setBool(themeMode, mode);
  }
}
