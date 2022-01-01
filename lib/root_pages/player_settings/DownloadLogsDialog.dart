import 'package:flutter/material.dart';

class DownloadLogsDialog extends StatelessWidget {
  const DownloadLogsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Downloading diagnostic files',
              style: Theme.of(context).textTheme.subtitle1),
          SizedBox(height: 48),
          SizedBox(width: 32, height: 32, child: CircularProgressIndicator())
        ],
      ),
    );
  }
}
