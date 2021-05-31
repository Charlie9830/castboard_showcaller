import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_remote/redux/actions/SyncActions.dart';
import 'package:castboard_remote/redux/state/AppState.dart';
import 'package:castboard_remote/redux/state/ShowState.dart';

ShowState showStateReducer(ShowState state, dynamic action) {
  if (action is AddNewPreset) {
    return state.copyWith(
      presets: Map<String, PresetModel>.from(state.presets)
        ..addAll({
          action.preset.uid: action.preset,
        }),
    );
  }

  if (action is UpdatePreset) {
    return state.copyWith(
        presets: Map<String, PresetModel>.from(state.presets)
          ..update(action.preset.uid, (_) => action.preset));
  }

  if (action is DeletePreset) {
    return state.copyWith(
      presets: Map<String, PresetModel>.from(state.presets)
        ..remove(action.presetId),
    );
  }

  return state;
}
