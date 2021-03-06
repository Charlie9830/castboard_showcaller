import 'package:castboard_showcaller/root_pages/showfile_page/ListItemHeader.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class UploadShowfileButton extends StatefulWidget {
  final void Function(XFile file) onUploadFile;

  const UploadShowfileButton({
    Key? key,
    required this.onUploadFile,
  }) : super(key: key);

  @override
  UploadShowfileButtonState createState() => UploadShowfileButtonState();
}

class UploadShowfileButtonState extends State<UploadShowfileButton> {
  String _fileName = '';
  XFile? _file;

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: 16);
    return Column(
      children: [
        const ListItemHeader(title: 'Upload .castboard File'),
        spacer,
        _UploadFileListItem(
            fileName: _fileName,
            isAwaitingUpload: true,
            onSelectPressed: _handleSelectFileForUploadPressed,
            onUploadPressed: () {
              if (_file != null) {
                widget.onUploadFile(_file!);
              }
            }),
      ],
    );
  }

  void _handleSelectFileForUploadPressed() async {
    final typeGroup =
        XTypeGroup(label: 'Castboard file', extensions: ['castboard']);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);

    if (file != null) {
      setState(() {
        _fileName = file.name;
        _file = file;
      });
    }
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
            onPressed: onSelectPressed,
            child: const Text('Select'),
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
                onPressed: onSelectPressed,
                child: const Text('Change'),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.file_upload),
                  label: const Text('Upload'),
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
