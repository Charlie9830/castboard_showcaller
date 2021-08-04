import 'package:file_selector/file_selector.dart';

class UploadShowfilePageViewModel {
  final void Function(XFile file) onFileUpload;
  final dynamic onSettingsButtonPressed;

  UploadShowfilePageViewModel({
    required this.onFileUpload,
    required this.onSettingsButtonPressed,
  });
}
