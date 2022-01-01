import 'package:castboard_remote/redux/actions/AsyncActions.dart';
import 'package:castboard_remote/redux/state/AppState.dart';
import 'package:castboard_remote/root_pages/player_settings/PlayerSettings.dart';
import 'package:castboard_remote/view_models/PlayerSettingsPageViewModel.dart';
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
          logsDownloadUri: Uri.http(store.state.playerState.uri.authority, '/logs'),
          systemConfigUri:
              Uri.http(store.state.playerState.uri.authority, '/system'),
          onShowDeviceRestartingSplash: () =>
              store.dispatch(showDeviceRestartingPage(context)),
        );
      },
    );
  }
}
