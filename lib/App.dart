import 'package:castboard_showcaller/Routes.dart';
import 'package:castboard_showcaller/containers/HomeScaffoldContainer.dart';
import 'package:castboard_showcaller/containers/PlayerSettingsPageContainer.dart';
import 'package:castboard_showcaller/containers/SplashScreenContainer.dart';
import 'package:castboard_showcaller/containers/UploadShowfilePageContainer.dart';
import 'package:castboard_showcaller/global_keys.dart';
import 'package:castboard_showcaller/root_pages/connection_failed/ConnectionFailed.dart';
import 'package:castboard_showcaller/root_pages/device_restarting/DeviceRestarting.dart';
import 'package:castboard_showcaller/view_models/AppViewModel.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final AppViewModel viewModel;

  const App({Key? key, required this.viewModel}) : super(key: key);

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
      navigatorKey: navigatorKey,
      initialRoute: Routes.splash,
      routes: {
        Routes.splash: (context) => const SplashScreenContainer(),
        Routes.home: (context) => viewModel.fetched
            ? const HomeScaffoldContainer()
            : const SplashScreenContainer(),
        Routes.settings: (context) => const PlayerSettingsPageContainer(),
        Routes.showfileUpload: (context) => const UploadShowfilePageContainer(),
        Routes.deviceRestarting: (context) => const DeviceRestarting(),
        Routes.connectionFailed: (context) => const ConnectionFailed(),
      },
      navigatorObservers: const [],
    );
  }
}
