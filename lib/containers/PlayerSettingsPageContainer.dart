import 'package:castboard_remote/HomeScaffold.dart';
import 'package:castboard_remote/SplashScreen.dart';
import 'package:castboard_remote/enums.dart';
import 'package:castboard_remote/redux/actions/AsyncActions.dart';
import 'package:castboard_remote/redux/actions/SyncActions.dart';
import 'package:castboard_remote/redux/state/AppState.dart';
import 'package:castboard_remote/root_pages/player_settings/PlayerSettings.dart';
import 'package:castboard_remote/root_pages/showfile_page/ShowfilePage.dart';
import 'package:castboard_remote/view_models/HomePopupMenuViewModel.dart';
import 'package:castboard_remote/view_models/HomeScaffoldViewModel.dart';
import 'package:castboard_remote/view_models/PlayerSettingsPageViewModel.dart';
import 'package:castboard_remote/view_models/ShowfilePageViewModel.dart';
import 'package:castboard_remote/view_models/SplashScreenViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class PlayerSettingsPageContainer extends StatelessWidget {
  const PlayerSettingsPageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PlayerSettingsPageViewModel>(
      builder: (context, viewModel) {
        return PlayerSettings();
      },
      converter: (Store<AppState> store) {
        return PlayerSettingsPageViewModel();
      },
    );
  }
}
