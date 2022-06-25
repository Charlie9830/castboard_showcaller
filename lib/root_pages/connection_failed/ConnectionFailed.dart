import 'package:flutter/material.dart';

class ConnectionFailed extends StatefulWidget {
  const ConnectionFailed({Key? key}) : super(key: key);

  @override
  ConnectionFailedState createState() => ConnectionFailedState();
}

class ConnectionFailedState extends State<ConnectionFailed> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error),
        const SizedBox(height: 16),
        Text("Unable to reconnect with player",
            style: Theme.of(context).textTheme.subtitle1),
        const SizedBox(height: 16),
        const Text('Please check your Wifi settings then refresh the page'),
      ],
    ));
  }
}
