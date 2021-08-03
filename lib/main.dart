import 'package:castboard_remote/Routes.dart';
import 'package:castboard_remote/SplashScreen.dart';
import 'package:castboard_remote/containers/AppContainer.dart';
import 'package:castboard_remote/containers/HomeScaffoldContainer.dart';
import 'package:castboard_remote/containers/SplashScreenContainer.dart';
import 'package:castboard_remote/redux/AppStore.dart';
import 'package:castboard_remote/redux/state/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() {
  runApp(_CastboardStoreProvider());
}

class _CastboardStoreProvider extends StatelessWidget {
  const _CastboardStoreProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(store: appStore, child: AppContainer());
  }
}
