import 'dart:convert';

import 'package:castboard_core/system-commands/SystemCommands.dart';
import 'package:http/http.dart' as http;

void sendSystemCommand(Uri uri, SystemCommand command) async {
  final commandUri = Uri.http(uri.authority, '/system/command');
  await http.put(commandUri, body: json.encode(command.toMap()));
}
