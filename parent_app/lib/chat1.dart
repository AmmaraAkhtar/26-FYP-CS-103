// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ChatMonitoringDashboard extends StatelessWidget {
//   const ChatMonitoringDashboard({super.key});

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
//           "Chat Monitoring Dashboard",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
//         ),
//         actions: [
//           Stack(
//             children: [
//               IconButton(
//                 onPressed: null,
//                 icon: Icon(Icons.notifications_none, color: Colors.black, size: 28.sp),
//               ),
//               Positioned(
//                 right: 8.w,
//                 top: 8.h,
//                 child: Container(
//                   padding: EdgeInsets.all(4.w),
//                   decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
//                   child: Text("1", style: TextStyle(fontSize: 10.sp, color: Colors.white)),
//                 ),
//               )
//             ],
//           ),
//           Icon(Icons.settings_outlined, color: Colors.black, size: 24.sp),
//           SizedBox(width: 15.w),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // --- Profile Section ---
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 45.r,
//                     backgroundColor: Colors.green,
//                     child: CircleAvatar(
//                       radius: 42.r,
//                       backgroundImage: const NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png'),
//                     ),
//                   ),
//                   SizedBox(width: 20.w),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Hamza Ali", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
//                       Text("11 Years Old", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
//                     ],
//                   )
//                 ],
//               ),
//               SizedBox(height: 25.h),

//               // --- Stats Cards Section ---
//               Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 15.h),
//                   child: Row(
//                     children: [
//                       _buildStatItem("Total Messages", "56", "Today"),
//                       _buildVerticalDivider(),
//                       _buildStatItem("Total Messages", "210", "Today"),
//                       _buildVerticalDivider(),
//                       _buildStatItem("Safe Chats", "10", "Last 7 messages"),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 30.h),

