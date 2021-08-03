import 'package:castboard_remote/Routes.dart';
import 'package:castboard_remote/containers/HomeScaffoldContainer.dart';
import 'package:castboard_remote/containers/SplashScreenContainer.dart';
import 'package:castboard_remote/root_pages/WaitingOverlay.dart';
import 'package:castboard_remote/view_models/AppViewModel.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final AppViewModel viewModel;

  App({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Castboard Remote',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
      ),
      initialRoute: Routes.splash,
      routes: {
        Routes.splash: (context) => SplashScreenContainer(),
        Routes.home: (context) => viewModel.fetched
            ? HomeScaffoldContainer()
            : SplashScreenContainer(),
      },
      navigatorObservers: [],
    );
  }
}
