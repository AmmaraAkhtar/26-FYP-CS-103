import 'package:flutter/material.dart';
import 'status.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:usage_stats/usage_stats.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WatcherScreen extends StatefulWidget {
  int screen_limit = 0;
  WatcherScreen({super.key, required this.screen_limit});
  @override
  _WatcherScreenState createState() => _WatcherScreenState();
}

class _WatcherScreenState extends State<WatcherScreen> {
  Future<void> checkPermission() async {
    bool? granted = await UsageStats.checkUsagePermission();
    if (granted != true) {
      await UsageStats.grantUsagePermission();
    }
  }

  void startAppMonitoring() async {
    Timer.periodic(Duration(hours: 1), (timer) {
      fetchAppUsageData();
    });
  }

  Future<void> fetchAppUsageData() async {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(hours: 1));

    Map<String, UsageInfo> usageStats =
        await UsageStats.queryAndAggregateUsageStats(startDate, endDate);

    processData(usageStats);
  }

  bool isSystemApp(String packageName) {
    return packageName.startsWith("com.android") ||
        packageName.startsWith("com.google.android");
  }

  int calculateTotalUsage(List<Map<String, dynamic>> apps) {
    int totalSeconds = 0;

    for (var app in apps) {
      totalSeconds += app["usage_time"] as int;
    }

    return totalSeconds ~/ 60; // convert to minutes
  }

  void processData(Map<String, UsageInfo> stats) {
    List<Map<String, dynamic>> filteredData = [];

    stats.forEach((packageName, info) {
      var usageTime = info.totalTimeInForeground;
      int time = 0;
      if (usageTime != null) {
        time = int.parse(usageTime);
      }

      if (time > 0 && !isSystemApp(packageName)) {
        filteredData.add({
          "package_name": packageName,
          "usage_time": time / 1000, // seconds
        });
      }
    });

    sendToBackend(filteredData);
    int totalUsageMinutes = calculateTotalUsage(filteredData);

    if (totalUsageMinutes >= widget.screen_limit) {
      // showLockScreen();
      triggerAlert("Low", "Screen Limit Exceede");
    }
  }

  Future<void> sendToBackend(List<Map<String, dynamic>> data) async {
    String link = 'http://10.27.190.96:8000/appdata/';
    final response = await http.post(
      Uri.parse(link),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer YOUR_TOKEN",
      },
      body: jsonEncode({
        "child_id": 2,
        "usage_data": data,
        "timestamp": DateTime.now().toIso8601String(),
      }),
    );

    print(response.statusCode);
  }

  void triggerAlert(String type, String message) async {
    var response = await http.post(
      Uri.parse("http://10.27.190.96:8000/sendalert/"),
      body: {"child_id": 2, "alert_type": type, "message": message},
    );
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
