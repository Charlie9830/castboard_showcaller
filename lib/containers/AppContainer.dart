import 'package:castboard_remote/App.dart';
import 'package:castboard_remote/redux/state/AppState.dart';
import 'package:castboard_remote/view_models/AppViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppViewModel>(
      builder: (context, viewModel) {
        return App(
          viewModel: viewModel,
        );
      },
      converter: (Store<AppState> store) {
        return AppViewModel(
          fetched: store.state.showState.fetched,
        );
      },
    );
  }
}
