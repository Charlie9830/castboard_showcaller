import 'package:castboard_showcaller/enums.dart';
import 'package:castboard_showcaller/view_models/HomePopupMenuViewModel.dart';
import 'package:flutter/material.dart';

class HomePopupMenu extends StatelessWidget {
  final HomePopupMenuViewModel viewModel;

  const HomePopupMenu({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (viewModel.mode == HomeSettingsMenuMode.playerSettings) {
      return _SettingsButton(onPressed: () => viewModel.onSettingsPressed());
    }

    if (viewModel.mode == HomeSettingsMenuMode.castChangeActions) {
      return _CastChangeActionsMenu(
        updateEnabled: viewModel.allowPresetUpdates,
        onUpdatePreset: viewModel.onUpdatePreset,
        onResetChanges: viewModel.onResetChanges,
      );
    }

    return IconButton(onPressed: () {}, icon: const Icon(Icons.flutter_dash));
  }
}

class _SettingsButton extends StatelessWidget {
  final dynamic onPressed;

  const _SettingsButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: onPressed,
    );
  }
}

class _CastChangeActionsMenu extends StatelessWidget {
  final bool updateEnabled;
  final dynamic onUpdatePreset;
  final dynamic onResetChanges;

  const _CastChangeActionsMenu({
    Key? key,
    required this.updateEnabled,
    this.onResetChanges,
    this.onUpdatePreset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: _handleItemPressed,
      icon: const Icon(Icons.more_vert),
      itemBuilder: (buttonContext) => <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: 'update-preset',
          enabled: updateEnabled,
          child: const Text('Update preset'),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'reset-changes',
          enabled: updateEnabled,
          child: const Text('Reset changes'),
        ),
      ],
    );
  }

  void _handleItemPressed(String value) {
    if (value == 'update-preset') {
      onUpdatePreset?.call();
      return;
    }

    if (value == 'reset-changes') {
      onResetChanges?.call();
      return;
    }
  }
}
