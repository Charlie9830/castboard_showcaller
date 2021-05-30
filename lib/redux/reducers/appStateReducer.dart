import 'package:castboard_remote/redux/actions/SyncActions.dart';
import 'package:castboard_remote/redux/state/AppState.dart';

AppState appStateReducer(AppState state, dynamic action) {
  if (action is SetHomePage) {
    return state.copyWith(
      homePage: action.homePage,
    );
  }

  return state;
}
