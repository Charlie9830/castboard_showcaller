import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_remote/enums.dart';
import 'package:castboard_remote/redux/actions/SyncActions.dart';
import 'package:castboard_remote/redux/reducers/editingStateReducer.dart';
import 'package:castboard_remote/redux/reducers/navStateReducer.dart';
import 'package:castboard_remote/redux/reducers/playerStateReducer.dart';
import 'package:castboard_remote/redux/reducers/showStateReducer.dart';
import 'package:castboard_remote/redux/state/AppState.dart';

AppState appStateReducer(AppState state, dynamic action) {
  if (action is InitMockData) {
    return state.copyWith(
        navState: state.navState.copyWith(
          homePage: HomePage.castChanges,
          castChangePageTab: CastChangePageTab.presets,
        ),
        showState: state.showState.copyWith(presets: <String, PresetModel>{
          'preset1': PresetModel(uid: 'preset1', name: 'Full Cast Tina', details: 'Some details about this Preset'),
          'preset2': PresetModel(uid: 'preset2', name: 'Full Cast Gemma'),
          'preset3': PresetModel(
            uid: 'preset3',
            name: 'Diamonds',
            isNestable: true,
          ),
          'preset4': PresetModel(
            uid: 'preset4',
            name: 'Saphires',
            isNestable: true,
          ),
          'preset5': PresetModel(
            uid: 'preset5',
            name: 'Rubies',
            isNestable: true,
          ),
        }));
  }

  return state.copyWith(
    showState: showStateReducer(state.showState, action),
    navState: navStateReducer(state.navState, action),
    playerState: playerStateReducer(state.playerState, action),
    editingState: editingStateReducer(state.editingState, action),
  );
}
