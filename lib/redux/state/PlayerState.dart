import 'package:castboard_core/models/ManifestModel.dart';
import 'package:flutter/foundation.dart';

class PlayerState {
  final Uri uri;
  final ManifestModel loadedManifest;

  PlayerState({
    required this.uri,
    required this.loadedManifest,
  });

  PlayerState.initial()
      : uri = kDebugMode ? Uri.http('localhost:8080', '') : Uri.base,
        loadedManifest = ManifestModel();

  PlayerState copyWith({
    Uri? uri,
    ManifestModel? loadedManifest,
  }) {
    return PlayerState(
      uri: uri ?? this.uri,
      loadedManifest: loadedManifest ?? this.loadedManifest,
    );
  }
}
