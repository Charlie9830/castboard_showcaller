import 'dart:async';
import 'dart:convert';

import 'package:castboard_core/models/CastChangeModel.dart';
import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_core/models/RemoteShowData.dart';
import 'package:castboard_core/models/ShowDataModel.dart';
import 'package:castboard_core/models/ShowModificationData.dart';
import 'package:castboard_core/models/playback_state_model.dart';
import 'package:castboard_core/utils/is_mobile_layout.dart';
import 'package:castboard_showcaller/Routes.dart';
import 'package:castboard_showcaller/dialogs/AddNewPresetDialog.dart';
import 'package:castboard_showcaller/dialogs/DeletePresetDialog.dart';
import 'package:castboard_showcaller/dialogs/EditPresetPropertiesDialog.dart';
import 'package:castboard_showcaller/dialogs/FileUploadDialog.dart';
import 'package:castboard_showcaller/dialogs/ResyncingDialog.dart';
import 'package:castboard_showcaller/dialogs/SelectNestedPresetBottomSheet.dart';
import 'package:castboard_showcaller/dialogs/UpdatePresetDialog.dart';
import 'package:castboard_showcaller/dialogs/performer_update_ready_dialog.dart';
import 'package:castboard_showcaller/enums.dart';
import 'package:castboard_showcaller/global_keys.dart';
import 'package:castboard_showcaller/presence/PresenceManager.dart';
import 'package:castboard_showcaller/redux/actions/SyncActions.dart';
import 'package:castboard_showcaller/redux/state/AppState.dart';
import 'package:castboard_showcaller/root_pages/WaitingOverlay.dart';
import 'package:castboard_showcaller/snackBars/FileUploadSnackBar.dart';
import 'package:castboard_showcaller/snackBars/GeneralMessageSnackBar.dart';
import 'package:castboard_showcaller/utils/getUid.dart';
import 'package:castboard_showcaller/utils/is_root_scaffold_mounted.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:http/http.dart' as http;

ThunkAction<AppState> showDeviceRestartingPage(BuildContext context) {
  return (Store<AppState> store) async {
    navigatorKey.currentState?.pushNamed(Routes.deviceRestarting);

    final playerUp = await _waitForPlayerRestart(store.state.playerState.uri,
        const Duration(seconds: kDebugMode ? 2 : 30));

    if (playerUp == true) {
      // Player has restarted and we are ready to restablish a connection.
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(Routes.splash, (route) => false);
    } else {
      // Player has not returned. We may have discconected off the network. Prompt the user to refresh.
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(Routes.connectionFailed, (route) => false);
    }
  };
}

ThunkAction<AppState> goToSettingsPage(BuildContext context) {
  return (Store<AppState> store) async {
    navigatorKey.currentState?.pushNamed(Routes.settings);
  };
}

