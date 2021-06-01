import 'package:castboard_remote/enums.dart';

class HomePopupMenuViewModel {
  final bool allowPresetUpdates;
  final HomeSettingsMenuMode mode;
  final dynamic onUpdatePreset;
  final dynamic onResetChanges;
  final dynamic onSettingsPressed;

  HomePopupMenuViewModel({
    required this.allowPresetUpdates,
    required this.mode,
    required this.onResetChanges,
    required this.onUpdatePreset,
    required this.onSettingsPressed,
  });
}
