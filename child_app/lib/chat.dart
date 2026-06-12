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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'monitor_service.dart';
import 'lock_service.dart';
import 'package:permission_handler/permission_handler.dart';

class WatcherScreen extends StatefulWidget {
  int screen_limit = 0;
  int child_id = 0;
  WatcherScreen({
    super.key,
    required this.screen_limit,
    required this.child_id,
  });
  @override
  _WatcherScreenState createState() => _WatcherScreenState();
}

class _WatcherScreenState extends State<WatcherScreen> {
  int? storedChildId;
  int? storedScreenLimit;
  bool _smsPermissionGranted = false;

  
  // Load Child Data
  Future<void> loadChildData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      storedChildId = prefs.getInt("child_id");
      storedScreenLimit = prefs.getInt("screen_limit");
    });

    print("Loaded Child ID: $storedChildId");
  }

  // Save Child Data
  Future<void> saveChildData(int childId, int screenLimit) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("child_id", childId);
  await prefs.setInt("screen_limit", screenLimit);
  print("Saved child_id: $childId");
}

// Battery Optimization

Future<void> requestBatteryOptimization() async {
  const platform = MethodChannel('monitor_channel');
  try {
    final result = await platform.invokeMethod('requestIgnoreBatteryOptimizations');
    print("Battery optimization: $result");
  } catch (e) {
    print("Battery optimization error: $e");
  }
}

  // APP MOnitoring

  Future<void> checkPermission() async {
    bool? granted = await UsageStats.checkUsagePermission();
    if (granted != true) {
      await UsageStats.grantUsagePermission();
    }
  }

  Future<void> checkSmsPermission() async {
  final status = await Permission.sms.status;
  setState(() {
    _smsPermissionGranted = status.isGranted;
  });
}

// SMS Permissions
Future<void> requestSmsPermission() async {
  final status = await Permission.sms.status;

  if (status.isGranted) {
    setState(() => _smsPermissionGranted = true);
    return;
  }

  if (status.isDenied) {
    final result = await Permission.sms.request();
    setState(() => _smsPermissionGranted = result.isGranted);

    if (!result.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("SMS permission denied"),
          backgroundColor: Colors.red,
        ),
      );
    }
    return;
  }
}
// Notification Listener permission check
Future<void> checkNotificationListenerPermission() async {
  const platform = MethodChannel('monitor_channel');
  
  try {
    final bool isEnabled = await platform.invokeMethod(
      'isNotificationListenerEnabled'
    );
    
    if (!isEnabled) {
      // Settings pe le jao
      showNotificationPermissionDialog();
    }
  } catch (e) {
    print("Error checking notification permission: $e");
  }
}
// Notification Listener permission 
void showNotificationPermissionDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        "Notification Access Required",
        style: TextStyle(
          color: Color(0xFF699886),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "WhatsApp aur Instagram messages monitor karne ke liye "
        "notification access zaruri hai.",
        style: TextStyle(color: Colors.grey[700]),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text("Later", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx);
            // Notification listener settings pe le jao
            const AndroidIntent intent = AndroidIntent(
              action: 'android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS',
            );
            intent.launch();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFEB9974),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            "Enable Now",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

  void startAppMonitoring() async {
    print("App Monitoring is called");
    Timer.periodic(Duration(seconds: 10), (timer) {
      print("TIMER TICK ");
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
    print("SENDING TO BACKEND: $data");
    String link = 'http://192.168.18.163:8000/appdata/';
    final response = await http.post(
      Uri.parse(link),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "child_id": widget.child_id != 0 ? widget.child_id : storedChildId,
        "usage_data": data,
        "timestamp": DateTime.now().toIso8601String(),
      }),
    );

    print(response.statusCode);
    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");
     if (response.statusCode == 200) {
    final result = jsonDecode(response.body);

    List predictions = result["predictions"];

    bool shouldLock = predictions.any((app) =>
        app["action"] == "Block" || app["risk"] == "High");

    if (shouldLock) {

  await LockService.lockDevice();

  triggerAlert(
    "High",
    "High Risk App Detected - Device Locked"
  );

  showLockScreen();
}
  }
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

  // void webMonitoring() {
  //   platform.setMethodCallHandler((call) async {
  //     if (call.method == "onUrlDetected") {
  //       String url = call.arguments;
  //       setState(() => detectedUrls.add(url));

  //       // Send to backend
  //       await sendURLToBackend(url);
  //     }
  //   });
  // }

  
void webMonitoring() {
  print("Web Monitoring Started");

  platform1.setMethodCallHandler((call) async {

    print("FROM ANDROID METHOD: ${call.method}");

    if (call.method == "onUrlDetected") {

      String url = call.arguments;

      print(" URL RECEIVED: $url");

      setState(() {
        detectedUrls.add(url);
      });

      await sendURLToBackend(url);
    }
  });
}

  // Future<void> sendURLToBackend(String url) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse("http://192.168.18.163:8000/collectwebusage/"),
  //       body: {'url': url},
  //     );
  //     print("Backend response: ${response.statusCode}");
  //   } catch (e) {
  //     print("Error sending to backend: $e");
  //   }
  // }

  Future<void> sendURLToBackend(String url) async {
  // Removing prefix
  String cleanUrl = url
      .replaceFirst("UI:", "")
      .replaceFirst("VPN:", "")
      .trim();

  if (cleanUrl.isEmpty) return;

  // adding https:// 
  if (!cleanUrl.startsWith("http://") && !cleanUrl.startsWith("https://")) {
    cleanUrl = "https://$cleanUrl";
  }

  try {
    print("Sending URL: $cleanUrl");

    final response = await http.post(
      Uri.parse("http://192.168.18.163:8000/collectwebusage/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "child_id": widget.child_id != 0 ? widget.child_id : storedChildId,
        "url": cleanUrl,
        "usage_time": 0,        
        "timestamp": DateTime.now().toIso8601String(),
      }),
    );

    print("Backend response: ${response.statusCode}");
  } catch (e) {
    print("Error: $e");
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
    Uri.parse("http://192.168.18.163:8000/sendalert/"),

    headers: {
      "Content-Type": "application/json",
    },

    body: jsonEncode({
      "child_id": widget.child_id,
      "alert_type": type,
      "message": message,
    }),
  );

  print(response.statusCode);
  print(response.body);
}

  void showLockScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => lockScreen()),
    );
  }

