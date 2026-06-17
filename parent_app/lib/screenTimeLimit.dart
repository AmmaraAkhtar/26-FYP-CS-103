// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ScreenTimeLimitScreen extends StatelessWidget {
//   const ScreenTimeLimitScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFBFBFC),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         scrolledUnderElevation: 0,
//         surfaceTintColor: Colors.transparent,
//         elevation: 0,
//         leading: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
//         title: Text("Screen Time Limit", 
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp)),
//         actions: [
//           Icon(Icons.notifications_none, color: Colors.black, size: 28.sp),
//           SizedBox(width: 10.w),
//           Icon(Icons.settings_outlined, color: Colors.black, size: 24.sp),
//           SizedBox(width: 15.w),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // --- Profile Section ---
//             Row(
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


//             SizedBox(height: 25.h),
//             Text("Daily Screen Time", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20.h),

//             // --- Graph and Side Cards ---
//             Row(
//               children: [
//                 Expanded(flex: 5, child: Image.asset("assets/dailyLimit.png", fit: BoxFit.contain)),
//                 SizedBox(width: 15.w),
//                 Expanded(
//                   flex: 5,
//                   child: Column(
//                     children: [
//                       _buildSimpleCard("Daily Limit", "2h 30m", Icons.add_circle_outline),
//                       SizedBox(height: 10.h),
//                       _buildSimpleCard("Bedtime Block", "9:00 PM - 7:00 AM", Icons.toggle_on),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 30.h),

//             // --- App Category Section ---
//             Container(
//               padding: EdgeInsets.all(16.w),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20.r),
//                 boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
//               ),
//               child: Column(
//                 children: [
//                   _categoryWithCircle("Social", "30 min", 0.4, Colors.pink),
//                   SizedBox(height: 20.h),
//                   _categoryWithCircle("Entertainment", "1 hour", 0.8, Colors.orange),
//                   SizedBox(height: 20.h),
//                   _categoryWithCircle("Gaming", "45 min", 0.6, Colors.green),
//                 ],
//               ),
//             ),

//             SizedBox(height: 40.h),

//             // --- Apply Button ---
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFEB9974),
//                   minimumSize: Size(280.w, 50.h),
//                   shape: const StadiumBorder(),
//                   elevation: 5,
//                 ),
//                 child: Text("Apply Limits", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
//               ),
//             ),
//             SizedBox(height: 20.h),
//           ],),
//       ),
//     );
//   }

//   // --- Naya Simple function circles ke liye ---
//   Widget _categoryWithCircle(String title, String time, double progress, Color col) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
//             Text(time, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp)),
//           ],
//         ),
//         SizedBox(height: 12.h),
//         // LayoutBuilder use kiya hai taake humein line ki width pata chale
//         LayoutBuilder(
//           builder: (context, constraints) {
//             return Stack(
//               alignment: Alignment.centerLeft,
//               clipBehavior: Clip.none, // Taake circle line se bahar cut na ho
//               children: [
//                 // 1. Background halki line
//                 Container(
//                   height: 6.h,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: col.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                 ),
//                 // 2. Colorful progress line
//                 Container(
//                   height: 6.h,
//                   width: constraints.maxWidth * progress,
//                   decoration: BoxDecoration(
//                     color: col,
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                 ),
//                 // 3. Gol Circle (Thumb)
//                 Positioned(
//                   left: (constraints.maxWidth * progress) - 8.w, // Center karne ke liye
//                   child: Container(
//                     height: 16.h,
//                     width: 16.h,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                       border: Border.all(color: col, width: 3),
//                       boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildSimpleCard(String title, String sub, IconData icon) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15.r),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
//           Text(sub, style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
//           const Divider(),
//           Align(alignment: Alignment.centerRight, child: Icon(icon, color: Colors.orange)),
//         ],
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

const String kBaseUrl = "https://the-watcher-backend.onrender.com";

class ScreenTimeLimitScreen extends StatefulWidget {
  final int childId;
  final String childName;
  final int childAge;

  const ScreenTimeLimitScreen({
    super.key,
    required this.childId,
    required this.childName,
    required this.childAge,
  });

  @override
  State<ScreenTimeLimitScreen> createState() => _ScreenTimeLimitScreenState();
}

class _ScreenTimeLimitScreenState extends State<ScreenTimeLimitScreen> {
  bool _isLoading = true;
  bool _isSaving = false;

  int _screenTimeLimitMinutes = 150;
  int _totalUsageSeconds = 0;

  Map<String, int> _categoryUsageSeconds = {
    "Social Media":  0,
    "Entertainment": 0,
    "Gaming":        0,
  };

  TimeOfDay _bedtimeStart = const TimeOfDay(hour: 21, minute: 0);
  TimeOfDay _bedtimeEnd   = const TimeOfDay(hour: 7,  minute: 0);
  bool _bedtimeEnabled = true;

  static const Color primaryOrange = Color(0xFFEB9974);
  static const Color bgColor       = Color(0xFFFBFBFC);

  @override
  void initState() {
    super.initState();
    _fetchLimits();
  }

  String _normalizeCat(String raw) {
    const map = {
      'Social':        'Social Media',
      'Games':         'Gaming',
      'Entertainment': 'Entertainment',
      'Education':     'Education',
      'Tools':         'Tools',
      'Sensitive':     'Sensitive',
      'Social Media':  'Social Media',
      'Gaming':        'Gaming',
    };
    return map[raw] ?? raw;
  }

  Future<void> _fetchLimits() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('$kBaseUrl/get-screen-limits/?child_id=${widget.childId}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final catUsage = Map<String, dynamic>.from(
          data['category_usage_seconds'] ?? {},
        );

