import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_showcaller/redux/actions/SyncActions.dart';
import 'package:castboard_showcaller/redux/state/ShowState.dart';

ShowState showStateReducer(ShowState state, dynamic action) {
  if (action is SetFetched) {
    return state.copyWith(
      fetched: action.fetched,
    );
  }

  if (action is ReceiveShowData) {
    return state.copyWith(
      fetched: true,
      actors: action.data.showData.actors,
      tracks: action.data.showData.tracks,
      presets: action.data.showData.presets,
      actorIndex: action.data.showData.actorIndex,
      trackIndex: action.data.showData.trackIndex,
    );
  }

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
