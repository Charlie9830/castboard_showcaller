import 'package:castboard_core/models/PresetModel.dart';
import 'package:flutter/material.dart';

class EditPresetPropertiesDialog extends StatefulWidget {
  final PresetModel existing;

  EditPresetPropertiesDialog({
    Key? key,
    required this.existing,
  }) : super(key: key);

  @override
  _EditPresetPropertiesDialogState createState() =>
      _EditPresetPropertiesDialogState();
}

class _EditPresetPropertiesDialogState
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
    const switchListTilePadding = const EdgeInsets.only(left: 0);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Details'),
        actions: [
          TextButton(
            child: Text('Update'),
            onPressed: () => Navigator.of(context).pop(widget.existing.copyWith(
              name: _nameController.text,
              details: _detailsController.text,
              isNestable: _isNestable,
            )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _detailsController,
              decoration: InputDecoration(
                hintText: 'Details',
              ),
            ),
            SizedBox(height: 16),
            SwitchListTile(
              contentPadding: switchListTilePadding,
              title: Text('Nestable'),
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