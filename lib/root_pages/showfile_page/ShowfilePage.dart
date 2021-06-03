import 'package:castboard_remote/dialogs/FileDownloadDialog.dart';
import 'package:castboard_remote/root_pages/showfile_page/ListItemHeader.dart';
import 'package:castboard_remote/snackBars/FileDownloadSnackBar.dart';
import 'package:castboard_remote/view_models/ShowfilePageViewModel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class ShowfilePage extends StatefulWidget {
  final ShowfilePageViewModel viewModel;

  const ShowfilePage({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  _ShowfilePageState createState() => _ShowfilePageState();
}

class _ShowfilePageState extends State<ShowfilePage> {
  String _fileName = '';
  XFile? _file;

  @override
  Widget build(BuildContext context) {
    final spacer = SizedBox(height: 16);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: _FileData(
                fileName: 'Les Dogerables',
                dateCreated: 'Yesterday',
                dateModified: 'Today',
              ),
            ),
            ListItemHeader(title: 'Upload .castboard File'),
            spacer,
            _UploadFileListItem(
                fileName: _fileName,
                isAwaitingUpload: true,
                onSelectPressed: _handleSelectFileForUploadPressed,
                onUploadPressed: () {
                  if (_file != null) {
                    widget.viewModel.onFileUpload(_file!);
                  }
                }),
            spacer,
            ListItemHeader(title: 'Download .castboard File'),
            spacer,
            _DownloadFileListItem(
                onDownloadButtonPressed: _handleDownloadButtonPressed)
          ],
        ));
  }

  void _handleDownloadButtonPressed() async {
    final uri = Uri.http(widget.viewModel.uri.authority, '/download');

    final result = await showDialog(
        context: context,
        builder: (builderContext) => FileDownloadDialog(uri: uri));

    if (result is FileDownloadDialogResult &&
        result.response != null &&
        result.response!.statusCode == 200) {
      // Success.
      final data = result.response!.bodyBytes;

      final typeGroup =
          XTypeGroup(label: 'Castboard file', extensions: ['castboard']);

      final path = await getSavePath(
          acceptedTypeGroups: [typeGroup], suggestedName: 'Castboard Showfile.castboard');

      if (path == null || path.isEmpty) {
        return;
      }

      final file = XFile.fromData(data);
      await file.saveTo(path);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: FileDownloadSnackBar(success: true)));
    } else {
      // Something went wrong.
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: FileDownloadSnackBar(success: false)));
    }
  }

  void _handleSelectFileForUploadPressed() async {
    final typeGroup =
        XTypeGroup(label: 'Castboard file', extensions: ['castboard']);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);

    if (file != null) {
      setState(() {
        _fileName = p.basenameWithoutExtension(file.path);
        _file = file;
      });
    }
  }
}

class _DownloadFileListItem extends StatelessWidget {
  final dynamic onDownloadButtonPressed;

  const _DownloadFileListItem({
    Key? key,
    required this.onDownloadButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        OutlinedButton.icon(
          icon: Icon(Icons.file_download),
          label: Text('Download'),
          onPressed: onDownloadButtonPressed,
        ),
      ],
    ));
  }
}

class _UploadFileListItem extends StatelessWidget {
  final String fileName;
  final bool isAwaitingUpload;
  final dynamic onSelectPressed;
  final dynamic onUploadPressed;

  const _UploadFileListItem({
    Key? key,
    required this.fileName,
    required this.onSelectPressed,
    required this.onUploadPressed,
    this.isAwaitingUpload = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fileName.isEmpty) {
      return Row(
        children: [
          OutlinedButton(
            child: Text('Select'),
            onPressed: onSelectPressed,
          )
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  fileName,
                  overflow: TextOverflow.fade,
                ),
              ),
              TextButton(
                child: Text('Change'),
                onPressed: onSelectPressed,
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.file_upload),
                  label: Text('Upload'),
                  onPressed: onUploadPressed,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}

class _FileData extends StatelessWidget {
  final String fileName;
  final String dateCreated;
  final String? dateModified;

  const _FileData({
    Key? key,
    this.fileName = '',
    this.dateCreated = '',
    this.dateModified = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileName,
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Text('Created $dateCreated',
                  style: Theme.of(context).textTheme.caption),
              Text('Modified $dateCreated',
                  style: Theme.of(context).textTheme.caption)
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(BuildContext context) {
    return BoxDecoration(
      border: Border.all(color: Theme.of(context).dividerColor, width: 2),
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    );
  }
}
