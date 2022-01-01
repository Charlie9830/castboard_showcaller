class PlayerSettingsPageViewModel {
  final Uri uri;
  final Uri systemConfigUri;
  final dynamic onShowDeviceRestartingSplash;

  PlayerSettingsPageViewModel({
    required this.uri,
    required this.systemConfigUri,
    this.onShowDeviceRestartingSplash,
  });
}
