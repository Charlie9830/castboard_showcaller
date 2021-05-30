import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_remote/enums.dart';

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

  SetSelectedPresetId(this.id);
}

class UpdateCombinedPresets {
  final PresetModel basePreset;
  final List<PresetModel> combinedPresets;

  UpdateCombinedPresets({
    required this.basePreset,
    required this.combinedPresets,
  });
}
