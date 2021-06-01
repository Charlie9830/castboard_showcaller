import 'package:castboard_core/models/CastChangeModel.dart';
import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_remote/dialogs/AddNewPresetDialog.dart';
import 'package:castboard_remote/dialogs/DeletePresetDialog.dart';
import 'package:castboard_remote/dialogs/EditPresetPropertiesDialog.dart';
import 'package:castboard_remote/dialogs/SelectNestedPresetBottomSheet.dart';
import 'package:castboard_remote/dialogs/UpdatePresetDialog.dart';
import 'package:castboard_remote/enums.dart';
import 'package:castboard_remote/redux/actions/SyncActions.dart';
import 'package:castboard_remote/redux/state/AppState.dart';
import 'package:castboard_remote/utils/getUid.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:http/http.dart' as http;

ThunkAction<AppState> updatePreset(BuildContext context) {
  return (Store<AppState> store) async {
    final preset = store
        .state.showState.presets[store.state.editingState.selectedPresetId];

    if (preset == null) {
      return;
    }

    final result = await showDialog(
        context: context,
        builder: (builderContext) => UpdatePresetDialog(
              presetName: preset.name,
            ));

    if (result is bool && result == true) {
      final newPreset = preset.copyWith(
        castChange: preset.castChange
            .combinedWithOthers(
              store.state.editingState.combinedPresetIds
                  .map((id) => store.state.showState.presets[id]!.castChange),
            )
            .stompedByOther(store.state.editingState.editedAssignments),
      );

      store.dispatch(UpdatePreset(newPreset));
      store.dispatch(ResetLiveEdits());
      store.dispatch(ClearCombinedPresets());
    }
  };
}

ThunkAction<AppState> showPlayerSettings(BuildContext context) {
  return (Store<AppState> store) async {};
}

ThunkAction<AppState> editPresetProperties(
    BuildContext context, String presetId) {
  return (Store<AppState> store) async {
    final preset = store.state.showState.presets[presetId];

    if (preset == null) {
      return;
    }

    final result = await showDialog(
        context: context,
        builder: (builderContext) =>
            EditPresetPropertiesDialog(existing: preset));

    if (result is PresetModel) {
      store.dispatch(UpdatePreset(result));
    }
  };
}

ThunkAction<AppState> deletePreset(BuildContext context, String presetId) {
  return (Store<AppState> store) async {
    final preset = store.state.showState.presets[presetId];

    if (preset == null) {
      return;
    }

    final result = await showDialog(
        context: context,
        builder: (builderContext) =>
            DeletePresetDialog(presetName: preset.name));

    if (result is bool && result == true) {
      store.dispatch(DeletePreset(presetId));
    }
  };
}

ThunkAction<AppState> duplicatePreset(String sourcePresetId) {
  return (Store<AppState> store) async {
    final preset = store.state.showState.presets[sourcePresetId];

    if (preset == null) {
      return;
    }

    final newPreset = preset.copyWith(
      uid: getUid(),
      name: preset.name + ' Copy',
      createdOnRemote: true,
      castChange: preset.castChange.copy(),
    );

    store.dispatch(AddNewPreset(newPreset));
  };
}

ThunkAction<AppState> addNewPreset(BuildContext context) {
  return (Store<AppState> store) async {
    final result = await showDialog(
      context: context,
      builder: (builderContext) => AddNewPresetDialog(),
    );

    if (result is AddNewPresetDialogResult) {
      final preset = PresetModel(
        uid: getUid(),
        createdOnRemote: true,
        name: result.name,
        details: result.details,
        isNestable: result.isNestable,
        castChange: result.useExistingCastChange
            ? buildCopiedCastChange(
                store.state.showState
                    .presets[store.state.editingState.selectedPresetId],
                store.state.editingState.combinedPresetIds
                    .map((id) => store.state.showState.presets[id]!)
                    .toList(),
                store.state.editingState.editedAssignments,
              )
            : CastChangeModel.initial(),
      );

      store.dispatch(AddNewPreset(preset));
    }
  };
}

ThunkAction<AppState> combinePreset(BuildContext context, String presetId) {
  return (Store<AppState> store) async {
    final nestablePresets = store.state.showState.presets.values
        .where((preset) => preset.isNestable == true);

    final unavailablePresetIds =
        store.state.editingState.combinedPresetIds.toSet();

    if (nestablePresets.isEmpty ||
        nestablePresets.length == unavailablePresetIds.length) {
      // Wouldn't be able to show any available options to user. So Bail.
      return;
    }

    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (builderContext) => SelectNestedPresetBottomSheet(
        availablePresets: nestablePresets.toList(),
        unavailablePresetIds: unavailablePresetIds,
      ),
    );

    if (result is String && result.isNotEmpty) {
      final newCombinedPresetIds =
          store.state.editingState.combinedPresetIds.toList()..add(result);
      final basePreset = store.state.showState.presets[presetId]!;

      store.dispatch(UpdateCombinedPresets(
        basePreset: basePreset,
        combinedPresets: newCombinedPresetIds
            .map((id) => store.state.showState.presets[id]!)
            .toList(),
      ));
    }
  };
}

ThunkAction<AppState> sendPlaybackAction(PlaybackAction action) {
  return (Store<AppState> store) async {
    final uri = Uri.http(store.state.playerState.uri.authority, '/playback');
    final payload = _buildPlaybackActionPayload(action);

    try {
      final response = await http.put(uri, body: payload);
      print(response.statusCode);
    } catch (error) {
      print('');
      print(error);
      print('');
    }
  };
}

String _buildPlaybackActionPayload(PlaybackAction action) {
  switch (action) {
    case PlaybackAction.play:
      return 'play';
    case PlaybackAction.pause:
      return 'pause';
    case PlaybackAction.prev:
      return 'prev';
    case PlaybackAction.next:
      return 'next';
  }
}

CastChangeModel buildCopiedCastChange(PresetModel? preset,
    List<PresetModel> combinedPresets, CastChangeModel editedCastChange) {
  if (preset == null) {
    return CastChangeModel.initial();
  }

  return preset.castChange
      .combinedWithOthers(combinedPresets.map((item) => item.castChange))
      .stompedByOther(editedCastChange);
}
