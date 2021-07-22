import 'package:castboard_remote/Routes.dart';
import 'package:castboard_remote/SplashScreen.dart';
import 'package:castboard_remote/containers/HomeScaffoldContainer.dart';
import 'package:castboard_remote/containers/SplashScreenContainer.dart';
import 'package:castboard_remote/redux/AppStore.dart';
import 'package:castboard_remote/redux/state/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: appStore,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Castboard Remote',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
        ),
        
        initialRoute: Routes.splash,
        routes: {
          Routes.splash: (context) => SplashScreenContainer(),
          Routes.home: (context) => HomeScaffoldContainer()
        },
      ),
    );
  }
}
