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

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'dart:convert';

// class AlertMonitoringDashboard extends StatefulWidget {
//   final int childId;
//   final String childName;
//   final int childAge;
//   const AlertMonitoringDashboard({super.key, required this.childId, required this.childName, required this.childAge });

//   @override
//   State<AlertMonitoringDashboard> createState() => _AlertMonitoringDashboardState();
// }

// class _AlertMonitoringDashboardState extends State<AlertMonitoringDashboard> {
//   List<dynamic> alerts = [];
  
//   bool isLoading = true;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     fetchAlerts();
//   }

// // Function to fetch alerts from backend
//   Future<void> fetchAlerts() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     try {
//       // SharedPreferences prefs = await SharedPreferences.getInstance();
//       // int? childId = prefs.getInt("child_id");

//       // if (childId == null) {
//       //   setState(() {
//       //     isLoading = false;
//       //     errorMessage = "Child not paired yet";
//       //   });
//       //   return;
//       // }

//       final response = await http.get(
//         Uri.parse('http://192.168.18.163:8000/fetch-alerts/?child_id=${widget.childId}'),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           alerts = data['alerts'] ?? [];
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//           errorMessage = "Failed to load alerts";
//         });
//       }
//     } catch (e) {
//       print("Fetch alerts error: $e");
//       setState(() {
//         isLoading = false;
//         errorMessage = "Error: $e";
//       });
//     }
//   }

//   // Time formatting using timeago package
//   String formatTime(String createdAt) {
//     try {
//       final dt = DateTime.parse(createdAt);
//       return timeago.format(dt);
//     } catch (e) {
//       return "";
//     }
//   }

// // Function to check device status and report to backend (for lock/unlock actions)
//   Future<void> reportDeviceStatus(int childId, String statusType) async {
//   try {
//     await http.post(
//       Uri.parse("http://192.168.18.163:8000/report-device-status/"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"child_id": childId, "status_type": statusType}),
//     );
//   } catch (e) {
//     print("Report device status error: $e");
//   }
// }

//   // Color mapping based on alert_type + source
//   Color getAlertColor(String type, String source) {
//   if (source == 'device') return Colors.redAccent;
//   switch (type.toLowerCase()) {
//     case 'bullying':
//     case 'hate':
//     case 'block':
//       return Colors.red;
//     case 'suicide':
//     case 'escalate':
//       return Colors.purple;
//     case 'alert':
//       return Colors.orange;
//     default:
//       return Colors.grey;
//   }
// }
// //   Icons for alert_type + source 
// IconData getAlertIcon(String type, String source) {
//   if (source == 'device') {
//     switch (type) {
//       case 'accessibility_off':
//         return Icons.accessibility_new;
//       case 'admin_disabled':
//         return Icons.admin_panel_settings;
//     }
//     return Icons.warning;
//   }
//   if (source == 'chat') {
//     switch (type.toLowerCase()) {
//       case 'bullying':
//         return Icons.security;
//       case 'hate':
//         return Icons.report;
//       case 'suicide':
//         return Icons.psychology;
//     }
//   } else if (source == 'app') {
//     switch (type.toLowerCase()) {
//       case 'block':
//         return Icons.phone_disabled;
//       case 'escalate':
//         return Icons.warning_amber_rounded;
//       case 'alert':
//         return Icons.apps;
//     }
//   } else if (source == 'web') {
//     switch (type.toLowerCase()) {
//       case 'block':
//         return Icons.link_off;
//       case 'escalate':
//         return Icons.warning_amber_rounded;
//       case 'alert':
//         return Icons.language;
//     }
//   }
//   return Icons.error;
// }

// //   Action Buttons for alert_type + source 
// // Action buttons — only show "Unblock Device" if this alert locked the device
// List<String> getActionButtons(String type, String source) {
//   String t = type.toLowerCase();
//   if (t == 'block' || t == 'escalate' || (source == 'chat' && t == 'suicide')) {
//     return ["Unblock Device"];
//   }
//   return [];
// }

