import 'package:flutter/material.dart';

import '/repositories/app_storage.dart';

class PromptTile extends StatelessWidget {
  const PromptTile(this.prompt, {super.key});

  final String prompt;
  
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
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: appStorage.paint(2),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              tooltip: appStorage.localize(70),
              onPressed: () => setState(() => visible = false),
            ),
          ),
        );
      },
    );
  }
}
