import 'package:castboard_showcaller/dialogs/GeneralFileDownloadDialog.dart';
import 'package:castboard_showcaller/root_pages/showfile_page/ListItemHeader.dart';
import 'package:castboard_showcaller/root_pages/showfile_page/UploadShowfileButton.dart';
import 'package:castboard_showcaller/view_models/ShowfilePageViewModel.dart';
import 'package:flutter/material.dart';

class ShowfilePage extends StatefulWidget {
  final ShowfilePageViewModel viewModel;

  const ShowfilePage({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  ShowfilePageState createState() => ShowfilePageState();
}

class ShowfilePageState extends State<ShowfilePage> {
  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: 16);
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: _FileData(
                fileName: widget.viewModel.fileName,
                dateCreated: widget.viewModel.dateCreated,
                dateModified: widget.viewModel.dateModified,
              ),
            ),
            UploadShowfileButton(
                onUploadFile: (file) => widget.viewModel.onFileUpload(file)),
            spacer,
            Column(
              children: [
                const ListItemHeader(title: 'Download .castboard File'),
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
    return Row(
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.file_download),
          label: const Text('Download'),
          onPressed: onDownloadButtonPressed,
        ),
      ],
    );
  }
}

class _FileData extends StatelessWidget {
  final String fileName;
  final String dateCreated;
  final String dateModified;

  const _FileData({
    Key? key,
    this.fileName = '',
    this.dateCreated = '',
    this.dateModified = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime? created = DateTime.tryParse(dateCreated);
    final DateTime? modified = DateTime.tryParse(dateModified);

    return SizedBox(
      height: 160,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileName,
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text('Created ${_formatDate(created)}',
                  style: Theme.of(context).textTheme.caption),
              Text('Modified ${_formatDate(modified)}',
                  style: Theme.of(context).textTheme.caption)
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }

    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
