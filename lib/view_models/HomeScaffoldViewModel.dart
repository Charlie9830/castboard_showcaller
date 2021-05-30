import 'package:castboard_remote/enums.dart';

class HomeScaffoldViewModel {
  final HomePage currentPage;
  final dynamic onHomePageChanged;
  final dynamic onPlaybackAction;

  HomeScaffoldViewModel({
    required this.currentPage,
    required this.onHomePageChanged,
    required this.onPlaybackAction,
  });
}
