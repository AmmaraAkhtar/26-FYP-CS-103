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

class AppUsageMonitoringScreen extends StatefulWidget {
  final int childId;
  final String childName;
  final int childAge;

  const AppUsageMonitoringScreen({
    super.key,
    required this.childId,
    required this.childName,
    required this.childAge,
  });

  @override
  State<AppUsageMonitoringScreen> createState() =>
      _AppUsageMonitoringScreenState();
}

class _AppUsageMonitoringScreenState extends State<AppUsageMonitoringScreen> {
  List<Map<String, dynamic>> usageData = [];
  bool isLoading = true;
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Social Media', 'Entertainment', 'Gaming', 'Chatting', 'Browsing'];

  @override
  void initState() {
    super.initState();
    fetchUsageData();
  }

  // Package name se readable app name — dynamic
  String getAppName(String packageName) {
    // Known app names map
    const knownApps = {
      'com.whatsapp': 'WhatsApp',
      'com.instagram.android': 'Instagram',
      'com.facebook.katana': 'Facebook',
      'com.google.android.youtube': 'YouTube',
      'com.spotify.music': 'Spotify',
      'com.netflix.mediaclient': 'Netflix',
      'com.google.android.gm': 'Gmail',
      'com.android.chrome': 'Chrome',
      'com.tiktok.android': 'TikTok',
      'com.snapchat.android': 'Snapchat',
      'com.twitter.android': 'Twitter',
      'com.fingersoft.hillclimb2': 'Hill Climb 2',
      'com.roblox.client': 'Roblox',
      'com.pubg.imobile': 'PUBG',
      'org.telegram.messenger': 'Telegram',
    };

    if (knownApps.containsKey(packageName)) return knownApps[packageName]!;

    List<String> parts = packageName.split('.');
    String last = parts.last;
    if (last == 'android' || last == 'app' || last == 'mobile') {
      last = parts.length >= 2 ? parts[parts.length - 2] : last;
    }
    // camelCase ko spaces mein todna
    final spaced = last.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (m) => '${m[1]} ${m[2]}',
    );
    return spaced[0].toUpperCase() + spaced.substring(1);
  }

  // Backend category ko normalize karo, fallback local detection
  String resolveCategory(Map<String, dynamic> app) {
  final String pkg = (app['package_name'] ?? '').toLowerCase();

  // Explicit package overrides — ML model galat category de raha hai inhe
  if (pkg.contains('youtube')) return 'Entertainment';
  if (pkg.contains('netflix')) return 'Entertainment';
  if (pkg.contains('spotify')) return 'Entertainment';
  if (pkg.contains('whatsapp')) return 'Chatting';
  if (pkg.contains('telegram')) return 'Chatting';
  if (pkg.contains('instagram')) return 'Social Media';
  if (pkg.contains('facebook')) return 'Social Media';
  if (pkg.contains('tiktok')) return 'Social Media';
  if (pkg.contains('snapchat')) return 'Social Media';
  if (pkg.contains('twitter')) return 'Social Media';
  if (pkg.contains('roblox')) return 'Gaming';
  if (pkg.contains('pubg')) return 'Gaming';

  final backendCat = app['category']?.toString() ?? '';

  if (backendCat.isNotEmpty &&
      backendCat != 'Pending' &&
      backendCat != 'Unknown') {
    return _normalizeCategoryName(backendCat);
  }

  return _localCategory(pkg);
}

  // ML model ke category names ko UI names pe map karo
  String _normalizeCategoryName(String cat) {
    const mapping = {
      'Social': 'Social Media',
      'social': 'Social Media',
      'Games': 'Gaming',
      'games': 'Gaming',
      'game': 'Gaming',
      'Entertainment': 'Entertainment',
      'entertainment': 'Entertainment',
      'Sensitive': 'Sensitive',
      'sensitive': 'Sensitive',
      'Education': 'Education',
      'education': 'Education',
      'Tools': 'Tools',
      'tools': 'Tools',
    };
    return mapping[cat] ?? cat;
  }

  String _localCategory(String packageName) {
    if (packageName.contains('whatsapp') ||
        packageName.contains('telegram') ||
        packageName.contains('messenger') ||
        packageName.contains('signal')) return 'Chatting';
    if (packageName.contains('instagram') ||
        packageName.contains('facebook') ||
        packageName.contains('tiktok') ||
        packageName.contains('snapchat') ||
        packageName.contains('twitter')) return 'Social Media';
    if (packageName.contains('youtube') ||
        packageName.contains('netflix') ||
        packageName.contains('spotify')) return 'Entertainment';
    if (packageName.contains('chrome') ||
        packageName.contains('browser') ||
        packageName.contains('firefox')) return 'Browsing';
    if (packageName.contains('game') ||
        packageName.contains('hillclimb') ||
        packageName.contains('roblox') ||
        packageName.contains('pubg') ||
        packageName.contains('fingersoft')) return 'Gaming';
    if (packageName.contains('gmail') || packageName.contains('mail')) return 'Email';
    return 'App';
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Chatting':      return const Color(0xFF4CAF50);
      case 'Social Media':  return const Color(0xFFFF9800);
      case 'Entertainment': return const Color(0xFFF44336);
      case 'Browsing':      return const Color(0xFF2196F3);
      case 'Gaming':        return const Color(0xFF9C27B0);
      case 'Email':         return const Color(0xFF009688);
      case 'Education':     return const Color(0xFF03A9F4);
      case 'Tools':         return const Color(0xFF607D8B);
      case 'Sensitive':     return const Color(0xFFE53935);
      default:              return const Color(0xFFEB9974);
    }
  }

  Color getHeaderBg(String category) {
    switch (category) {
      case 'Chatting':      return const Color(0xFFE8F5E9);
      case 'Social Media':  return const Color(0xFFFFF3E0);
      case 'Entertainment': return const Color(0xFFFFEBEE);
      case 'Browsing':      return const Color(0xFFE3F2FD);
      case 'Gaming':        return const Color(0xFFF3E5F5);
      case 'Email':         return const Color(0xFFE0F2F1);
      case 'Education':     return const Color(0xFFE1F5FE);
      case 'Tools':         return const Color(0xFFECEFF1);
      case 'Sensitive':     return const Color(0xFFFFEBEE);
      default:              return const Color(0xFFFCE4EC);
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Chatting':      return Icons.chat_bubble_rounded;
      case 'Social Media':  return Icons.people_rounded;
      case 'Entertainment': return Icons.play_circle_rounded;
      case 'Browsing':      return Icons.language_rounded;
      case 'Gaming':        return Icons.games_rounded;
      case 'Email':         return Icons.email_rounded;
      case 'Education':     return Icons.school_rounded;
      case 'Tools':         return Icons.build_rounded;
      case 'Sensitive':     return Icons.warning_rounded;
      default:              return Icons.android_rounded;
    }
  }

  String formatTime(int seconds) {
    if (seconds < 60) return "${seconds}s";
    int minutes = seconds ~/ 60;
    if (minutes < 60) return "${minutes}m";
    int hours = minutes ~/ 60;
    int remainingMins = minutes % 60;
    return "${hours}h ${remainingMins}m";
  }

