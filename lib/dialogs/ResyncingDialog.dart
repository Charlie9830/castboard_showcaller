import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResyncingDialog extends StatefulWidget {
  const ResyncingDialog({Key? key}) : super(key: key);

  @override
  _ResyncingDialogState createState() => _ResyncingDialogState();
}

class _ResyncingDialogState extends State<ResyncingDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(),
          ),
          SizedBox(height: 16),
          Text('Upload Complete',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Theme.of(context).colorScheme.secondary)),
          SizedBox(height: 16),
          Text('Syncing with Player..',
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
