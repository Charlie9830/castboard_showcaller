class PlayerSettingsPageViewModel {
  final Uri uri;
  final Uri systemConfigUri;
  final dynamic onShowDeviceRestartingSplash;
  final dynamic onUpdateSoftwareButtonPressed;

  PlayerSettingsPageViewModel({
    required this.uri,
    required this.systemConfigUri,
    required this.onUpdateSoftwareButtonPressed,
    this.onShowDeviceRestartingSplash,
  });
}
