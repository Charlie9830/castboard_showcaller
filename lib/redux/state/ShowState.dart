import 'package:castboard_core/models/ActorModel.dart';
import 'package:castboard_core/models/ActorRef.dart';
import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_core/models/TrackModel.dart';
import 'package:castboard_core/models/TrackRef.dart';

class ShowState {
  final bool fetched;
  final Map<String, PresetModel> presets;
  final Map<ActorRef, ActorModel> actors;
  final Map<TrackRef, TrackModel> tracks;
  final Map<String, List<ActorRef>> categorizedActorRefs;

  ShowState({
    required this.fetched,
    required this.presets,
    required this.actors,
    required this.tracks,
    required this.categorizedActorRefs,
  });

  ShowState.initial()
      : fetched = false,
        presets = <String, PresetModel>{},
        actors = <ActorRef, ActorModel>{},
        tracks = <TrackRef, TrackModel>{},
        categorizedActorRefs = <String, List<ActorRef>>{};

  ShowState copyWith({
    bool? fetched,
    Map<String, PresetModel>? presets,
    Map<ActorRef, ActorModel>? actors,
    Map<TrackRef, TrackModel>? tracks,
    Map<String, List<ActorRef>>? categorizedActorRefs,
  }) {
    return ShowState(
      fetched: fetched ?? this.fetched,
      presets: presets ?? this.presets,
      actors: actors ?? this.actors,
      tracks: tracks ?? this.tracks,
      categorizedActorRefs: categorizedActorRefs ?? this.categorizedActorRefs,
    );
  }
}
