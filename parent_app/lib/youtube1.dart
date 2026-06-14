// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class YoutubeActivityScreen extends StatelessWidget {
//   const YoutubeActivityScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFBFBFC),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFBFBFC),
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         surfaceTintColor: Colors.transparent,
        
//         title: Text(
//           "YouTube Activity",
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
//                   child: Text("3", style: TextStyle(fontSize: 10.sp, color: Colors.white)),
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
//               // --- Header Section ---
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
//                       Text("YouTube Activity", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
//                       Text("Monitoring Hamza's YouTube usage", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
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
//                       _buildStatItem(Icons.play_circle_fill, Colors.red, "Video Watched", "25", "Today", "120", "This Week"),
//                       _buildVerticalDivider(),
//                       _buildStatItem(Icons.access_time_filled, Colors.blue, "Time Spent", "2h 15m", "Today", "120", "This Week"),
//                       _buildVerticalDivider(),
//                       _buildStatItem(Icons.search, Colors.grey, "Searches Made", "8", "Today", "35", "This Week"),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 25.h),

//               Text("Viewing History", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//               SizedBox(height: 15.h),

//               _buildHistoryCard("Fortnite Batyle Gameplay!", "Gaming", Colors.blueAccent, "20 mins ago", 'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=200&q=80'),
//               _buildHistoryCard("Funny Animal Videos Compilation", "Entertainment", Colors.indigoAccent, "1 hour ago", 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=200&q=80'),
//               // _buildHistoryCard("Scary Ghost Stories", "Horror", Colors.red, "2 hour ago", 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYfJM-FPMXCzKRSQReogsEPPeh8XbyZuCOMQ&s'),

//               SizedBox(height: 25.h),
//               Text("Active Overview", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//               SizedBox(height: 15.h),

//               // --- Charts Section replaced with Images ---
//                Image.asset("assets/charts.png", height: 150.h, width: double.infinity, fit: BoxFit.contain),

//               SizedBox(height: 25.h),
//               Text("Safety Alerts", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//               SizedBox(height: 15.h),
//               _buildAlertTile("Ammara"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper for Chart Images
//   Widget _buildImageCard(String title, String imageUrl) {
//     return Container(
//       padding: EdgeInsets.all(8.w),
//       decoration: BoxDecoration(
//         color: Colors.white, 
//         borderRadius: BorderRadius.circular(12.r), 
//         border: Border.all(color: Colors.grey[200]!),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
//         ]
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold)),
//           SizedBox(height: 10.h),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8.r),
//             child: Image.network(
//               imageUrl, 
//               height: 100.h, 
//               width: double.infinity, 
//               fit: BoxFit.contain,
//               errorBuilder: (context, error, stackTrace) => Icon(Icons.bar_chart, size: 50.sp, color: Colors.grey),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Stats Item
//   Widget _buildStatItem(IconData icon, Color color, String label, String mainVal, String mainSub, String secVal, String secSub) {
//     return Expanded(
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, color: color, size: 14.sp),
//               SizedBox(width: 4.w),
//               Text(label, style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w500)),
//             ],
//           ),
//           SizedBox(height: 8.h),
//           RichText(
//             text: TextSpan(
//               children: [
//                 TextSpan(text: mainVal, style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold)),
//                 TextSpan(text: " $mainSub", style: TextStyle(color: Colors.grey, fontSize: 8.sp)),
//               ],
//             ),
//           ),
//           SizedBox(height: 4.h),
//           RichText(
//             text: TextSpan(
//               children: [
//                 TextSpan(text: secVal, style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w500)),
//                 TextSpan(text: " $secSub", style: TextStyle(color: Colors.grey, fontSize: 8.sp)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVerticalDivider() => Container(height: 40.h, width: 1.w, color: Colors.grey[300]);

