import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class MonitorService {

  static const platform =
      MethodChannel('monitor_channel');




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