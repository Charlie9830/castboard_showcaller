import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String affirmativeText;
  final String negativeText;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.affirmativeText,
    required this.negativeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
            child: Text(negativeText),
            onPressed: () => Navigator.of(context).pop(false)),
        TextButton(
            child: Text(affirmativeText),
            onPressed: () => Navigator.of(context).pop(true)),
      ],
    );
  }
}
