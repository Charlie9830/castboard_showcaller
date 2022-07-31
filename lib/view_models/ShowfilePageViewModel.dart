import 'package:file_selector/file_selector.dart';

class ShowfilePageViewModel {
  final Uri uri;
  final String fileName;
  final String dateCreated;
  final String dateModified;
  final void Function(XFile file) onFileUpload;

  ShowfilePageViewModel({
    required this.uri,
    required this.onFileUpload,
    required this.fileName,
    required this.dateCreated,
    required this.dateModified,
  });
}
