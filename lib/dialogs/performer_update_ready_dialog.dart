import 'package:flutter/material.dart';

class PerformerUpdateReadyDialog extends StatelessWidget {
  const PerformerUpdateReadyDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AlertDialog(
        title: const Text('Software Update'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'A Software update for Castboard Performer is ready to be installed.'),
            const SizedBox(height: 16),
            Text(
                'To install this update, open Performer, Then go to  Settings (Press Escape) > Install Update.',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Okay'))
        ],
      ),
    );
  }
}
