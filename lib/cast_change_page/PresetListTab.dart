import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_remote/view_models/CastChangePageViewModel.dart';
import 'package:flutter/material.dart';

class PresetListTab extends StatelessWidget {
  final CastChangePageViewModel viewModel;
  const PresetListTab({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presets = viewModel.presets.values.toList();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: presets.length,
              itemBuilder: (context, index) {
                final preset = presets[index];
                final selected = preset.uid == viewModel.selectedPresetId;
                return _PresetListTile(
                  preset: preset,
                  selected: selected,
                  nestedPresetText: selected
                      ? _getNestedPresetText(preset, viewModel.combinedPresets)
                      : '',
                  onTap: () => viewModel.onPresetSelected(preset.uid),
                  onCombineButtonPressed: () =>
                      viewModel.onCombinePresetButtonPressed(preset.uid),
                );
              },
            ),
          ),
        ],
      ),
    );
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
  final String nestedPresetText;
  final dynamic onTap;
  final dynamic onCombineButtonPressed;

  const _PresetListTile({
    Key? key,
    required this.preset,
    required this.selected,
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
              size: 20,
              color: Theme.of(context).disabledColor)
          : null,
      title: Text(preset.name),
      subtitle: preset.details.isNotEmpty || nestedPresetText.isNotEmpty
          ? _PresetSubtitle(
              details: preset.details, nestedPresetText: nestedPresetText)
          : null,
      onTap: () => onTap?.call(),
      trailing: preset.isNestable == false
          ? IconButton(
              icon: Icon(Icons.merge_type),
              onPressed: () => onCombineButtonPressed?.call())
          : null,
    );
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
