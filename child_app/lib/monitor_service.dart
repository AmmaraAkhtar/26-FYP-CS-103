import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class MonitorService {

  static const platform =
      MethodChannel('monitor_channel');


Future<void> sendHeartbeat(int childId) async {
  try {
    await http.post(
      Uri.parse('http://192.168.18.163:8000/heartbeat/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "child_id": childId,
        "timestamp": DateTime.now().toIso8601String(),
      }),
    );
    print("Heartbeat sent for child $childId");
  } catch (e) {
    print("Heartbeat error: $e");
  }
}

  Future<void> startService(int childId) async {

    try {

       await platform.invokeMethod("startService", {
    "child_id": childId
  });

      print("SERVICE STARTED");

    } catch (e) {

      print("SERVICE ERROR: $e");
    }
  }
}