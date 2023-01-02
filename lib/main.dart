import 'package:bus/repositories/app_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/languages.dart';
import 'app/localizations.dart';
import 'app/pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppLocalizations.initialize();
  runApp(
    MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppPages.routerConfig,
      title: AppLocalizations.localize(0), 
      supportedLocales: AppLanguages.supportedLocales,
      theme: appStorage.getThemeMode() ? ThemeData.light() : ThemeData.dark(),
    ),
  );
}