//   Widget _buildHistoryCard(String title, String cat, Color catColor, String time, String imgUrl) {
//     return Card(
//       elevation: 2,
//       margin: EdgeInsets.only(bottom: 12.h),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
//       child: Padding(
//         padding: EdgeInsets.all(8.w),
//         child: Row(
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8.r),
//                   child: Image.network(imgUrl, width: 80.w, height: 50.h, fit: BoxFit.cover),
//                 ),
//                 Icon(Icons.play_circle_fill, color: Colors.red, size: 24.sp),
//               ],
//             ),
//             SizedBox(width: 12.w),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(child: Text(title, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
//                       Text(time, style: TextStyle(fontSize: 8.sp, color: Colors.grey)),
//                     ],
//                   ),
//                   SizedBox(height: 8.h),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
//                     decoration: BoxDecoration(color: catColor, borderRadius: BorderRadius.circular(15.r)),
//                     child: Text(cat, style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.bold)),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAlertTile(String contact) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
//       child: ListTile(
//         leading: Icon(Icons.error, color: Colors.red, size: 35.sp),
//         title: Text("Violence Message Detected", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
//         subtitle: Text(contact, style: TextStyle(color: Colors.redAccent, fontSize: 12.sp)),
//         trailing: Text("10:30 AM >", style: TextStyle(fontSize: 9.sp, color: Colors.grey)),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class YoutubeActivityScreen extends StatefulWidget {
  final int childId;
  final String childName;
  final int childAge;

  const YoutubeActivityScreen({
    super.key,
    required this.childId,
    required this.childName,
    required this.childAge,
  });

  @override
  State<YoutubeActivityScreen> createState() => _YoutubeActivityScreenState();
}

class _YoutubeActivityScreenState extends State<YoutubeActivityScreen> {
  Map<String, dynamic>? data;
  bool isLoading = true;
  String selectedFilter = 'today';

