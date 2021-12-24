import 'dart:convert';

import 'package:castboard_core/models/system_controller/SystemConfig.dart';
import 'package:http/http.dart' as http;

Future<bool> pushSystemConfig(Uri uri, SystemConfig config) async {
  final request = await http.post(uri, body: json.encode(config.toMap()));

  if (request.statusCode == 200 && request.body is String) {
    return request.body == 'true';
  }

  return false;
}
