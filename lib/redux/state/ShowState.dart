import 'package:castboard_core/models/ActorModel.dart';
import 'package:castboard_core/models/ActorRef.dart';
import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_core/models/TrackModel.dart';
import 'package:castboard_core/models/TrackRef.dart';

class ShowState {
  final Map<String, PresetModel> presets;
  final Map<ActorRef, ActorModel> actors;
  final Map<TrackRef, TrackModel> tracks;

  ShowState({
    required this.presets,
    required this.actors,
    required this.tracks,
  });

  ShowState.initial()
      : presets = <String, PresetModel>{},
        actors = <ActorRef, ActorModel>{},
        tracks = <TrackRef, TrackModel>{};

  ShowState copyWith({
    Map<String, PresetModel>? presets,
    Map<ActorRef, ActorModel>? actors,
    Map<TrackRef, TrackModel>? tracks,
  }) {
    return ShowState(
      presets: presets ?? this.presets,
      actors: actors ?? this.actors,
      tracks: tracks ?? this.tracks,
    );
  }
}