Future<void> activateDeviceAdmin() async {
  const platform = MethodChannel('monitor_channel');
  try {
    final result = await platform.invokeMethod('activateDeviceAdmin');
    print("Device Admin: $result");
  } catch (e) {
    print("Device Admin Error: $e");
  }
}

  Future<void> checkLockState() async {

  bool locked = await LockService.isLocked();

  if (locked) {
    showLockScreen();
  }
}
Future<void> _startServiceWithDelay() async {
  // Thoda wait karo taake SharedPreferences load ho jaye
  await Future.delayed(Duration(milliseconds: 500));
  
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int childId = widget.child_id != 0 
      ? widget.child_id 
      : (prefs.getInt("child_id") ?? -1);
  
  print(" Starting service with Child ID: $childId");
  
  await MonitorService().startService(childId);
}

Future<void> checkAccessibilityPermission() async {
  const platform = MethodChannel('monitor_channel');
  try {
    final bool isEnabled = await platform.invokeMethod('isAccessibilityServiceEnabled');
    if (!isEnabled) {
      showAccessibilityPermissionDialog();
    }
  } catch (e) {
    print("Error checking accessibility permission: $e");
  }
}

// Accessibility permission dialog

void showAccessibilityPermissionDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        "Accessibility Access Required",
        style: TextStyle(
          color: Color(0xFF699886),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Chats aur web browsing monitor karne ke liye Accessibility "
        "permission zaruri hai. Sirf ek dafa enable karna hoga.",
        style: TextStyle(color: Colors.grey[700]),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text("Later", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(ctx);
            const platform = MethodChannel('monitor_channel');
            await platform.invokeMethod('openAccessibilitySettings');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFEB9974),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text("Enable Now", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}


void setupListener() {
  // Chat reader channel (accessibility)
  platform.setMethodCallHandler((call) async {
    print("CHANNEL CALL: ${call.method}");
    
    if (call.method == "onChatText") {
      print("CHAT: ${call.arguments}");
      await sendChatToBackend(call.arguments);
    }

    if (call.method == "onUrlDetected") {
      String url = call.arguments;
      print("URL FROM ACCESSIBILITY: $url");
      setState(() => detectedUrls.add(url));
      await sendURLToBackend(url);
    }
  });

  // VPN channel — alag handler
  platform1.setMethodCallHandler((call) async {
    print("VPN CHANNEL CALL: ${call.method}");
    
    if (call.method == "onUrlDetected") {
      String url = call.arguments;
      print("URL FROM VPN: $url");
      setState(() => detectedUrls.add(url));
      await sendURLToBackend(url);
    }
  });
}

  @override
  void initState() {
    super.initState();
    print("INIT STATE CALLED ");
    checkAccessibilityPermission();
    activateDeviceAdmin();
    setupListener();
    //webMonitoring();
    loadChildData();
    saveChildData(widget.child_id, widget.screen_limit);
    checkPermission();
    // startAppMonitoring();
    // START BACKGROUND SERVICE HERE
   _startServiceWithDelay();
   checkSmsPermission();
   requestSmsPermission();
   checkNotificationListenerPermission();
   requestBatteryOptimization();
    
    

    //checkLockState();
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
