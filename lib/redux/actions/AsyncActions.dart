import 'package:castboard_remote/dialogs/SelectNestedPresetBottomSheet.dart';
import 'package:castboard_remote/enums.dart';
import 'package:castboard_remote/redux/actions/SyncActions.dart';
import 'package:castboard_remote/redux/state/AppState.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:http/http.dart' as http;

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

    print(result.runtimeType);
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
