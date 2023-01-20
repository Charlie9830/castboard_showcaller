import 'package:castboard_core/utils/is_mobile_layout.dart';
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
      if (isNotMobileLayout(context)) {
        return largeContentBuilder(context);
      } else {
        return smallContentBuilder(context);
      }
    });
  }
}
