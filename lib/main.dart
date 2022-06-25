import 'package:castboard_showcaller/containers/AppContainer.dart';
import 'package:castboard_showcaller/redux/AppStore.dart';
import 'package:castboard_showcaller/redux/state/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() {
  runApp(const _CastboardStoreProvider());
}

class _CastboardStoreProvider extends StatelessWidget {
  const _CastboardStoreProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(store: appStore, child: const AppContainer());
  }
}
