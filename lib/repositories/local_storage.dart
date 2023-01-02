import 'package:bus/app/languages.dart';
import 'package:bus/exports/entities.dart';
import 'package:bus/repositories/app_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalRepository {
  Future<void> initialize();

  String getLanguageCode();

  Future<Iterable<Stop>> getFavoriteStops();

  Future<Iterable<Route>> getFavoriteRoutes();

  Future<bool> setFavoriteStops(Iterable<Stop> stops);

  Future<bool> setFavoriteRoutes(Iterable<Route> routes);
}

class LocalStorage implements LocalRepository {
  static const themeMode = 'theme_mode';
  static const languageCode = 'language_code';
  static const favoriteStops = 'favorite_stops';
  static const favoriteRoutes = 'favorite_routes';

  static late final SharedPreferences _prefs;

  @override
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<Iterable<Stop>> getFavoriteStops() async {
    final stopIds = _prefs.getStringList(favoriteStops) ?? [];
    if (stopIds.isEmpty) return [];
    final stops = await appStorage.getAllStops();
    return stops.where((stop) => stopIds.contains(stop.id));
  }

  @override
  Future<bool> setFavoriteStops(Iterable<Stop> stops) async {
    final stopIds = stops.map((stop) => stop.id).toList();
    return _prefs.setStringList(favoriteStops, stopIds);
  }

  @override
  Future<bool> setFavoriteRoutes(Iterable<Route> routes) async {
    final routeIds = routes.map((route) => route.id).toList();
    return _prefs.setStringList(favoriteRoutes, routeIds);
  }

  @override
  Future<Iterable<Route>> getFavoriteRoutes() async {
    final routeIds = _prefs.getStringList(favoriteRoutes) ?? [];
    if (routeIds.isEmpty) return [];
    final routes = await appStorage.getAllRoutes();
    return routes.where((route) => routeIds.contains(route.id));
  }

  @override
  String getLanguageCode() => _prefs.getString(languageCode) ?? AppLanguages.vi.name;

  bool getThemeMode() => _prefs.getBool(themeMode) ?? true;

  Future<bool> setLanguageCode(String code) => _prefs.setString(languageCode, code);

  Future<bool> setThemeMode(bool mode) => _prefs.setBool(themeMode, mode);
}
