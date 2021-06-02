import 'package:flutter/material.dart';

class Parent extends StatelessWidget {
  const Parent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Child(
      onChildButtonPressed: () => print('Button was pressed'),
    );
  }
}

class Child extends StatelessWidget {
  final dynamic onChildButtonPressed;       // <------- HERE

  const Child({Key? key, this.onChildButtonPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onChildButtonPressed, // <---- AND HERE
      child: Text('Press Me'),
    );
  }
}
