import 'package:castboard_remote/enums.dart';
import 'package:castboard_remote/redux/state/NavigationState.dart';
import 'package:castboard_remote/redux/state/ShowState.dart';
import 'package:flutter/foundation.dart';

class PlayerState {
  final Uri uri;
  PlayerState({
    required this.uri,
  });

  PlayerState.initial()
      : uri = kDebugMode
            ? Uri.http('localhost:8080', '')
            : Uri.base;

  PlayerState copyWith({
    Uri? uri,
  }) {
    return PlayerState(
      uri: uri ?? this.uri,
    );
  }
}
