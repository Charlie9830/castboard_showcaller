import 'package:castboard_core/models/ActorRef.dart';
import 'package:castboard_core/models/CastChangeModel.dart';
import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_core/models/TrackRef.dart';
import 'package:castboard_remote/redux/actions/SyncActions.dart';
import 'package:castboard_remote/redux/state/EditingState.dart';
import 'package:castboard_remote/redux/state/NavigationState.dart';

EditingState editingStateReducer(EditingState state, dynamic action) {
  if (action is ReceiveShowData) {
    final data = action.data;
    return state.copyWith(
      selectedPresetId: data.playbackState.currentPresetId,
      combinedPresetIds: data.playbackState.combinedPresetIds,
      editedAssignments: data.playbackState.liveCastChangeEdits,
    );
  }

  if (action is DeletePreset) {
    return state.copyWith(
      selectedPresetId: const PresetModel.builtIn().uid,
      deletedPresetIds: state.deletedPresetIds.toSet()..add(action.presetId),
      combinedPresetIds: <String>[],
      editedAssignments: CastChangeModel.initial(),
    );
  }

  if (action is UpdatePreset) {
    return state.copyWith(
      selectedPresetId: action.preset.uid,
      editedPresetIds: state.editedPresetIds.toSet()..add(action.preset.uid),
    );
  }

  if (action is AddNewPreset) {
    return state.copyWith(
      freshPresetIds: state.freshPresetIds.toSet()..add(action.preset.uid),
      selectedPresetId: action.preset.uid,
      combinedPresetIds: const [],
      editedAssignments: CastChangeModel.initial(),
    );
  }

  if (action is SetSelectedPresetId) {
    if (action.id == state.selectedPresetId) {
      return state;
    }

    return state.copyWith(
      selectedPresetId: action.id,
      combinedPresetIds: const <String>[],
      editedAssignments: CastChangeModel.initial(),
    );
  }

  if (action is UpdateCombinedPresets) {
    return state.copyWith(
      selectedPresetId: action.basePreset.uid,
      combinedPresetIds:
          action.combinedPresets.map((preset) => preset.uid).toList(),
    );
  }

  if (action is ClearCombinedPresets) {
    return state.copyWith(
      combinedPresetIds: const [],
    );
  }

  if (action is UpdateAssignment) {
    return state.copyWith(
        editedAssignments: state.editedAssignments
            .withUpdatedAssignment(action.trackRef, action.actorRef));
  }

  if (action is ClearLiveEdit) {
    return state.copyWith(
      editedAssignments:
          state.editedAssignments.withRemovedAssignment(action.track),
    );
  }

  if (action is ResetLiveEdits) {
    return state.copyWith(
      editedAssignments: CastChangeModel.initial(),
    );
  }

  return state;
}
