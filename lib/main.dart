import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'app/app_pages.dart';
import 'repositories/app_storage.dart';

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  await appStorage.ensureInitialized();
  runApp(
    StreamBuilder(
      initialData: appStorage.getThemeMode(),
      stream: appStorage.themeController.stream,
      builder: (context, snapshot) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppPages.routerConfig,
          title: appStorage.localize(0),
          theme: snapshot.requireData
              ? ThemeData.light().copyWith(
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.blue,
                    brightness: Brightness.light,
                  ),
                )
              : ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.teal,
                    brightness: Brightness.dark,
                  ),
                ),
        );
      },
    ),
  );
  FlutterNativeSplash.remove();
}
