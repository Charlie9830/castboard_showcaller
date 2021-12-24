import 'package:flutter/material.dart';

class DeviceRestarting extends StatefulWidget {
  const DeviceRestarting({Key? key}) : super(key: key);

  @override
  _DeviceRestartingState createState() => _DeviceRestartingState();
}

class _DeviceRestartingState extends State<DeviceRestarting> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Applying changes',
              style: Theme.of(context).textTheme.subtitle1),
          SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: LinearProgressIndicator(),
          ),
        ],
      ),
    ));
  }
}