//               // --- Flagged Chats Header ---
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("Flagged Chats", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//                   Row(
//                     children: [
//                       Text("View All ", style: TextStyle(color: Colors.green, fontSize: 13.sp)),
//                       Icon(Icons.keyboard_double_arrow_right, color: Colors.green, size: 16.sp),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 15.h),

//               // --- Flagged Chats List (Ab images ke sath) ---
//               _buildChatTile(
//                 "Ammara", 
//                 "Tuhma mana mar dena ha.", 
//                 "10 mins ago", 
//                 "High Risk", 
//                 Colors.red,
//                 'https://cdn-icons-png.flaticon.com/512/4086/4086679.png' // Ammara's Pic
//               ),
//               _buildChatTile(
//                 "Ali raza", 
//                 "Let's play game tonight", 
//                 "30 mins ago", 
//                 "Moderate", 
//                 Colors.orange,
//                 'https://cdn-icons-png.flaticon.com/512/6833/6833605.png' // Ali's Pic
//               ),
//               _buildChatTile(
//                 "Sara", 
//                 "Shared a photo", 
//                 "50 mins ago", 
//                 "Media", 
//                 Colors.lightBlue,
//                 'https://cdn-icons-png.flaticon.com/512/6997/6997662.png' // Sara's Pic
//               ),

//               SizedBox(height: 30.h),

//               // --- Safety Alerts Header ---
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("Safety Alerts", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//                   Row(
//                     children: [
//                       Text("See All ", style: TextStyle(color: Colors.redAccent, fontSize: 14.sp)),
//                       Icon(Icons.keyboard_double_arrow_right, color: Colors.redAccent, size: 16.sp),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 15.h),

//               _buildAlertTile("Ammara"),
//               _buildAlertTile("Unknown Contact"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Stats Item Helper
//   Widget _buildStatItem(String label, String value, String subLabel) {
//     return Expanded(
//       child: Column(
//         children: [
//           Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10.sp, color: Colors.black54)),
//           SizedBox(height: 5.h),
//           Text(value, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
//           SizedBox(height: 5.h),
//           Text(subLabel, textAlign: TextAlign.center, style: TextStyle(fontSize: 9.sp, color: Colors.grey)),
//         ],
//       ),
//     );
//   }

//   // Vertical Divider Helper
//   Widget _buildVerticalDivider() {
//     return Container(height: 40.h, width: 1.w, color: Colors.grey[200]);
//   }

//   // --- UPDATED Chat Tile Helper with Image ---
//   Widget _buildChatTile(String name, String msg, String time, String status, Color statusColor, String imageUrl) {
//     return Card(
//       elevation: 1,
//       margin: EdgeInsets.only(bottom: 12.h),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
//       child: ListTile(
//         contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
//         leading: CircleAvatar(
//           radius: 25.r,
//           backgroundColor: Colors.grey[200],
//           // Yahan pic lag rahi hai
//           backgroundImage: NetworkImage(imageUrl), 
//           // Error handling agar image load na ho
//           onBackgroundImageError: (exception, stackTrace) => const Icon(Icons.person),
//         ),
//         title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
//         subtitle: Text(msg, style: TextStyle(fontSize: 11.sp, color: Colors.grey[600], overflow: TextOverflow.ellipsis)),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text("$time >", style: TextStyle(fontSize: 9.sp, color: Colors.black)),
//             SizedBox(height: 5.h),
//             Container(
//               width: 75.w,
//               alignment: Alignment.center,
//               padding: EdgeInsets.symmetric(vertical: 4.h),
//               decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12.r)),
//               child: Text(status, style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Alert Tile Helper
//   Widget _buildAlertTile(String contact) {
//     return Card(
//       elevation: 1,
//       margin: EdgeInsets.only(bottom: 12.h),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
//       child: ListTile(
//         contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
//         leading: Icon(Icons.error, color: Colors.red, size: 35.sp),
//         title: Text("Violence Message Detected", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
//         subtitle: Text(contact, style: TextStyle(color: Colors.redAccent, fontSize: 12.sp)),
//         trailing: Text("10:30 AM >", style: TextStyle(fontSize: 9.sp, color: Colors.grey)),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

const String kChatBaseUrl = "http://192.168.18.163:8000";

// Models 

class FlaggedChat {
  final int id;
  final String appName;
  final String sender;
  final String message;
  final String category;
  final String risk;
  final String action;
  final String time;

  FlaggedChat({
    required this.id,
    required this.appName,
    required this.sender,
    required this.message,
    required this.category,
    required this.risk,
    required this.action,
    required this.time,
  });

  factory FlaggedChat.fromJson(Map<String, dynamic> j) {
    return FlaggedChat(
      id: j['id'] ?? 0,
      appName: j['app_name'] ?? '',
      sender: j['sender'] ?? 'Unknown',
      message: j['message'] ?? '',
      category: j['category'] ?? 'unknown',
      risk: j['risk'] ?? 'Low',
      action: j['action'] ?? 'Allow',
      time: _formatTime(j['time']),
    );
  }

  static String _formatTime(dynamic raw) {
    if (raw == null) return '';
    try {
      final dt = DateTime.parse(raw.toString()).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
      if (diff.inHours < 24) return "${diff.inHours}h ago";
      return "${diff.inDays}d ago";
    } catch (_) {
      return '';
    }
  }
}

class ChatAlert {
  final String alertType;
  final String message;
  final String time;

  ChatAlert({required this.alertType, required this.message, required this.time});

  factory ChatAlert.fromJson(Map<String, dynamic> j) {
    return ChatAlert(
      alertType: j['alert_type'] ?? '',
      message: j['message'] ?? '',
      time: FlaggedChat._formatTime(j['created_at']),
    );
  }
}

// Screen 

class ChatMonitoringDashboard extends StatefulWidget {
  final int childId;
  final String childName;
  final int childAge;

  const ChatMonitoringDashboard({
    super.key,
    required this.childId,
    required this.childName,
    required this.childAge,
  });

  @override
  State<ChatMonitoringDashboard> createState() => _ChatMonitoringDashboardState();
}

class _ChatMonitoringDashboardState extends State<ChatMonitoringDashboard> {
  static const Color primaryOrange = Color(0xFFEB9974);
  static const Color primaryGreen = Color(0xFF699886);

  bool _isLoading = true;
  int _totalToday = 0;
  int _totalAll = 0;
  int _safeCount = 0;
  List<FlaggedChat> _flaggedChats = [];
  List<ChatAlert> _alerts = [];

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) => _fetchData());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('$kChatBaseUrl/fetch-chat-messages/?child_id=${widget.childId}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("STATUS: ${response.statusCode}");
        debugPrint("BODY: ${response.body}");
        setState(() {
          _totalToday = data['stats']['total_today'] ?? 0;
          _totalAll = data['stats']['total_all'] ?? 0;
          _safeCount = data['stats']['safe_count'] ?? 0;
          _flaggedChats = (data['flagged_chats'] as List)
              .map((e) => FlaggedChat.fromJson(e))
              .toList();
          _alerts = (data['safety_alerts'] as List)
              .map((e) => ChatAlert.fromJson(e))
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Chat fetch error: $e");
      setState(() => _isLoading = false);
    }
  }

  //  Risk color
  Color _riskColor(String category) {
    switch (category.toLowerCase()) {
      case 'suicide':
        return Colors.red.shade700;
      case 'hate':
      case 'bullying':
        return Colors.orange.shade700;
      default:
        return Colors.blue.shade600;
    }
  }

  String _riskLabel(String category) {
    switch (category.toLowerCase()) {
      case 'suicide':
        return 'Crisis';
      case 'hate':
        return 'Hate';
      case 'bullying':
        return 'Bullying';
      default:
        return category;
    }
  }

  //  App icon 
  IconData _appIcon(String appName) {
    switch (appName.toLowerCase()) {
      case 'whatsapp':
        return Icons.chat_bubble_outline;
      case 'instagram':
        return Icons.camera_alt_outlined;
      case 'telegram':
        return Icons.send_outlined;
      case 'snapchat':
        return Icons.filter_outlined;
      case 'messenger':
        return Icons.message_outlined;
      case 'youtube':
        return Icons.play_circle_outline;
      case 'tiktok':
        return Icons.music_video_outlined;
      default:
        return Icons.smartphone_outlined;
    }
  }

  Color _appColor(String appName) {
    switch (appName.toLowerCase()) {
      case 'whatsapp':
        return const Color(0xFF25D366);
      case 'instagram':
        return const Color(0xFFE1306C);
      case 'telegram':
        return const Color(0xFF0088CC);
      case 'snapchat':
        return const Color(0xFFFFFC00);
      case 'messenger':
        return const Color(0xFF0084FF);
      case 'youtube':
        return Colors.red;
      case 'tiktok':
        return Colors.black87;
      default:
        return primaryOrange;
    }
  }

  // BUILD 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFC),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Chat Monitoring",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _fetchData,
            icon: Icon(Icons.refresh, color: Colors.black, size: 24.sp),
          ),
          Icon(Icons.settings_outlined, color: Colors.black, size: 24.sp),
          SizedBox(width: 15.w),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryOrange))
          : RefreshIndicator(
              color: primaryOrange,
              onRefresh: _fetchData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  Profile 
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 38.r,
                          backgroundColor: primaryOrange.withOpacity(0.2),
                          child: CircleAvatar(
                            radius: 35.r,
                            backgroundImage: const NetworkImage(
                              'https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png',
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.childName,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${widget.childAge} years old",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    //  Stats Row 
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Row(
                        children: [
                          _statItem("Today", _totalToday.toString(), "Messages"),
                          _vDivider(),
                          _statItem("Total", _totalAll.toString(), "All time"),
                          _vDivider(),
                          _statItem("Safe", _safeCount.toString(), "Allowed"),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    //  Flagged Chats 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Flagged chats",
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${_flaggedChats.length} detected",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    if (_flaggedChats.isEmpty)
                      _emptyState(
                        icon: Icons.chat_bubble_outline,
                        message: "No flagged chats — all clear!",
                      )
                    else
                      ..._flaggedChats.map((chat) => _chatTile(chat)),

                    SizedBox(height: 24.h),

                    // Safety Alerts 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Safety alerts",
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${_alerts.length} alerts",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    if (_alerts.isEmpty)
                      _emptyState(
                        icon: Icons.shield_outlined,
                        message: "No safety alerts yet",
                      )
                    else
                      ..._alerts.map((alert) => _alertTile(alert)),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
    );
  }

  // ── Widget Helpers ──────────────────────────────────────────────────────────

  Widget _statItem(String label, String value, String sub) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            sub,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _vDivider() {
    return Container(
      height: 40.h,
      width: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _chatTile(FlaggedChat chat) {
    final color = _riskColor(chat.category);
    final appColor = _appColor(chat.appName);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App icon circle
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: appColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _appIcon(chat.appName),
              color: appColor,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      chat.appName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      chat.time,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  chat.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        _riskLabel(chat.category),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        chat.action,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _alertTile(ChatAlert alert) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.red.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: Colors.red.shade600,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      alert.alertType,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                        color: Colors.red.shade700,
                      ),
                    ),
                    Text(
                      alert.time,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  alert.message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState({required IconData icon, required String message}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, size: 36.sp, color: Colors.grey.shade300),
          SizedBox(height: 10.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
