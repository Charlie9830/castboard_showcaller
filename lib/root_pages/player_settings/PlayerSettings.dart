import 'package:castboard_core/models/system_controller/DeviceOrientation.dart';
import 'package:castboard_core/models/system_controller/DeviceResolution.dart';
import 'package:castboard_core/models/system_controller/SystemConfig.dart';
import 'package:castboard_core/system-commands/SystemCommands.dart';
import 'package:castboard_showcaller/dialogs/GeneralFileDownloadDialog.dart';
import 'package:castboard_showcaller/root_pages/player_settings/ConfirmationDialog.dart';
import 'package:castboard_showcaller/root_pages/player_settings/OrientationDropdown.dart';
import 'package:castboard_showcaller/root_pages/player_settings/PackageInfoDisplay.dart';
import 'package:castboard_showcaller/root_pages/player_settings/PlayerDetailsListTile.dart';
import 'package:castboard_showcaller/root_pages/player_settings/ResolutionDropdown.dart';
import 'package:castboard_showcaller/root_pages/player_settings/sendSystemCommand.dart';
import 'package:castboard_showcaller/root_pages/player_settings/UploadingSettingsDialog.dart';
import 'package:castboard_showcaller/root_pages/player_settings/pullSystemConfig.dart';
import 'package:castboard_showcaller/root_pages/player_settings/pushSystemConfig.dart';
import 'package:castboard_showcaller/snackBars/GeneralMessageSnackBar.dart';
import 'package:castboard_showcaller/view_models/PlayerSettingsPageViewModel.dart';
import 'package:flutter/material.dart';

class PlayerSettings extends StatefulWidget {
  final PlayerSettingsPageViewModel viewModel;
  const PlayerSettings({Key? key, required this.viewModel}) : super(key: key);

  @override
  PlayerSettingsState createState() => PlayerSettingsState();
}

class PlayerSettingsState extends State<PlayerSettings> {
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
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()),
          title: const Text('Settings'),
          actions: [
            TextButton(
                onPressed: _editingSystemConfig != null
                    ? _handleSaveButtonPressed
                    : null,
                child: const Text('Save')),
            TextButton(
              onPressed: _editingSystemConfig != null
                  ? _handleResetButtonPressed
                  : null,
              child: const Text('Reset'),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildPageContents(context),
        ));
  }

  Widget _buildPageContents(BuildContext context) {
    if (_isFetchingSystemConfig) {
      return const _SystemConfigThrobber();
    }

    if (_systemConfigError) {
      return const _SystemConfigFallback();
    }

    return _buildSettings(context);
  }

  ListView _buildSettings(BuildContext context) {
    return ListView(
      children: [
        const _Subheading(text: 'Playback'),
        ListTile(
          title: const Text('Auto resume playback'),
          subtitle: const Text(
              'Allow the player to resume playback when it no longer detects any active remotes'),
          trailing: Checkbox(
            value: _editingSystemConfig == null
                ? _loadedSystemConfig.playShowOnIdle
                : _editingSystemConfig!.playShowOnIdle,
            onChanged: _handlePlayFromIdleChanged,
          ),
        ),
        const _Subheading(text: 'Diagnostics'),
        PlayerDetailsListTile(
          leading: 'Player Version',
          trailing: _loadedSystemConfig.playerVersion,
        ),
        PlayerDetailsListTile(
          leading: 'Player Build Number',
          trailing: _loadedSystemConfig.playerBuildNumber,
        ),
        PlayerDetailsListTile(
          leading: 'Player Build Signature',
          trailing: _loadedSystemConfig.playerBuildSignature,
        ),
        ListTile(
          title: TextButton(
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Download Diagnostic Logs',
              ),
            ),
            onPressed: () => _handleDownloadLogsButtonButtonPressed(context),
          ),
        ),
        const _Subheading(text: "Showcaller Infomation"),
        const ListTile(
          title: PackageInfoDisplay(),
        ),
      ],
    );
  }

  void _handleShutdownButtonPressed(BuildContext context) async {
    final result = await showDialog(
        context: context,
        builder: (context) => const ConfirmationDialog(
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
        builder: (context) => const ConfirmationDialog(
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
        builder: (context) => const ConfirmationDialog(
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

  void _handlePlayFromIdleChanged(bool? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _editingSystemConfig =
          _getEditingConfig().copyWith(playShowOnIdle: value);
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
      builder: (innerContext) => const UploadingSettingsDialog(),
      barrierDismissible: false,
    );

    try {
      final restartRequired = await pushSystemConfig(
          widget.viewModel.systemConfigUri, _editingSystemConfig!);

      if (restartRequired) {
        widget.viewModel.onShowDeviceRestartingSplash?.call();
      } else {
        // No System restart required.
        if (mounted && Navigator.of(context).canPop()) {
          // Pop the UploadingSettingsDialog off the stack.
          Navigator.of(context).pop();
        }
        await _notifyAndReSync();
      }
    } catch (e) {
      // Pop the throbber Dialog.
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: GeneralMessageSnackBar(
        success: true,
        message: 'Settings updated',
      )));
    }
  }
}

class _SystemConfigThrobber extends StatelessWidget {
  const _SystemConfigThrobber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
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
