import 'package:castboard_showcaller/HomeScaffold.dart';
import 'package:castboard_showcaller/SplashScreen.dart';
import 'package:castboard_showcaller/enums.dart';
import 'package:castboard_showcaller/redux/actions/AsyncActions.dart';
import 'package:castboard_showcaller/redux/state/AppState.dart';
import 'package:castboard_showcaller/root_pages/showfile_page/ShowfilePage.dart';
import 'package:castboard_showcaller/view_models/ShowfilePageViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ShowfilePageContainer extends StatelessWidget {
  const ShowfilePageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ShowfilePageViewModel>(
      builder: (context, viewModel) {
        return ShowfilePage(
          viewModel: viewModel,
        );
      },
      converter: (Store<AppState> store) {
        return ShowfilePageViewModel(
            uri: store.state.playerState.uri,
            onFileUpload: (file) =>
                store.dispatch(uploadShowFile(context, file)));
      },
    );
  }
}
