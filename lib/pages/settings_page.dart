
import 'package:bus/extensions/appearance.dart';
import 'package:flutter/material.dart';

import '/app/app_languages.dart';
import '/repositories/app_storage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = appStorage.getThemeMode();
    final appLanguage = AppLanguages.values.byName(
      appStorage.getLanguageCode(),
    );
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          appStorage.localize(6),
        ),
      ),
      body: ListView(
        children: [
          // Language
          ListTile(
            title: Text(
              appStorage.localize(61),
            ),
            subtitle: Text(appLanguage.localeName),
            trailing: const Icon(Icons.arrow_right),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text(
                      appStorage.localize(61),
                    ),
                    children: AppLanguages.values.map(
                      (language) {
                        return RadioListTile(
                          value: language,
                          groupValue: appLanguage,
                          onChanged: (value) async {
                            appStorage.refresh();
                            await appStorage.setLanguageCode(value!.name);
                          },
                          title: Text(language.localeName),
                        );
                      },
                    ).toList(),
                  );
                },
              );
            },
          ),
          // Theme
          ListTile(
            title: Text(
              appStorage.localize(62),
            ),
            subtitle: Text(
              themeMode.getLocaleName(),
            ),
            trailing: const Icon(Icons.arrow_right),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text(
                      appStorage.localize(62),
                    ),
                    children: ThemeMode.values.map((mode) {
                      return RadioListTile(
                        value: mode,
                        groupValue: themeMode,
                        onChanged: (_) async {
                          await appStorage.setThemeMode(mode);
                          appStorage.refresh();
                        },
                        title: Text(
                          mode.getLocaleName(),
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
