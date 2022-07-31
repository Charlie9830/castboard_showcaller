import 'package:flutter/cupertino.dart';

bool isLargeLayout(BuildContext context) {
  return MediaQuery.of(context).size.width > 1200;
}
