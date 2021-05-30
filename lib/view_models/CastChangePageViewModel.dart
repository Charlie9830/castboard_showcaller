import 'package:castboard_core/models/ActorModel.dart';
import 'package:castboard_core/models/ActorRef.dart';
import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_core/models/TrackModel.dart';
import 'package:castboard_core/models/TrackRef.dart';

class CastChangePageViewModel {
  final Map<String, PresetModel> presets;
  final Map<ActorRef, ActorModel> actors;
  final Map<TrackRef, TrackModel> tracks;
  final String selectedPresetId;
  final List<PresetModel> combinedPresets;
  final dynamic onPresetSelected;
  final dynamic onCombinePresetButtonPressed;

  CastChangePageViewModel({
    required this.presets,
    required this.actors,
    required this.tracks,
    required this.selectedPresetId,
    required this.combinedPresets,
    required this.onPresetSelected,
    required this.onCombinePresetButtonPressed,
  });
}
