import 'package:castboard_remote/redux/reducers/appStateReducer.dart';
import 'package:castboard_remote/redux/state/AppState.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

final appStore = Store<AppState>(appStateReducer,
    initialState: AppState.initial(), middleware: [thunkMiddleware]);