// //   label for alert_type + source 
// String getAlertTitle(String type, String source) {
//   if (source == 'device') {
//     switch (type) {
//       case 'accessibility_off':
//         return "Accessibility Permission Off";
//       case 'admin_disabled':
//         return "Device Monitoring Disabled";
//     }
//     return "Device Status Alert";
//   }
//   switch (source) {
//     case 'chat':
//       switch (type.toLowerCase()) {
//         case 'bullying':
//           return "Bullying Detected in Chat";
//         case 'hate':
//           return "Hate Speech Detected in Chat";
//         case 'suicide':
//           return "Concerning Message Detected";
//       }
//       break;
//     case 'app':
//       switch (type.toLowerCase()) {
//         case 'block':
//           return "App Blocked";
//         case 'escalate':
//           return "Urgent: App Activity Escalated";
//         case 'alert':
//           return "App Activity Alert";
//       }
//       break;
//     case 'web':
//       switch (type.toLowerCase()) {
//         case 'block':
//           return "Website Blocked";
//         case 'escalate':
//           return "Urgent: Browsing Activity Escalated";
//         case 'alert':
//           return "Browsing Activity Alert";
//       }
//       break;
//   }
//   return "Alert";
// }
  
 

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFBFBFC),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFBFBFC),
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         surfaceTintColor: Colors.transparent,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Alert Monitoring Dashboard",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
//         ),
//         actions: [
//           IconButton(
//             onPressed: fetchAlerts,
//             icon: Icon(Icons.refresh, color: Colors.black, size: 24.sp),
//           ),
//           SizedBox(width: 10.w),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator(color: Color(0xFFEB9974)))
//           : RefreshIndicator(
//               onRefresh: fetchAlerts,
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       //  User Header Section
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 40.r,
//                             backgroundColor: Colors.green,
//                             child: CircleAvatar(
//                               radius: 37.r,
//                               backgroundImage: const NetworkImage(
//                                   'https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png'),
//                             ),
//                           ),
//                           SizedBox(width: 15.w),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(widget.childName, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//                               Text("${widget.childAge}   Years Old", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
//                             ],
//                           )
//                         ],
//                       ),
//                       SizedBox(height: 30.h),
//                       Text("Alerts", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//                       SizedBox(height: 15.h),

//                       //  Error State 
//                       if (errorMessage != null)
//                         Padding(
//                           padding: EdgeInsets.only(top: 50.h),
//                           child: Center(
//                             child: Text(errorMessage!,
//                                 style: TextStyle(color: Colors.red, fontSize: 14.sp)),
//                           ),
//                         )

//                       //  Empty State 
//                       else if (alerts.isEmpty)
//                         Padding(
//                           padding: EdgeInsets.only(top: 50.h),
//                           child: Center(
//                             child: Column(
//                               children: [
//                                 Icon(Icons.check_circle, size: 60.sp, color: Colors.green),
//                                 SizedBox(height: 10.h),
//                                 Text("No alerts yet",
//                                     style: TextStyle(color: Colors.grey, fontSize: 16.sp)),
//                               ],
//                             ),
//                           ),
//                         )

//                       // Alerts List 
//                       else
//                         Column(
//                           children: alerts.map((alert) {
//                             String type = alert['alert_type'] ?? '';
//                             String source = alert['source'] ?? 'unknown';
//                             return _buildAlertCard(
//                               getAlertTitle(type, source),
//                               alert['message'] ?? '',
//                               formatTime(alert['created_at'] ?? ''),
//                               getAlertColor(type, source),
//                               getAlertIcon(type, source),
//                               getActionButtons(type, source),
//                             );
//                           }).toList(),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildAlertCard(String title, String message, String time, Color color,
//       IconData icon, List<String> actions) {
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
//             offset: const Offset(0, 4),
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
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               title,
//                               style: TextStyle(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: color,
//                                 height: 1.2,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             time,
//                             style: TextStyle(
//                                 color: Colors.grey[600], fontSize: 10.sp, fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 6.h),
//                       Text(
//                         message,
//                         style: TextStyle(color: Colors.black87, fontSize: 13.sp, height: 1.3),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (actions.isNotEmpty) ...[
//             const Divider(height: 1, thickness: 1.5),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 spacing: 10.w,
//                 children: actions.map((btnText) {
//                   return ElevatedButton(
//                     onPressed: () {
//                       _handleAction(btnText);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: color,
//                       elevation: 3,
//                       shadowColor: color.withOpacity(0.4),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
//                       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
//                     ),
//                     child: Text(
//                       btnText,
//                       style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.bold),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   //  Handle action button taps 
//   void _handleAction(String action) async {
//   switch (action) {
//     case "Unblock Device":
//       await _unlockDevice();
//       break;
//     default:
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("$action — coming soon")),
//       );
//   }
// }

