import 'package:castboard_showcaller/global_keys.dart';

bool isRootScaffoldMounted() {
  return scaffoldKey.currentState != null && scaffoldKey.currentState!.mounted;
}
