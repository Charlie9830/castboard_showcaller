import 'package:castboard_remote/redux/actions/SyncActions.dart';
import 'package:castboard_remote/redux/state/EditingState.dart';
import 'package:castboard_remote/redux/state/NavigationState.dart';

EditingState editingStateReducer(EditingState state, dynamic action) {
  if (action is SetSelectedPresetId) {
    return state.copyWith(
        selectedPresetId: action.id, combinedPresetIds: const <String>[]);
  }

  if (action is UpdateCombinedPresets) {
    return state.copyWith(
        selectedPresetId: action.basePreset.uid,
        combinedPresetIds:
            action.combinedPresets.map((preset) => preset.uid).toList(),
        activeCastChange: action.basePreset.castChange.combinedWithOthers(
            action.combinedPresets.map((preset) => preset.castChange)));
  }

  return state;
}
