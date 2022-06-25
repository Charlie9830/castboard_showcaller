import 'package:flutter/material.dart';

class GeneralMessageSnackBar extends StatelessWidget {
  final bool success;
  final String message;
  const GeneralMessageSnackBar({Key? key, required this.success, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Icon(success: success),
        const SizedBox(width: 8),
        Expanded(
          child: Text(message),
        )
      ],
    );
  }
}

class _Icon extends StatelessWidget {
  final bool success;
  const _Icon({Key? key, required this.success}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = DefaultTextStyle.of(context).style.color;
    if (success) {
      return Icon(Icons.check, color: color);
    } else {
      return Icon(Icons.error, color: color);
    }
  }
}
