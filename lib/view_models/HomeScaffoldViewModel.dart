import 'package:castboard_remote/enums.dart';
import 'package:castboard_remote/view_models/HomePopupMenuViewModel.dart';

class HomeScaffoldViewModel {
  final HomePage currentPage;
  final HomePopupMenuViewModel popupMenuViewModel;
  final dynamic onHomePageChanged;
  final dynamic onPlaybackAction;
  final dynamic onCastChangeTabChanged;
  final dynamic onDebugButtonPressed;
  final dynamic onUploadCastChange;

  HomeScaffoldViewModel({
    required this.onUploadCastChange,
    required this.currentPage,
    required this.popupMenuViewModel,
    required this.onHomePageChanged,
    required this.onPlaybackAction,
    required this.onCastChangeTabChanged,
    required this.onDebugButtonPressed,
  });
}
