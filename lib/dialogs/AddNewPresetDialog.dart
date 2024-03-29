import 'package:castboard_core/utils/is_mobile_layout.dart';
import 'package:castboard_core/widgets/color_tag_selector/color_tag_selector.dart';
import 'package:castboard_showcaller/ResponsiveDialogContainer.dart';
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
  int _colorTag = -1;

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

    final desktopLayout = isNotMobileLayout(context);

    return ResponsiveDialogContainer(
      title: 'Create new Preset',
      actions: [
        TextButton(
          onPressed: _allowCreation
              ? () => Navigator.of(context).pop(
                    AddNewPresetDialogResult(
                      name: _nameController.text,
                      details: _detailsController.text,
                      useExistingCastChange: _useExistingCastChange,
                      colorTagIndex: _colorTag,
                    ),
                  )
              : null,
          child: const Text('Create'),
        )
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            autofocus: true,
            controller: _nameController,
            decoration: const InputDecoration(
              label: Text('Name'),
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
            labelPosition: ColorTagSelectorLabelPosition.top,
            leftAligned: true,
            selectedColorIndex: _colorTag,
            onChange: (value) => setState(() => _colorTag = value),
          ),
          const SizedBox(height: 16),
          if (!desktopLayout)
            SwitchListTile(
              contentPadding: switchListTilePadding,
              title: Text("Copy from current cast change",
                  style: Theme.of(context).textTheme.bodyMedium),
              value: _useExistingCastChange,
              onChanged: (value) =>
                  setState(() => _useExistingCastChange = value),
            ),
          if (desktopLayout)
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: switchListTilePadding,
              title: Text("Copy from current cast change",
                  style: Theme.of(context).textTheme.bodyMedium),
              value: _useExistingCastChange,
              onChanged: (value) =>
                  setState(() => _useExistingCastChange = value ?? true),
            ),
          if (_useExistingCastChange == false)
            Text('Cast change will start from blank',
                style: Theme.of(context).textTheme.caption),
        ],
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
  final int colorTagIndex;

  AddNewPresetDialogResult({
    this.name = '',
    this.details = '',
    this.useExistingCastChange = false,
    this.colorTagIndex = -1,
  });
}
