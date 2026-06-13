import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'youtube1.dart';
import 'AlertMonitoring.dart';
import 'chat1.dart';
import 'appUsage.dart';
import 'screenTimeLimit.dart';
import 'browsering1.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Monitoring extends StatefulWidget {
  final Map<String, dynamic>? childData;
  final String token ;
  const Monitoring({super.key, this.childData,  required this.token});

  @override
  State<Monitoring> createState() => _MonitoringState();
}

class _MonitoringState extends State<Monitoring> {
  bool isDeviceLocked = false;
  bool isStatusLoading = true;
  Timer? _statusTimer;

  late int childId;

// To unlock the child device remotely
  Future<void> unlockChildDevice(int childId) async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.18.163:8000/unlock-device/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"child_id": childId}),
      );

      if (response.statusCode == 200) {
        setState(() => isDeviceLocked = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Device unlocked successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to unlock device")),
        );
      }
    } catch (e) {
      print("Unlock error: $e");
    }
  }

// Function to fetch the lock satus of the child device
Future<void> _fetchLockStatus() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.18.163:8000/check-lock-status/?child_id=$childId"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            isDeviceLocked = data["is_locked"] ?? false;
            isStatusLoading = false;
          });
        }
      }
    } catch (e) {
      print("Status fetch error: $e");
      if (mounted) {
        setState(() => isStatusLoading = false);
      }
    }
  }

