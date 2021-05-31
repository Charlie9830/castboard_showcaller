import 'package:flutter/material.dart';

class DialogButtonRow extends StatelessWidget {
  final String affirmativeButtonText;
  final String negativeButtonText;
  final dynamic onAffirmatedButtonPressed;
  final dynamic onNegativeButtonPressed;

  const DialogButtonRow(
      {Key? key, this.affirmativeButtonText = '', this.negativeButtonText = '', this.onNegativeButtonPressed, this.onAffirmatedButtonPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (negativeButtonText.isNotEmpty)
        TextButton(
          child: Text(negativeButtonText),
          onPressed: onNegativeButtonPressed,
        ),
        if (negativeButtonText.isNotEmpty)
        SizedBox(
          width: 8,
        ),
        if (affirmativeButtonText.isNotEmpty)
        TextButton(
          child: Text(affirmativeButtonText),
          onPressed: onAffirmatedButtonPressed,
        ),
      ],
    );
  }
}