// void _showInstructionsDialog() {
//   showDialog(
//     context: context,
//     builder: (ctx) => AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       title: const Text("Re-enable Permission"),
//       content: const Text(
//         "Ask your child to go to Settings > Accessibility (or Device Admin Apps) "
//         "and re-enable the monitoring app's permission so tracking continues to work.",
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(ctx),
//           child: const Text("OK"),
//         ),
//       ],
//     ),
//   );
// }
//   // Future<void> _lockDevice() async {
//   //   try {
//   //     // SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     // int? childId = prefs.getInt("child_id");
//   //     // if (childId == null) return;

//   //     final response = await http.post(
//   //       Uri.parse("http://192.168.18.163:8000/lock-device/"),
//   //       headers: {"Content-Type": "application/json"},
//   //       body: jsonEncode({"child_id": widget.childId}),
//   //     );

//   //     if (response.statusCode == 200) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         const SnackBar(content: Text("Device locked successfully")),
//   //       );
//   //     } else {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         const SnackBar(content: Text("Failed to lock device")),
//   //       );
//   //     }
//   //   } catch (e) {
//   //     print("Lock error: $e");
//   //   }
//   // }

// //   Future<void> _unlockDevice() async {
// //     try {
// //       // SharedPreferences prefs = await SharedPreferences.getInstance();
// //       // int? childId = prefs.getInt("child_id");
// //       // if (childId == null) return;

// //       final response = await http.post(
// //         Uri.parse("http://192.168.18.163:8000/unlock-device/"),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({"child_id": widget.childId}),
// //       );

// //       if (response.statusCode == 200) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("Device unlocked successfully")),
// //         );
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("Failed to unlock device")),
// //         );
// //       }
// //     } catch (e) {
// //       print("Unlock error: $e");
// //     }
// //   }
// // }

// Future<void> _unlockDevice() async {
//   try {
//     final response = await http.post(
//       Uri.parse("http://192.168.18.163:8000/unlock-device/"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"child_id": widget.childId}),
//     );

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Device unlocked successfully")),
//       );
//       fetchAlerts(); // refresh list after unlock
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to unlock device")),
//       );
//     }
//   } catch (e) {
//     print("Unlock error: $e");
//   }
// }







// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:timeago/timeago.dart' as timeago;
// import 'dart:convert';

// class AlertMonitoringDashboard extends StatefulWidget {
//   final int childId;
//   final String childName;
//   final int childAge;
//   const AlertMonitoringDashboard({
//     super.key,
//     required this.childId,
//     required this.childName,
//     required this.childAge,
//   });

//   @override
//   State<AlertMonitoringDashboard> createState() => _AlertMonitoringDashboardState();
// }

// class _AlertMonitoringDashboardState extends State<AlertMonitoringDashboard> {
//   List<dynamic> alerts = [];
//   bool isLoading = true;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     fetchAlerts();
//   }

//   // Fetch alerts from backend
//   Future<void> fetchAlerts() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     try {
//       final response = await http.get(
//         Uri.parse('http://192.168.18.163:8000/fetch-alerts/?child_id=${widget.childId}'),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           alerts = data['alerts'] ?? [];
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//           errorMessage = "Failed to load alerts";
//         });
//       }
//     } catch (e) {
//       print("Fetch alerts error: $e");
//       setState(() {
//         isLoading = false;
//         errorMessage = "Error: $e";
//       });
//     }
//   }

