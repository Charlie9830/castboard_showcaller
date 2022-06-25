import 'package:castboard_core/models/PresetModel.dart';
import 'package:flutter/material.dart';

class SelectNestedPresetBottomSheet extends StatelessWidget {
  final List<PresetModel> availablePresets;
  final Set<String> unavailablePresetIds;
  const SelectNestedPresetBottomSheet({
    Key? key,
    this.availablePresets = const [],
    this.unavailablePresetIds = const {},
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 14),
            child: Text('Combine with..',
                style: Theme.of(context).textTheme.caption),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: availablePresets.length,
              itemBuilder: (builderContext, index) {
                final preset = availablePresets[index];
                return ListTile(
                  title: Text(preset.name),
                  subtitle:
                      preset.details.isNotEmpty ? Text(preset.details) : null,
                  enabled: unavailablePresetIds.contains(preset.uid) == false,
                  onTap: () => Navigator.of(context).pop(preset.uid),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
