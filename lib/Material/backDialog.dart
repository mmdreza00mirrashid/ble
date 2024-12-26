import 'dart:async';

import 'package:flutter/material.dart';

void showMessage(BuildContext context ,String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Params'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<bool> backDialog(BuildContext context) async {
  final completer = Completer<bool>();

  connectionDialog(
    context,
    message: "Do you want to quit?",
    title: "Are you sure",
    // height: MediaQuery.of(context).size.height * 0.19,
    // width: MediaQuery.of(context).size.width * 0.3,
    // textColor: Colors.white,
    // backgroundColor: grayNoticBG,
    // borderColor: Colors.white24,
    // buttonTextColor: yellow,
    secondButtonText: "Yes",
    cancelButtonText: "No",
    cancelButtonPressed: () {
      completer.complete(false); // Return `false` for cancel
      // Close the dialog
    },
    onSecondButtonPressed: () async {
      completer.complete(true); // Return `true` for allow
      // Close the dialog
    },
  );

  return completer.future;
}

Future<void> connectionDialog(
  BuildContext context, {
  required String message,
  required String title,
  required VoidCallback cancelButtonPressed,
  required VoidCallback onSecondButtonPressed,
  String cancelButtonText = "Cancel",
  String secondButtonText = "OK",
  double borderRadius = 16.0,
}) {
  final theme = Theme.of(context);

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface,
                      foregroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        side: BorderSide(
                          color: theme.colorScheme.outline,
                          width: 1.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      cancelButtonPressed();
                    },
                    child: Text(cancelButtonText),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onSecondButtonPressed();
                    },
                    child: Text(secondButtonText),
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      );
    },
  );
}
