import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrowsingMonitoringScreen extends StatelessWidget {
  const BrowsingMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFC),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Profile Section ---
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
              SizedBox(height: 30.h),

              // --- Tabs Section ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTab("Today", isSelected: true),
                    _buildDivider(),
                    _buildTab("This Week"),
                    _buildDivider(),
                    _buildTab("This Month"),
                    _buildDivider(),
                    Icon(Icons.more_horiz, color: Colors.grey, size: 20.sp),
                    SizedBox(width: 5.w),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // --- Table Header ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: Text("Title", style: TextStyle(color: Colors.grey, fontSize: 12.sp))),
                    Expanded(flex: 2, child: Text("Time Spend", style: TextStyle(color: Colors.grey, fontSize: 12.sp))),
                    Expanded(flex: 2, child: Text("Category", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12.sp))),
                    Expanded(flex: 2, child: Text("Block", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12.sp))),
                  ],
                ),
              ),
              SizedBox(height: 10.h),

              // --- List Items ---
              _buildMonitoringRow("youtube.com", "1h 10min", "Violence", Colors.red, Icons.video_library, Colors.red),
              _buildMonitoringRow("Academy.com", "1h 10min", "Educational", Colors.blueAccent, Icons.school, Colors.blue),
              _buildMonitoringRow("roblox.com", "1h 10min", "Gaming", Colors.green, Icons.videogame_asset, Colors.green),

              SizedBox(height: 20.h),

              // --- Safety Alerts Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Safety Alerts",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  Text("See All >",
                      style: TextStyle(color: Colors.redAccent, fontSize: 14.sp)),
                ],
              ),
              SizedBox(height: 15.h),

              _buildAlertTile(),
              _buildAlertTile(),
            ],
          ),
        ),
      ),
    );
  }



// Helper for Vertical Line
  Widget _buildDivider() {
    return Container(
      height: 20.h,
      width: 1.w,
      color: Colors.grey[350],
    );
  }
  // Helper Widget for Tabs
  Widget _buildTab(String text, {bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isSelected ? Colors.lightGreen : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  // Helper Widget for Browsing Rows
  Widget _buildMonitoringRow(String title, String time, String category, Color catColor, IconData icon, Color iconColor) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Icon(icon, size: 18.sp, color: iconColor),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(time, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                decoration: BoxDecoration(color: catColor, borderRadius: BorderRadius.circular(20.r)),
                child: Text(
                  category,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 8.sp),
                ),
              ),
            ),
            SizedBox(width: 5.w),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5.r)),
                child: Text(
                  "Yes",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Safety Alerts
  Widget _buildAlertTile() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        leading: Icon(Icons.error, color: Colors.red, size: 35.sp),
        title: Text("Violence Message Detected",
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
        subtitle: Text("Ammara",
            style: TextStyle(color: Colors.redAccent, fontSize: 12.sp)),
        trailing: Text("10:30 AM >",
            style: TextStyle(fontSize: 9.sp, color: Colors.grey)),
      ),
    );
  }
}