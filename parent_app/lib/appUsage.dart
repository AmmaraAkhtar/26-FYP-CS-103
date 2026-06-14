// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class AppUsageMonitoringScreen extends StatelessWidget {
//   const AppUsageMonitoringScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFBFBFC),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFBFBFC),
//         scrolledUnderElevation: 0,
//         surfaceTintColor: Colors.transparent,
//         elevation: 0,
//         leading: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
//         title: Text(
//           "App Usage Monitoring",
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
//             children: [
//               // --- User Header Section ---
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 35.r,
//                     backgroundColor: Colors.green,
//                     child: CircleAvatar(
//                       radius: 32.r,
//                       backgroundImage: const NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png'),
//                     ),
//                   ),
//                   SizedBox(width: 15.w),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Hamza Ali", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
//                       Text("11 Years Old", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
//                     ],
//                   )
//                 ],
//               ),
//               SizedBox(height: 30.h),
//               Text("Time Spent", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
//               SizedBox(height: 20.h),

//               // --- App Usage Section (Wrap for Dynamic Heights) ---
//               Wrap(
//                 spacing: 15.w, 
//                 runSpacing: 15.h, 
//                 children: [
//                   // Logo Path aur Colors image ke mutabiq
//                   _buildUsageCard("Whatsapp", "Spent 14 min", "Chatting", Colors.green, const Color(0xFFE8F5E9), "assets/whatsapp.png"),
//                   _buildUsageCard("Instagram", "Spent 1 hour", "Entertainment", Colors.orange, const Color(0xFFFFF3E0), "assets/insta.png"),
//                   _buildUsageCard("Roblox", "Played 35 min", "Gaming", Colors.red, const Color(0xFFFFEBEE), "assets/roblox.png"),
//                   _buildUsageCard("Facebook", "Spent 24 min", "Entertainment", Colors.blue, const Color(0xFFE3F2FD), "assets/facebook.png"),
//                 ],
//               ),

//               SizedBox(height: 40.h),

//               // --- Change Screen Limit Button ---
//               SizedBox(
//                 width: 285.w,
//                 height: 50.h,
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFEB9974),
//                     elevation: 5,
//                     shadowColor: const Color(0xFFEB9974).withOpacity(0.5),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(40.r),
//                     ),
//                   ),
//                   child: Text(
//                     'Change Screen Limit',
//                     style: TextStyle(
//                       fontSize: 18.sp, 
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20.h), // Bottom space
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- Card Builder with App Logo ---
//   Widget _buildUsageCard(String title, String time, String tag, Color accentColor, Color headerBg, String logoPath) {
//     double cardWidth = (ScreenUtil().screenWidth - 55.w) / 2; 

//     return Container(
//       width: cardWidth,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08), 
//             blurRadius: 10, 
//             offset: const Offset(0, 4)
//           )
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min, 
//         children: [
//           // Header: Logo + Name
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
//             decoration: BoxDecoration(
//               color: headerBg,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(15.r), 
//                 topRight: Radius.circular(15.r)
//               ),
//             ),
//             child: Row(
//               children: [
//                 // App Logo from Assets
//                 Image.asset(
//                   logoPath,
//                   width: 20.w,
//                   height: 20.w,
//                   fit: BoxFit.contain,
//                     ),
//                 SizedBox(width: 8.w),
//                 Expanded(
//                   child: Text(
//                     title, 
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)
//                   )
//                 ),
//               ],
//             ),
//           ),
          
//           // Body: Usage Stats & Tag
//           Padding(
//             padding: EdgeInsets.all(12.w),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("26%", style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
//                     Text(time, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11.sp)),
//                   ],
//                 ),
//                 SizedBox(height: 8.h),
//                 const Divider(height: 1, thickness: 1.5),
//                 SizedBox(height: 12.h),
                
//                 // Tag Button (Chatting, Gaming, etc.)
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
//                   decoration: BoxDecoration(
//                     color: accentColor,
//                     borderRadius: BorderRadius.circular(20.r),
//                     boxShadow: [
//                       BoxShadow(
//                         color: accentColor.withOpacity(0.3), 
//                         blurRadius: 4, 
//                         offset: const Offset(0, 2)
//                       )
//                     ]
//                   ),
//                   child: Text(
//                     tag, 
//                     style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold)
//                   ),
//                 ),
//               ],
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
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppUsageMonitoringScreen extends StatefulWidget {
  const AppUsageMonitoringScreen({super.key});

  @override
  State<AppUsageMonitoringScreen> createState() => _AppUsageMonitoringScreenState();
}

