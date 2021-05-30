import 'package:castboard_remote/enums.dart';

class NavigationState {
  final HomePage homePage;
  final CastChangePageTab castChangePageTab;

  NavigationState({
    required this.homePage,
    required this.castChangePageTab,
  });

  NavigationState.initial()
      : homePage = HomePage.remote,
        castChangePageTab = CastChangePageTab.presets;

  NavigationState copyWith({
    HomePage? homePage,
    CastChangePageTab? castChangePageTab,
  }) {
    return NavigationState(
      homePage: homePage ?? this.homePage,
      castChangePageTab: castChangePageTab ?? this.castChangePageTab,
    );
  }
}
