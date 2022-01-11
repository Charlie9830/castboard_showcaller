import 'package:castboard_showcaller/Routes.dart';
import 'package:castboard_showcaller/containers/HomeScaffoldContainer.dart';
import 'package:castboard_showcaller/containers/PlayerSettingsPageContainer.dart';
import 'package:castboard_showcaller/containers/SplashScreenContainer.dart';
import 'package:castboard_showcaller/containers/UploadShowfilePageContainer.dart';
import 'package:castboard_showcaller/root_pages/WaitingOverlay.dart';
import 'package:castboard_showcaller/root_pages/connection_failed/ConnectionFailed.dart';
import 'package:castboard_showcaller/root_pages/device_restarting/DeviceRestarting.dart';
import 'package:castboard_showcaller/view_models/AppViewModel.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final AppViewModel viewModel;

  App({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Castboard Showcaller',
      theme: ThemeData(
        fontFamily: 'Poppins',
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
        Routes.settings: (context) => PlayerSettingsPageContainer(),
        Routes.showfileUpload: (context) => UploadShowfilePageContainer(),
        Routes.deviceRestarting: (context) => DeviceRestarting(),
        Routes.connectionFailed: (context) => ConnectionFailed(),
      },
      navigatorObservers: [],
    );
  }
}
