import 'package:flutter/material.dart';

class CastChangeActionsMenu extends StatelessWidget {
  final bool updateEnabled;
  final dynamic onUpdatePreset;
  final dynamic onResetChanges;

  const CastChangeActionsMenu({
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
