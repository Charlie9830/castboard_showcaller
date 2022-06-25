import 'package:castboard_showcaller/view_models/SplashScreenViewModel.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final SplashScreenViewModel viewModel;

  const SplashScreen({Key? key, required this.viewModel}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.onPullDownData();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Castboard', style: Theme.of(context).textTheme.headline5),
        const SizedBox(height: 16),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: const LinearProgressIndicator(),
        ),
      ],
    ));
  }
}