//   // Time formatting using timeago package
//   String formatTime(String createdAt) {
//     try {
//       final dt = DateTime.parse(createdAt);
//       return timeago.format(dt);
//     } catch (e) {
//       return "";
//     }
//   }

//   // Color mapping based on alert_type + source
//   Color getAlertColor(String type, String source) {
//     if (source == 'device') return Colors.blueGrey;
//     switch (type.toLowerCase()) {
//       case 'bullying':
//       case 'hate':
//       case 'block':
//         return Colors.red;
//       case 'suicide':
//       case 'escalate':
//         return Colors.purple;
//       case 'alert':
//         return Colors.orange;
//       default:
//         return Colors.grey;
//     }
//   }

//   // Icon mapping based on alert_type + source
//   IconData getAlertIcon(String type, String source) {
//     if (source == 'device') {
//       switch (type) {
//         case 'accessibility_off':
//           return Icons.accessibility_new;
//         case 'admin_disabled':
//           return Icons.admin_panel_settings;
//       }
//       return Icons.warning;
//     }
//     if (source == 'chat') {
//       switch (type.toLowerCase()) {
//         case 'bullying':
//           return Icons.security;
//         case 'hate':
//           return Icons.report;
//         case 'suicide':
//           return Icons.psychology;
//       }
//     } else if (source == 'app') {
//       switch (type.toLowerCase()) {
//         case 'block':
//           return Icons.phone_disabled;
//         case 'escalate':
//           return Icons.warning_amber_rounded;
//         case 'alert':
//           return Icons.apps;
//       }
//     } else if (source == 'web') {
//       switch (type.toLowerCase()) {
//         case 'block':
//           return Icons.link_off;
//         case 'escalate':
//           return Icons.warning_amber_rounded;
//         case 'alert':
//           return Icons.language;
//       }
//     }
//     return Icons.error;
//   }

//   // Action buttons based on alert_type + source
//   List<String> getActionButtons(String type, String source) {
//     if (source == 'device') {
//       return ["View Instructions"];
//     }
//     String t = type.toLowerCase();
//     if (t == 'block' || t == 'escalate' || (source == 'chat' && t == 'suicide')) {
//       return ["Unblock Device"];
//     }
//     return [];
//   }

//   // Title for alert_type + source
//   String getAlertTitle(String type, String source) {
//     if (source == 'device') {
//       switch (type) {
//         case 'accessibility_off':
//           return "Accessibility Permission Off";
//         case 'admin_disabled':
//           return "Device Monitoring Disabled";
//       }
//       return "Device Status Alert";
//     }
//     switch (source) {
//       case 'chat':
//         switch (type.toLowerCase()) {
//           case 'bullying':
//             return "Bullying Detected in Chat";
//           case 'hate':
//             return "Hate Speech Detected in Chat";
//           case 'suicide':
//             return "Concerning Message Detected";
//         }
//         break;
//       case 'app':
//         switch (type.toLowerCase()) {
//           case 'block':
//             return "App Blocked — Device Locked";
//           case 'escalate':
//             return "Urgent: App Activity Escalated";
//           case 'alert':
//             return "App Activity Alert";
//         }
//         break;
//       case 'web':
//         switch (type.toLowerCase()) {
//           case 'block':
//             return "Website Blocked — Device Locked";
//           case 'escalate':
//             return "Urgent: Browsing Activity Escalated";
//           case 'alert':
//             return "Browsing Activity Alert";
//         }
//         break;
//     }
//     return "Alert";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFBFBFC),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFBFBFC),
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         surfaceTintColor: Colors.transparent,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Alert Monitoring Dashboard",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
//         ),
//         actions: [
//           IconButton(
//             onPressed: fetchAlerts,
//             icon: Icon(Icons.refresh, color: Colors.black, size: 24.sp),
//           ),
//           SizedBox(width: 10.w),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator(color: Color(0xFFEB9974)))
//           : RefreshIndicator(
//               onRefresh: fetchAlerts,
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // User Header Section
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 40.r,
//                             backgroundColor: Colors.green,
//                             child: CircleAvatar(
//                               radius: 37.r,
//                               backgroundImage: const NetworkImage(
//                                   'https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png'),
//                             ),
//                           ),
//                           SizedBox(width: 15.w),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(widget.childName, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//                               Text("${widget.childAge} Years Old", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
//                             ],
//                           )
//                         ],
//                       ),
//                       SizedBox(height: 30.h),
//                       Text("Alerts", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//                       SizedBox(height: 15.h),

