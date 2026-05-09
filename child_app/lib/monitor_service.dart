import 'package:flutter/services.dart';

class MonitorService {
  static const platform = MethodChannel('monitor_channel');

  Future<void> startService() async {
    try {
      await platform.invokeMethod("startService");
    } catch (e) {
      print("Failed to start service: $e");
    }
  }
}