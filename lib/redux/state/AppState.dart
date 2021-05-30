import 'package:castboard_remote/enums.dart';
import 'package:castboard_remote/redux/state/EditingState.dart';
import 'package:castboard_remote/redux/state/NavigationState.dart';
import 'package:castboard_remote/redux/state/PlayerState.dart';
import 'package:castboard_remote/redux/state/ShowState.dart';

class AppState {
  final ShowState showState;
  final NavigationState navState;
  final PlayerState playerState;
  final EditingState editingState;

  AppState({
    required this.showState,
    required this.navState,
    required this.playerState,
    required this.editingState,
  });

  AppState.initial()
      : showState = ShowState.initial(),
        navState = NavigationState.initial(),
        playerState = PlayerState.initial(),
        editingState = EditingState.initial();

  AppState copyWith({
    ShowState? showState,
    NavigationState? navState,
    PlayerState? playerState,
    EditingState? editingState,
  }) {
    return AppState(
      showState: showState ?? this.showState,
      navState: navState ?? this.navState,
      playerState: playerState ?? this.playerState,
      editingState: editingState ?? this.editingState,
    );
  }
}
