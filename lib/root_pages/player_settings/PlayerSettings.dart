import 'package:castboard_core/models/system_controller/AvailableResolutions.dart';
import 'package:castboard_core/models/system_controller/DeviceOrientation.dart';
import 'package:castboard_core/models/system_controller/DeviceResolution.dart';
import 'package:castboard_core/models/system_controller/SystemConfig.dart';
import 'package:castboard_core/system-commands/SystemCommands.dart';
import 'package:castboard_remote/dialogs/GeneralFileDownloadDialog.dart';
import 'package:castboard_remote/root_pages/player_settings/ConfirmationDialog.dart';
import 'package:castboard_remote/root_pages/player_settings/DownloadLogsDialog.dart';
import 'package:castboard_remote/root_pages/player_settings/OrientationDropdown.dart';
import 'package:castboard_remote/root_pages/player_settings/ResolutionDropdown.dart';
import 'package:castboard_remote/root_pages/player_settings/sendSystemCommand.dart';
import 'package:castboard_remote/root_pages/player_settings/UploadingSettingsDialog.dart';
import 'package:castboard_remote/root_pages/player_settings/pullSystemConfig.dart';
import 'package:castboard_remote/root_pages/player_settings/pushSystemConfig.dart';
import 'package:castboard_remote/snackBars/GeneralMessageSnackBar.dart';
import 'package:castboard_remote/view_models/PlayerSettingsPageViewModel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlayerSettings extends StatefulWidget {
  final PlayerSettingsPageViewModel viewModel;
  PlayerSettings({Key? key, required this.viewModel}) : super(key: key);

  @override
  _PlayerSettingsState createState() => _PlayerSettingsState();
}

class _PlayerSettingsState extends State<PlayerSettings> {
  // System Configuration
  bool _isFetchingSystemConfig = true;
  bool _systemConfigError = false;
  SystemConfig _loadedSystemConfig = SystemConfig.defaults();
  SystemConfig? _editingSystemConfig;

