import 'package:castboard_remote/root_pages/showfile_page/UploadShowfileButton.dart';
import 'package:castboard_remote/view_models/UploadShowfilePageViewModel.dart';
import 'package:flutter/material.dart';

class UploadShowfilePage extends StatelessWidget {
  final UploadShowfilePageViewModel viewModel;

  const UploadShowfilePage({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Show File'),
        actions: [
          IconButton(onPressed: viewModel.onSettingsButtonPressed, icon: Icon(Icons.settings))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: UploadShowfileButton(onUploadFile: viewModel.onFileUpload)),
    );
  }
}
