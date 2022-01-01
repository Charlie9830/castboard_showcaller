class PlayerSettingsPageViewModel {
  final Uri systemConfigUri;
  final Uri logsDownloadUri;
  final dynamic onShowDeviceRestartingSplash;

  PlayerSettingsPageViewModel({
    required this.logsDownloadUri,
    required this.systemConfigUri,
    this.onShowDeviceRestartingSplash,
  });
}
