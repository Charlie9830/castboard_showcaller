import 'package:castboard_showcaller/SplashScreen.dart';
import 'package:castboard_showcaller/redux/actions/AsyncActions.dart';
import 'package:castboard_showcaller/redux/state/AppState.dart';
import 'package:castboard_showcaller/view_models/SplashScreenViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SplashScreenContainer extends StatelessWidget {
  const SplashScreenContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SplashScreenViewModel>(
      builder: (context, viewModel) {
        return SplashScreen(
          viewModel: viewModel,
        );
      },
      converter: (Store<AppState> store) {
        return SplashScreenViewModel(
            onPullDownData: () => store.dispatch(initializeApp(context)));
      },
    );
  }
}
