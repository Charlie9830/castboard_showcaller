import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FileUploadDialog extends StatefulWidget {
  final XFile xFile;
  final Uri uri;

  const FileUploadDialog({Key? key, required this.uri, required this.xFile})
      : super(key: key);

  @override
  _FileUploadDialogState createState() => _FileUploadDialogState();
}

class _FileUploadDialogState extends State<FileUploadDialog> {
  @override
  void initState() {
    super.initState();
    _startFileTransfer();
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
          Text('Uploading file..',
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Colors.white)),
          SizedBox(height: 8),
          Text('This can take a while',
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  Future<void> _startFileTransfer() async {
    try {
      // Build Request. We use a Multipart Request so avoid blocking the main thread.
      final request = http.MultipartRequest('PUT', widget.uri);
      request.files.add(await _buildMultipartFile(widget.xFile));

      // Initialize the Http Client.
      final client = http.Client();

      // Send the request, extract the response from the return stream.
      final response =
          await http.Response.fromStream(await client.send(request));

      Navigator.of(context).pop(FileUploadDialogResult(
        response: response,
      ));
    } catch (e) {
      Navigator.of(context).pop(FileUploadDialogResult(
        exceptionMessage: e.toString(),
      ));
    }
  }

  /// Packages the provided [file] into a [MultipartFile] with 'file' as the field header.
  Future<http.MultipartFile> _buildMultipartFile(XFile file) async {
    const fieldHeader =
        'file'; // Performer will check for this field before processing the request.

    final length = await widget.xFile.length();
    return http.MultipartFile(fieldHeader, widget.xFile.openRead(), length);
  }
}

class FileUploadDialogResult {
  final http.Response? response;
  final String exceptionMessage;

  FileUploadDialogResult({
    this.response,
    this.exceptionMessage = '',
  });
}
