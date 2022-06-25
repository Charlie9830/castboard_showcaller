import 'package:flutter/material.dart';

class AddNewPresetDialog extends StatefulWidget {
  const AddNewPresetDialog({
    Key? key,
  }) : super(key: key);

  @override
  AddNewPresetDialogState createState() => AddNewPresetDialogState();
}

class AddNewPresetDialogState extends State<AddNewPresetDialog> {
  late TextEditingController _nameController;
  late TextEditingController _detailsController;
  bool _allowCreation = false;
  bool _useExistingCastChange = true;
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
    const switchListTilePadding = EdgeInsets.only(left: 0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Preset'),
        actions: [
          TextButton(
            onPressed: _allowCreation
                ? () => Navigator.of(context).pop(
                      AddNewPresetDialogResult(
                        name: _nameController.text,
                        details: _detailsController.text,
                        useExistingCastChange: _useExistingCastChange,
                        isNestable: _isNestable,
                      ),
                    )
                : null,
            child: const Text('Create'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              autofocus: true,
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
            SwitchListTile(
              contentPadding: switchListTilePadding,
              title: const Text("Copy from current cast change"),
              value: _useExistingCastChange,
              onChanged: (value) => setState(() => _useExistingCastChange = value),
            ),
            if (_useExistingCastChange == false)
            Text('Cast change will start from blank', style: Theme.of(context).textTheme.caption),
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
  final bool useExistingCastChange;
  final bool isNestable;

  AddNewPresetDialogResult({
    this.name = '',
    this.details = '',
    this.useExistingCastChange = false,
    this.isNestable = false,
  });
}
