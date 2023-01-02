import 'package:flutter/material.dart';

import '/app/localizations.dart';
import '/exports/widgets.dart';

final guides = {
  AppLocalizations.localize(10): AppLocalizations.localize(51),
  AppLocalizations.localize(4): AppLocalizations.localize(52),
  AppLocalizations.localize(47): AppLocalizations.localize(53),
  AppLocalizations.localize(48): AppLocalizations.localize(54),
  AppLocalizations.localize(49): AppLocalizations.localize(55),
  AppLocalizations.localize(7): AppLocalizations.localize(56),
};

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.localize(9),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: AppLocalizations.localize(46),
        ),
      ),
      body: Column(
        children: [
          PromptTile(
            AppLocalizations.localize(45),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: guides.length,
              itemBuilder: (context, index) {
                final guide = guides.entries.elementAt(index);
                return ExpansionTile(
                  title: Text(guide.key),
                  childrenPadding: const EdgeInsets.all(16.0),
                  children: [
                    Text(guide.value),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
