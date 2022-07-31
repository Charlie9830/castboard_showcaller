import 'package:castboard_core/models/PresetModel.dart';
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
  late bool _isNestable;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.existing.name);
    _detailsController = TextEditingController(text: widget.existing.name);
    _isNestable = widget.existing.isNestable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const switchListTilePadding = EdgeInsets.only(left: 0);

    return ResponsiveDialogContainer(
      title: 'Edit Details',
      actions: [
        TextButton(
          child: const Text('Update'),
          onPressed: () => Navigator.of(context).pop(widget.existing.copyWith(
            name: _nameController.text,
            details: _detailsController.text,
            isNestable: _isNestable,
          )),
        )
      ],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _detailsController,
              decoration: const InputDecoration(
                hintText: 'Details',
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: switchListTilePadding,
              title: const Text('Nestable'),
              value: _isNestable,
              onChanged: (value) => setState(() => _isNestable = value),
            ),
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
