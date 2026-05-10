import 'package:flutter/services.dart';

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