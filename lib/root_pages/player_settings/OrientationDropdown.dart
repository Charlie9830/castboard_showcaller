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
        items: const [
          DropdownMenuItem<DeviceOrientation>(
            value: DeviceOrientation.landscape,
            child: Text('Landscape'),
          ),
          DropdownMenuItem<DeviceOrientation>(
            value: DeviceOrientation.portraitLeft,
            child: Text('Portrait Left'),
          ),
          DropdownMenuItem<DeviceOrientation>(
            value: DeviceOrientation.portraitRight,
            child: Text('Portrait Right'),
          ),
        ],
      ),
    );
  }
}
