import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_showcaller/root_pages/cast_change/PresetListTile.dart';
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
        return PresetListTile(
          preset: preset,
          selected: selected,
          canCombine: viewModel.presets.values.length > 1,
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

  void _handlePresetAction(String presetId, PresetAction action) {
    switch (action) {
      case PresetAction.duplicate:
        viewModel.onDuplicatePreset(presetId);
        break;
      case PresetAction.editProperties:
        viewModel.onEditPresetProperties(presetId);
        break;
      case PresetAction.delete:
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