class _AppUsageMonitoringScreenState extends State<AppUsageMonitoringScreen> {
  List<Map<String, dynamic>> usageData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsageData();
  }

  // Package name se readable app name nikalo - fully dynamic
  String getAppName(String packageName) {
    // com.whatsapp → WhatsApp
    // com.instagram.android → Instagram
    // com.sec.android.app.launcher → Launcher
    List<String> parts = packageName.split('.');
    
    // Last meaningful part lo
    String last = parts.last;
    
    // Common suffixes hata do
    if (last == 'android' || last == 'app' || last == 'mobile') {
      last = parts.length >= 2 ? parts[parts.length - 2] : last;
    }
    
    // Capitalize karo
    return last[0].toUpperCase() + last.substring(1);
  }

  // Package name se category detect karo - dynamic
  String getCategory(String packageName) {
    if (packageName.contains('whatsapp') || 
        packageName.contains('telegram') ||
        packageName.contains('messenger') ||
        packageName.contains('signal')) {
      return 'Chatting';
    } else if (packageName.contains('instagram') || 
               packageName.contains('facebook') ||
               packageName.contains('tiktok') ||
               packageName.contains('snapchat') ||
               packageName.contains('pinterest') ||
               packageName.contains('twitter')) {
      return 'Social Media';
    } else if (packageName.contains('youtube') || 
               packageName.contains('netflix') ||
               packageName.contains('spotify')) {
      return 'Entertainment';
    } else if (packageName.contains('chrome') || 
               packageName.contains('browser') ||
               packageName.contains('firefox')) {
      return 'Browsing';
    } else if (packageName.contains('game') || 
               packageName.contains('hillclimb') ||
               packageName.contains('roblox') ||
               packageName.contains('pubg') ||
               packageName.contains('fingersoft')) {
      return 'Gaming';
    } else if (packageName.contains('gmail') || 
               packageName.contains('mail')) {
      return 'Email';
    } else if (packageName.contains('launcher') || 
               packageName.contains('calculator') ||
               packageName.contains('dialer') ||
               packageName.contains('android') ||
               packageName.contains('samsung')) {
      return 'System';
    }
    return 'App';
  }

  // Category se color - dynamic
  Color getCategoryColor(String category) {
    switch (category) {
      case 'Chatting': return Colors.green;
      case 'Social Media': return Colors.orange;
      case 'Entertainment': return Colors.red;
      case 'Browsing': return Colors.blue;
      case 'Gaming': return Colors.purple;
      case 'Email': return Colors.teal;
      case 'System': return Colors.grey;
      default: return const Color(0xFFEB9974);
    }
  }

  // Category se background color
  Color getHeaderBg(String category) {
    switch (category) {
      case 'Chatting': return const Color(0xFFE8F5E9);
      case 'Social Media': return const Color(0xFFFFF3E0);
      case 'Entertainment': return const Color(0xFFFFEBEE);
      case 'Browsing': return const Color(0xFFE3F2FD);
      case 'Gaming': return const Color(0xFFF3E5F5);
      case 'Email': return const Color(0xFFE0F2F1);
      case 'System': return const Color(0xFFF5F5F5);
      default: return const Color(0xFFFCE4EC);
    }
  }

  // Category se icon - dynamic
  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Chatting': return Icons.chat_bubble_rounded;
      case 'Social Media': return Icons.people_rounded;
      case 'Entertainment': return Icons.play_circle_rounded;
      case 'Browsing': return Icons.language_rounded;
      case 'Gaming': return Icons.games_rounded;
      case 'Email': return Icons.email_rounded;
      case 'System': return Icons.settings_rounded;
      default: return Icons.android_rounded;
    }
  }

  //  Seconds ko readable format
  String formatTime(int seconds) {
    if (seconds < 60) return "${seconds}s";
    int minutes = seconds ~/ 60;
    if (minutes < 60) return "${minutes}m";
    int hours = minutes ~/ 60;
    int remainingMins = minutes % 60;
    return "${hours}h ${remainingMins}m";
  }

  Future<void> fetchUsageData() async {
    setState(() => isLoading = true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? childId = prefs.getInt("child_id");

      if (childId == null) {
        setState(() => isLoading = false);
        return;
      }

      final response = await http.get(
       Uri.parse('http://192.168.18.163:8000/get-child-usage/$childId/'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> rawUsage = data['usage_data'];

        // System apps filter karo
        List<Map<String, dynamic>> filtered = rawUsage
            .where((app) {
              String pkg = app['package_name'];
              int time = app['usage_time'] as int;
              // System apps aur zero usage hata do
              return time > 0 &&
                  !pkg.contains('android') &&
                  !pkg.contains('samsung') &&
                  !pkg.contains('launcher') &&
                  !pkg.contains('dialer') &&
                  !pkg.contains('calculator') &&
                  !pkg.contains('permissioncontroller') &&
                  !pkg.contains('bixby');
            })
            .map((app) => Map<String, dynamic>.from(app))
            .toList();

        // Usage time se sort karo - highest first
        filtered.sort((a, b) =>
            (b['usage_time'] as int).compareTo(a['usage_time'] as int));

        setState(() {
          usageData = filtered;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  int get totalSeconds =>
      usageData.fold(0, (sum, app) => sum + (app['usage_time'] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFC),
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "App Usage Monitoring",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp),
        ),
        actions: [
          IconButton(
            onPressed: fetchUsageData,
            icon: const Icon(Icons.refresh, color: Colors.black),
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFEB9974)))
          : RefreshIndicator(
              onRefresh: fetchUsageData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    children: [
                      // Profile
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 35.r,
                            backgroundColor: Colors.green,
                            child: CircleAvatar(
                              radius: 32.r,
                              backgroundImage: const NetworkImage(
                                'https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png',
                              ),
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Hamza Ali",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold)),
                              Text("11 Years Old",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.sp)),
                            ],
                          )
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Total Screen Time Banner
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15.w),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEB9974), Color(0xFFF5CBA7)],
                          ),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Column(
                          children: [
                            Text("Total Screen Time Today",
                                style: TextStyle(
                                    fontSize: 14.sp, color: Colors.white)),
                            SizedBox(height: 5.h),
                            Text(
                              formatTime(totalSeconds),
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${usageData.length} apps used",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white70),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),
                      Text("Time Spent",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 15.h),

                      // ✅ 100% Dynamic Cards
                      usageData.isEmpty
                          ? Padding(
                              padding: EdgeInsets.only(top: 50.h),
                              child: Column(
                                children: [
                                  Icon(Icons.phonelink_off,
                                      size: 60.sp, color: Colors.grey),
                                  SizedBox(height: 10.h),
                                  Text("No usage data yet",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.sp)),
                                ],
                              ),
                            )
                          : Wrap(
                              spacing: 15.w,
                              runSpacing: 15.h,
                              children: usageData.map((app) {
                                String pkg = app['package_name'];
                                int appSeconds = app['usage_time'] as int;
                                int percentage = totalSeconds > 0
                                    ? ((appSeconds / totalSeconds) * 100).round()
                                    : 0;

                                // ✅ Sab kuch package name se automatically
                                String appName = getAppName(pkg);
                                String category = getCategory(pkg);
                                Color color = getCategoryColor(category);
                                Color headerBg = getHeaderBg(category);
                                IconData icon = getCategoryIcon(category);

                                return _buildCard(
                                  appName: appName,
                                  time: formatTime(appSeconds),
                                  category: category,
                                  color: color,
                                  headerBg: headerBg,
                                  icon: icon,
                                  percentage: percentage,
                                );
                              }).toList(),
                            ),

                      SizedBox(height: 40.h),

                      SizedBox(
                        width: 285.w,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEB9974),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.r),
                            ),
                          ),
                          child: Text(
                            'Change Screen Limit',
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildCard({
    required String appName,
    required String time,
    required String category,
    required Color color,
    required Color headerBg,
    required IconData icon,
    required int percentage,
  }) {
    double cardWidth = (ScreenUtil().screenWidth - 55.w) / 2;

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header - icon + name
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r),
                topRight: Radius.circular(15.r),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20.w, color: color),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    appName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$percentage%",
                        style:
                            TextStyle(color: Colors.grey, fontSize: 11.sp)),
                    Text(time,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 11.sp)),
                  ],
                ),
                SizedBox(height: 6.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey[200],
                    color: color,
                    minHeight: 5.h,
                  ),
                ),
                SizedBox(height: 8.h),
                const Divider(height: 1, thickness: 1.5),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}