import 'package:castboard_remote/redux/actions/SyncActions.dart';
import 'package:castboard_remote/redux/state/AppState.dart';
import 'package:castboard_remote/redux/state/ShowState.dart';

ShowState showStateReducer(ShowState state, dynamic action) {
  if (action is SetSelectedPresetId) {
    return state.copyWith(
      
    );
  }
  return state;
}
