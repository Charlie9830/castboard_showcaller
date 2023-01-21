import 'package:castboard_core/utils/is_mobile_layout.dart';
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
    if (isNotMobileLayout(context)) {
      return Dialog(
        child: Material(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                body,
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (includeCancel) ...[
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel')),
                      const SizedBox(width: 16),
                    ],
                    ...actions,
                  ],
                )
              ]),
            ),
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