ThunkAction<AppState> uploadShowFile(BuildContext context, XFile file,
    {bool isInitialRoute = false}) {
  return (Store<AppState> store) async {
    final uri = Uri.http(store.state.playerState.uri.authority, '/upload');

    final result = await showDialog(
        context: context,
        builder: (builderContext) => FileUploadDialog(uri: uri, xFile: file));

    if (result is FileUploadDialogResult) {
      if (result.response == null) {
        // An Exception was thrown.
        if (isRootScaffoldMounted()) {}
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: FileUploadSnackBar(success: false)),
        );
        return;
      }

      final statusCode = result.response!.statusCode;

      if (statusCode != 200) {
        // Something went wrong Serverside.
        final serverMessage = result.response!.body;
        if (isRootScaffoldMounted() == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: FileUploadSnackBar(
              success: false,
              message: serverMessage,
            )),
          );
        }

        return;
      }

      // Ensure we are in sync with Player.
      showDialog(context: context, builder: (_) => const ResyncingDialog());
      await Future.delayed(const Duration(
          seconds:
              4)); // Give the player some breathing room to finish loading the show File.

      final uri = Uri.http(store.state.playerState.uri.authority, '/show');

      try {
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final raw = jsonDecode(response.body);
          final data = RemoteShowData.fromMap(raw);
          store.dispatch(ReceiveShowData(data));

          // If we are in Large Layout we go to the Cast Changes Tab. Otherwise we go to the Remote Tab.
          if (scaffoldKey.currentContext != null &&
              isNotMobileLayout(scaffoldKey.currentContext!)) {
            store.dispatch(SetHomePage(HomePage.castChanges));
          } else {
            store.dispatch(SetHomePage(HomePage.remote));
          }

          // Pops the resyncing Dialog.
          navigatorKey.currentState?.pop();

          if (isInitialRoute) {
            // Because this is the initial route. We have no home page route underneath in the stack.
            navigatorKey.currentState?.popAndPushNamed(Routes.home);
          }
        } else {
          print(response.statusCode);
        }
      } catch (error) {
        print(error);

        if (kDebugMode) {
          store.dispatch(SetHomePage(HomePage.remote));

          if (navigatorKey.currentState?.canPop() == true) {
            navigatorKey.currentState?.pop();
          } else {
            navigatorKey.currentState?.popAndPushNamed(Routes.home);
          }
        }
      }
    }
  };
}

ThunkAction<AppState> uploadShowData(BuildContext context) {
  return (Store<AppState> store) async {
    final uri = Uri.http(store.state.playerState.uri.authority, '/show');

    if (store.state.editingState.slidesMetadata.every((slide) =>
        store.state.editingState.disabledSlideIds.contains(slide.slideId))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: GeneralMessageSnackBar(
              success: false,
              message: 'Please select at least one slide to display')));
      store.dispatch(SetHomePage(HomePage.slides));
      return;
    }

    final remoteShowData = RemoteShowData(
        playbackState: PlaybackStateModel(
          combinedPresetIds: store.state.editingState.combinedPresetIds,
          currentPresetId: store.state.editingState.selectedPresetId,
          liveCastChangeEdits: store.state.editingState.editedAssignments,
          disabledSlideIds: store.state.editingState.disabledSlideIds,
          slidesMetadata: [], // We don't need to pass the Slide Metadata back to Performer.
        ),
        showModificationData: ShowModificationData(
          deletedPresetIds: store.state.editingState.deletedPresetIds,
          editedPresetIds: store.state.editingState.editedPresetIds,
          freshPresetIds: store.state.editingState.freshPresetIds,
        ),
        showData: ShowDataModel(
          presets: store.state.showState.presets,
          actorIndex: const ShowDataModel.initial().actorIndex,
          actors: const ShowDataModel.initial().actors,
          trackRefsByName: const ShowDataModel.initial().trackRefsByName,
          tracks: const ShowDataModel.initial().tracks,
          trackIndex: const ShowDataModel.initial().trackIndex,
          subtitleFields: const ShowDataModel.initial().subtitleFields,
        ));

    final jsonShowData = json.encode(remoteShowData.toMap());

    showDialog(context: context, builder: (_) => const WaitingOverlay());

    try {
      final response = await http.post(uri,
          body: jsonShowData, headers: {'Content-Type': 'application/json'});

      navigatorKey.currentState?.pop();
      if (response.statusCode == 200) {
        store.dispatch(SetHasUploadableEdits(false));

        if (isRootScaffoldMounted()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: GeneralMessageSnackBar(
                  success: true, message: 'Changes uploaded'),
            ),
          );
        }
      } else {
        if (isRootScaffoldMounted()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: GeneralMessageSnackBar(
                  success: false,
                  message: 'Something went wrong, please try again.'),
            ),
          );
        }
      }
    } catch (error) {
      navigatorKey.currentState?.pop();

      if (isRootScaffoldMounted()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: GeneralMessageSnackBar(
                success: false,
                message: 'Something went wrong, please try again.'),
          ),
        );
      }
    }
  };
}

