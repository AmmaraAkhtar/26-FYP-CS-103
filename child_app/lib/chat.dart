import 'package:flutter/material.dart';
import 'status.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:usage_stats/usage_stats.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lockScreen.dart';
import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WatcherScreen extends StatefulWidget {
  int screen_limit = 0;
  WatcherScreen({super.key, required this.screen_limit});
  @override
  _WatcherScreenState createState() => _WatcherScreenState();
}

class _WatcherScreenState extends State<WatcherScreen> {
  // APP MOnitoring

  Future<void> checkPermission() async {
    bool? granted = await UsageStats.checkUsagePermission();
    if (granted != true) {
      await UsageStats.grantUsagePermission();
    }
  }

  void startAppMonitoring() async {
    print("App Monitoring is called");
    Timer.periodic(Duration(seconds: 10), (timer) {
        print("TIMER TICK 🔁");
      fetchAppUsageData();
    });
  }

  Future<void> fetchAppUsageData() async {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(minutes: 1));

    Map<String, UsageInfo> usageStats =
        await UsageStats.queryAndAggregateUsageStats(startDate, endDate);

    processData(usageStats);
  }

  bool isSystemApp(String packageName) {
    return packageName.startsWith("com.android") ||
        packageName.startsWith("com.google.android");
  }

  // Screen Time MOnitoring

  int calculateTotalUsage(List<Map<String, dynamic>> apps) {
    int totalSeconds = 0;

    for (var app in apps) {
      int time = (app["usage_time"] ?? 0) as int;
      totalSeconds += time;
    }

    return totalSeconds ~/ 60; // convert to minutes
  }

  void processData(Map<String, UsageInfo> stats) {
    List<Map<String, dynamic>> filteredData = [];
    print("RAW STATS: $stats");

    stats.forEach((packageName, info) {
      var usageTime = info.totalTimeInForeground;

      int time = 0;
      if (usageTime != null) {
        time = int.parse(usageTime);
      }

      if (time > 0 && !isSystemApp(packageName)) {
        filteredData.add({
          "package_name": packageName,
          "usage_time": (time ~/ 1000), // integer seconds
        });
      }
      print("PACKAGE: $packageName");
      print("TIME: $time");
    });
    print("FILTERED APPS:");
    print(filteredData);

    sendToBackend(filteredData);
    int totalUsageMinutes = calculateTotalUsage(filteredData);
    bool alertSent = false;

    if (totalUsageMinutes >= widget.screen_limit) {
      // showLockScreen();
      triggerAlert("Low", "Screen Limit Exceeded");
      alertSent = true;
    }
  }

  Future<void> sendToBackend(List<Map<String, dynamic>> data) async {
    print("🚀 SENDING TO BACKEND: $data");
    String link = 'http://192.168.18.31:8000/appdata/';
    final response = await http.post(
      Uri.parse(link),
      headers: {
        "Content-Type": "application/json",
        
      },
      body: jsonEncode({
        "child_id": 2,
        "usage_data": data,
        "timestamp": DateTime.now().toIso8601String(),
      }),
    );

    print(response.statusCode);
    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");
  }

  // Chat Monitoring

  void openAccessibilitySettings() {
    final intent = AndroidIntent(
      action: 'android.settings.ACCESSIBILITY_SETTINGS',
    );
    intent.launch();
  }

  var platform = MethodChannel('chat_reader_channel');
  final FlutterTts flutterTts = FlutterTts();

  void chatMonitoring() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "onChatText") {
        String text = call.arguments;
        // Step 1: Read text aloud
        await flutterTts.speak(text);

        // Step 2: Send to backend
        await sendChatToBackend(text);
      }
    });
  }

  Future<void> sendChatToBackend(String text) async {
    final url = Uri.parse('https://yourbackend.com/api/chats');
    try {
      await http.post(url, body: {'message': text});
    } catch (e) {
      print('Error sending chat: $e');
    }
  }

  // Web Monitoring

  void openVpnConsent() {
    final intent = AndroidIntent(action: 'android.net.VpnService');
    intent.launch();
  }

  var platform1 = MethodChannel('vpn_channel');
  List<String> detectedUrls = [];

  void webMonitoring() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "onUrlDetected") {
        String url = call.arguments;
        setState(() => detectedUrls.add(url));

        // Send to backend
        await sendURLToBackend(url);
      }
    });
  }

  Future<void> sendURLToBackend(String url) async {
    try {
      final response = await http.post(
        Uri.parse('https://yourbackend.com/api/url'),
        body: {'url': url},
      );
      print("Backend response: ${response.statusCode}");
    } catch (e) {
      print("Error sending to backend: $e");
    }
  }

  void startVpn() async {
    try {
      await platform.invokeMethod("startVpn");
    } on PlatformException catch (e) {
      print("Failed to start VPN: ${e.message}");
    }
  }

  // Alert MEchanism

  void triggerAlert(String type, String message) async {
    var response = await http.post(
      Uri.parse("http://192.168.18.31/sendalert/"),
      body:  jsonEncode({
    "child_id": 2,
    "alert_type": type,
    "message": message,
  }),
    );
  }

  void showLocKScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => lockScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    print("INIT STATE CALLED 🚀");

    checkPermission();
    startAppMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250.h), // AppBar ka height adjust
        child: AppBar(
          backgroundColor: Color(0xFFFBFBFC),
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: 50.h), // top space
            child: Hero(
              tag: 'applog',
              child: Image.asset('assets/logo.png', height: 189.h),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
            child: Column(
              children: [
                Text(
                  "Permissions",
                  style: TextStyle(
                    fontSize: 36.sp,
                    color: Color(0xFF699886),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5CD97),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/OneTimePassword.png",
                        width: 50.w,
                        height: 50.h,
                      ),
                      SizedBox(width: 12.w),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Usage Access",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Color(0xFF8D7365),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Monitoring kids online",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Color(0xFFAF8067),
                            ),
                          ),
                        ],
                      ),

                      Spacer(),

                      Switch(value: true, onChanged: null),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(bottom: 12.w),
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5CD97),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/AccessibilityTools.png",
                        width: 50.w,
                        height: 50.h,
                      ),
                      SizedBox(width: 12.w),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Accessibility Services",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Color(0xFF8D7365),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Foreground services",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Color(0xFFAF8067),
                            ),
                          ),
                        ],
                      ),

                      Spacer(),

                      Switch(value: true, onChanged: null),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(bottom: 12.w),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5CD97),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/Alarm.png",
                        width: 50.w,
                        height: 50.h,
                      ),
                      SizedBox(width: 12.w),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Notification Access",
                            style: TextStyle(
                              color: Color(0xFF8D7365),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "To view all notifications",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Color(0xFFAF8067),
                            ),
                          ),
                        ],
                      ),

                      Spacer(),

                      Switch(value: true, onChanged: null),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(bottom: 12.w),
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5CD97),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/UserShield.png",
                        width: 50.w,
                        height: 50.h,
                      ),
                      SizedBox(width: 12.w),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Account Activity",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Color(0xFF8D7365),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "To view account activity",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Color(0xFFAF8067),
                            ),
                          ),
                        ],
                      ),

                      Spacer(),

                      Switch(value: true, onChanged: null),
                    ],
                  ),
                ),

                SizedBox(height: 25.h),

                SizedBox(
                  width: 285.w,
                  height: 47.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => status()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEB9974),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
