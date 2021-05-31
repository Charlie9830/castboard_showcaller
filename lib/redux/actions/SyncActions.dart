import 'package:castboard_core/models/ActorRef.dart';
import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_core/models/TrackRef.dart';
import 'package:castboard_remote/enums.dart';

class DeletePreset {
  final String presetId;

  DeletePreset(this.presetId);
}

class SetHomePage {
  final HomePage homePage;

  SetHomePage(this.homePage);
}

class SetCastChangePageTab {
  final CastChangePageTab tab;

  SetCastChangePageTab(this.tab);
}

class InitMockData {
  InitMockData();
}

class SetSelectedPresetId {
  final String id;
  final PresetModel? preset;

  SetSelectedPresetId({required this.id, this.preset});
}

class UpdateCombinedPresets {
  final PresetModel basePreset;
  final List<PresetModel> combinedPresets;

  UpdateCombinedPresets({
    required this.basePreset,
    required this.combinedPresets,
  });
}

class UpdateAssignment {
  final TrackRef trackRef;
  final ActorRef actorRef;

  UpdateAssignment({
    required this.trackRef,
    required this.actorRef,
  });
}

class ClearLiveEdit {
  final TrackRef track;

  ClearLiveEdit(this.track);
}

class AddNewPreset {
  final PresetModel preset;

  AddNewPreset(this.preset);
}

class UpdatePreset {
  final PresetModel preset;

  UpdatePreset(this.preset);
}