ThunkAction<AppState> initializeApp(BuildContext context) {
  return (Store<AppState> store) async {
    final uri = Uri.http(store.state.playerState.uri.authority, '/show');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final raw = jsonDecode(response.body);
        final data = RemoteShowData.fromMap(raw);
        store.dispatch(ReceiveShowData(data));

        final bool showLoaded =
            data.manifest != null && data.manifest!.created.isNotEmpty;

        if (data.softwareUpdateReady) {
          // A software Update for Performer is ready to install. Inform the user.
          await showDialog(
              context: context,
              builder: (_) => const PerformerUpdateReadyDialog());
        }

        if (showLoaded) {
          navigatorKey.currentState?.popAndPushNamed(Routes.home);
        } else {
          navigatorKey.currentState?.popAndPushNamed(Routes.showfileUpload);
        }

        // Establish a Heartbeat.
        final presenceManager = PresenseManager(
          serverUri: store.state.playerState.uri,
          sessionId: getUid(),
        )..establishHeartbeat();
      } else {
        print(response.statusCode);
      }
    } catch (error) {
      print(error);

      // If in debug. Continue on through to home anyway.
      if (kDebugMode) {
        store.dispatch(SetFetched(true));
        navigatorKey.currentState?.popAndPushNamed(Routes.home);
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
      name: '${preset.name} Copy',
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
      builder: (builderContext) => const AddNewPresetDialog(),
    );

    if (result is AddNewPresetDialogResult) {
      final preset = PresetModel(
        uid: getUid(),
        createdOnRemote: true,
        name: result.name,
        details: result.details,
        colorTagIndex: result.colorTagIndex,
        castChange: result.useExistingCastChange
            ? buildCopiedCastChange(
                store.state.showState
                    .presets[store.state.editingState.selectedPresetId],
                store.state.editingState.combinedPresetIds
                    .map((id) => store.state.showState.presets[id]!)
                    .toList(),
                store.state.editingState.editedAssignments,
              )
            : const CastChangeModel.initial(),
      );

      store.dispatch(AddNewPreset(preset));
    }
  };
}

ThunkAction<AppState> combinePreset(BuildContext context, String presetId) {
  return (Store<AppState> store) async {
    final unavailablePresetIds =
        store.state.editingState.combinedPresetIds.toSet();

    final availablePresets = store.state.showState.presets.values
        .where((preset) =>
            preset.uid != store.state.editingState.selectedPresetId &&
            unavailablePresetIds.contains(preset.uid) == false)
        .toList();

    if (availablePresets.isEmpty) {
      // Wouldn't be able to show any available options to user. So Bail.
      return;
    }

    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (builderContext) => SelectNestedPresetBottomSheet(
        availablePresets: availablePresets,
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
    return const CastChangeModel.initial();
  }

  return preset.castChange
      .combinedWithOthers(combinedPresets.map((item) => item.castChange))
      .stompedByOther(editedCastChange);
}

/// Waits for the player to restart, begins pinging the player for signs of life after the [initialWait] as expired.
/// Returns true once player has replied to a ping.
/// Will attempt to ping the player [maxAttempts] number of times before returning false.
Future<bool> _waitForPlayerRestart(
  Uri uri,
  Duration initialWait, {
  int maxAttempts = 5,
  int throttleSeconds = 1,
}) async {
  // Wait for the initial time before we start pinging the player.
  await Future.delayed(initialWait);

  int currentAttempt = 0;
  while (currentAttempt <= maxAttempts) {
    print('Attemping to Ping Player, currentAttempt $currentAttempt');
    final result = await _pingPlayer(uri);
    if (result == true) {
      return true;
    }

    await Future.delayed(Duration(seconds: throttleSeconds));
    currentAttempt++;
  }

  return false;
}

Future<bool> _pingPlayer(Uri uri) async {
  final target = Uri.http(uri.authority, '/alive/doop');

  try {
    final response = await http.get(target);
    return response.statusCode == 200 ? true : false;
  } catch (e) {
    print(e);
    return false;
  }
}
