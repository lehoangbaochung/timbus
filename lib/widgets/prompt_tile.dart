import 'package:flutter/material.dart';

import '/app/localizations.dart';

class PromptTile extends StatelessWidget {
  final String prompt;

  const PromptTile(this.prompt, {super.key});

  @override
  Widget build(BuildContext context) {
    var visible = true;
    return StatefulBuilder(
      builder: (context, setState) {
        return Visibility(
          visible: visible,
          child: ListTile(
            tileColor: Colors.orangeAccent,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            title: Text(
              prompt,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              tooltip: AppLocalizations.localize(70),
              onPressed: () => setState(() => visible = false),
            ),
          ),
        );
      },
    );
  }
}
