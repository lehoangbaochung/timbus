import 'package:bus/app/languages.dart';
import 'package:bus/app/localizations.dart';
import 'package:bus/extensions/context.dart';
import 'package:bus/repositories/app_storage.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appTheme = appStorage.getThemeMode();
    var appLanguage = AppLanguages.values.byName(
      appStorage.getLanguageCode(),
    );
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.localize(6),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              context.showSnackBar(
                AppLocalizations.localize(83),
              );
              await appStorage.setThemeMode(appTheme);
              await appStorage.setLanguageCode(appLanguage.name);
            },
            tooltip: AppLocalizations.localize(82),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Language
          StatefulBuilder(builder: (context, setState) {
            return ListTile(
              title: Text(
                AppLocalizations.localize(61),
                style: const TextStyle(color: Colors.blue),
              ),
              subtitle: Text(appLanguage.fullname),
              trailing: const Icon(Icons.arrow_right),
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text(
                        AppLocalizations.localize(61),
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
                            title: Text(language.fullname),
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
          StatefulBuilder(
            builder: (context, setState) {
              return ListTile(
                trailing: const Icon(Icons.arrow_right),
                title: Text(
                  AppLocalizations.localize(62),
                  style: const TextStyle(color: Colors.blue),
                ),
                subtitle: Text(
                  appTheme ? AppLocalizations.localize(80) : AppLocalizations.localize(81),
                ),
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text(
                          AppLocalizations.localize(62),
                        ),
                        children: [
                          RadioListTile(
                            value: true,
                            groupValue: appTheme,
                            onChanged: (value) {
                              setState(() {
                                Navigator.pop(context);
                                appTheme = value ?? appTheme;
                              });
                            },
                            title: Text(
                              AppLocalizations.localize(80),
                            ),
                          ),
                          RadioListTile(
                            value: false,
                            groupValue: appTheme,
                            onChanged: (value) {
                              setState(() {
                                Navigator.pop(context);
                                appTheme = value ?? appTheme;
                              });
                            },
                            title: Text(
                              AppLocalizations.localize(81),
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
