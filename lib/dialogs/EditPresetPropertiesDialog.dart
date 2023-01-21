import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_core/widgets/color_tag_selector/color_tag_selector.dart';
import 'package:castboard_showcaller/ResponsiveDialogContainer.dart';
import 'package:flutter/material.dart';

class EditPresetPropertiesDialog extends StatefulWidget {
  final PresetModel existing;

  const EditPresetPropertiesDialog({
    Key? key,
    required this.existing,
  }) : super(key: key);

  @override
  EditPresetPropertiesDialogState createState() =>
      EditPresetPropertiesDialogState();
}

class EditPresetPropertiesDialogState
    extends State<EditPresetPropertiesDialog> {
  late TextEditingController _nameController;
  late TextEditingController _detailsController;
  int _colorTag = -1;

  @override
  void initState() {
    _colorTag = widget.existing.colorTagIndex;
    _nameController = TextEditingController(text: widget.existing.name);
    _detailsController = TextEditingController(text: widget.existing.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveDialogContainer(
      title: 'Edit Preset Details',
      actions: [
        TextButton(
          child: const Text('Update'),
          onPressed: () => Navigator.of(context).pop(widget.existing.copyWith(
            name: _nameController.text,
            details: _detailsController.text,
            colorTagIndex: _colorTag
          )),
        )
      ],
      includeCancel: true,
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                label: Text('Name'),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _detailsController,
              decoration: const InputDecoration(
                label: Text('Details'),
              ),
            ),
            const SizedBox(height: 24),
            ColorTagSelector(
              leftAligned: true,
              selectedColorIndex: _colorTag,
              onChange: (value) => setState(() => _colorTag = value),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    super.dispose();
  }
}
