import 'package:castboard_showcaller/ResponsiveBuilder.dart';
import 'package:castboard_showcaller/containers/selectors.dart';
import 'package:castboard_showcaller/home_scaffold/HomeScaffoldLarge.dart';
import 'package:castboard_showcaller/home_scaffold/HomeScaffoldSmall.dart';
import 'package:castboard_showcaller/enums.dart';
import 'package:castboard_showcaller/redux/actions/AsyncActions.dart';
import 'package:castboard_showcaller/redux/actions/SyncActions.dart';
import 'package:castboard_showcaller/redux/state/AppState.dart';
import 'package:castboard_showcaller/view_models/HomePopupMenuViewModel.dart';
import 'package:castboard_showcaller/view_models/HomeScaffoldViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class HomeScaffoldContainer extends StatelessWidget {
  const HomeScaffoldContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeScaffoldViewModel>(
      builder: (context, viewModel) {
        return ResponsiveBuilder(
            smallContentBuilder: (_) => HomeScaffoldSmall(
                  viewModel: viewModel,
                ),
            largeContentBuilder: (_) =>
                HomeScaffoldLarge(viewModel: viewModel));
      },
      converter: (Store<AppState> store) {
        return HomeScaffoldViewModel(
          hasUploadableEdits: store.state.editingState.hasUploadableEdits,
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
          onUploadCastChange: () => store.dispatch(uploadShowData(context)),
          popupMenuViewModel: HomePopupMenuViewModel(
            allowPresetUpdates: selectShowPresetActions(store),
            mode: _selectSettingsMode(store),
            onUpdatePreset: () => store.dispatch(updatePreset(context)),
            onResetChanges: () => store.dispatch(ResetLiveEdits()),
            onSettingsPressed: () => store.dispatch(goToSettingsPage(context)),
          ),
          onSettingsButtonPressed: () =>
              store.dispatch(goToSettingsPage(context)),
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
}
