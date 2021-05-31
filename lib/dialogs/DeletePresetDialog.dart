import 'package:flutter/material.dart';

class DeletePresetDialog extends StatelessWidget {
  final String presetName;

  const DeletePresetDialog({
    Key? key,
    required this.presetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete $presetName?'),
      content: SingleChildScrollView(
          child: Text(
              '$presetName will be deleted from the player. Are you sure you want to continue?')),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: Text('Delete'),
          onPressed: () => Navigator.of(context).pop(true),
        )
      ],
    );
  }
}
