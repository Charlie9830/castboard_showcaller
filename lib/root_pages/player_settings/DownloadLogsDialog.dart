import 'package:flutter/material.dart';

class DownloadLogsDialog extends StatelessWidget {
  const DownloadLogsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Downloading diagnostic files',
            style: Theme.of(context).textTheme.subtitle1),
        const SizedBox(height: 48),
        const SizedBox(width: 32, height: 32, child: CircularProgressIndicator())
      ],
    );
  }
}
