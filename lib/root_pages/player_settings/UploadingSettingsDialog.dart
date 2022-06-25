import 'package:flutter/material.dart';

class UploadingSettingsDialog extends StatelessWidget {
  const UploadingSettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Sending updated settings to player...',
            style: Theme.of(context).textTheme.subtitle1),
        const SizedBox(height: 48),
        const SizedBox(width: 32, height: 32, child: CircularProgressIndicator())
      ],
    );
  }
}
