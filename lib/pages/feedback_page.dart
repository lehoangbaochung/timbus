import 'package:bus/repositories/app_storage.dart';
import 'package:bus/widgets/prompt_tile.dart';
import 'package:bus/app/app_pages.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  /// Launch the given [id] can be handled by some app installed on the device.
  Uri getSurveyUrl(String id) => Uri.parse('https://docs.google.com/forms/d/e/$id/viewform?usp=sf_link');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          appStorage.localize(7),
        ),
        actions: [
          IconButton(
            tooltip: appStorage.localize(9),
            icon: const Icon(Icons.help_outline),
            onPressed: () => AppPages.push(context, AppPages.help.path),
          ),
        ],
      ),
      body: Column(
        children: [
          PromptTile(
            appStorage.localize(38),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  isThreeLine: true,
                  title: Text(
                    appStorage.localize(39),
                  ),
                  subtitle: Text(
                    appStorage.localize(40),
                  ),
                  leading: SizedBox(
                    height: double.infinity,
                    child: CircleAvatar(
                      foregroundColor: appStorage.paint(0),
                      child: const Icon(Icons.send_time_extension),
                    ),
                  ),
                  trailing: const SizedBox(
                    height: double.infinity,
                    child: Icon(Icons.open_in_new),
                  ),
                  onTap: () async {
                    await launchUrl(
                      getSurveyUrl(
                        '1FAIpQLScQLYEyRKEaXYcuGUa1tRq5ma17fvoJ679jeXBdq_FJuEVwrQ',
                      ),
                    );
                  },
                ),
                ListTile(
                  isThreeLine: true,
                  title: Text(
                    appStorage.localize(41),
                  ),
                  subtitle: Text(
                    appStorage.localize(42),
                  ),
                  leading: SizedBox(
                    height: double.infinity,
                    child: CircleAvatar(
                      foregroundColor: appStorage.paint(0),
                      child: const Icon(Icons.content_paste_go),
                    ),
                  ),
                  trailing: const SizedBox(
                    height: double.infinity,
                    child: Icon(Icons.open_in_new),
                  ),
                  onTap: () async {
                    await launchUrl(
                      getSurveyUrl(
                        '1FAIpQLSd_nI3J8cxbMDbyaEp-xe9MH6unaF6ajhjfHN48f200THDBbQ',
                      ),
                    );
                  },
                ),
                ListTile(
                  isThreeLine: true,
                  title: Text(
                    appStorage.localize(43),
                  ),
                  subtitle: Text(
                    appStorage.localize(44),
                  ),
                  leading: SizedBox(
                    height: double.infinity,
                    child: CircleAvatar(
                      foregroundColor: appStorage.paint(0),
                      child: const Icon(Icons.send_to_mobile),
                    ),
                  ),
                  trailing: const SizedBox(
                    height: double.infinity,
                    child: Icon(Icons.open_in_new),
                  ),
                  onTap: () async {
                    await launchUrl(
                      getSurveyUrl(
                        '1FAIpQLSd_nI3J8cxbMDbyaEp-xe9MH6unaF6ajhjfHN48f200THDBbQ',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
