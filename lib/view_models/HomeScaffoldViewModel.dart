import 'package:castboard_showcaller/enums.dart';
import 'package:castboard_showcaller/view_models/HomePopupMenuViewModel.dart';

class HomeScaffoldViewModel {
  final bool hasUploadableEdits;
  final HomePage currentPage;
  final HomePopupMenuViewModel popupMenuViewModel;
  final dynamic onHomePageChanged;
  final dynamic onPlaybackAction;
  final dynamic onCastChangeTabChanged;
  final dynamic onDebugButtonPressed;
  final dynamic onUploadCastChange;
  final dynamic onSettingsButtonPressed;

  HomeScaffoldViewModel({
    required this.hasUploadableEdits,
    required this.onUploadCastChange,
    required this.currentPage,
    required this.popupMenuViewModel,
    required this.onHomePageChanged,
    required this.onPlaybackAction,
    required this.onCastChangeTabChanged,
    required this.onDebugButtonPressed,
    required this.onSettingsButtonPressed,
  });
}
