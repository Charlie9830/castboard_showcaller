import 'package:flutter/material.dart';

class PlayerSettings extends StatefulWidget {
  PlayerSettings({Key? key}) : super(key: key);

  @override
  _PlayerSettingsState createState() => _PlayerSettingsState();
}

class _PlayerSettingsState extends State<PlayerSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
          title: Text('Settings'),
          actions: [
            TextButton(onPressed: () {}, child: Text('Save')),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Text('General', style: Theme.of(context).textTheme.caption),
              ListTile(
                title: Text('Resume playing when idle'),
                trailing: Checkbox(
                  value: false,
                  onChanged: (_) {},
                ),
              ),
              ListTile(
                  title: Text('Adjust scaling'),
                  trailing: TextButton(
                    child: Text('Adjust'),
                    onPressed: () {},
                  ))
            ],
          ),
        ));
  }
}
