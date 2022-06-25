import 'package:flutter/material.dart';

class FileDownloadSnackBar extends StatelessWidget {
  final bool success;
  const FileDownloadSnackBar({Key? key, required this.success}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Icon(success: success),
        const SizedBox(width: 8),
        Expanded(
          child: Text(_getText()),
        )
      ],
    );
  }

  String _getText() {
    if (success) {
      return 'File downloaded.';
    } else {
      return 'An error occured. Please try again.';
    }
  }
}

class _Icon extends StatelessWidget {
  final bool success;
  const _Icon({Key? key, required this.success}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = DefaultTextStyle.of(context).style.color;
    if (success) {
      return Icon(Icons.file_download_done, color: color);
    } else {
      return Icon(Icons.error, color: color);
    }
  }
}
