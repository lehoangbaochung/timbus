import 'package:flutter/material.dart';

import '/app/localizations.dart';
import '/app/pages.dart';
import '/exports/widgets.dart';
import '/extensions/context.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.localize(8),
        ),
      ),
      body: ListView(
        children: [
          PromptTile(
            AppLocalizations.localize(8),
          ),
          MenuTile(
            leading: Icons.directions,
            trailing: Icons.arrow_right,
            title: AppLocalizations.localize(10),
            subtitle: AppLocalizations.localize(87),
            onTap: () => showSearch(
              context: context,
              delegate: DirectionPage(),
            ),
          ),
          MenuTile(
            leading: Icons.manage_search,
            trailing: Icons.arrow_right,
            title: AppLocalizations.localize(4),
            subtitle: AppLocalizations.localize(88),
            onTap: () => AppPages.push(context, AppPages.lookup.path),
          ),
          MenuTile(
            title: AppLocalizations.localize(2),
            subtitle: AppLocalizations.localize(89),
            leading: Icons.follow_the_signs,
            trailing: Icons.arrow_right,
            onTap: () => showSearch(
              context: context,
              delegate: DirectionPage(),
            ),
          ),
          MenuTile(
            title: AppLocalizations.localize(50),
            subtitle: AppLocalizations.localize(90),
            leading: Icons.support,
            trailing: Icons.arrow_right,
            onTap: () => context.launch(
              'mailto:contact@transerco.com.vn',
            ),
          ),
        ],
      ),
    );
  }
}
