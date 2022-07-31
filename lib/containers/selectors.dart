import 'package:castboard_showcaller/redux/state/AppState.dart';
import 'package:redux/redux.dart';

bool selectShowPresetActions(Store<AppState> store) {
  return store.state.editingState.editedAssignments.isNotEmpty;
}