        final Map<String, int> normalized = {};
        catUsage.forEach((key, value) {
          final flutterKey = _normalizeCat(key);
          normalized[flutterKey] =
              (normalized[flutterKey] ?? 0) + (value as int? ?? 0);
        });

        setState(() {
          _screenTimeLimitMinutes = data['screen_time_limit'] ?? 150;
          _totalUsageSeconds      = data['total_usage_seconds'] ?? 0;
          _bedtimeEnabled         = data['bedtime_enabled'] ?? true;

          _categoryUsageSeconds = {
            "Social Media":  normalized['Social Media']  ?? 0,
            "Entertainment": normalized['Entertainment'] ?? 0,
            "Gaming":        normalized['Gaming']        ?? 0,
          };

          if (data['bedtime_start'] != null) {
            _bedtimeStart = _parseTime(data['bedtime_start']);
          }
          if (data['bedtime_end'] != null) {
            _bedtimeEnd = _parseTime(data['bedtime_end']);
          }
        });
      } else {
        _showSnack(
          "Failed to load limits (${response.statusCode})",
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Error fetching limits: $e");
      _showSnack("Network error. Check your server URL.", isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _applyLimits() async {
    setState(() => _isSaving = true);
    try {
      final response = await http.post(
        Uri.parse('$kBaseUrl/update-screen-limits/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "child_id":          widget.childId,
          "screen_time_limit": _screenTimeLimitMinutes,
          "bedtime_start":     _formatTimeOfDay(_bedtimeStart),
          "bedtime_end":       _formatTimeOfDay(_bedtimeEnd),
          "bedtime_enabled":   _bedtimeEnabled,
        }),
      );

      if (response.statusCode == 200) {
        final data     = jsonDecode(response.body);
        final isLocked = data['is_locked'] ?? false;
        final reason   = data['reason']    ?? '';

        String msg;
        if (reason == 'bedtime') {
          msg = "Limits updated. Device locked — bedtime active.";
        } else if (reason == 'screen_limit') {
          msg = "Limits updated. Device locked — usage limit reached.";
        } else if (reason == 'grace_period') {
          msg = "Limits updated. Grace period active — device stays unlocked.";
        } else if (isLocked) {
          msg = "Limits updated. Device is locked.";
        } else {
          msg = "Limits updated. Device unlocked ✓";
        }

        _showSnack(msg, isError: isLocked);
        await _fetchLimits();
      } else if (response.statusCode == 400) {
    final data = jsonDecode(response.body);
    _showSnack(data['error'] ?? "Invalid input", isError: true);
  }else {
        _showSnack(
          "Failed to update limits (${response.statusCode})",
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Error updating limits: $e");
      _showSnack("Network error. Check your server URL.", isError: true);
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _lockDevice() async {
    try {
      final res = await http.post(
        Uri.parse('$kBaseUrl/lock-device/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"child_id": widget.childId}),
      );
      _showSnack(
        res.statusCode == 200 ? "Device locked successfully" : "Lock failed",
        isError: res.statusCode != 200,
      );
    } catch (e) {
      _showSnack("Network error.", isError: true);
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTimeOfDay(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return "$h:$m:00";
  }

  String _formatTimeDisplay(TimeOfDay t) {
    final hour   = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  String _formatDailyLimitDisplay() {
    final h = _screenTimeLimitMinutes ~/ 60;
    final m = _screenTimeLimitMinutes % 60;
    if (h == 0) return "${m}m";
    if (m == 0) return "${h}h";
    return "${h}h ${m}m";
  }

  String _formatUsageTime(int seconds) {
    final mins = (seconds / 60).round();
    if (mins < 60) return "${mins}m";
    final h = mins ~/ 60;
    final m = mins % 60;
    return m == 0 ? "${h}h" : "${h}h ${m}m";
  }

  double _categoryProgress(int seconds) {
    if (_screenTimeLimitMinutes <= 0) return 0.0;
    return ((seconds / 60) / _screenTimeLimitMinutes).clamp(0.0, 1.0);
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            isError ? Colors.redAccent : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  Future<void> _pickBedtime({required bool isStart}) async {
    final initial = isStart ? _bedtimeStart : _bedtimeEnd;
    final picked  = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: isStart ? "Select bedtime start" : "Select bedtime end",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary:   primaryOrange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _bedtimeStart = picked;
        } else {
          _bedtimeEnd = picked;
        }
      });
    }
  }

  Future<void> _showEditLimitDialog() async {
    int hours   = _screenTimeLimitMinutes ~/ 60;
    int minutes = _screenTimeLimitMinutes % 60;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Set daily screen limit",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: _pickerColumn(
                          label: "Hours",
                          value: hours,
                          max: 12,
                          onChanged: (v) => setModalState(() => hours = v),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _pickerColumn(
                          label: "Minutes",
                          value: minutes,
                          max: 59,
                          step: 5,
                          onChanged: (v) =>
                              setModalState(() => minutes = v),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _screenTimeLimitMinutes = (hours * 60) + minutes;
                          if (_screenTimeLimitMinutes < 5) {
                            _screenTimeLimitMinutes = 5;
                          }
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrange,
                        minimumSize: Size(double.infinity, 50.h),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── BUILD ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final overallProgress = _screenTimeLimitMinutes > 0
        ? (_totalUsageSeconds / 60) / _screenTimeLimitMinutes
        : 0.0;
    final clampedProgress = overallProgress.clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Screen time limit",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          Icon(Icons.notifications_none, color: Colors.black, size: 28.sp),
          SizedBox(width: 10.w),
          Icon(Icons.settings_outlined, color: Colors.black, size: 24.sp),
          SizedBox(width: 15.w),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: primaryOrange),
            )
          : RefreshIndicator(
              color: primaryOrange,
              onRefresh: _fetchLimits,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Profile ──
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 35.r,
                          backgroundColor: primaryOrange.withOpacity(0.25),
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
                            Text(
                              widget.childName,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${widget.childAge} years old",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 25.h),
                    Text(
                      "Daily screen time",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // ── Ring + Side Cards ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                            onTap: _showEditLimitDialog,
                            child: _DailyLimitRing(
                              progress:   clampedProgress,
                              usedLabel:  _formatUsageTime(_totalUsageSeconds),
                              limitLabel: _formatDailyLimitDisplay(),
                              color:      primaryOrange,
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              _buildEditableCard(
                                "Daily limit",
                                _formatDailyLimitDisplay(),
                                Icons.add_circle_outline,
                                onTap: _showEditLimitDialog,
                              ),
                              SizedBox(height: 10.h),
                              _buildBedtimeCard(),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30.h),

                    // ── App Category Usage ──
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "App category usage",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "today",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 18.h),
                          _categoryWithCircle(
                            "Social Media",
                            _formatUsageTime(
                              _categoryUsageSeconds["Social Media"] ?? 0,
                            ),
                            _categoryProgress(
                              _categoryUsageSeconds["Social Media"] ?? 0,
                            ),
                            const Color(0xFFE85D8C),
                          ),
                          SizedBox(height: 20.h),
                          _categoryWithCircle(
                            "Entertainment",
                            _formatUsageTime(
                              _categoryUsageSeconds["Entertainment"] ?? 0,
                            ),
                            _categoryProgress(
                              _categoryUsageSeconds["Entertainment"] ?? 0,
                            ),
                            const Color(0xFFF5A623),
                          ),
                          SizedBox(height: 20.h),
                          _categoryWithCircle(
                            "Gaming",
                            _formatUsageTime(
                              _categoryUsageSeconds["Gaming"] ?? 0,
                            ),
                            _categoryProgress(
                              _categoryUsageSeconds["Gaming"] ?? 0,
                            ),
                            const Color(0xFF4CAF82),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ── Quick Stats Row ──
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            label:      "Used today",
                            value:      _formatUsageTime(_totalUsageSeconds),
                            valueColor: primaryOrange,
                            badge:      _buildUsageBadge(),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _statCard(
                            label:      "Daily limit",
                            value:      _formatDailyLimitDisplay(),
                            valueColor: Colors.black87,
                            badge: Container(
                              margin: EdgeInsets.only(top: 6.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 11.sp,
                                    color: Colors.green.shade700,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    "Active",
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // ── Controls Card ──
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          // Bedtime toggle row
                          _controlRow(
                            iconData:  Icons.bedtime_outlined,
                            iconColor: primaryOrange,
                            iconBg:    primaryOrange.withOpacity(0.12),
                            title:     "Bedtime block",
                            subtitle:  _bedtimeEnabled
                                ? "${_formatTimeDisplay(_bedtimeStart)} – ${_formatTimeDisplay(_bedtimeEnd)}"
                                : "Disabled",
                            trailing: Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value:       _bedtimeEnabled,
                                activeColor: primaryOrange,
                                onChanged:   (v) =>
                                    setState(() => _bedtimeEnabled = v),
                              ),
                            ),
                            showDivider: true,
                          ),

                          // Bedtime START row
                          _controlRow(
                            iconData:  Icons.nights_stay_outlined,
                            iconColor: const Color(0xFF7E57C2),
                            iconBg:    const Color(0xFFEDE7F6),
                            title:     "Bedtime starts",
                            subtitle:  _formatTimeDisplay(_bedtimeStart),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: _bedtimeEnabled
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade300,
                              size: 20.sp,
                            ),
                            showDivider: true,
                            onTap: _bedtimeEnabled
                                ? () => _pickBedtime(isStart: true)
                                : null,
                          ),

                          // Bedtime END row
                          _controlRow(
                            iconData:  Icons.wb_sunny_outlined,
                            iconColor: const Color(0xFFF5A623),
                            iconBg:    const Color(0xFFFFF3E0),
                            title:     "Bedtime ends",
                            subtitle:  _formatTimeDisplay(_bedtimeEnd),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: _bedtimeEnabled
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade300,
                              size: 20.sp,
                            ),
                            showDivider: true,
                            onTap: _bedtimeEnabled
                                ? () => _pickBedtime(isStart: false)
                                : null,
                          ),

                          // Lock device row
                          _controlRow(
                            iconData:  Icons.lock_outline,
                            iconColor: const Color(0xFF185FA5),
                            iconBg:    const Color(0xFFE6F1FB),
                            title:     "Lock device now",
                            subtitle:  "Immediately restricts access",
                            trailing: OutlinedButton(
                              onPressed: _lockDevice,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF185FA5),
                                side: const BorderSide(
                                  color: Color(0xFF185FA5),
                                  width: 0.8,
                                ),
                                shape: const StadiumBorder(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 4.h,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                "Lock",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30.h),

                    // ── Apply Button ──
                    Center(
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _applyLimits,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryOrange,
                          minimumSize: Size(280.w, 50.h),
                          shape: const StadiumBorder(),
                          elevation: 5,
                        ),
                        child: _isSaving
                            ? SizedBox(
                                width: 22.w,
                                height: 22.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                "Apply limits",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
    );
  }

  // ── Widget Helpers ────────────────────────────────────────────────────────

  Widget _statCard({
    required String label,
    required String value,
    required Color valueColor,
    required Widget badge,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          badge,
        ],
      ),
    );
  }

  Widget _buildUsageBadge() {
    final usedMins = _totalUsageSeconds / 60;
    final leftMins = _screenTimeLimitMinutes - usedMins;
    final isOver   = leftMins <= 0;
    return Container(
      margin: EdgeInsets.only(top: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isOver ? Colors.red.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        isOver ? "Limit reached" : "${leftMins.round()}m left",
        style: TextStyle(
          fontSize: 11.sp,
          color: isOver ? Colors.red.shade700 : Colors.orange.shade800,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _controlRow({
    required IconData iconData,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required Widget trailing,
    required bool showDivider,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 13.h),
            child: Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(iconData, color: iconColor, size: 18.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: onTap == null && title != "Bedtime block" && title != "Lock device now"
                              ? Colors.grey.shade400
                              : Colors.black87,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: onTap == null && title != "Bedtime block" && title != "Lock device now"
                              ? Colors.grey.shade300
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
        if (showDivider) Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }

  Widget _buildEditableCard(
    String title,
    String sub,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              sub,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(icon, color: primaryOrange, size: 20.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBedtimeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bedtime",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Transform.scale(
                scale: 0.7,
                child: Switch(
                  value:       _bedtimeEnabled,
                  activeColor: primaryOrange,
                  onChanged:   (v) => setState(() => _bedtimeEnabled = v),
                ),
              ),
            ],
          ),

          // Start time
          GestureDetector(
            onTap: _bedtimeEnabled ? () => _pickBedtime(isStart: true) : null,
            child: Row(
              children: [
                Icon(
                  Icons.nights_stay_outlined,
                  size: 12.sp,
                  color: _bedtimeEnabled
                      ? const Color(0xFF7E57C2)
                      : Colors.grey.shade300,
                ),
                SizedBox(width: 4.w),
                Text(
                  _formatTimeDisplay(_bedtimeStart),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: _bedtimeEnabled
                        ? Colors.grey.shade700
                        : Colors.grey.shade400,
                    decoration: _bedtimeEnabled
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // End time
          GestureDetector(
            onTap: _bedtimeEnabled ? () => _pickBedtime(isStart: false) : null,
            child: Row(
              children: [
                Icon(
                  Icons.wb_sunny_outlined,
                  size: 12.sp,
                  color: _bedtimeEnabled
                      ? const Color(0xFFF5A623)
                      : Colors.grey.shade300,
                ),
                SizedBox(width: 4.w),
                Text(
                  _formatTimeDisplay(_bedtimeEnd),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: _bedtimeEnabled
                        ? Colors.grey.shade700
                        : Colors.grey.shade400,
                    decoration: _bedtimeEnabled
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.edit_outlined,
              color: _bedtimeEnabled ? primaryOrange : Colors.grey.shade300,
              size: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryWithCircle(
    String title,
    String time,
    double progress,
    Color col,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
            Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: col,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 6.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: col.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                Container(
                  height: 6.h,
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    color: col,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                Positioned(
                  left: (constraints.maxWidth * progress) - 8.w,
                  child: Container(
                    height: 16.h,
                    width: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: col, width: 3),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _pickerColumn({
    required String label,
    required int value,
    required int max,
    int step = 1,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _circleIconButton(
                icon: Icons.remove,
                onTap: () {
                  int newVal = value - step;
                  if (newVal < 0) newVal = 0;
                  onChanged(newVal);
                },
              ),
              Text(
                "$value",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _circleIconButton(
                icon: Icons.add,
                onTap: () {
                  int newVal = value + step;
                  if (newVal > max) newVal = max;
                  onChanged(newVal);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: primaryOrange.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18.sp, color: primaryOrange),
      ),
    );
  }
}

// ── Custom Painted Ring ───────────────────────────────────────────────────────

class _DailyLimitRing extends StatelessWidget {
  final double progress;
  final String usedLabel;
  final String limitLabel;
  final Color color;

  const _DailyLimitRing({
    required this.progress,
    required this.usedLabel,
    required this.limitLabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: _RingPainter(progress: progress, color: color),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                usedLabel,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "of $limitLabel",
                style: TextStyle(fontSize: 10.sp, color: Colors.grey),
              ),
              SizedBox(height: 2.h),
              Text(
                "Daily limit",
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center      = Offset(size.width / 2, size.height / 2);
    final radius      = (size.width / 2) * 0.85;
    const strokeWidth = 14.0;

    final bgPaint = Paint()
      ..color       = color.withOpacity(0.12)
      ..style       = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap   = StrokeCap.round;

    final fgPaint = Paint()
      ..color       = color
      ..style       = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap   = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    const startAngle = -1.5708;
    final sweepAngle = 6.2832 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}













// jo code phle chl rha tha
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;

// const String kBaseUrl = "http://192.168.18.163:8000";

// class ScreenTimeLimitScreen extends StatefulWidget {
//   final int childId;
//   final String childName;
//   final int childAge;

//   const ScreenTimeLimitScreen({
//     super.key,
//     required this.childId,
//     required this.childName,
//     required this.childAge,
//   });

//   @override
//   State<ScreenTimeLimitScreen> createState() => _ScreenTimeLimitScreenState();
// }

// class _ScreenTimeLimitScreenState extends State<ScreenTimeLimitScreen> {
//   bool _isLoading = true;
//   bool _isSaving = false;

//   int _screenTimeLimitMinutes = 150;
//   int _totalUsageSeconds = 0;

//   // Flutter-side keys — "Social Media" aur "Gaming" use karo
//   Map<String, int> _categoryUsageSeconds = {
//     "Social Media":  0,
//     "Entertainment": 0,
//     "Gaming":        0,
//   };

//   TimeOfDay _bedtimeStart = const TimeOfDay(hour: 21, minute: 0);
//   TimeOfDay _bedtimeEnd   = const TimeOfDay(hour: 7,  minute: 0);
//   bool _bedtimeEnabled = true;

//   static const Color primaryOrange = Color(0xFFEB9974);
//   static const Color bgColor       = Color(0xFFFBFBFC);

//   @override
//   void initState() {
//     super.initState();
//     _fetchLimits();
//   }

//   // Backend category names → Flutter names
//   String _normalizeCat(String raw) {
//     const map = {
//       'Social':        'Social Media',
//       'Games':         'Gaming',
//       'Entertainment': 'Entertainment',
//       'Education':     'Education',
//       'Tools':         'Tools',
//       'Sensitive':     'Sensitive',
//       // Already-correct keys (backend fix ke baad)
//       'Social Media':  'Social Media',
//       'Gaming':        'Gaming',
//     };
//     return map[raw] ?? raw;
//   }

//   // Fetch current limits
//   Future<void> _fetchLimits() async {
//     setState(() => _isLoading = true);
//     try {
//       final response = await http.get(
//         Uri.parse('$kBaseUrl/get-screen-limits/?child_id=${widget.childId}'),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final catUsage = Map<String, dynamic>.from(
//           data['category_usage_seconds'] ?? {},
//         );

//         // Normalize all keys coming from backend
//         final Map<String, int> normalized = {};
//         catUsage.forEach((key, value) {
//           final flutterKey = _normalizeCat(key);
//           normalized[flutterKey] =
//               (normalized[flutterKey] ?? 0) + (value as int? ?? 0);
//         });

//         setState(() {
//           _screenTimeLimitMinutes = data['screen_time_limit'] ?? 150;
//           _totalUsageSeconds      = data['total_usage_seconds'] ?? 0;
//           _bedtimeEnabled         = data['bedtime_enabled'] ?? true;

//           _categoryUsageSeconds = {
//             "Social Media":  normalized['Social Media']  ?? 0,
//             "Entertainment": normalized['Entertainment'] ?? 0,
//             "Gaming":        normalized['Gaming']        ?? 0,
//           };

//           if (data['bedtime_start'] != null) {
//             _bedtimeStart = _parseTime(data['bedtime_start']);
//           }
//           if (data['bedtime_end'] != null) {
//             _bedtimeEnd = _parseTime(data['bedtime_end']);
//           }
//         });
//       } else {
//         _showSnack(
//           "Failed to load limits (${response.statusCode})",
//           isError: true,
//         );
//       }
//     } catch (e) {
//       debugPrint("Error fetching limits: $e");
//       _showSnack("Network error. Check your server URL.", isError: true);
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   // Apply / save limits
//   Future<void> _applyLimits() async {
//   setState(() => _isSaving = true);
//   try {
//     final response = await http.post(
//       Uri.parse('$kBaseUrl/update-screen-limits/'),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "child_id":          widget.childId,
//         "screen_time_limit": _screenTimeLimitMinutes,
//         "bedtime_start":     _formatTimeOfDay(_bedtimeStart),
//         "bedtime_end":       _formatTimeOfDay(_bedtimeEnd),
//         "bedtime_enabled":   _bedtimeEnabled,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data     = jsonDecode(response.body);
//       final isLocked = data['is_locked'] ?? false;
//       final reason   = data['reason']    ?? '';

//       String msg;
//       if (reason == 'bedtime') {
//         msg = "Limits updated. Device locked — bedtime active.";
//       } else if (reason == 'screen_limit') {
//         msg = "Limits updated. Device locked — usage limit reached.";
//       } else if (reason == 'grace_period') {
//         msg = "Limits updated. Grace period active — device stays unlocked.";
//       } else if (isLocked) {
//         msg = "Limits updated. Device is locked.";
//       } else {
//         msg = "Limits updated. Device unlocked ✓";
//       }

//       _showSnack(msg, isError: isLocked);

//       // Local state refresh karo
//       await _fetchLimits();
//     } else {
//       _showSnack(
//         "Failed to update limits (${response.statusCode})",
//         isError: true,
//       );
//     }
//   } catch (e) {
//     debugPrint("Error updating limits: $e");
//     _showSnack("Network error. Check your server URL.", isError: true);
//   } finally {
//     setState(() => _isSaving = false);
//   }
// }
//   // Lock device manually
//   Future<void> _lockDevice() async {
//     try {
//       final res = await http.post(
//         Uri.parse('$kBaseUrl/lock-device/'),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"child_id": widget.childId}),
//       );
//       _showSnack(
//         res.statusCode == 200 ? "Device locked successfully" : "Lock failed",
//         isError: res.statusCode != 200,
//       );
//     } catch (e) {
//       _showSnack("Network error.", isError: true);
//     }
//   }

//   // Helpers
//   TimeOfDay _parseTime(String timeStr) {
//     final parts = timeStr.split(':');
//     return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
//   }

//   String _formatTimeOfDay(TimeOfDay t) {
//     final h = t.hour.toString().padLeft(2, '0');
//     final m = t.minute.toString().padLeft(2, '0');
//     return "$h:$m:00";
//   }

//   String _formatTimeDisplay(TimeOfDay t) {
//     final hour   = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
//     final minute = t.minute.toString().padLeft(2, '0');
//     final period = t.period == DayPeriod.am ? "AM" : "PM";
//     return "$hour:$minute $period";
//   }

//   String _formatDailyLimitDisplay() {
//     final h = _screenTimeLimitMinutes ~/ 60;
//     final m = _screenTimeLimitMinutes % 60;
//     if (h == 0) return "${m}m";
//     if (m == 0) return "${h}h";
//     return "${h}h ${m}m";
//   }

//   String _formatUsageTime(int seconds) {
//     final mins = (seconds / 60).round();
//     if (mins < 60) return "${mins}m";
//     final h = mins ~/ 60;
//     final m = mins % 60;
//     return m == 0 ? "${h}h" : "${h}h ${m}m";
//   }

//   double _categoryProgress(int seconds) {
//     if (_screenTimeLimitMinutes <= 0) return 0.0;
//     return ((seconds / 60) / _screenTimeLimitMinutes).clamp(0.0, 1.0);
//   }

//   void _showSnack(String msg, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor:
//             isError ? Colors.redAccent : Colors.green.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//       ),
//     );
//   }

//   // Bedtime time picker
//   Future<void> _pickBedtime({required bool isStart}) async {
//     final initial = isStart ? _bedtimeStart : _bedtimeEnd;
//     final picked  = await showTimePicker(
//       context: context,
//       initialTime: initial,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary:   primaryOrange,
//               onPrimary: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           _bedtimeStart = picked;
//         } else {
//           _bedtimeEnd = picked;
//         }
//       });
//     }
//   }

//   // Edit Daily Limit bottom sheet
//   Future<void> _showEditLimitDialog() async {
//     int hours   = _screenTimeLimitMinutes ~/ 60;
//     int minutes = _screenTimeLimitMinutes % 60;

//     await showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Container(
//               padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius:
//                     BorderRadius.vertical(top: Radius.circular(24.r)),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Container(
//                       width: 40.w,
//                       height: 4.h,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(10.r),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//                   Text(
//                     "Set daily screen limit",
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 24.h),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _pickerColumn(
//                           label: "Hours",
//                           value: hours,
//                           max: 12,
//                           onChanged: (v) => setModalState(() => hours = v),
//                         ),
//                       ),
//                       SizedBox(width: 16.w),
//                       Expanded(
//                         child: _pickerColumn(
//                           label: "Minutes",
//                           value: minutes,
//                           max: 59,
//                           step: 5,
//                           onChanged: (v) =>
//                               setModalState(() => minutes = v),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 28.h),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           _screenTimeLimitMinutes =
//                               (hours * 60) + minutes;
//                           if (_screenTimeLimitMinutes < 5) {
//                             _screenTimeLimitMinutes = 5;
//                           }
//                         });
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: primaryOrange,
//                         minimumSize: Size(double.infinity, 50.h),
//                         shape: const StadiumBorder(),
//                       ),
//                       child: Text(
//                         "Done",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _pickerColumn({
//     required String label,
//     required int value,
//     required int max,
//     int step = 1,
//     required ValueChanged<int> onChanged,
//   }) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12.sp,
//             color: Colors.grey,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         SizedBox(height: 10.h),
//         Container(
//           decoration: BoxDecoration(
//             color: bgColor,
//             borderRadius: BorderRadius.circular(16.r),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           padding: EdgeInsets.symmetric(vertical: 8.h),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _circleIconButton(
//                 icon: Icons.remove,
//                 onTap: () {
//                   int newVal = value - step;
//                   if (newVal < 0) newVal = 0;
//                   onChanged(newVal);
//                 },
//               ),
//               Text(
//                 "$value",
//                 style: TextStyle(
//                   fontSize: 22.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               _circleIconButton(
//                 icon: Icons.add,
//                 onTap: () {
//                   int newVal = value + step;
//                   if (newVal > max) newVal = max;
//                   onChanged(newVal);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _circleIconButton({
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(50),
//       child: Container(
//         padding: EdgeInsets.all(6.w),
//         decoration: BoxDecoration(
//           color: primaryOrange.withOpacity(0.12),
//           shape: BoxShape.circle,
//         ),
//         child: Icon(icon, size: 18.sp, color: primaryOrange),
//       ),
//     );
//   }

//   // BUILD
//   @override
//   Widget build(BuildContext context) {
//     final overallProgress = _screenTimeLimitMinutes > 0
//         ? (_totalUsageSeconds / 60) / _screenTimeLimitMinutes
//         : 0.0;
//     final clampedProgress = overallProgress.clamp(0.0, 1.0);

//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         scrolledUnderElevation: 0,
//         surfaceTintColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Screen time limit",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 18.sp,
//           ),
//         ),
//         actions: [
//           Icon(Icons.notifications_none, color: Colors.black, size: 28.sp),
//           SizedBox(width: 10.w),
//           Icon(Icons.settings_outlined, color: Colors.black, size: 24.sp),
//           SizedBox(width: 15.w),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(color: primaryOrange),
//             )
//           : RefreshIndicator(
//               color: primaryOrange,
//               onRefresh: _fetchLimits,
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 padding:
//                     EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Profile
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 35.r,
//                           backgroundColor: primaryOrange.withOpacity(0.25),
//                           child: CircleAvatar(
//                             radius: 32.r,
//                             backgroundImage: const NetworkImage(
//                               'https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png',
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 15.w),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.childName,
//                               style: TextStyle(
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               "${widget.childAge} years old",
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12.sp,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: 25.h),
//                     Text(
//                       "Daily screen time",
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 20.h),

//                     // Ring + Side Cards
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           flex: 5,
//                           child: GestureDetector(
//                             onTap: _showEditLimitDialog,
//                             child: _DailyLimitRing(
//                               progress:   clampedProgress,
//                               usedLabel:  _formatUsageTime(_totalUsageSeconds),
//                               limitLabel: _formatDailyLimitDisplay(),
//                               color:      primaryOrange,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 15.w),
//                         Expanded(
//                           flex: 5,
//                           child: Column(
//                             children: [
//                               _buildEditableCard(
//                                 "Daily limit",
//                                 _formatDailyLimitDisplay(),
//                                 Icons.add_circle_outline,
//                                 onTap: _showEditLimitDialog,
//                               ),
//                               SizedBox(height: 10.h),
//                               _buildBedtimeCard(),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: 30.h),

//                     // App Category Usage
//                     Container(
//                       padding: EdgeInsets.all(16.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20.r),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 10,
//                           )
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "App category usage",
//                                 style: TextStyle(
//                                   fontSize: 14.sp,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 "today",
//                                 style: TextStyle(
//                                   fontSize: 11.sp,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 18.h),
//                           _categoryWithCircle(
//                             "Social Media",
//                             _formatUsageTime(
//                               _categoryUsageSeconds["Social Media"] ?? 0,
//                             ),
//                             _categoryProgress(
//                               _categoryUsageSeconds["Social Media"] ?? 0,
//                             ),
//                             const Color(0xFFE85D8C),
//                           ),
//                           SizedBox(height: 20.h),
//                           _categoryWithCircle(
//                             "Entertainment",
//                             _formatUsageTime(
//                               _categoryUsageSeconds["Entertainment"] ?? 0,
//                             ),
//                             _categoryProgress(
//                               _categoryUsageSeconds["Entertainment"] ?? 0,
//                             ),
//                             const Color(0xFFF5A623),
//                           ),
//                           SizedBox(height: 20.h),
//                           _categoryWithCircle(
//                             "Gaming",
//                             _formatUsageTime(
//                               _categoryUsageSeconds["Gaming"] ?? 0,
//                             ),
//                             _categoryProgress(
//                               _categoryUsageSeconds["Gaming"] ?? 0,
//                             ),
//                             const Color(0xFF4CAF82),
//                           ),
//                         ],
//                       ),
//                     ),

//                     SizedBox(height: 20.h),

//                     // Quick Stats Row
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _statCard(
//                             label:      "Used today",
//                             value:      _formatUsageTime(_totalUsageSeconds),
//                             valueColor: primaryOrange,
//                             badge:      _buildUsageBadge(),
//                           ),
//                         ),
//                         SizedBox(width: 10.w),
//                         Expanded(
//                           child: _statCard(
//                             label:      "Daily limit",
//                             value:      _formatDailyLimitDisplay(),
//                             valueColor: Colors.black87,
//                             badge: Container(
//                               margin: EdgeInsets.only(top: 6.h),
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 8.w,
//                                 vertical: 3.h,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.green.shade50,
//                                 borderRadius: BorderRadius.circular(20.r),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     Icons.check_circle_outline,
//                                     size: 11.sp,
//                                     color: Colors.green.shade700,
//                                   ),
//                                   SizedBox(width: 3.w),
//                                   Text(
//                                     "Active",
//                                     style: TextStyle(
//                                       fontSize: 11.sp,
//                                       color: Colors.green.shade700,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: 16.h),

//                     // Controls Card
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 16.w,
//                         vertical: 4.h,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20.r),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 10,
//                           )
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           _controlRow(
//                             iconData:  Icons.bedtime_outlined,
//                             iconColor: primaryOrange,
//                             iconBg:    primaryOrange.withOpacity(0.12),
//                             title:     "Bedtime block",
//                             subtitle:
//                                 "${_formatTimeDisplay(_bedtimeStart)} – ${_formatTimeDisplay(_bedtimeEnd)}",
//                             trailing: Transform.scale(
//                               scale: 0.8,
//                               child: Switch(
//                                 value:       _bedtimeEnabled,
//                                 activeColor: primaryOrange,
//                                 onChanged:   (v) =>
//                                     setState(() => _bedtimeEnabled = v),
//                               ),
//                             ),
//                             showDivider: true,
//                             onTap: _bedtimeEnabled
//                                 ? () => _pickBedtime(isStart: true)
//                                 : null,
//                           ),
//                           _controlRow(
//                             iconData:  Icons.lock_outline,
//                             iconColor: const Color(0xFF185FA5),
//                             iconBg:    const Color(0xFFE6F1FB),
//                             title:     "Lock device now",
//                             subtitle:  "Immediately restricts access",
//                             trailing: OutlinedButton(
//                               onPressed: _lockDevice,
//                               style: OutlinedButton.styleFrom(
//                                 foregroundColor: const Color(0xFF185FA5),
//                                 side: const BorderSide(
//                                   color: Color(0xFF185FA5),
//                                   width: 0.8,
//                                 ),
//                                 shape: const StadiumBorder(),
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 12.w,
//                                   vertical: 4.h,
//                                 ),
//                                 minimumSize: Size.zero,
//                                 tapTargetSize:
//                                     MaterialTapTargetSize.shrinkWrap,
//                               ),
//                               child: Text(
//                                 "Lock",
//                                 style: TextStyle(fontSize: 12.sp),
//                               ),
//                             ),
//                             showDivider: false,
//                           ),
//                         ],
//                       ),
//                     ),

//                     SizedBox(height: 30.h),

//                     // Apply Button
//                     Center(
//                       child: ElevatedButton(
//                         onPressed: _isSaving ? null : _applyLimits,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: primaryOrange,
//                           minimumSize: Size(280.w, 50.h),
//                           shape: const StadiumBorder(),
//                           elevation: 5,
//                         ),
//                         child: _isSaving
//                             ? SizedBox(
//                                 width: 22.w,
//                                 height: 22.w,
//                                 child: const CircularProgressIndicator(
//                                   color: Colors.white,
//                                   strokeWidth: 2.5,
//                                 ),
//                               )
//                             : Text(
//                                 "Apply limits",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                       ),
//                     ),
//                     SizedBox(height: 24.h),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   // Widget Helpers

//   Widget _statCard({
//     required String label,
//     required String value,
//     required Color valueColor,
//     required Widget badge,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(14.w),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(color: Colors.grey.shade100),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20.sp,
//               fontWeight: FontWeight.bold,
//               color: valueColor,
//             ),
//           ),
//           badge,
//         ],
//       ),
//     );
//   }

//   Widget _buildUsageBadge() {
//     final usedMins = _totalUsageSeconds / 60;
//     final leftMins = _screenTimeLimitMinutes - usedMins;
//     final isOver   = leftMins <= 0;
//     return Container(
//       margin: EdgeInsets.only(top: 6.h),
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
//       decoration: BoxDecoration(
//         color: isOver ? Colors.red.shade50 : Colors.orange.shade50,
//         borderRadius: BorderRadius.circular(20.r),
//       ),
//       child: Text(
//         isOver ? "Limit reached" : "${leftMins.round()}m left",
//         style: TextStyle(
//           fontSize: 11.sp,
//           color: isOver ? Colors.red.shade700 : Colors.orange.shade800,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   Widget _controlRow({
//     required IconData iconData,
//     required Color iconColor,
//     required Color iconBg,
//     required String title,
//     required String subtitle,
//     required Widget trailing,
//     required bool showDivider,
//     VoidCallback? onTap,
//   }) {
//     return Column(
//       children: [
//         InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(12.r),
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: 13.h),
//             child: Row(
//               children: [
//                 Container(
//                   width: 36.w,
//                   height: 36.w,
//                   decoration: BoxDecoration(
//                     color: iconBg,
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                   child: Icon(iconData, color: iconColor, size: 18.sp),
//                 ),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: TextStyle(
//                           fontSize: 13.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 11.sp,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 trailing,
//               ],
//             ),
//           ),
//         ),
//         if (showDivider) Divider(height: 1, color: Colors.grey.shade100),
//       ],
//     );
//   }

//   Widget _buildEditableCard(
//     String title,
//     String sub,
//     IconData icon, {
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(15.r),
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.all(12.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 5,
//             )
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style:
//                   TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               sub,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const Divider(),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Icon(icon, color: primaryOrange, size: 20.sp),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBedtimeCard() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 5,
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Bedtime block",
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Transform.scale(
//                 scale: 0.7,
//                 child: Switch(
//                   value:       _bedtimeEnabled,
//                   activeColor: primaryOrange,
//                   onChanged:   (v) => setState(() => _bedtimeEnabled = v),
//                 ),
//               ),
//             ],
//           ),
//           GestureDetector(
//             onTap:
//                 _bedtimeEnabled ? () => _pickBedtime(isStart: true) : null,
//             child: Text(
//               "${_formatTimeDisplay(_bedtimeStart)} – ${_formatTimeDisplay(_bedtimeEnd)}",
//               style: TextStyle(
//                 fontSize: 10.sp,
//                 color: _bedtimeEnabled
//                     ? Colors.grey.shade700
//                     : Colors.grey.shade400,
//               ),
//             ),
//           ),
//           const Divider(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               GestureDetector(
//                 onTap: _bedtimeEnabled
//                     ? () => _pickBedtime(isStart: true)
//                     : null,
//                 child: Icon(
//                   Icons.bedtime_outlined,
//                   color: _bedtimeEnabled
//                       ? primaryOrange
//                       : Colors.grey.shade300,
//                   size: 18.sp,
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               GestureDetector(
//                 onTap: _bedtimeEnabled
//                     ? () => _pickBedtime(isStart: false)
//                     : null,
//                 child: Icon(
//                   Icons.wb_sunny_outlined,
//                   color: _bedtimeEnabled
//                       ? primaryOrange
//                       : Colors.grey.shade300,
//                   size: 18.sp,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _categoryWithCircle(
//     String title,
//     String time,
//     double progress,
//     Color col,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14.sp,
//               ),
//             ),
//             Text(
//               time,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12.sp,
//                 color: col,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 12.h),
//         LayoutBuilder(
//           builder: (context, constraints) {
//             return Stack(
//               alignment: Alignment.centerLeft,
//               clipBehavior: Clip.none,
//               children: [
//                 Container(
//                   height: 6.h,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: col.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                 ),
//                 Container(
//                   height: 6.h,
//                   width: constraints.maxWidth * progress,
//                   decoration: BoxDecoration(
//                     color: col,
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                 ),
//                 Positioned(
//                   left: (constraints.maxWidth * progress) - 8.w,
//                   child: Container(
//                     height: 16.h,
//                     width: 16.h,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                       border: Border.all(color: col, width: 3),
//                       boxShadow: const [
//                         BoxShadow(color: Colors.black12, blurRadius: 4),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// // Custom Painted Ring
// class _DailyLimitRing extends StatelessWidget {
//   final double progress;
//   final String usedLabel;
//   final String limitLabel;
//   final Color color;

//   const _DailyLimitRing({
//     required this.progress,
//     required this.usedLabel,
//     required this.limitLabel,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           CustomPaint(
//             size: Size.infinite,
//             painter: _RingPainter(progress: progress, color: color),
//           ),
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 usedLabel,
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 2.h),
//               Text(
//                 "of $limitLabel",
//                 style: TextStyle(fontSize: 10.sp, color: Colors.grey),
//               ),
//               SizedBox(height: 2.h),
//               Text(
//                 "Daily limit",
//                 style: TextStyle(
//                   fontSize: 10.sp,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _RingPainter extends CustomPainter {
//   final double progress;
//   final Color color;

//   _RingPainter({required this.progress, required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center      = Offset(size.width / 2, size.height / 2);
//     final radius      = (size.width / 2) * 0.85;
//     const strokeWidth = 14.0;

//     final bgPaint = Paint()
//       ..color       = color.withOpacity(0.12)
//       ..style       = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap   = StrokeCap.round;

//     final fgPaint = Paint()
//       ..color       = color
//       ..style       = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap   = StrokeCap.round;

//     canvas.drawCircle(center, radius, bgPaint);

//     const startAngle = -1.5708;
//     final sweepAngle = 6.2832 * progress;

//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       startAngle,
//       sweepAngle,
//       false,
//       fgPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant _RingPainter oldDelegate) {
//     return oldDelegate.progress != progress || oldDelegate.color != color;
//   }
// }