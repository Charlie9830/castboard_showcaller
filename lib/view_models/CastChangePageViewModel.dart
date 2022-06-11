import 'package:castboard_core/models/ActorModel.dart';
import 'package:castboard_core/models/ActorRef.dart';
import 'package:castboard_core/models/CastChangeModel.dart';
import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_core/models/TrackModel.dart';
import 'package:castboard_core/models/TrackRef.dart';

class CastChangePageViewModel {
  final Map<String, PresetModel> presets;
  final PresetModel? basePreset;
  final Map<ActorRef, ActorModel> actors;
  final Map<String, List<ActorRef>> categorizedActorRefs;
  final Map<TrackRef, TrackModel> tracks;
  final String selectedPresetId;
  final List<PresetModel> combinedPresets;
  final CastChangeModel editedAssignments;
  final dynamic onPresetSelected;
  final dynamic onCombinePresetButtonPressed;
  final void Function(TrackRef track, ActorRef actor) onAssignmentUpdated;
  final void Function(TrackRef track) onClearLiveEdit;
  final dynamic onNewPresetButtonPressed;
  final dynamic onDuplicatePreset;
  final dynamic onEditPresetProperties;
  final dynamic onDeletePreset;

  CastChangePageViewModel({
    required this.presets,
    required this.basePreset,
    required this.actors,
    required this.categorizedActorRefs,
    required this.tracks,
    required this.editedAssignments,
    required this.selectedPresetId,
    required this.combinedPresets,
    required this.onPresetSelected,
    required this.onCombinePresetButtonPressed,
    required this.onAssignmentUpdated,
    required this.onClearLiveEdit,
    required this.onNewPresetButtonPressed,
    required this.onDeletePreset,
    required this.onEditPresetProperties,
    required this.onDuplicatePreset,
  });
}
