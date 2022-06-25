import 'package:flutter/material.dart';

class UpdatePresetDialog extends StatelessWidget {
  final String presetName;
  const UpdatePresetDialog({Key? key, required this.presetName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update $presetName?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text('Update'),
          onPressed: () => Navigator.of(context).pop(true),
        )
      ],
    );
  }
}
