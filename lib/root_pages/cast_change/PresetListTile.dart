import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_core/utils/is_mobile_layout.dart';
import 'package:castboard_core/widgets/color_tag.dart';
import 'package:castboard_core/widgets/hover_action_list_tile/HoverActionListTile.dart';
import 'package:flutter/material.dart';

class PresetListTile extends StatelessWidget {
  final PresetModel preset;
  final bool selected;
  final bool allowPropertyEdit;
  final String nestedPresetText;
  final Function(PresetAction action) onPresetAction;
  final dynamic onTap;
  final dynamic onCombineButtonPressed;

  const PresetListTile({
    Key? key,
    required this.preset,
    required this.selected,
    required this.onPresetAction,
    this.allowPropertyEdit = true,
    this.nestedPresetText = '',
    this.onTap,
    this.onCombineButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isNotMobileLayout(context)) {
      return HoverActionListTile(
          key: Key(preset.uid),
          leading: _buildLeadingIcon(context),
          title: Text(preset.name),
          subtitle: _buildSubtitle(),
          selected: selected,
          onTap: _handleTap,
          actions: [
            _buildCombineButton(showIfDisabled: true) ?? const SizedBox(),
            IconButton(
              onPressed: () => onPresetAction(PresetAction.editProperties),
              icon: const Icon(Icons.edit),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () => onPresetAction(PresetAction.duplicate),
              icon: const Icon(Icons.copy),
              color: Colors.white,
            ),
            IconButton(
              onPressed: preset.isBuiltIn
                  ? null
                  : () => onPresetAction(PresetAction.delete),
              icon: const Icon(Icons.delete),
              color: Colors.white,
            ),
          ]);
    }

    return ListTile(
        key: Key(preset.uid),
        selected: selected,
        leading: _buildLeadingIcon(context),
        title: Text(preset.name),
        subtitle: _buildSubtitle(),
        onTap: _handleTap,
        onLongPress: allowPropertyEdit ? () => _handleLongPress(context) : null,
        trailing: _buildCombineButton());
  }

  void _handleTap() {
    onTap?.call();
  }

  Widget? _buildLeadingIcon(context) {
    final colorTag = fetchPresetColorTag(preset.colorTagIndex);

    if (colorTag != null) {
      return ColorTag(color: colorTag);
    }

    return null;
  }

  Widget? _buildSubtitle() {
    return preset.details.isNotEmpty || nestedPresetText.isNotEmpty
        ? _PresetSubtitle(
            details: preset.details, nestedPresetText: nestedPresetText)
        : null;
  }

  Widget? _buildCombineButton({bool showIfDisabled = false}) {
    if (showIfDisabled == false) {
      return IconButton(
        icon: const Icon(Icons.merge_type),
        onPressed: () => onCombineButtonPressed?.call(),
        color: Colors.white,
      );
    }

    return IconButton(
      icon: const Icon(Icons.merge_type),
      onPressed: () => onCombineButtonPressed?.call(),
      color: Colors.white,
    );
  }

  void _handleLongPress(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        builder: (builderContext) => _PresetActionsBottomSheet(
              onAction: onPresetAction,
            ));
  }
}

class _PresetSubtitle extends StatelessWidget {
  final String details;
  final String nestedPresetText;

  const _PresetSubtitle({
    Key? key,
    this.details = '',
    this.nestedPresetText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        if (details.isNotEmpty)
          TextSpan(text: details, style: DefaultTextStyle.of(context).style),
        if (nestedPresetText.isNotEmpty)
          TextSpan(
            text: details.isEmpty ? nestedPresetText : '\n$nestedPresetText',
            style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
      ]),
    );
  }
}

enum PresetAction {
  duplicate,
  editProperties,
  delete,
}

class _PresetActionsBottomSheet extends StatelessWidget {
  final void Function(PresetAction action) onAction;

  const _PresetActionsBottomSheet({Key? key, required this.onAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Column(
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Duplicate'),
              onTap: () {
                Navigator.of(context).pop();
                onAction(PresetAction.duplicate);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Properties'),
              onTap: () {
                Navigator.of(context).pop();
                onAction(PresetAction.editProperties);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.of(context).pop();
                onAction(PresetAction.delete);
              },
            )
          ],
        );
      },
    );
  }
}
