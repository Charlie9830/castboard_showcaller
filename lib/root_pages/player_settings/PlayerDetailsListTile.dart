import 'package:flutter/material.dart';

class PlayerDetailsListTile extends StatelessWidget {
  final String leading;
  final String trailing;
  const PlayerDetailsListTile({Key? key, this.leading = '', this.trailing = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(leading, style: Theme.of(context).textTheme.caption),
        trailing: Text(trailing));
  }
}
