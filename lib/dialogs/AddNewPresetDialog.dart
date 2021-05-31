import 'package:flutter/material.dart';

class AddNewPresetDialog extends StatefulWidget {
  final String existingSelectedPresetName;
  AddNewPresetDialog({
    Key? key,
    this.existingSelectedPresetName = '',
  }) : super(key: key);

  @override
  _AddNewPresetDialogState createState() => _AddNewPresetDialogState();
}

class _AddNewPresetDialogState extends State<AddNewPresetDialog> {
  late TextEditingController _nameController;
  late TextEditingController _detailsController;
  bool _allowCreation = false;
  bool _startFromExisting = false;
  bool _isNestable = false;

  @override
  void initState() {
    _nameController = TextEditingController()
      ..addListener(() {
        setState(() => _allowCreation = _nameController.text.isNotEmpty);
      });
    _detailsController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const switchListTilePadding = const EdgeInsets.only(left: 0);
    return Scaffold(
      appBar: AppBar(
        title: Text('New Preset'),
        actions: [
          TextButton(
            child: Text('Create'),
            onPressed: _allowCreation
                ? () => Navigator.of(context).pop(
                      AddNewPresetDialogResult(
                        name: _nameController.text,
                        details: _detailsController.text,
                        useExistingSelectedCastChange: _startFromExisting,
                        isNestable: _isNestable,
                      ),
                    )
                : null,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              autofocus: true,
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
            if (widget.existingSelectedPresetName.isNotEmpty)
              SwitchListTile(
                  contentPadding: switchListTilePadding,
                  title: Text(
                      "Start from ${widget.existingSelectedPresetName}'s cast change"),
                  value: _startFromExisting,
                  onChanged: (value) =>
                      setState(() => _startFromExisting = value)),
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

class AddNewPresetDialogResult {
  final String name;
  final String details;
  final bool useExistingSelectedCastChange;
  final bool isNestable;

  AddNewPresetDialogResult({
    this.name = '',
    this.details = '',
    this.useExistingSelectedCastChange = false,
    this.isNestable = false,
  });
}
