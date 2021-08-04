import 'package:castboard_remote/HomeScaffold.dart';
import 'package:castboard_remote/enums.dart';
import 'package:castboard_remote/redux/actions/AsyncActions.dart';
import 'package:castboard_remote/redux/actions/SyncActions.dart';
import 'package:castboard_remote/redux/state/AppState.dart';
import 'package:castboard_remote/view_models/HomePopupMenuViewModel.dart';
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
          onUploadCastChange: () => store.dispatch(uploadCastChange(context)),
          popupMenuViewModel: HomePopupMenuViewModel(
            allowPresetUpdates: _selectShowPresetActions(store),
            mode: _selectSettingsMode(store),
            onUpdatePreset: () => store.dispatch(updatePreset(context)),
            onResetChanges: () => store.dispatch(ResetLiveEdits()),
            onSettingsPressed: () => store.dispatch(goToSettingsPage(context)),
          ),
        );
      },
    );
  }

  HomeSettingsMenuMode _selectSettingsMode(Store<AppState> store) {
    if (store.state.navState.homePage == HomePage.remote ||
        store.state.navState.homePage == HomePage.showfile) {
      return HomeSettingsMenuMode.playerSettings;
    }

    if (store.state.navState.homePage == HomePage.castChanges) {
      return HomeSettingsMenuMode.castChangeActions;
    }

    return HomeSettingsMenuMode.generic;
  }

  bool _selectShowPresetActions(Store<AppState> store) {
    return store.state.editingState.editedAssignments.isNotEmpty;
  }
}
