import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_remote/HomeScaffold.dart';
import 'package:castboard_remote/cast_change_page/CastChangePage.dart';
import 'package:castboard_remote/enums.dart';
import 'package:castboard_remote/redux/actions/AsyncActions.dart';
import 'package:castboard_remote/redux/actions/SyncActions.dart';
import 'package:castboard_remote/redux/state/AppState.dart';
import 'package:castboard_remote/view_models/CastChangePageViewModel.dart';
import 'package:castboard_remote/view_models/HomeScaffoldViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CastChangePageContainer extends StatelessWidget {
  final TabController tabController;
  const CastChangePageContainer({Key? key, required this.tabController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CastChangePageViewModel>(
      builder: (context, viewModel) {
        return CastChangePage(
          viewModel: viewModel,
          tabController: tabController,
        );
      },
      converter: (Store<AppState> store) {
        return CastChangePageViewModel(
            actors: store.state.showState.actors,
            tracks: store.state.showState.tracks,
            presets: store.state.showState.presets,
            selectedPresetId: store.state.editingState.selectedPresetId,
            combinedPresets: _selectCombinedPresets(store),
            onPresetSelected: (id) => store.dispatch(
                  SetSelectedPresetId(id),
                ),
            onCombinePresetButtonPressed: (presetId) =>
                store.dispatch(combinePreset(context, presetId)));
      },
    );
  }

  List<PresetModel> _selectCombinedPresets(Store<AppState> store) =>
      store.state.editingState.combinedPresetIds
          .map((id) => store.state.showState.presets[id]!)
          .toList();
}