//   Future<void> fetchUsageData() async {
//   setState(() => isLoading = true);
//   try {
//     final response = await http.get(
//       Uri.parse('http://192.168.18.163:8000/get-child-usage/${widget.childId}/'),
//       headers: {"Content-Type": "application/json"},
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       List<dynamic> rawUsage = data['usage_data'];

//       const skipKeywords = [
//         'com.android', 'com.samsung', 'com.sec', 'com.google.android.permissioncontroller', 'com.example'
//       ];

//       const skipPackages = {
//         'cn.wps.moffice_eng',
//         'com.google.android.googlequicksearchbox',
//         'com.samsung.android.incallui',
//         'com.sec.android.gallery3d',
//         'com.samsung.accessibility',
//         'com.android.settings',
//         'com.techlogix.mobilinkcustomer',
//         'com.android.chrome', // agar browser show nahi karna
//       };

//       List<Map<String, dynamic>> filtered = rawUsage
//           .where((app) {
//             String pkg = (app['package_name'] ?? '').toLowerCase();
//             int time = app['usage_time'] as int? ?? 0;

//             if (time <= 0) return false;
//             if (skipPackages.contains(pkg)) return false;
//             for (final kw in skipKeywords) {
//               if (pkg.contains(kw)) return false;
//             }
//             return true;
//           })
//           .map((app) => Map<String, dynamic>.from(app))
//           .toList();

