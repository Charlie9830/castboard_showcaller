import 'package:castboard_core/models/ActorIndex.dart';
import 'package:castboard_core/models/ActorOrDividerViewModel.dart';
import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_core/models/TrackIndex.dart';
import 'package:castboard_core/models/TrackOrIndexViewModel.dart';
import 'package:castboard_showcaller/ResponsiveBuilder.dart';
import 'package:castboard_showcaller/containers/selectors.dart';

import 'package:castboard_showcaller/redux/actions/AsyncActions.dart';
import 'package:castboard_showcaller/redux/actions/SyncActions.dart';
import 'package:castboard_showcaller/redux/state/AppState.dart';
import 'package:castboard_showcaller/root_pages/cast_change/CastChangePageLarge.dart';
import 'package:castboard_showcaller/root_pages/cast_change/CastChangePageSmall.dart';
import 'package:castboard_showcaller/view_models/CastChangePageViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CastChangePageContainer extends StatelessWidget {
  final TabController? tabController;
  const CastChangePageContainer({Key? key, this.tabController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CastChangePageViewModel>(
      builder: (context, viewModel) {
        return ResponsiveBuilder(
            smallContentBuilder: (_) => CastChangePageSmall(
                  viewModel: viewModel,
                  tabController: tabController,
                ),
            largeContentBuilder: (_) => CastChangePageLarge(
                  viewModel: viewModel,
                ));
      },
      converter: (Store<AppState> store) {
        return CastChangePageViewModel(
          actors: store.state.showState.actors,
          tracks: store.state.showState.tracks,
          actorViewModels: _selectActorViewModels(store),
          trackViewModels: _selectTrackViewModels(store),
          presets: store.state.showState.presets,
          basePreset: _selectBasePreset(store),
          selectedPresetId: store.state.editingState.selectedPresetId,
          combinedPresets: _selectCombinedPresets(store),
          editedAssignments: store.state.editingState.editedAssignments,
          onPresetSelected: (id) => store.dispatch(
            SetSelectedPresetId(
              id: id,
              preset: store.state.showState.presets[id],
            ),
          ),
          onCombinePresetButtonPressed: (presetId) => store.dispatch(
            combinePreset(context, presetId),
          ),
          onAssignmentUpdated: (trackRef, actorRef) => store.dispatch(
            UpdateAssignment(
              trackRef: trackRef,
              actorRef: actorRef,
            ),
          ),
          onClearLiveEdit: (trackRef) =>
              store.dispatch(ClearLiveEdit(trackRef)),
          onNewPresetButtonPressed: () => store.dispatch(addNewPreset(context)),
          onDeletePreset: (presetId) =>
              store.dispatch(deletePreset(context, presetId)),
          onDuplicatePreset: (presetId) =>
              store.dispatch(duplicatePreset(presetId)),
          onEditPresetProperties: (presetId) =>
              store.dispatch(editPresetProperties(context, presetId)),
          allowPresetUpdates: selectShowPresetActions(store),
          onUpdatePreset: () => store.dispatch(updatePreset(context)),
          onResetChanges: () => store.dispatch(ResetLiveEdits()),
        );
      },
    );
  }

  List<ActorOrDividerViewModel> _selectActorViewModels(Store<AppState> store) {
    return ActorIndexBase.toViewModels(
        store.state.showState.actors, store.state.showState.actorIndex);
  }

  List<TrackOrDividerViewModel> _selectTrackViewModels(Store<AppState> store) {
    return TrackIndexBase.toViewModels(
        store.state.showState.tracks, store.state.showState.trackIndex);
  }

  PresetModel? _selectBasePreset(Store<AppState> store) {
    return store
        .state.showState.presets[store.state.editingState.selectedPresetId];
  }

  List<PresetModel> _selectCombinedPresets(Store<AppState> store) =>
      store.state.editingState.combinedPresetIds
          .map((id) => store.state.showState.presets[id]!)
          .toList();
}
