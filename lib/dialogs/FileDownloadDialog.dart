import 'dart:typed_data';

import 'package:castboard_remote/snackBars/GeneralMessageSnackBar.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class FileDownloadDialog extends StatefulWidget {
  final Uri prepareShowfileUri;
  final Uri downloadShowfileUri;

  const FileDownloadDialog({
    Key? key,
    required this.prepareShowfileUri,
    required this.downloadShowfileUri,
  }) : super(key: key);

  @override
  _FileDownloadDialogState createState() => _FileDownloadDialogState();
}

class _FileDownloadDialogState extends State<FileDownloadDialog> {
  bool _showfileReady = false;
  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: _showfileReady
          ? _buildReadyForDownload(context)
          : _buildPreparing(context),
    );
  }

  Widget _buildPreparing(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        width: 64,
        height: 64,
        child: CircularProgressIndicator(),
      ),
      SizedBox(height: 16),
      Text('Player is preparing the showfile...',
          style: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: Colors.white)),
    ]);
  }

  Widget _buildReadyForDownload(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text('Ready')],
    );
  }

  void _start() async {
    final notifyFail = () {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: GeneralMessageSnackBar(
              success: false,
              message: 'An error occurred, please try again.')));
    };

    try {
      final result = await http.get(widget.prepareShowfileUri);

      if (result.statusCode != 200) {
        notifyFail();
      }

      print('Launching ${widget.downloadShowfileUri.toString()}');

      await launch(widget.downloadShowfileUri.toString());
      Navigator.of(context).pop();
    } catch (e) {
      notifyFail();
    }
  }
}