// Function to shoew confirmation dialog before deactivating the child admin
void _showDeactivateConfirmation(int childId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Deactivate Device Admin?",
          style: TextStyle(color: Color(0xFF699886), fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Yeh action child device se monitoring admin access hata dega. "
          "Kya aap confirm karte hain?",
          style: TextStyle(color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deactivateChildAdmin(childId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text("Deactivate", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

// to deactivate the child admin remotely
Future<void> _deactivateChildAdmin(int childId) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.18.163:8000/deactivate-admin/'),
        headers: {
            
  'Authorization': 'Bearer ${widget.token}',
  'Content-Type': 'application/json',

          
        },
        body: jsonEncode({'child_id': childId}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Command sent! Child app will deactivate soon.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send command')),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
 
  void initState() {
    super.initState();
    childId = widget.childData?['id'] ?? 0;
    _fetchLockStatus();

    // Har 15 sec status refresh karo
    _statusTimer = Timer.periodic(Duration(seconds: 15), (_) {
      _fetchLockStatus();
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
 appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFC),
        title: Text(
          "Browsing Monitoring",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          // Notification Icon with Responsive Badge
          Stack(
            children: [
              IconButton(
                onPressed: null,
                icon: Icon(Icons.notifications_none, color: Colors.black, size: 28.sp),
              ),
              Positioned(
                right: 8.w,
                top: 8.h,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Text(
                    "3",
                    style: TextStyle(fontSize: 10.sp, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          Icon(Icons.settings_outlined, color: Colors.black, size: 24.sp),
          SizedBox(width: 15.w),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Profile Section
                   Row(
                children: [
                  CircleAvatar(
                    radius: 45.r,
                    backgroundColor: Colors.green,
                    child: CircleAvatar(
                      radius: 42.r,
                      backgroundImage: const NetworkImage(
                          'https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png'),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hamza Ali",
                          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
                      Text("11 Years Old",
                          style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                    ],
                  )
                ],
              ),
                SizedBox(height: 25.h),

                SizedBox(height: 25.h),

                // Device Status & Controls Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Device Controls",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(thickness: 1.h),
                        SizedBox(height: 10.h),

                        // Lock Status Indicator
                        Row(
                          children: [
                            Icon(
                              isDeviceLocked ? Icons.lock : Icons.lock_open,
                              color: isDeviceLocked ? Colors.red : Colors.green,
                              size: 28.r,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: isStatusLoading
                                  ? Text(
                                      "Checking status...",
                                      style: TextStyle(
                                          fontSize: 14.sp, color: Colors.grey),
                                    )
                                  : Text(
                                      isDeviceLocked
                                          ? "Device is currently LOCKED"
                                          : "Device is Unlocked",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isDeviceLocked
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Buttons Row
                        Row(
                          children: [
                            // Unlock Device Button
                            Expanded(
                              child: SizedBox(
                                height: 42.h,
                                child: ElevatedButton.icon(
                                  onPressed: isDeviceLocked
                                      ? () => unlockChildDevice(childId)
                                      : null,
                                  icon: Icon(Icons.lock_open,
                                      size: 18.r, color: Colors.white),
                                  label: Text(
                                    "Unlock Device",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDeviceLocked
                                        ? const Color(0xFFEB9974)
                                        : Colors.grey[300],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),

                            // Deactivate Admin Button
                            Expanded(
                              child: SizedBox(
                                height: 42.h,
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      _showDeactivateConfirmation(childId),
                                  icon: Icon(Icons.admin_panel_settings,
                                      size: 18.r, color: Colors.white),
                                  label: Text(
                                    "Deactivate Admin",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF699886),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // First Row
                Row(
                  children: [
                    Expanded(
                      child: _buildActivityCard(
                        title: "Screen Time",
                        headerColor: const Color(0xFFE8FADC),
                        iconPath: "assets/watch.png",
                        iconColor: Colors.green,
                        mainValue: "2h 30m",
                        subValue: "+1h 30m used",
                        buttonText: "Set Limit",
                        buttonColor: const Color(0xFF8BC34A),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ScreenTimeLimitScreen()),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildActivityCard(
                        title: "App Usage",
                        headerColor: const Color(0xFFFFD1A4),
                        iconPath: "assets/app.png",
                        iconColor: Colors.orange,
                        mainValue: "2h 30m",
                        subValue: "+1h 30m used",
                        buttonText: "View All »",
                        buttonColor: const Color(0xFFFB8C00),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AppUsageMonitoringScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Second Row
                Row(
                  children: [
                    Expanded(
                      child: _buildActivityCard(
                        title: "YouTube Activities",
                        headerColor: const Color(0xFFFFEBEE),
                        iconPath: "assets/youtube1.png",
                        iconColor: Colors.red,
                        mainValue: "2 videos watch",
                        subValue: "Last watched:\nCompusx ML",
                        buttonText: "View All »",
                        buttonColor: const Color(0xFFF44336),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>YoutubeActivityScreen()),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildActivityCard(
                        title: "Web Activities",
                        headerColor: const Color(0xFFE3F2FD),
                        iconPath: "assets/web.png",
                        iconColor: Colors.blue,
                        mainValue: "6 blocked sites",
                        subValue: "Most Recent:\nfreev.com",
                        buttonText: "View All »",
                        buttonColor: const Color(0xFF03A9F4),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BrowsingMonitoringScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),

                // Chat Activities Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Chat Activities",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ChatMonitoringDashboard()),
                                );
                              },
                              child: const Text(
                                "View All >>",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                        Divider(thickness: 1.h),
                        SizedBox(height: 10.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.warning_rounded,
                                color: Colors.orange, size: 30.r),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Suspicious Chat Detected",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp),
                                      ),
                                      Text(
                                        "Today At 5:30pm",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 10.sp),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    "There's potentially inappropriate language in the chat with Abdullah",
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 14.sp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Divider(thickness: 2.h, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Bottom Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AlertMonitoringDashboard()));
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5CBA7),
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.r,
                            offset: Offset(0, 4.h))
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 28.r),
                        Expanded(
                          child: Center(
                            child: Text(
                              "View All Alerts",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(color: Colors.black26, blurRadius: 2.r)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_double_arrow_right,
                            color: Colors.white, size: 28.r),
                      ],
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

  Widget _buildActivityCard({
    required String title,
    required Color headerColor,
    required String iconPath,
    required Color iconColor,
    required String mainValue,
    required String subValue,
    required String buttonText,
    required Color buttonColor,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  Icon(Icons.bar_chart_rounded,
                      size: 22.r, color: iconColor.withOpacity(0.7)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  Image.asset(
                    iconPath,
                    width: 45.w,
                    height: 45.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mainValue,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.sp)),
                        Text(subValue,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11.sp,
                                height: 1.2)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
                height: 1.h,
                thickness: 1.5.h,
                color: const Color(0xFFEEEEEE),
                indent: 10.w,
                endIndent: 10.w),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: SizedBox(
                height: 32.h,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                  ),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}