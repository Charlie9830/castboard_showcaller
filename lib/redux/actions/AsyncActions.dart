import 'package:castboard_remote/enums.dart';
import 'package:castboard_remote/redux/state/AppState.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:http/http.dart' as http;

ThunkAction<AppState> sendPlaybackAction(PlaybackAction action) {
  return (Store<AppState> store) async {
    final uri = Uri.http(store.state.playerUri.authority, '/playback');
    final payload = _buildPlaybackActionPayload(action);

    try {
      final response = await http.put(uri, body: payload);
      print(response.statusCode);
    } catch (error) {
      print('');
      print(error);
      print('');
    }
  };
}

String _buildPlaybackActionPayload(PlaybackAction action) {
  switch (action) {
    case PlaybackAction.play:
      return 'play';
    case PlaybackAction.pause:
      return 'pause';
    case PlaybackAction.prev:
      return 'prev';
    case PlaybackAction.next:
      return 'next';
  }
}
