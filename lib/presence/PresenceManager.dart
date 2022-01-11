import 'dart:async';

import 'package:castboard_showcaller/presence/PresenseState.dart';
import 'package:http/http.dart' as http;

class PresenseManager {
  final Uri serverUri;
  final int heartbeatInterval;
  final int maxMissedBeats;
  final String sessionId;

  final Function(PresenseState state)? onStateChanged;

  bool established = false;
  Timer? _timer;
  PresenseState _state = PresenseState.disconnected;
  int _currentMissedBeats = 0;

  PresenseManager({
    required this.serverUri,
    required this.sessionId,
    this.heartbeatInterval = 5,
    this.maxMissedBeats = 3,
    this.onStateChanged,
  });

  Future<PresenseState> establishHeartbeat() async {
    final initialHeartbeatResult = await _sendHeartbeat();

    _initializeHeartbeatTimer();

    _state = initialHeartbeatResult
        ? PresenseState.connected
        : PresenseState.disconnected;
    return _state;
  }

  Future<bool> _sendHeartbeat() async {
    try {
      final response = await http
          .post(Uri.http(serverUri.authority, '/heartbeat'), body: sessionId);
      if (response.statusCode != 200) {
        return false;
      }

      return true;
    } catch (error) {
      return false;
    }
  }

  void _initializeHeartbeatTimer() {
    if (_timer != null) {
      return;
    }

    _timer = Timer.periodic(
        Duration(seconds: heartbeatInterval), (_) => _handleTimerTick());
  }

  void _handleTimerTick() async {
    final result = await _sendHeartbeat();

    if (result == true && _state == PresenseState.disconnected) {
      // Connection Re-established.
      _state = PresenseState.connected;
      _currentMissedBeats = 0;
      onStateChanged?.call(PresenseState.connected);
    }

    if (result == false && _state == PresenseState.connected) {
      // Connection dropped.
      _state = PresenseState.disconnected;
      _currentMissedBeats++;

      if (_currentMissedBeats == maxMissedBeats) {
        onStateChanged?.call(PresenseState.disconnected);
      }
    }
  }

  void stop() {
    if (_timer == null) {
      return;
    }

    _currentMissedBeats = 0;
    _timer!.cancel();
    _timer = null;
  }
}
