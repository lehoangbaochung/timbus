import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '/app/app_pages.dart';
import '/extensions/appearance.dart';
import '/repositories/app_storage.dart';

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  await appStorage.ensureInitialized();
  runApp(
    StreamBuilder(
      stream: appStorage.lifecycle,
      builder: (context, snapshot) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppPages.routerConfig,
          title: appStorage.localize(0),
          theme: appStorage.getThemeMode().getThemeData(),
        );
      },
    ),
  );
  FlutterNativeSplash.remove();
}
