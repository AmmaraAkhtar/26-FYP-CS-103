// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class AlertMonitoringDashboard extends StatelessWidget {
//   const AlertMonitoringDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFBFBFC),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFBFBFC),
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         surfaceTintColor: Colors.transparent,
//         leading: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
//         title: Text(
//           "Alert Monitoring Dashboard",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
//         ),
//         actions: [
//           IconButton(
//             onPressed: null,
//             icon: Icon(Icons.notifications_none, color: Colors.black, size: 28.sp),
//           ),
//           Icon(Icons.settings_outlined, color: Colors.black, size: 24.sp),
//           SizedBox(width: 15.w),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // --- User Header Section ---
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 40.r,
//                     backgroundColor: Colors.green,
//                     child: CircleAvatar(
//                       radius: 37.r,
//                       backgroundImage: const NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png'),
//                     ),
//                   ),
//                   SizedBox(width: 15.w),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Hamza Ali", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//                       Text("11 Years Old", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
//                     ],
//                   )
//                 ],
//               ),
//               SizedBox(height: 30.h),
//               Text("Alerts", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//               SizedBox(height: 15.h),

//               // --- Alerts List ---
//               _buildAlertCard(
//                 "Toxic Language Detected: Bullying in Social Media Chat",
//                 "15min ago",
//                 Colors.red,
//                 Icons.security, // Police hat icon replace
//                 ["Block Source"],
//               ),
//               _buildAlertCard(
//                 "Late Night Usage: App Activity after Bedtime",
//                 "15min ago",
//                 Colors.orange,
//                 Icons.person, // Bedtime/person icon
//                 ["Extend Limit", "Lock Screen"],
//               ),
//               _buildAlertCard(
//                 "Behavior: Signs of Anxiety Detected",
//                 "15min ago",
//                 Colors.purple,
//                 Icons.psychology, 
//                 ["View Suggestions"],
//               ),
//               _buildAlertCard(
//                 "Mood Analysis: Signs of happiness",
//                 "15min ago",
//                 const Color(0xFFB07F2E),
//                 Icons.lightbulb,
//                 ["Extend Limit"],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAlertCard(String title, String time, Color color, IconData icon, List<String> actions) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 20.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25.r),
//         border: Border.all(color: color, width: 2.w),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06), 
//             blurRadius: 10, 
//             offset: const Offset(0, 4)
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(15.w),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Icon(icon, color: color, size: 35.sp),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: TextStyle(
//                           fontSize: 14.sp, 
//                           fontWeight: FontWeight.bold, 
//                           color: color,
//                           height: 1.2,
//                         ),
//                       ),
//                       SizedBox(height: 4.h),
//                       Text(
//                         time,
//                         style: TextStyle(color: Colors.redAccent, fontSize: 12.sp, fontWeight: FontWeight.w500),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 10.w),
//                 Icon(icon, color: color, size: 35.sp),
//               ],
//             ),
//           ),
//           const Divider(height: 1, thickness: 1.5),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
//             child: Wrap( // Buttons ke liye wrap use kiya taake overflow na ho
//               alignment: WrapAlignment.center,
//               spacing: 10.w,
//               children: actions.map((btnText) {
//                 return ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: color,
//                     elevation: 3,
//                     shadowColor: color.withOpacity(0.4),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
//                     padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
//                   ),
//                   child: Text(
//                     btnText,
//                     style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.bold),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:convert';

class AlertMonitoringDashboard extends StatefulWidget {
  final int childId;
  final String childName;
  final int childAge;
  const AlertMonitoringDashboard({super.key, required this.childId, required this.childName, required this.childAge });

  @override
  State<AlertMonitoringDashboard> createState() => _AlertMonitoringDashboardState();
}

class _AlertMonitoringDashboardState extends State<AlertMonitoringDashboard> {
  List<dynamic> alerts = [];
  
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchAlerts();
  }

// Function to fetch alerts from backend
  Future<void> fetchAlerts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // int? childId = prefs.getInt("child_id");

      // if (childId == null) {
      //   setState(() {
      //     isLoading = false;
      //     errorMessage = "Child not paired yet";
      //   });
      //   return;
      // }

      final response = await http.get(
        Uri.parse('http://192.168.18.163:8000/fetch-alerts/?child_id=${widget.childId}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          alerts = data['alerts'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Failed to load alerts";
        });
      }
    } catch (e) {
      print("Fetch alerts error: $e");
      setState(() {
        isLoading = false;
        errorMessage = "Error: $e";
      });
    }
  }

  // Time formatting using timeago package
  String formatTime(String createdAt) {
    try {
      final dt = DateTime.parse(createdAt);
      return timeago.format(dt);
    } catch (e) {
      return "";
    }
  }

  // Color mapping based on alert_type + source
  Color getAlertColor(String type, String source) {
    switch (type.toLowerCase()) {
      case 'bullying':
      case 'hate':
      case 'block':
        return Colors.red;
      case 'suicide':
      case 'escalate':
        return Colors.purple;
      case 'alert':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Icon mapping based on alert_type + source 
  IconData getAlertIcon(String type, String source) {
    if (source == 'chat') {
      switch (type.toLowerCase()) {
        case 'bullying':
          return Icons.security;
        case 'hate':
          return Icons.report;
        case 'suicide':
          return Icons.psychology;
      }
    } else if (source == 'app') {
      switch (type.toLowerCase()) {
        case 'block':
          return Icons.phone_disabled;
        case 'escalate':
          return Icons.warning_amber_rounded;
        case 'alert':
          return Icons.apps;
      }
    } else if (source == 'web') {
      switch (type.toLowerCase()) {
        case 'block':
          return Icons.link_off;
        case 'escalate':
          return Icons.warning_amber_rounded;
        case 'alert':
          return Icons.language;
      }
    }
    return Icons.error;
  }

  //  Action buttons based on alert_type + source 
  List<String> getActionButtons(String type, String source) {
    switch (type.toLowerCase()) {
      case 'block':
        return source == 'app' ? ["Unlock Device"] : ["Unblock Site"];
      case 'escalate':
      case 'suicide':
        return ["View Suggestions", "Lock Screen"];
      case 'bullying':
      case 'hate':
        return ["Block"];
      case 'alert':
        return ["View Details"];
      default:
        return [];
    }
  }

  //   label for alert_type + source 
  String getAlertTitle(String type, String source) {
    switch (source) {
      case 'chat':
        switch (type.toLowerCase()) {
          case 'bullying':
            return "Bullying Detected in Chat";
          case 'hate':
            return "Hate Speech Detected in Chat";
          case 'suicide':
            return "Concerning Message Detected";
        }
        break;
      case 'app':
        switch (type.toLowerCase()) {
          case 'block':
            return "App Blocked";
          case 'escalate':
            return "Urgent: App Activity Escalated";
          case 'alert':
            return "App Activity Alert";
        }
        break;
      case 'web':
        switch (type.toLowerCase()) {
          case 'block':
            return "Website Blocked";
          case 'escalate':
            return "Urgent: Browsing Activity Escalated";
          case 'alert':
            return "Browsing Activity Alert";
        }
        break;
    }
    return "Alert";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Alert Monitoring Dashboard",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        actions: [
          IconButton(
            onPressed: fetchAlerts,
            icon: Icon(Icons.refresh, color: Colors.black, size: 24.sp),
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFEB9974)))
          : RefreshIndicator(
              onRefresh: fetchAlerts,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  User Header Section
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40.r,
                            backgroundColor: Colors.green,
                            child: CircleAvatar(
                              radius: 37.r,
                              backgroundImage: const NetworkImage(
                                  'https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png'),
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.childName, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                              Text("${widget.childAge}   Years Old", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 30.h),
                      Text("Alerts", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 15.h),

                      //  Error State 
                      if (errorMessage != null)
                        Padding(
                          padding: EdgeInsets.only(top: 50.h),
                          child: Center(
                            child: Text(errorMessage!,
                                style: TextStyle(color: Colors.red, fontSize: 14.sp)),
                          ),
                        )

                      //  Empty State 
                      else if (alerts.isEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 50.h),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.check_circle, size: 60.sp, color: Colors.green),
                                SizedBox(height: 10.h),
                                Text("No alerts yet",
                                    style: TextStyle(color: Colors.grey, fontSize: 16.sp)),
                              ],
                            ),
                          ),
                        )

                      // Alerts List 
                      else
                        Column(
                          children: alerts.map((alert) {
                            String type = alert['alert_type'] ?? '';
                            String source = alert['source'] ?? 'unknown';
                            return _buildAlertCard(
                              getAlertTitle(type, source),
                              alert['message'] ?? '',
                              formatTime(alert['created_at'] ?? ''),
                              getAlertColor(type, source),
                              getAlertIcon(type, source),
                              getActionButtons(type, source),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildAlertCard(String title, String message, String time, Color color,
      IconData icon, List<String> actions) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: color, width: 2.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 35.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: color,
                                height: 1.2,
                              ),
                            ),
                          ),
                          Text(
                            time,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 10.sp, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        message,
                        style: TextStyle(color: Colors.black87, fontSize: 13.sp, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (actions.isNotEmpty) ...[
            const Divider(height: 1, thickness: 1.5),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10.w,
                children: actions.map((btnText) {
                  return ElevatedButton(
                    onPressed: () {
                      _handleAction(btnText);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      elevation: 3,
                      shadowColor: color.withOpacity(0.4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    ),
                    child: Text(
                      btnText,
                      style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  //  Handle action button taps 
  void _handleAction(String action) async {
    switch (action) {
      case "Lock Screen":
        await _lockDevice();
        break;
      case "Unlock Device":
        await _unlockDevice();
        break;
      default:
        // "Block Source", "Unblock Site", "View Suggestions", "View Details"
        // no backend endpoint yet, placeholder only
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$action — coming soon")),
        );
    }
  }

  Future<void> _lockDevice() async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // int? childId = prefs.getInt("child_id");
      // if (childId == null) return;

      final response = await http.post(
        Uri.parse("http://192.168.18.163:8000/lock-device/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"child_id": widget.childId}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Device locked successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to lock device")),
        );
      }
    } catch (e) {
      print("Lock error: $e");
    }
  }

  Future<void> _unlockDevice() async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // int? childId = prefs.getInt("child_id");
      // if (childId == null) return;

      final response = await http.post(
        Uri.parse("http://192.168.18.163:8000/unlock-device/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"child_id": widget.childId}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Device unlocked successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to unlock device")),
        );
      }
    } catch (e) {
      print("Unlock error: $e");
    }
  }
}