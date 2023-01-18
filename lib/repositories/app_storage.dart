import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/app/app_languages.dart';
import '/exports/entities.dart';
import '/firebase_options.dart';

part 'local_storage.dart';
part 'remote_storage.dart';

final appStorage = _AppStorage();

class _AppStorage with _LocalStorage, _RemoteStorage {
  late final stateController = StreamController.broadcast(sync: true);

  Future<void> ensureInitialized() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    preferences = await SharedPreferences.getInstance();
    localizations = Map.from(
      jsonDecode(
        await rootBundle.loadString(
          'assets/locales/${appStorage.getLanguageCode()}.json',
        ),
      ),
    );
  }
}

abstract class _LocalRepository {
  /// Returns a localized string with specified [id].
  String localize(int id);

  /// Returns an [Iterable] contains favorite stops.
  Future<Iterable<Stop>> getFavoriteStops();

  /// Returns an [Iterable] contains favorite agencies.
  Future<Iterable<Route>> getFavoriteRoutes();

  String getLanguageCode();

  bool getThemeMode();

  Future<bool> setFavoriteRoutes(Iterable<Route> routes);

  Future<bool> setFavoriteStops(Iterable<Stop> stops);

  Future<bool> setLanguageCode(String code);

  Future<bool> setThemeMode(bool mode);
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
