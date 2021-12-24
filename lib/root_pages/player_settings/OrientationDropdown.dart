import 'package:castboard_core/models/system_controller/DeviceOrientation.dart';
import 'package:flutter/material.dart';

class OrientationDropdown extends StatelessWidget {
  final DeviceOrientation? selectedValue;
  final void Function(DeviceOrientation? ori)? onChanged;

  const OrientationDropdown({
    Key? key,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: 180,
      child: DropdownButton<DeviceOrientation>(
        isExpanded: true,
        onChanged: onChanged,
        value: selectedValue,
        items: [
          DropdownMenuItem<DeviceOrientation>(
            child: Text('Landscape'),
            value: DeviceOrientation.landscape,
          ),
          DropdownMenuItem<DeviceOrientation>(
            child: Text('Portrait Left'),
            value: DeviceOrientation.portraitLeft,
          ),
          DropdownMenuItem<DeviceOrientation>(
            child: Text('Portrait Right'),
            value: DeviceOrientation.portraitRight,
          ),
        ],
      ),
    );
  }
}