//                       // Error State
//                       if (errorMessage != null)
//                         Padding(
//                           padding: EdgeInsets.only(top: 50.h),
//                           child: Center(
//                             child: Text(errorMessage!,
//                                 style: TextStyle(color: Colors.red, fontSize: 14.sp)),
//                           ),
//                         )

//                       // Empty State
//                       else if (alerts.isEmpty)
//                         Padding(
//                           padding: EdgeInsets.only(top: 50.h),
//                           child: Center(
//                             child: Column(
//                               children: [
//                                 Icon(Icons.check_circle, size: 60.sp, color: Colors.green),
//                                 SizedBox(height: 10.h),
//                                 Text("No alerts yet",
//                                     style: TextStyle(color: Colors.grey, fontSize: 16.sp)),
//                               ],
//                             ),
//                           ),
//                         )

//                       // Alerts List
//                       else
//                         Column(
//                           children: alerts.map((alert) {
//                             String type = alert['alert_type'] ?? '';
//                             String source = alert['source'] ?? 'unknown';
//                             return _buildAlertCard(
//                               getAlertTitle(type, source),
//                               alert['message'] ?? '',
//                               formatTime(alert['created_at'] ?? ''),
//                               getAlertColor(type, source),
//                               getAlertIcon(type, source),
//                               getActionButtons(type, source),
//                               type,
//                             );
//                           }).toList(),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildAlertCard(String title, String message, String time, Color color,
//       IconData icon, List<String> actions, String alertType) {
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
//             offset: const Offset(0, 4),
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
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               title,
//                               style: TextStyle(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: color,
//                                 height: 1.2,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             time,
//                             style: TextStyle(
//                                 color: Colors.grey[600], fontSize: 10.sp, fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 6.h),
//                       Text(
//                         message,
//                         style: TextStyle(color: Colors.black87, fontSize: 13.sp, height: 1.3),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (actions.isNotEmpty) ...[
//             const Divider(height: 1, thickness: 1.5),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 spacing: 10.w,
//                 children: actions.map((btnText) {
//                   return ElevatedButton(
//                     onPressed: () {
//                       _handleAction(btnText, alertType);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: color,
//                       elevation: 3,
//                       shadowColor: color.withOpacity(0.4),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
//                       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
//                     ),
//                     child: Text(
//                       btnText,
//                       style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.bold),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   // Handle action button taps
//   void _handleAction(String action, String type) async {
//     switch (action) {
//       case "Unblock Device":
//         await _unlockDevice();
//         break;
//       case "View Instructions":
//         _showInstructionsDialog(type);
//         break;
//       default:
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("$action — coming soon")),
//         );
//     }
//   }

//   Future<void> _unlockDevice() async {
//     try {
//       final response = await http.post(
//         Uri.parse("http://192.168.18.163:8000/unlock-device/"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"child_id": widget.childId}),
//       );

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Device unlocked successfully")),
//         );
//         fetchAlerts();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to unlock device")),
//         );
//       }
//     } catch (e) {
//       print("Unlock error: $e");
//     }
//   }

//   // Instructions dialog for device-status alerts
//   void _showInstructionsDialog(String type) {
//     String content;
//     switch (type) {
//       case 'accessibility_off':
//         content = "Accessibility permission has been turned off on your child's device.\n\n"
//             "To fix:\n"
//             "1. Open Settings on the child's device\n"
//             "2. Go to Accessibility\n"
//             "3. Find this app and turn the permission back ON\n\n"
//             "Without this, app and web monitoring may stop working.";
//         break;
//       case 'admin_disabled':
//         content = "Device admin / monitoring has been disabled on your child's device.\n\n"
//             "To fix:\n"
//             "1. Open Settings on the child's device\n"
//             "2. Go to Apps > Special access > Device admin apps\n"
//             "3. Re-enable this app as device admin\n\n"
//             "Without this, lock/unlock controls won't work.";
//         break;
//       default:
//         content = "A monitoring permission was disabled on your child's device. "
//             "Please check device settings to re-enable it.";
//     }

