
import 'package:flutter/material.dart';

class ResyncingDialog extends StatefulWidget {
  const ResyncingDialog({Key? key}) : super(key: key);

  @override
  ResyncingDialogState createState() => ResyncingDialogState();
}

class ResyncingDialogState extends State<ResyncingDialog> {
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
          const SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(height: 16),
          Text('Upload Complete',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Theme.of(context).colorScheme.secondary)),
          const SizedBox(height: 16),
          Text('Syncing with Performer..',
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