  @override
  void initState() {
    super.initState();
    _getSystemConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()),
          title: Text('Settings'),
          actions: [
            if (_editingSystemConfig != null)
              TextButton(
                  onPressed: _handleResetButtonPressed, child: Text('Reset')),
            ElevatedButton(
                onPressed: _editingSystemConfig != null
                    ? _handleSaveButtonPressed
                    : null,
                child: Text('Save')),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildPageContents(context),
        ));
  }

  Widget _buildPageContents(BuildContext context) {
    if (_isFetchingSystemConfig) {
      return _SystemConfigThrobber();
    }

    if (_systemConfigError) {
      return _SystemConfigFallback();
    }

    return _buildSettings(context);
  }

  ListView _buildSettings(BuildContext context) {
    return ListView(
      children: [
        _Subheading(text: 'Playback'),
        ListTile(
          title: Text('Auto resume playback'),
          subtitle: Text(
              'Allow the player to resume playback when it no longer detects any active remotes'),
          trailing: Checkbox(
            value: _editingSystemConfig == null
                ? _loadedSystemConfig.playShowOnIdle
                : _editingSystemConfig!.playShowOnIdle,
            onChanged: _handlePlayFromIdleChanged,
          ),
        ),
        _Subheading(text: 'Video Output'),
        ListTile(
          title: Text('Output Resolution'),
          trailing: SizedBox(
            width: 180,
            child: ResolutionDropdown(
              selectedValue: _editingSystemConfig == null
                  ? _loadedSystemConfig.deviceResolution
                  : _editingSystemConfig!.deviceResolution,
              resolutions: _loadedSystemConfig.availableResolutions.resolutions,
              onChanged: _handleResolutionChanged,
            ),
          ),
        ),
        ListTile(
            title: Text('Screen Orientation'),
            trailing: OrientationDropdown(
              selectedValue: _editingSystemConfig == null
                  ? _loadedSystemConfig.deviceOrientation
                  : _editingSystemConfig!.deviceOrientation,
              onChanged: _handleOrientationChanged,
            )),
        _Subheading(text: 'Device Commands'),
        ListTile(
          title: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              TextButton(
                child: Text('Shutdown Player'),
                onPressed: () => _handleShutdownButtonPressed(context),
              ),
              TextButton(
                child: Text('Reboot Player'),
                onPressed: () => _handleRebootButtonPressed(context),
              ),
              TextButton(
                child: Text('Restart Player Software'),
                onPressed: () => _handleRestartSoftwareButtonPressed(context),
              )
            ],
          ),
        ),
        _Subheading(text: 'Diagnostics'),
        ListTile(
          title: TextButton(
            child: Text('Download Diagnostic Logs'),
            onPressed: () => _handleDownloadLogsButtonButtonPressed(context),
          ),
        )
      ],
    );
  }

  void _handleShutdownButtonPressed(BuildContext context) async {
    final result = await showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
            title: 'Shutdown Player',
            message: "Are you sure?",
            affirmativeText: 'Shutdown',
            negativeText: 'Cancel'));

    if (result is bool && result == true) {
      sendSystemCommand(
          widget.viewModel.systemConfigUri, SystemCommand.powerOff());
    }
  }

  void _handleRebootButtonPressed(BuildContext context) async {
    final result = await showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
            title: 'Reboot Player',
            message: "Are you sure?",
            affirmativeText: 'Reboot',
            negativeText: 'Cancel'));

    if (result is bool && result == true) {
      sendSystemCommand(
          widget.viewModel.systemConfigUri, SystemCommand.reboot());
    }
  }

  void _handleRestartSoftwareButtonPressed(BuildContext context) async {
    final result = await showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
            title: 'Restart Player Software',
            message: "Are you sure?",
            affirmativeText: 'Restart',
            negativeText: 'Cancel'));

    if (result is bool && result == true) {
      sendSystemCommand(
          widget.viewModel.systemConfigUri, SystemCommand.restartApplication());
    }
  }

  SystemConfig _getEditingConfig() {
    return _editingSystemConfig ?? _loadedSystemConfig.copyWith();
  }

  Future<void> _getSystemConfig() async {
    final SystemConfig? systemConfig =
        await pullSystemConfig(widget.viewModel.systemConfigUri);

    if (systemConfig == null) {
      setState(() {
        _isFetchingSystemConfig = false;
        _systemConfigError = true;
      });
      return;
    }

    setState(() {
      _isFetchingSystemConfig = false;
      _loadedSystemConfig = systemConfig;
    });
  }

  void _handleResolutionChanged(DeviceResolution? res) {
    if (res == null || res == _loadedSystemConfig.deviceResolution) {
      return;
    }

    setState(() {
      _editingSystemConfig =
          _getEditingConfig().copyWith(deviceResolution: res);
    });
  }

  void _handlePlayFromIdleChanged(bool? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _editingSystemConfig =
          _getEditingConfig().copyWith(playShowOnIdle: value);
    });
  }

  void _handleOrientationChanged(DeviceOrientation? ori) {
    if (ori == null) {
      return;
    }

    setState(() {
      _editingSystemConfig =
          _getEditingConfig().copyWith(deviceOrientation: ori);
    });
  }

  void _handleResetButtonPressed() {
    setState(() {
      _editingSystemConfig = null;
    });
  }

  void _handleSaveButtonPressed() async {
    if (_editingSystemConfig == null) {
      return;
    }

    // Show a throbber Dialog.
    showDialog(
      context: context,
      builder: (innerContext) => UploadingSettingsDialog(),
      barrierDismissible: false,
    );

    try {
      final restartRequired = await pushSystemConfig(
          widget.viewModel.systemConfigUri, _editingSystemConfig!);

      if (restartRequired) {
        widget.viewModel.onShowDeviceRestartingSplash?.call();
      } else {
        await _notifyAndReSync();
      }
    } catch (e) {
      // Pop the throbber Dialog.
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: GeneralMessageSnackBar(
            success: false, message: 'An unexpected error occurred'),
      ));
    }
  }

  void _handleDownloadLogsButtonButtonPressed(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => GeneralFileDownloadDialog(
        waitingMessage: 'Player is preparing the logs...',
        prepareFileUri:
            Uri.http(widget.viewModel.uri.authority, 'prepareLogsDownload'),
        downloadFileUri:
            Uri.http(widget.viewModel.uri.authority, 'logsDownload'),
      ),
    );
  }

  Future<void> _notifyAndReSync() async {
    await _getSystemConfig();

    setState(() {
      _editingSystemConfig = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: GeneralMessageSnackBar(
      success: true,
      message: 'Settings updated',
    )));
  }
}

class _SystemConfigThrobber extends StatelessWidget {
  const _SystemConfigThrobber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: 32,
      width: 32,
      child: CircularProgressIndicator(),
    ));
  }
}

class _SystemConfigFallback extends StatelessWidget {
  const _SystemConfigFallback({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Unavailable', style: Theme.of(context).textTheme.caption);
  }
}

class _Subheading extends StatelessWidget {
  final String text;
  const _Subheading({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(text, style: Theme.of(context).textTheme.caption),
    );
  }
}