//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text("Re-enable Permission"),
//         content: Text(content),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'dart:convert';

class AlertMonitoringDashboard extends StatefulWidget {
  final int childId;
  final String childName;
  final int childAge;
  const AlertMonitoringDashboard({
    super.key,
    required this.childId,
    required this.childName,
    required this.childAge,
  });

  @override
  State<AlertMonitoringDashboard> createState() =>
      _AlertMonitoringDashboardState();
}

class _AlertMonitoringDashboardState extends State<AlertMonitoringDashboard> {
  List<dynamic> alerts = [];
  bool isLoading = true;
  String? errorMessage;
  bool _isDeviceLocked = true;

  static const kGreen = Color(0xFF699886);
  static const kOrange = Color(0xFFEB9974);

  @override
  void initState() {
    super.initState();
    fetchAlerts();
    _fetchLockStatus();
  }

  Future<void> _fetchLockStatus() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.18.163:8000/check-lock-status/?child_id=${widget.childId}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() => _isDeviceLocked = data['is_locked'] ?? true);
        }
      }
    } catch (e) {
      print("Lock status error: $e");
    }
  }

  Future<void> fetchAlerts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.18.163:8000/fetch-alerts/?child_id=${widget.childId}'),
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
      setState(() {
        isLoading = false;
        errorMessage = "Error: $e";
      });
    }
  }

  String formatTime(String createdAt) {
    try {
      final dt = DateTime.parse(createdAt);
      return timeago.format(dt);
    } catch (e) {
      return "";
    }
  }

  Color getAlertColor(String type, String source) {
    if (source == 'device') {
      if (type == 'accessibility_off') return Colors.orange;
      if (type == 'admin_disabled') return Colors.red;
      return Colors.blueGrey;
    }
    if (source == 'chat') {
      switch (type.toLowerCase()) {
        case 'bullying':
          return Colors.red;
        case 'hate':
          return Colors.red;
        case 'suicide':
          return Colors.purple;
        case 'warn':
        case 'alert':
          return Colors.orange;
        default:
          return Colors.orange;
      }
    }
    switch (type.toLowerCase()) {
      case 'bullying':
      case 'hate':
      case 'block':
        return Colors.red;
      case 'suicide':
      case 'escalate':
        return Colors.purple;
      case 'warn':
      case 'alert':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData getAlertIcon(String type, String source) {
    if (source == 'device') {
      switch (type) {
        case 'accessibility_off':
          return Icons.accessibility_new;
        case 'admin_disabled':
          return Icons.admin_panel_settings;
      }
      return Icons.warning;
    }
    if (source == 'chat') {
      switch (type.toLowerCase()) {
        case 'bullying':
          return Icons.security;
        case 'hate':
          return Icons.report;
        case 'suicide':
          return Icons.psychology;
        default:
          return Icons.chat_bubble_outline;
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

  List<String> getActionButtons(String type, String source) {
    if (source == 'device') {
      return ["Unblock Device", "View Instructions"];
    }
    String t = type.toLowerCase();
    if (t == 'block' ||
        t == 'escalate' ||
        (source == 'chat' && t == 'suicide')) {
      return ["Unblock Device"];
    }
    return [];
  }

  String getAlertTitle(String type, String source) {
    if (source == 'device') {
      switch (type) {
        case 'accessibility_off':
          return "Accessibility Permission Off";
        case 'admin_disabled':
          return "Device Monitoring Disabled";
      }
      return "Device Status Alert";
    }
    switch (source) {
      case 'chat':
        switch (type.toLowerCase()) {
          case 'bullying':
            return "Bullying Detected in Chat";
          case 'hate':
            return "Hate Speech Detected in Chat";
          case 'suicide':
            return "Concerning Message Detected";
          default:
            return "Suspicious Chat Detected";
        }
      case 'app':
        switch (type.toLowerCase()) {
          case 'block':
            return "App Blocked — Device Locked";
          case 'escalate':
            return "Urgent: App Activity Escalated";
          case 'alert':
            return "App Activity Alert";
        }
        break;
      case 'web':
        switch (type.toLowerCase()) {
          case 'block':
            return "Website Blocked — Device Locked";
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
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Alert Dashboard",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17.sp),
        ),
        actions: [
          IconButton(
            onPressed: () {
              fetchAlerts();
              _fetchLockStatus();
            },
            icon: Icon(Icons.refresh, color: Colors.black, size: 22.sp),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: kGreen))
          : RefreshIndicator(
              color: kGreen,
              onRefresh: () async {
                await fetchAlerts();
                await _fetchLockStatus();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Section
                      Row(children: [
                        Container(
                          width: 62.r,
                          height: 62.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient:
                                LinearGradient(colors: [kGreen, kOrange]),
                          ),
                          padding: EdgeInsets.all(2.5.r),
                          child: const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png'),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.childName,
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold)),
                            Text("${widget.childAge} Years Old",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.sp)),
                          ],
                        ),
                      ]),
                      SizedBox(height: 20.h),

                      // Device status indicator
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: _isDeviceLocked
                              ? Colors.red.shade50
                              : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: _isDeviceLocked
                                ? Colors.red.shade200
                                : Colors.green.shade200,
                          ),
                        ),
                        child: Row(children: [
                          Icon(
                            _isDeviceLocked ? Icons.lock : Icons.lock_open,
                            color: _isDeviceLocked ? Colors.red : kGreen,
                            size: 18.r,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            _isDeviceLocked
                                ? "Device is currently LOCKED"
                                : "Device is Unlocked",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color:
                                  _isDeviceLocked ? Colors.red : kGreen,
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(height: 16.h),

                      // Summary chips
                      if (alerts.isNotEmpty) _buildSummaryRow(),
                      SizedBox(height: 16.h),

                      // Section title
                      Text("All Alerts",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.h),

                      // Error
                      if (errorMessage != null)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40.h),
                            child: Column(children: [
                              Icon(Icons.wifi_off,
                                  size: 48.sp, color: Colors.grey),
                              SizedBox(height: 10.h),
                              Text(errorMessage!,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 13.sp)),
                            ]),
                          ),
                        )

                      // Empty
                      else if (alerts.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 60.h),
                            child: Column(children: [
                              Container(
                                width: 72.r,
                                height: 72.r,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8FADC),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.check_circle,
                                    size: 40.sp, color: kGreen),
                              ),
                              SizedBox(height: 14.h),
                              Text("All clear!",
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4.h),
                              Text("No alerts for ${widget.childName}",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13.sp)),
                            ]),
                          ),
                        )

                      // Alerts list
                      else
                        Column(
                          children: alerts.map((alert) {
                            final type = alert['alert_type'] ?? '';
                            final source = alert['source'] ?? 'unknown';
                            return _buildAlertCard(
                              title: getAlertTitle(type, source),
                              message: alert['message'] ?? '',
                              time: formatTime(alert['created_at'] ?? ''),
                              color: getAlertColor(type, source),
                              icon: getAlertIcon(type, source),
                              actions: getActionButtons(type, source),
                              alertType: type,
                              source: source,
                            );
                          }).toList(),
                        ),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryRow() {
    final total = alerts.length;
    final critical = alerts
        .where((a) => ['block', 'escalate', 'suicide', 'bullying', 'hate']
            .contains((a['alert_type'] ?? '').toLowerCase()))
        .length;
    final device =
        alerts.where((a) => (a['source'] ?? '') == 'device').length;

    return Row(children: [
      _chip("$total Total", Colors.grey.shade700, Colors.grey.shade100),
      SizedBox(width: 8.w),
      if (critical > 0)
        _chip(
            "$critical Critical", Colors.red.shade700, Colors.red.shade50),
      SizedBox(width: 8.w),
      if (device > 0)
        _chip("$device Device", Colors.orange.shade700,
            Colors.orange.shade50),
    ]);
  }

  Widget _chip(String label, Color textColor, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: textColor)),
    );
  }

  Widget _buildAlertCard({
    required String title,
    required String message,
    required String time,
    required Color color,
    required IconData icon,
    required List<String> actions,
    required String alertType,
    required String source,
  }) {
    final bgColor = color.withOpacity(0.05);

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.4), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header strip
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Row(
              children: [
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20.r),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: color,
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    source.toUpperCase(),
                    style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                        color: color),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                      color: Colors.black87, fontSize: 12.sp, height: 1.4),
                ),
                SizedBox(height: 8.h),
                Row(children: [
                  Icon(Icons.access_time, size: 11.r, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Text(time,
                      style:
                          TextStyle(color: Colors.grey, fontSize: 10.sp)),
                ]),
              ],
            ),
          ),

          // Action buttons
          if (actions.isNotEmpty) ...[
            Divider(
                height: 1,
                thickness: 1,
                color: color.withOpacity(0.15)),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.h, horizontal: 12.w),
              child: Row(
                children: actions.map((btnText) {
                  final isUnlock = btnText == "Unblock Device";
                  final isDisabled = isUnlock && !_isDeviceLocked;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: SizedBox(
                        height: 36.h,
                        child: ElevatedButton(
                          onPressed: isDisabled
                              ? null
                              : () => _handleAction(
                                  btnText, alertType, source),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDisabled
                                ? Colors.grey.shade300
                                : isUnlock
                                    ? color
                                    : Colors.white,
                            foregroundColor: isDisabled
                                ? Colors.grey
                                : isUnlock
                                    ? Colors.white
                                    : color,
                            elevation:
                                isDisabled ? 0 : (isUnlock ? 2 : 0),
                            side: (isUnlock || isDisabled)
                                ? BorderSide.none
                                : BorderSide(color: color, width: 1.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            isDisabled ? "Already Unlocked" : btnText,
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
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

  void _handleAction(String action, String type, String source) async {
    switch (action) {
      case "Unblock Device":
        await _unlockDevice();
        break;
      case "View Instructions":
        _showInstructionsDialog(type);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$action — coming soon")),
        );
    }
  }

  Future<void> _unlockDevice() async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.18.163:8000/unlock-device/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"child_id": widget.childId}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Device unlocked successfully"),
            backgroundColor: kGreen,
          ),
        );
        await fetchAlerts();
        await _fetchLockStatus();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to unlock device"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Unlock error: $e");
    }
  }

  void _showInstructionsDialog(String type) {
    String title;
    String content;

    switch (type) {
      case 'accessibility_off':
        title = "Re-enable Accessibility";
        content = "Accessibility permission band ho gayi hai.\n\n"
            "Fix karne ke liye:\n"
            "1. Child ke device mein Settings kholo\n"
            "2. Accessibility > Downloaded apps mein jao\n"
            "3. Is app ko ON karo\n\n"
            "Iske baghair app aur web monitoring kaam nahi karegi.";
        break;
      case 'admin_disabled':
        title = "Re-enable Device Admin";
        content = "Device admin/monitoring disable ho gaya hai.\n\n"
            "Fix karne ke liye:\n"
            "1. Child ke device mein Settings kholo\n"
            "2. Apps > Special access > Device admin apps mein jao\n"
            "3. Is app ko phir se enable karo\n\n"
            "Iske baghair lock/unlock control kaam nahi karega.";
        break;
      default:
        title = "Re-enable Permission";
        content = "Ek monitoring permission disable ho gayi hai.\n"
            "Device settings mein ja kar ise re-enable karo.";
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(title,
            style: const TextStyle(
                color: kGreen, fontWeight: FontWeight.bold)),
        content: Text(content, style: const TextStyle(height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                const Text("OK", style: TextStyle(color: kGreen)),
          ),
        ],
      ),
    );
  }
}