  static const kGreen = Color(0xFF699886);
  static const kOrange = Color(0xFFEB9974);
  static const kRed = Color(0xFFE53935);
  static const kBg = Color(0xFFF7F8FA);

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse(
        "http://192.168.18.163:8000/youtube-activity/?child_id=${widget.childId}&filter=$selectedFilter",
      ));
      if (res.statusCode == 200 && mounted) {
        setState(() {
          data = jsonDecode(res.body);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  String _formatSeconds(int sec) {
    final h = sec ~/ 3600;
    final m = (sec % 3600) ~/ 60;
    if (h > 0) return "${h}h ${m}m";
    return "${m}m";
  }

  @override
  Widget build(BuildContext context) {
    final stats = data?['stats'] as Map? ?? {};
    final lastWatched = data?['last_watched'] as Map?;
    final history = (data?['history'] as List?) ?? [];
    final categories = (data?['categories'] as List?) ?? [];
    final alerts = (data?['alerts'] as List?) ?? [];
    final flaggedCount = stats['flagged_count'] ?? 0;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("YouTube Activity",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17.sp)),
        actions: [
          Stack(children: [
            IconButton(
                onPressed: null,
                icon: Icon(Icons.notifications_none,
                    color: Colors.black, size: 26.sp)),
            Positioned(
                right: 8.w,
                top: 8.h,
                child: Container(
                  width: 15.w,
                  height: 15.h,
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                  child: Center(
                      child: Text("3",
                          style: TextStyle(
                              fontSize: 8.sp, color: Colors.white))),
                )),
          ]),
          Icon(Icons.settings_outlined, color: Colors.black, size: 22.sp),
          SizedBox(width: 12.w),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: kGreen))
          : RefreshIndicator(
              color: kGreen,
              onRefresh: _fetch,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                      child: Row(children: [
                        Container(
                          width: 62.r,
                          height: 62.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [kGreen, kOrange]),
                          ),
                          padding: EdgeInsets.all(2.5.r),
                          child: CircleAvatar(
                            backgroundImage: const NetworkImage(
                                'https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png'),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(widget.childName,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              "YouTube monitoring • ${widget.childAge} years old",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 11.sp)),
                        ]),
                      ]),
                    ),

                    // Filter Tabs
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.all(3.r),
                        child: Row(
                          children: ['today', 'week', 'month']
                              .map((f) => Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() => selectedFilter = f);
                                        _fetch();
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7.h),
                                        decoration: BoxDecoration(
                                          color: selectedFilter == f
                                              ? Colors.white
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          boxShadow: selectedFilter == f
                                              ? [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.08),
                                                      blurRadius: 4.r)
                                                ]
                                              : [],
                                        ),
                                        child: Text(
                                          f == 'today'
                                              ? 'Today'
                                              : f == 'week'
                                                  ? 'This Week'
                                                  : 'This Month',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                            color: selectedFilter == f
                                                ? kGreen
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),

                    // Stats Cards
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                      child: Row(children: [
                        _statCard(Icons.play_circle_fill, Colors.red,
                            "${stats['total_videos'] ?? 0}", "Videos Watched"),
                        SizedBox(width: 8.w),
                        _statCard(Icons.access_time_filled, Colors.blue,
                            _formatSeconds(stats['total_watch_seconds'] ?? 0),
                            "Time Spent"),
                        SizedBox(width: 8.w),
                        _statCard(Icons.flag_rounded, kOrange,
                            "${stats['flagged_count'] ?? 0}", "Flagged"),
                      ]),
                    ),

                    // Flagged Banner
                    if (flaggedCount > 0)
                      GestureDetector(
                        onTap: () {/* navigate to flagged list */},
                        child: Container(
                          margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8F0),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: Color(0xFFE65100), size: 24),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("$flaggedCount Flagged Videos",
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                const Color(0xFFE65100))),
                                    Text(
                                        "Inappropriate content detected — tap to review",
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color:
                                                const Color(0xFFBF360C))),
                                  ]),
                            ),
                            const Icon(Icons.chevron_right,
                                color: Color(0xFFE65100)),
                          ]),
                        ),
                      ),

                    // Last Watched
                    if (lastWatched != null) ...[
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
                        child: Text("Last Watched",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF7EF),
                          borderRadius: BorderRadius.circular(13.r),
                          border: Border.all(
                              color: const Color(0xFFA5D6B7)),
                        ),
                        child: Row(children: [
                          const Icon(Icons.play_circle,
                              color: Color(0xFF2E7D32), size: 22),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text("Last watched content",
                                  style: TextStyle(
                                      fontSize: 9.sp,
                                      color: const Color(0xFF388E3C),
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 3.h),
                              Text(lastWatched['title'] ?? '',
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      color: const Color(0xFF1B5E20),
                                      fontWeight: FontWeight.w500),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ]),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: lastWatched['is_flagged'] == true
                                  ? const Color(0xFFFFCDD2)
                                  : const Color(0xFFC8E6C9),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              lastWatched['is_flagged'] == true
                                  ? 'Flagged'
                                  : 'Safe',
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: lastWatched['is_flagged'] == true
                                    ? const Color(0xFFB71C1C)
                                    : const Color(0xFF1B5E20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],

                    // Viewing History
                    _sectionTitle("Viewing History", onTap: () {}),
                    if (history.isEmpty)
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Text("No viewing history yet",
                            style: TextStyle(
                                color: Colors.grey, fontSize: 12.sp)),
                      )
                    else
                      ...history.map((item) => _historyCard(item)).toList(),

                    // Category Breakdown
                    _sectionTitle("Category Breakdown"),
                    if (categories.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 8.w,
                          mainAxisSpacing: 8.h,
                          childAspectRatio: 2.2,
                          children: categories
                              .map((c) => _categoryCard(c))
                              .toList(),
                        ),
                      ),

                    // Safety Alerts
                    _sectionTitle("Safety Alerts", onTap: () {}),
                    if (alerts.isEmpty)
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Text("No safety alerts",
                            style: TextStyle(
                                color: Colors.grey, fontSize: 12.sp)),
                      )
                    else
                      ...alerts.map((a) => _alertCard(a)).toList(),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _statCard(IconData icon, Color color, String val, String label) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 18.r),
          SizedBox(height: 4.h),
          Text(val,
              style: TextStyle(
                  fontSize: 15.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 2.h),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 9.sp, color: Colors.grey)),
        ]),
      ),
    );
  }

  Widget _historyCard(Map item) {
    final isFlagged = item['is_flagged'] == true;
    final cat = item['category'] ?? 'Unknown';
    final catColor = _catColor(cat, isFlagged);

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 9.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
            color: isFlagged
                ? const Color(0xFFFFCDD2)
                : Colors.grey.shade100),
      ),
      child: Row(children: [
        Container(
          width: 80.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: isFlagged
                ? const Color(0xFFFFEBEE)
                : const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(9.r),
          ),
          child: Stack(alignment: Alignment.center, children: [
            Icon(
              isFlagged ? Icons.warning_rounded : Icons.play_circle_fill,
              color: isFlagged ? kRed : Colors.grey.shade500,
              size: 28.r,
            ),
            if (isFlagged)
              Positioned(
                top: 4.h,
                right: 4.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: kRed,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  child: Text("FLAGGED",
                      style: TextStyle(
                          fontSize: 6.sp, color: Colors.white)),
                ),
              ),
          ]),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(item['title'] ?? '',
                style: TextStyle(
                    fontSize: 11.sp, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            SizedBox(height: 4.h),
            Row(children: [
              Icon(Icons.access_time,
                  size: 9.r, color: Colors.grey),
              SizedBox(width: 2.w),
              Text(item['time_ago'] ?? '',
                  style: TextStyle(
                      fontSize: 8.sp, color: Colors.grey)),
            ]),
            SizedBox(height: 4.h),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 9.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: catColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(isFlagged ? 'Flagged' : cat,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold)),
              ),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _categoryCard(Map cat) {
    final name = cat['name'] ?? '';
    final pct = cat['percent'] ?? 0;
    final color = _catColor(name, name == 'Flagged');
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Text(name,
              style: TextStyle(
                  fontSize: 10.sp, color: Colors.grey)),
          Text("$pct%",
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold)),
        ]),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(2.r),
          child: LinearProgressIndicator(
            value: pct / 100,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4.h,
          ),
        ),
      ]),
    );
  }

  Widget _alertCard(Map alert) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 9.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        const Icon(Icons.error, color: kRed, size: 24),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(alert['alert_type'] ?? "Alert",
                style: TextStyle(
                    fontSize: 12.sp, fontWeight: FontWeight.w500)),
            SizedBox(height: 2.h),
            Text(alert['message'] ?? '',
                style: TextStyle(
                    fontSize: 10.sp, color: const Color(0xFFC62828))),
            SizedBox(height: 3.h),
            Text(
              (alert['created_at'] ?? '').toString().length > 16
                  ? (alert['created_at'] ?? '').toString().substring(0, 16)
                  : (alert['created_at'] ?? '').toString(),
              style: TextStyle(
                  fontSize: 9.sp, color: Colors.grey),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _sectionTitle(String title, {VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        Text(title,
            style:
                TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
        if (onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Text("View All ›",
                style: TextStyle(fontSize: 11.sp, color: kGreen)),
          ),
      ]),
    );
  }

  Color _catColor(String cat, bool isFlagged) {
    if (isFlagged || cat == 'Flagged') return kRed;
    switch (cat.toLowerCase()) {
      case 'gaming': return const Color(0xFF1565C0);
      case 'entertainment': return kGreen;
      case 'education': return kOrange;
      case 'horror': return kRed;
      default: return Colors.grey;
    }
  }
}