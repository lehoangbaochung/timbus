import 'package:flutter/material.dart';

import '/app/app_languages.dart';
import '/repositories/app_storage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = appStorage.getThemeMode();
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
                            appStorage.stateController.add(value);
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
              appTheme ? appStorage.localize(80) : appStorage.localize(81),
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
                    children: [
                      RadioListTile(
                        value: true,
                        groupValue: appTheme,
                        onChanged: (value) async {
                          appStorage.stateController.add(value);
                          await appStorage.setThemeMode(value!);
                        },
                        title: Text(
                          appStorage.localize(80),
                        ),
                      ),
                      RadioListTile(
                        value: false,
                        groupValue: appTheme,
                        onChanged: (value) async {
                          appStorage.stateController.add(value);
                          await appStorage.setThemeMode(value!);
                        },
                        title: Text(
                          appStorage.localize(81),
                        ),
                      ),
                    ],
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
