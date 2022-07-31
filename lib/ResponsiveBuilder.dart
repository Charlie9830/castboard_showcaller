import 'package:castboard_showcaller/isLargeLayout.dart';
import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  final WidgetBuilder smallContentBuilder;
  final WidgetBuilder largeContentBuilder;

  const ResponsiveBuilder({
    Key? key,
    required this.smallContentBuilder,
    required this.largeContentBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      if (isLargeLayout(context)) {
        return largeContentBuilder(context);
      } else {
        return smallContentBuilder(context);
      }
    });
  }
}
