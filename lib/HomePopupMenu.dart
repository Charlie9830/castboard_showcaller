import 'package:castboard_showcaller/CastChangeActionsMenu.dart';
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
      return CastChangeActionsMenu(
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
