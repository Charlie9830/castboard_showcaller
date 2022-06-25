import 'package:castboard_showcaller/snackBars/GeneralMessageSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class GeneralFileDownloadDialog extends StatefulWidget {
  final String waitingMessage;
  final Uri prepareFileUri;
  final Uri downloadFileUri;

  const GeneralFileDownloadDialog({
    Key? key,
    required this.waitingMessage,
    required this.prepareFileUri,
    required this.downloadFileUri,
  }) : super(key: key);

  @override
  GeneralFileDownloadDialogState createState() =>
      GeneralFileDownloadDialogState();
}

class GeneralFileDownloadDialogState extends State<GeneralFileDownloadDialog> {
  final bool _showfileReady = false;
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
      const SizedBox(
        width: 64,
        height: 64,
        child: CircularProgressIndicator(),
      ),
      const SizedBox(height: 16),
      Text(
          widget.waitingMessage.isNotEmpty
              ? widget.waitingMessage
              : 'Preparing file...',
          style: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: Colors.white)),
    ]);
  }

  Widget _buildReadyForDownload(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [Text('Ready')],
    );
  }

  void _start() async {
    notifyFail() {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: GeneralMessageSnackBar(
              success: false,
              message: 'An error occurred, please try again.')));
    }

    try {
      final result = await http.get(widget.prepareFileUri);

      if (result.statusCode != 200) {
        notifyFail();
      }

      await launchUrl(widget.downloadFileUri);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      notifyFail();
    }
  }
}
