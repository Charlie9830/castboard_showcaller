import 'package:castboard_core/models/CastChangeModel.dart';
import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_showcaller/redux/actions/SyncActions.dart';
import 'package:castboard_showcaller/redux/state/EditingState.dart';

EditingState editingStateReducer(EditingState state, dynamic action) {
  if (action is SetDisabledSlideIds) {
    return state.copyWith(
      hasUploadableEdits: true,
      disabledSlideIds: action.ids,
    );
  }

  if (action is ReceiveShowData) {
    final data = action.data;
    return state.copyWith(
      hasUploadableEdits: false,
      selectedPresetId: data.playbackState.currentPresetId,
      combinedPresetIds: data.playbackState.combinedPresetIds,
      editedAssignments: data.playbackState.liveCastChangeEdits,
      slidesMetadata: data.playbackState.slidesMetadata,
      disabledSlideIds: data.playbackState.disabledSlideIds,
    );
  }

  if (action is DeletePreset) {
    return state.copyWith(
      hasUploadableEdits: true,
      selectedPresetId: const PresetModel.builtIn().uid,
      deletedPresetIds: state.deletedPresetIds.toSet()..add(action.presetId),
      combinedPresetIds: <String>[],
      editedAssignments: const CastChangeModel.initial(),
    );
  }

  if (action is UpdatePreset) {
    return state.copyWith(
      hasUploadableEdits: true,
      selectedPresetId: action.preset.uid,
      editedPresetIds: state.editedPresetIds.toSet()..add(action.preset.uid),
    );
  }

  if (action is AddNewPreset) {
    return state.copyWith(
      hasUploadableEdits: true,
      freshPresetIds: state.freshPresetIds.toSet()..add(action.preset.uid),
      selectedPresetId: action.preset.uid,
      combinedPresetIds: const [],
      editedAssignments: const CastChangeModel.initial(),
    );
  }

  if (action is SetSelectedPresetId) {
    if (action.id == state.selectedPresetId) {
      return state;
    }

    return state.copyWith(
      hasUploadableEdits: true,
      selectedPresetId: action.id,
      combinedPresetIds: const <String>[],
      editedAssignments: const CastChangeModel.initial(),
    );
  }

  if (action is UpdateCombinedPresets) {
    return state.copyWith(
      hasUploadableEdits: true,
      selectedPresetId: action.basePreset.uid,
      combinedPresetIds:
          action.combinedPresets.map((preset) => preset.uid).toList(),
    );
  }

  if (action is ClearCombinedPresets) {
    return state.copyWith(
      hasUploadableEdits: true,
      combinedPresetIds: const [],
    );
  }

  if (action is SetHasUploadableEdits) {
    return state.copyWith(hasUploadableEdits: action.value);
  }

  if (action is UpdateAssignment) {
    return state.copyWith(
        hasUploadableEdits: true,
        editedAssignments: state.editedAssignments
            .withUpdatedAssignment(action.trackRef, action.actorRef));
  }

  if (action is ClearLiveEdit) {
    return state.copyWith(
      hasUploadableEdits: true,
      editedAssignments:
          state.editedAssignments.withRemovedAssignment(action.track),
    );
  }

  if (action is ResetLiveEdits) {
    return state.copyWith(
      hasUploadableEdits: true,
      editedAssignments: const CastChangeModel.initial(),
    );
  }

  return state;
}
