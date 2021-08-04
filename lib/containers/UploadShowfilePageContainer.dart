import 'package:castboard_remote/redux/actions/AsyncActions.dart';
import 'package:castboard_remote/redux/state/AppState.dart';
import 'package:castboard_remote/root_pages/showfile_page/ShowfilePage.dart';
import 'package:castboard_remote/root_pages/upload_showfile_page/UploadShowfilePage.dart';
import 'package:castboard_remote/view_models/ShowfilePageViewModel.dart';
import 'package:castboard_remote/view_models/UploadShowfilePageViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class UploadShowfilePageContainer extends StatelessWidget {
  const UploadShowfilePageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UploadShowfilePageViewModel>(
      builder: (context, viewModel) {
        return UploadShowfilePage(
          viewModel: viewModel,
        );
      },
      converter: (Store<AppState> store) {
        return UploadShowfilePageViewModel(
            onSettingsButtonPressed: () =>
                store.dispatch(goToSettingsPage(context)),
            onFileUpload: (file) =>
                store.dispatch(uploadShowFile(context, file)));
      },
    );
  }
}
