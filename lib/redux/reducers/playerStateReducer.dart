import 'package:castboard_showcaller/redux/actions/SyncActions.dart';
import 'package:castboard_showcaller/redux/state/PlayerState.dart';

PlayerState playerStateReducer(PlayerState state, dynamic action) {
  if (action is ReceiveShowData) {
    return state.copyWith(loadedManifest: action.data.manifest);
  }

  return state;
}
