import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:castboard_core/models/CastChangeModel.dart';
import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_core/models/RemoteCastChangeData.dart';
import 'package:castboard_core/models/RemoteShowData.dart';
import 'package:castboard_core/models/ShowDataModel.dart';
import 'package:castboard_core/models/ShowModificationData.dart';
import 'package:castboard_remote/Routes.dart';
import 'package:castboard_remote/dialogs/AddNewPresetDialog.dart';
import 'package:castboard_remote/dialogs/DeletePresetDialog.dart';
import 'package:castboard_remote/dialogs/EditPresetPropertiesDialog.dart';
import 'package:castboard_remote/dialogs/FileUploadDialog.dart';
import 'package:castboard_remote/dialogs/ResyncingDialog.dart';
import 'package:castboard_remote/dialogs/SelectNestedPresetBottomSheet.dart';
import 'package:castboard_remote/dialogs/UpdatePresetDialog.dart';
import 'package:castboard_remote/enums.dart';
import 'package:castboard_remote/redux/actions/SyncActions.dart';
import 'package:castboard_remote/redux/state/AppState.dart';
import 'package:castboard_remote/snackBars/FileUploadSnackBar.dart';
import 'package:castboard_remote/utils/getUid.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:http/http.dart' as http;

ThunkAction<AppState> uploadShowFile(BuildContext context, XFile file) {
  return (Store<AppState> store) async {
    final uri = Uri.http(store.state.playerState.uri.authority, '/upload');

    final byteData = await file.readAsBytes();

    final result = await showDialog(
        context: context,
        builder: (builderContext) =>
            FileUploadDialog(uri: uri, byteData: byteData));

    if (result is FileUploadDialogResult) {
      if (result.response == null) {
        // An Exception was thrown.
        print(result.exceptionMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: FileUploadSnackBar(success: false)),
        );
        return;
      }

      final statusCode = result.response!.statusCode;

      if (statusCode != 200) {
        // Something went wrong Serverside.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: FileUploadSnackBar(success: false)),
        );
        print(result.response!.body);
        return;
      }

      // Ensure we are in sync with Player.
      showDialog(context: context, builder: (_) => ResyncingDialog());
      await Future.delayed(Duration(
          seconds:
              4)); // Give he player some breathing room to finish loading the show File.

      final uri = Uri.http(store.state.playerState.uri.authority, '/show');

      try {
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final raw = jsonDecode(response.body);
          final data = RemoteShowData.fromMap(raw);
          store.dispatch(ReceiveShowData(data));
          store.dispatch(SetHomePage(HomePage.remote));

          Navigator.of(context).pop();
        } else {
          print(response.statusCode);
        }
      } catch (error) {
        print(error);

        if (kDebugMode) {
          store.dispatch(SetHomePage(HomePage.remote));
          Navigator.of(context).pop();
        }
      }
    }
  };
}

ThunkAction<AppState> uploadCastChange(BuildContext context) {
  return (Store<AppState> store) async {
    final uri = Uri.http(store.state.playerState.uri.authority, '/show');

    final remoteShowData = RemoteShowData(
        playbackState: PlaybackStateData(
          combinedPresetIds: store.state.editingState.combinedPresetIds,
          currentPresetId: store.state.editingState.selectedPresetId,
          liveCastChangeEdits: store.state.editingState.editedAssignments,
        ),
        showModificationData: ShowModificationData(
          deletedPresetIds: store.state.editingState.deletedPresetIds,
          editedPresetIds: store.state.editingState.editedPresetIds,
          freshPresetIds: store.state.editingState.freshPresetIds,
        ),
        showData: ShowDataModel(
          presets: store.state.showState.presets,
        ));

    final jsonShowData = json.encode(remoteShowData.toMap());

    final response = await http.post(uri,
        body: jsonShowData, headers: {'Content-Type': 'application/json'});
    print(response.statusCode);
  };
}

ThunkAction<AppState> pullShowData(BuildContext context) {
  return (Store<AppState> store) async {
    final uri = Uri.http(store.state.playerState.uri.authority, '/show');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final raw = jsonDecode(response.body);
        final data = RemoteShowData.fromMap(raw);
        store.dispatch(ReceiveShowData(data));

        Navigator.of(context).popAndPushNamed(Routes.home);
      } else {
        print(response.statusCode);
      }
    } catch (error) {
      print(error);

      if (kDebugMode) {
        Navigator.of(context).popAndPushNamed(Routes.home);
      }
    }
  };
}

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
