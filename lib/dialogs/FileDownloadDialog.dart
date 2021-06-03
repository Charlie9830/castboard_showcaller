import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FileDownloadDialog extends StatefulWidget {
  final Uri uri;

  const FileDownloadDialog({Key? key, required this.uri}) : super(key: key);

  @override
  _FileDownloadDialogState createState() => _FileDownloadDialogState();
}

class _FileDownloadDialogState extends State<FileDownloadDialog> {
  @override
  void initState() {
    super.initState();
    _startFileDownload();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(),
          ),
          SizedBox(height: 16),
          Text('Downloading file..',
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  void _startFileDownload() async {
    try {
      final response = await http.get(widget.uri);

      Navigator.of(context).pop(
        FileDownloadDialogResult(response: response),
      );
    } catch (e) {
      Navigator.of(context).pop(FileDownloadDialogResult(
        exceptionMessage: e.toString(),
      ));
    }
  }
}

class FileDownloadDialogResult {
  final http.Response? response;
  final String exceptionMessage;

  FileDownloadDialogResult({
    this.response,
    this.exceptionMessage = '',
  });
}
