import 'package:castboard_remote/redux/actions/SyncActions.dart';
import 'package:castboard_remote/redux/state/NavigationState.dart';

NavigationState navStateReducer(NavigationState state, dynamic action) {
  if (action is SetHomePage) {
    return state.copyWith(
      homePage: action.homePage,
    );
  }

  if (action is SetCastChangePageTab) {
    return state.copyWith(
      castChangePageTab: action.tab,
    );
  }

  return state;
}
