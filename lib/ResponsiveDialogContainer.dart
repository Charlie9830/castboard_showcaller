import 'package:castboard_showcaller/dialogs/DialogButtonRow.dart';
import 'package:castboard_showcaller/isLargeLayout.dart';
import 'package:flutter/material.dart';

class ResponsiveDialogContainer extends StatelessWidget {
  final List<Widget> actions;
  final Widget body;
  final String title;
  final bool includeCancel;

  const ResponsiveDialogContainer(
      {Key? key,
      required this.title,
      required this.body,
      this.actions = const [],
      this.includeCancel = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLargeLayout(context)) {
      return Dialog(
        child: Material(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Expanded(child: body),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel')),
                  const SizedBox(width: 16),
                  ...actions,
                ],
              )
            ]),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: actions,
        ),
        body: body,
      );
    }
  }
}
