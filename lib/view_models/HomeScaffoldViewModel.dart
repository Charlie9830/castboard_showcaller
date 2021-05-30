import 'package:castboard_remote/enums.dart';

class HomeScaffoldViewModel {
  final HomePage currentPage;
  final dynamic onHomePageChanged;
  final dynamic onPlaybackAction;
  final dynamic onCastChangeTabChanged;
  final dynamic onDebugButtonPressed;

  HomeScaffoldViewModel({
    required this.currentPage,
    required this.onHomePageChanged,
    required this.onPlaybackAction,
    required this.onCastChangeTabChanged,
    required this.onDebugButtonPressed,
  });
}
