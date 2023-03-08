import 'dart:async';
import 'dart:convert';

import 'package:bus/extensions/appearance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/app/app_languages.dart';
import '/exports/entities.dart';
import '/firebase_options.dart';

part 'local_storage.dart';
part 'remote_storage.dart';

final appStorage = _AppStorage();

class _AppStorage with _LocalStorage, _RemoteStorage {
  late final _stateController = StreamController<void>.broadcast();

  Stream<void> get lifecycle => _stateController.stream;

  void refresh() => _stateController.add(null);

  Future<bool> ensureInitialized() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _preferences = await SharedPreferences.getInstance();
    _colors = appStorage.getThemeMode().getPlatformBrightness().toSwatch();
    _localizations = Map.from(
      jsonDecode(
        await rootBundle.loadString(
          'assets/locales/${appStorage.getLanguageCode()}.json',
        ),
      ),
    );
    return Future.value(true);
  }
}

abstract class _LocalRepository {
  /// Returns the current brightness mode of the host platform.
  Color paint(int id);

  /// Returns a localized string with specified [id].
  String localize(int id);

  /// Returns an [Iterable] contains favorite stops.
  Future<Iterable<Stop>> getFavoriteStops();

  /// Returns an [Iterable] contains favorite agencies.
  Future<Iterable<Route>> getFavoriteRoutes();

  String getLanguageCode();

  ThemeMode getThemeMode();

  Future<bool> setFavoriteRoutes(Iterable<Route> routes);

  Future<bool> setFavoriteStops(Iterable<Stop> stops);

  Future<bool> setLanguageCode(String code);

  Future<bool> setThemeMode(ThemeMode mode);
}

abstract class _RemoteRepository {
  /// Returns an [Iterable] contains all agencies in the storage.
  Future<Iterable<Agency>> getAllAgencies();

  /// Returns an [Iterable] contains all articles in the storage.
  Future<Iterable<Article>> getAllArticles();

  /// Returns an [Iterable] contains all stops in the storage.
  Future<Iterable<Stop>> getAllStops();

  /// Returns an [Iterable] contains all routes in the storage.
  Future<Iterable<Route>> getAllRoutes();

  /// Returns an [Iterable] contains all places in the storage.
  Future<Iterable<Place>> getAllPlaces();
}
