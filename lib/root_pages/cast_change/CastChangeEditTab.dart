import 'package:castboard_core/widgets/cast-change-details/CastChangeDetails.dart';
import 'package:castboard_core/widgets/cast-change-details/buildCombinedPresets.dart';
import 'package:castboard_showcaller/view_models/CastChangePageViewModel.dart';
import 'package:flutter/material.dart';

class CastChangeEditTab extends StatelessWidget {
  final CastChangePageViewModel viewModel;

  const CastChangeEditTab({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: CastChangeDetails(
        selfScrolling: true,
        allowNestedEditing: true,
        actorViewModels: viewModel.actorViewModels,
        actorsByRef: viewModel.actors,
        trackViewModels: viewModel.trackViewModels,
        tracksByRef: viewModel.tracks,
        assignments: _getAssignments(),
        onAssignmentUpdated: viewModel.onAssignmentUpdated,
        onResetLiveEdit: viewModel.onClearLiveEdit,
      ),
    );
  }

  Map<String, ActorTuple> _getAssignments() {
    return buildCombinedAssignments(
        viewModel.basePreset, viewModel.combinedPresets)
      ..addAll(
        {
          ...viewModel.editedAssignments.assignments.map(
            (trackRef, actorRef) => MapEntry(
              trackRef.uid,
              ActorTuple(
                actorRef: actorRef,
                fromNestedPreset: false,
                sourcePresetName: '',
                fromLiveEdit: true,
              ),
            ),
          )
        },
      );
  }
}
