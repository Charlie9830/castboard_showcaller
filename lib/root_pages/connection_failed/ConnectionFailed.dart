import 'package:flutter/material.dart';

class ConnectionFailed extends StatefulWidget {
  const ConnectionFailed({Key? key}) : super(key: key);

  @override
  _ConnectionFailedState createState() => _ConnectionFailedState();
}

class _ConnectionFailedState extends State<ConnectionFailed> {
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
          Icon(Icons.error),
          SizedBox(height: 16),
          Text("Unable to reconnect with player",
              style: Theme.of(context).textTheme.subtitle1),
          SizedBox(height: 16),
          Text('Please check your Wifi settings then refresh the page'),
        ],
      ),
    ));
  }
}
