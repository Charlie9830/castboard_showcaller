import 'package:castboard_showcaller/redux/actions/AsyncActions.dart';
import 'package:castboard_showcaller/redux/state/AppState.dart';
import 'package:castboard_showcaller/root_pages/player_settings/PlayerSettings.dart';
import 'package:castboard_showcaller/view_models/PlayerSettingsPageViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class PlayerSettingsPageContainer extends StatelessWidget {
  const PlayerSettingsPageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PlayerSettingsPageViewModel>(
      builder: (context, viewModel) {
        return PlayerSettings(
          viewModel: viewModel,
        );
      },
      converter: (Store<AppState> store) {
        return PlayerSettingsPageViewModel(
            uri: store.state.playerState.uri,
            systemConfigUri:
                Uri.http(store.state.playerState.uri.authority, '/system'),
            onShowDeviceRestartingSplash: () =>
                store.dispatch(showDeviceRestartingPage(context)),
            onUpdateSoftwareButtonPressed: () =>
                store.dispatch(updateSoftware(context)));
      },
    );
  }
}
