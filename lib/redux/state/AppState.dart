import 'package:castboard_remote/enums.dart';

class AppState {
  final Uri playerUri;
  final HomePage homePage;

  AppState({required this.homePage, required this.playerUri});

  AppState.initial()
      : homePage = HomePage.remote,
        playerUri = Uri.http('localhost:8080', '');

  AppState copyWith({
    Uri? playerUri,
    HomePage? homePage,
  }) {
    return AppState(
      playerUri: playerUri ?? this.playerUri,
      homePage: homePage ?? this.homePage,
    );
  }
}
