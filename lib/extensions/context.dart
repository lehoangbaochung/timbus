import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension BuildContextX on BuildContext {
  /// Returns the [BuildContext] of the nearest ancestor of the given type.
  Future<bool> checkNetwork({String url = 'google.com'}) async {
    try {
      final result = await InternetAddress.lookup(url);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (e) {
      showSnackBar(e.message);
    }
    return false;
  }

  /// Shows a [SnackBar] with a [message] across all registered [Scaffold]s.
  void showSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: action,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  /// Copy [text] into clipboard then shows a [SnackBar] with a [message] to user.
  void copyToClipboard(String? text, {required String message}) async {
    await Clipboard.setData(
      ClipboardData(text: text),
    );
    showSnackBar(message);
  }
}
