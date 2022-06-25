import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_showcaller/view_models/CastChangePageViewModel.dart';
import 'package:flutter/material.dart';

class PresetListTab extends StatelessWidget {
  final CastChangePageViewModel viewModel;
  const PresetListTab({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ...viewModel.presets.values.map((preset) {
        final selected = preset.uid == viewModel.selectedPresetId;
        return _PresetListTile(
          preset: preset,
          selected: selected,
          allowPropertyEdit: preset.isBuiltIn == false,
          onPresetAction: (action) => _handlePresetAction(preset.uid, action),
          nestedPresetText: selected
              ? _getNestedPresetText(preset, viewModel.combinedPresets)
              : '',
          onTap: () => viewModel.onPresetSelected(preset.uid),
          onCombineButtonPressed: () =>
              viewModel.onCombinePresetButtonPressed(preset.uid),
        );
      }).toList(),
      Container(
        margin: const EdgeInsets.only(left: 16),
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: OutlinedButton.icon(
          onPressed: viewModel.onNewPresetButtonPressed,
          icon: const Icon(Icons.add),
          label: const Text('New Preset'),
        ),
      ),
    ]);
  }

  void _handlePresetAction(String presetId, _PresetAction action) {
    switch (action) {
      case _PresetAction.duplicate:
        viewModel.onDuplicatePreset(presetId);
        break;
      case _PresetAction.editProperties:
        viewModel.onEditPresetProperties(presetId);
        break;
      case _PresetAction.delete:
        viewModel.onDeletePreset(presetId);
        break;
    }
  }

  String _getNestedPresetText(
      PresetModel preset, List<PresetModel> combinedPresets) {
    if (combinedPresets.isEmpty) {
      return '';
    }

    final reducedPresetNames = combinedPresets
        .map((preset) => preset.name)
        .reduce((acum, item) => '$acum > $item');

    return 'Combined with $reducedPresetNames';
  }
}

class _PresetListTile extends StatelessWidget {
  final PresetModel preset;
  final bool selected;
  final bool allowPropertyEdit;
  final String nestedPresetText;
  final Function(_PresetAction action) onPresetAction;
  final dynamic onTap;
  final dynamic onCombineButtonPressed;

  const _PresetListTile({
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
    return ListTile(
      selected: selected,
      leading: preset.isNestable
          ? Icon(Icons.subdirectory_arrow_right,
              size: 20, color: Theme.of(context).disabledColor)
          : null,
      title: Text(preset.name),
      subtitle: preset.details.isNotEmpty || nestedPresetText.isNotEmpty
          ? _PresetSubtitle(
              details: preset.details, nestedPresetText: nestedPresetText)
          : null,
      onTap: () => onTap?.call(),
      onLongPress: allowPropertyEdit ? () => _handleLongPress(context) : null,
      trailing: preset.isNestable == false
          ? IconButton(
              icon: const Icon(Icons.merge_type),
              onPressed: () => onCombineButtonPressed?.call())
          : null,
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

enum _PresetAction {
  duplicate,
  editProperties,
  delete,
}

class _PresetActionsBottomSheet extends StatelessWidget {
  final void Function(_PresetAction action) onAction;

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
                onAction(_PresetAction.duplicate);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Properties'),
              onTap: () {
                Navigator.of(context).pop();
                onAction(_PresetAction.editProperties);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.of(context).pop();
                onAction(_PresetAction.delete);
              },
            )
          ],
        );
      },
    );
  }
}
