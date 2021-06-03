import 'package:file_selector/file_selector.dart';

class ShowfilePageViewModel {
  final Uri uri;
  final void Function(XFile file) onFileUpload;

  ShowfilePageViewModel({
    required this.uri,
    required this.onFileUpload,
  });
}