//       filtered.sort((a, b) =>
//           (b['usage_time'] as int).compareTo(a['usage_time'] as int));

//       setState(() {
//         usageData = filtered;
//         isLoading = false;
//       });
//     } else {
//       setState(() => isLoading = false);
//     }
//   } catch (e) {
//     debugPrint("Error: $e");
//     setState(() => isLoading = false);
//   }
// }



Future<void> fetchUsageData() async {
  setState(() => isLoading = true);
  try {
    final response = await http.get(
      Uri.parse('https://the-watcher-backend.onrender.com/get-child-usage/${widget.childId}/'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> rawUsage = data['usage_data'];

      const skipPackages = {
        'cn.wps.moffice_eng',
        'com.google.android.googlequicksearchbox',
        'com.samsung.android.incallui',
        'com.sec.android.gallery3d',
        'com.samsung.accessibility',
        'com.android.settings',
        'com.techlogix.mobilinkcustomer',
      };

      const skipPrefixes = [
        'com.android.',
        'com.samsung.',
        'com.sec.',
        'com.google.android.permissioncontroller',
        'com.example.',
      ];

      List<Map<String, dynamic>> filtered = rawUsage
          .where((app) {
            String pkg = (app['package_name'] ?? '').toLowerCase();
            int time = app['usage_time'] as int? ?? 0;

            if (time <= 0) return false;
            if (skipPackages.contains(pkg)) return false;

            for (final prefix in skipPrefixes) {
              if (pkg.startsWith(prefix)) return false;
            }

            return true;
          })
          .map((app) => Map<String, dynamic>.from(app))
          .toList();

      filtered.sort((a, b) =>
          (b['usage_time'] as int).compareTo(a['usage_time'] as int));

      setState(() {
        usageData = filtered;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  } catch (e) {
    debugPrint("Error: $e");
    setState(() => isLoading = false);
  }
}

      

     

  int get totalSeconds =>
      usageData.fold(0, (sum, app) => sum + (app['usage_time'] as int? ?? 0));

  List<Map<String, dynamic>> get filteredData {
    if (_selectedFilter == 'All') return usageData;
    return usageData.where((app) {
      return resolveCategory(app) == _selectedFilter;
    }).toList();
  }

  // Category wise breakdown for summary
  Map<String, int> get categoryBreakdown {
    final Map<String, int> breakdown = {};
    for (final app in usageData) {
      final cat = resolveCategory(app);
      breakdown[cat] = (breakdown[cat] ?? 0) + (app['usage_time'] as int? ?? 0);
    }
    final sorted = Map.fromEntries(
      breakdown.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "App Usage",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp),
        ),
        actions: [
          IconButton(
            onPressed: fetchUsageData,
            icon:
                const Icon(Icons.refresh_rounded, color: Color(0xFFEB9974)),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(color: Color(0xFFEB9974)))
          : RefreshIndicator(
              color: const Color(0xFFEB9974),
              onRefresh: fetchUsageData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 18.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Profile Row ──
                      _buildProfileRow(),
                      SizedBox(height: 18.h),

                      // ── Total Screen Time Banner ──
                      _buildScreenTimeBanner(),
                      SizedBox(height: 18.h),

                      // ── Category Summary Bar ──
                      if (usageData.isNotEmpty) ...[
                        _buildCategoryBreakdown(),
                        SizedBox(height: 18.h),
                      ],

                      // ── Filter Chips ──
                      _buildFilterChips(),
                      SizedBox(height: 14.h),

                      // ── Section Title ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Time Spent",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          Text(
                            "${filteredData.length} apps",
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // ── App Cards Grid ──
                      filteredData.isEmpty
                          ? _buildEmptyState()
                          : _buildAppGrid(),

                      SizedBox(height: 30.h),

                      // ── Change Limit Button ──
                      Center(
                        child: SizedBox(
                          width: 280.w,
                          height: 50.h,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.timer_outlined,
                                color: Colors.white, size: 20.r),
                            label: Text(
                              'Change Screen Limit',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEB9974),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.r),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // ── Profile Row Widget ──
  Widget _buildProfileRow() {
    return Row(
      children: [
        CircleAvatar(
          radius: 32.r,
          backgroundColor: const Color(0xFFEB9974),
          child: CircleAvatar(
            radius: 29.r,
            backgroundImage: const NetworkImage(
              'https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png',
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.childName,
                style: TextStyle(
                    fontSize: 16.sp, fontWeight: FontWeight.bold)),
            Text("${widget.childAge} Years Old",
                style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
          ],
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              Icon(Icons.circle, size: 8.r, color: Colors.green),
              SizedBox(width: 4.w),
              Text("Active",
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.green,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        )
      ],
    );
  }

  // ── Screen Time Banner ──
  Widget _buildScreenTimeBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEB9974), Color(0xFFF5CBA7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEB9974).withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Screen Time Today",
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.85))),
                SizedBox(height: 6.h),
                Text(
                  totalSeconds > 0 ? formatTime(totalSeconds) : "No data yet",
                  style: TextStyle(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 4.h),
                Text(
                  "${usageData.length} apps used",
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.75)),
                ),
              ],
            ),
          ),
          Icon(Icons.phone_android_rounded,
              color: Colors.white.withOpacity(0.4), size: 60.r),
        ],
      ),
    );
  }

  // ── Category Breakdown Bar ──
  Widget _buildCategoryBreakdown() {
    final breakdown = categoryBreakdown;
    if (breakdown.isEmpty) return const SizedBox();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Category Breakdown",
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          SizedBox(height: 12.h),
          // Stacked bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              height: 10.h,
              child: Row(
                children: breakdown.entries.map((entry) {
                  double fraction =
                      totalSeconds > 0 ? entry.value / totalSeconds : 0;
                  return Flexible(
                    flex: (fraction * 1000).round(),
                    child: Container(color: getCategoryColor(entry.key)),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Legend
          Wrap(
            spacing: 12.w,
            runSpacing: 8.h,
            children: breakdown.entries.take(5).map((entry) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: getCategoryColor(entry.key),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "${entry.key} · ${formatTime(entry.value)}",
                    style:
                        TextStyle(fontSize: 10.sp, color: Colors.grey[700]),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Filter Chips ──
  Widget _buildFilterChips() {
    return SizedBox(
      height: 34.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFEB9974)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFEB9974)
                      : Colors.grey.shade300,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color:
                              const Color(0xFFEB9974).withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── App Cards Grid ──
  Widget _buildAppGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 0.9,
      ),
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final app = filteredData[index];
        final String pkg = app['package_name'] ?? '';
        final int appSeconds = app['usage_time'] as int? ?? 0;
        final int percentage = totalSeconds > 0
            ? ((appSeconds / totalSeconds) * 100).round()
            : 0;

        final String appName = getAppName(pkg);

        //  Backend ML category use karo, fallback local
        final String category = resolveCategory(app);

        final Color color = getCategoryColor(category);
        final Color headerBg = getHeaderBg(category);
        final IconData icon = getCategoryIcon(category);

        return _buildCard(
          appName: appName,
          time: formatTime(appSeconds),
          category: category,
          color: color,
          headerBg: headerBg,
          icon: icon,
          percentage: percentage,
        );
      },
    );
  }

  // ── Empty State ──
  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.only(top: 40.h, bottom: 20.h),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.phonelink_off_rounded,
                size: 56.sp, color: Colors.grey[300]),
            SizedBox(height: 12.h),
            Text(
              _selectedFilter == 'All'
                  ? "No usage data yet"
                  : "No $_selectedFilter apps used today",
              style: TextStyle(
                  color: Colors.grey[500], fontSize: 14.sp),
            ),
            SizedBox(height: 6.h),
            Text("Pull down to refresh",
                style:
                    TextStyle(color: Colors.grey[400], fontSize: 11.sp)),
          ],
        ),
      ),
    );
  }

  // ── Single App Card ──
  Widget _buildCard({
    required String appName,
    required String time,
    required String category,
    required Color color,
    required Color headerBg,
    required IconData icon,
    required int percentage,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, size: 16.w, color: color),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    appName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12.sp),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            color: Colors.black87),
                      ),
                    ],
                  ),

                  // Progress
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("$percentage%",
                              style: TextStyle(
                                  color: color,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold)),
                          Text("of total",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 10.sp)),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey[100],
                          color: color,
                          minHeight: 5.h,
                        ),
                      ),
                    ],
                  ),

                  // Category pill
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                          color: color.withOpacity(0.3), width: 1),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                          color: color,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}