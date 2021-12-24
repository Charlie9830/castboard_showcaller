import 'package:castboard_core/models/system_controller/DeviceResolution.dart';
import 'package:flutter/material.dart';

class ResolutionDropdown extends StatelessWidget {
  final List<DeviceResolution> resolutions;
  final DeviceResolution? selectedValue;
  final void Function(DeviceResolution? res)? onChanged;

  const ResolutionDropdown({
    Key? key,
    required this.resolutions,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (resolutions.isEmpty) {
      return _ResolutionErrorFallback();
    }

    return SizedBox(
      height: 56,
      width: 180,
      child: DropdownButton<DeviceResolution>(
        isExpanded: true,
        onChanged: onChanged,
        value: selectedValue,
        items: [
          ...resolutions
              .map((item) => DropdownMenuItem<DeviceResolution>(
                    value: item,
                    child: Text(
                        item.auto ? 'Auto' : '${item.width} x ${item.height}'),
                  ))
              .toList(),
        ],
      ),
    );
  }
}

class _ResolutionErrorFallback extends StatelessWidget {
  const _ResolutionErrorFallback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Unavailable', style: Theme.of(context).textTheme.caption);
  }
}
