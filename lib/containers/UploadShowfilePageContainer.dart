import 'package:castboard_showcaller/redux/actions/AsyncActions.dart';
import 'package:castboard_showcaller/redux/state/AppState.dart';
import 'package:castboard_showcaller/root_pages/upload_showfile_page/UploadShowfilePage.dart';
import 'package:castboard_showcaller/view_models/UploadShowfilePageViewModel.dart';
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
            onFileUpload: (file) => store
                .dispatch(uploadShowFile(context, file, isInitialRoute: true)));
      },
    );
  }
}
