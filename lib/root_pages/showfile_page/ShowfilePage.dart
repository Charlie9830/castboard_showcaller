import 'package:castboard_remote/dialogs/GeneralFileDownloadDialog.dart';
import 'package:castboard_remote/root_pages/showfile_page/ListItemHeader.dart';
import 'package:castboard_remote/root_pages/showfile_page/UploadShowfileButton.dart';
import 'package:castboard_remote/snackBars/FileDownloadSnackBar.dart';
import 'package:castboard_remote/view_models/ShowfilePageViewModel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

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
            UploadShowfileButton(
                onUploadFile: (file) => widget.viewModel.onFileUpload(file)),
            spacer,
            Column(
              children: [
                ListItemHeader(title: 'Download .castboard File'),
                spacer,
                _DownloadFileListItem(
                    onDownloadButtonPressed: _handleDownloadButtonPressed),
              ],
            )
          ],
        ));
  }

  void _handleDownloadButtonPressed() async {
    await showDialog(
        context: context,
        builder: (_) => GeneralFileDownloadDialog(
            waitingMessage: 'Player is preparing the showfile...',
            prepareFileUri: Uri.http(
                widget.viewModel.uri.authority, 'prepareShowfileDownload'),
            downloadFileUri:
                Uri.http(widget.viewModel.uri.authority, 'showfileDownload')));
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
}
