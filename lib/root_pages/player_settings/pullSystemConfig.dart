import 'dart:convert';

import 'package:castboard_core/models/system_controller/SystemConfig.dart';
import 'package:http/http.dart' as http;

Future<SystemConfig?> pullSystemConfig(Uri uri) async {
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    try {
      final raw = jsonDecode(response.body);
      final data = SystemConfig.fromMap(raw);

      return data;
    } catch (e) {
      return null;
    }
  } else {
    return null;
  }
}
