import 'package:flutter/material.dart';

class WaitingOverlay extends StatelessWidget {
  const WaitingOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(64, 0, 0, 0),
        alignment: Alignment.center,
        child: const SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator(),
        ));
  }
}
