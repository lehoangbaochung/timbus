import 'package:bus/app/app_languages.dart';
import 'package:bus/repositories/app_storage.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appLanguage = AppLanguages.values.byName(
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
          StatefulBuilder(builder: (context, setState) {
            return ListTile(
              title: Text(
                appStorage.localize(61),
                style: const TextStyle(color: Colors.blue),
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
                            onChanged: (value) {
                              setState(() {
                                Navigator.pop(context);
                                appLanguage = value ?? appLanguage;
                              });
                            },
                            title: Text(language.localeName),
                          );
                        },
                      ).toList(),
                    );
                  },
                );
              },
            );
          }),
          // Theme
          StreamBuilder(
            initialData: appStorage.getThemeMode(),
            stream: appStorage.themeController.stream,
            builder: (context, snapshot) {
              final appTheme = snapshot.requireData;
              return ListTile(
                trailing: const Icon(Icons.arrow_right),
                title: Text(
                  appStorage.localize(62),
                ),
                subtitle: Text(
                  appTheme ? appStorage.localize(80) : appStorage.localize(81),
                ),
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
                              Navigator.pop(context);
                              final mode = value ?? true;
                              await appStorage.setThemeMode(mode);
                              appStorage.themeController.add(mode);
                            },
                            title: Text(
                              appStorage.localize(80),
                            ),
                          ),
                          RadioListTile(
                            value: false,
                            groupValue: appTheme,
                            onChanged: (value) async {
                              Navigator.pop(context);
                              final mode = value ?? true;
                              await appStorage.setThemeMode(mode);
                              appStorage.themeController.add(mode);
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
              );
            },
          ),
        ],
      ),
    );
  }
}
