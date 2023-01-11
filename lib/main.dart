import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '/repositories/app_storage.dart';
import 'app/localizations.dart';
import 'app/pages.dart';
import 'firebase_options.dart';

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppLocalizations.initialize();
  runApp(
    MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppPages.routerConfig,
      title: AppLocalizations.localize(0),
      theme: appStorage.getThemeMode() ? ThemeData.light() : ThemeData.dark(),
    ),
  );
  FlutterNativeSplash.remove();
}
