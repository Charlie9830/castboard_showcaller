import 'package:castboard_remote/HomeScaffold.dart';
import 'package:castboard_remote/enums.dart';
import 'package:castboard_remote/redux/actions/AsyncActions.dart';
import 'package:castboard_remote/redux/actions/SyncActions.dart';
import 'package:castboard_remote/redux/state/AppState.dart';
import 'package:castboard_remote/view_models/HomeScaffoldViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class HomeScaffoldContainer extends StatelessWidget {
  const HomeScaffoldContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeScaffoldViewModel>(
      builder: (context, viewModel) {
        return HomeScaffold(
          viewModel: viewModel,
        );
      },
      converter: (Store<AppState> store) {
        return HomeScaffoldViewModel(
          currentPage: store.state.navState.homePage,
          onHomePageChanged: (HomePage page) => store.dispatch(
            SetHomePage(page),
          ),
          onPlaybackAction: (action) => store.dispatch(
            sendPlaybackAction(action),
          ),
          onCastChangeTabChanged: (tab) => store.dispatch(
            SetCastChangePageTab(tab),
          ),
          onDebugButtonPressed: () => store.dispatch(InitMockData()),
        );
      },
    );
  }
}
