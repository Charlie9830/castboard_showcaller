import 'package:flutter/material.dart';

class ListItemHeader extends StatelessWidget {
  final String title;
  const ListItemHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: Theme.of(context)
            .textTheme
            .subtitle2!
            .copyWith(color: Theme.of(context).colorScheme.secondaryContainer));
  }
}
