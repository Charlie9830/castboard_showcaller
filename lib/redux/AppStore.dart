import 'package:castboard_showcaller/redux/reducers/appStateReducer.dart';
import 'package:castboard_showcaller/redux/state/AppState.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

final appStore = Store<AppState>(appStateReducer,
    initialState: AppState.initial(), middleware: [thunkMiddleware]);
