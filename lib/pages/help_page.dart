import 'package:bus/repositories/app_storage.dart';
import 'package:flutter/material.dart';

import '/exports/widgets.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final guides = {
      appStorage.localize(10): appStorage.localize(51),
      appStorage.localize(4): appStorage.localize(52),
      appStorage.localize(47): appStorage.localize(53),
      appStorage.localize(48): appStorage.localize(54),
      appStorage.localize(49): appStorage.localize(55),
      appStorage.localize(7): appStorage.localize(56),
    };
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          appStorage.localize(9),
        ),
      ),
      body: Column(
        children: [
          PromptTile(
            appStorage.localize(45),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: guides.length,
              itemBuilder: (context, index) {
                final guide = guides.entries.elementAt(index);
                return ExpansionTile(
                  title: Text(guide.key),
                  childrenPadding: const EdgeInsets.all(16),
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
