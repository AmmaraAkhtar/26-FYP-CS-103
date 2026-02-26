import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMonitoringDashboard extends StatelessWidget {
  const ChatMonitoringDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFC),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
        title: Text(
          "Chat Monitoring Dashboard",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        actions: [
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
                  child: Text("1", style: TextStyle(fontSize: 10.sp, color: Colors.white)),
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
                      backgroundImage: const NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png'),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hamza Ali", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
                      Text("11 Years Old", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                    ],
                  )
                ],
              ),
              SizedBox(height: 25.h),

              // --- Stats Cards Section ---
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: Row(
                    children: [
                      _buildStatItem("Total Messages", "56", "Today"),
                      _buildVerticalDivider(),
                      _buildStatItem("Total Messages", "210", "Today"),
                      _buildVerticalDivider(),
                      _buildStatItem("Safe Chats", "10", "Last 7 messages"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // --- Flagged Chats Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Flagged Chats", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text("View All ", style: TextStyle(color: Colors.green, fontSize: 13.sp)),
                      Icon(Icons.keyboard_double_arrow_right, color: Colors.green, size: 16.sp),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15.h),

              // --- Flagged Chats List (Ab images ke sath) ---
              _buildChatTile(
                "Ammara", 
                "Tuhma mana mar dena ha.", 
                "10 mins ago", 
                "High Risk", 
                Colors.red,
                'https://cdn-icons-png.flaticon.com/512/4086/4086679.png' // Ammara's Pic
              ),
              _buildChatTile(
                "Ali raza", 
                "Let's play game tonight", 
                "30 mins ago", 
                "Moderate", 
                Colors.orange,
                'https://cdn-icons-png.flaticon.com/512/6833/6833605.png' // Ali's Pic
              ),
              _buildChatTile(
                "Sara", 
                "Shared a photo", 
                "50 mins ago", 
                "Media", 
                Colors.lightBlue,
                'https://cdn-icons-png.flaticon.com/512/6997/6997662.png' // Sara's Pic
              ),

              SizedBox(height: 30.h),

              // --- Safety Alerts Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Safety Alerts", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text("See All ", style: TextStyle(color: Colors.redAccent, fontSize: 14.sp)),
                      Icon(Icons.keyboard_double_arrow_right, color: Colors.redAccent, size: 16.sp),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15.h),

              _buildAlertTile("Ammara"),
              _buildAlertTile("Unknown Contact"),
            ],
          ),
        ),
      ),
    );
  }

  // Stats Item Helper
  Widget _buildStatItem(String label, String value, String subLabel) {
    return Expanded(
      child: Column(
        children: [
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10.sp, color: Colors.black54)),
          SizedBox(height: 5.h),
          Text(value, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 5.h),
          Text(subLabel, textAlign: TextAlign.center, style: TextStyle(fontSize: 9.sp, color: Colors.grey)),
        ],
      ),
    );
  }

  // Vertical Divider Helper
  Widget _buildVerticalDivider() {
    return Container(height: 40.h, width: 1.w, color: Colors.grey[200]);
  }

  // --- UPDATED Chat Tile Helper with Image ---
  Widget _buildChatTile(String name, String msg, String time, String status, Color statusColor, String imageUrl) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        leading: CircleAvatar(
          radius: 25.r,
          backgroundColor: Colors.grey[200],
          // Yahan pic lag rahi hai
          backgroundImage: NetworkImage(imageUrl), 
          // Error handling agar image load na ho
          onBackgroundImageError: (exception, stackTrace) => const Icon(Icons.person),
        ),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
        subtitle: Text(msg, style: TextStyle(fontSize: 11.sp, color: Colors.grey[600], overflow: TextOverflow.ellipsis)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("$time >", style: TextStyle(fontSize: 9.sp, color: Colors.black)),
            SizedBox(height: 5.h),
            Container(
              width: 75.w,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 4.h),
              decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12.r)),
              child: Text(status, style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // Alert Tile Helper
  Widget _buildAlertTile(String contact) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        leading: Icon(Icons.error, color: Colors.red, size: 35.sp),
        title: Text("Violence Message Detected", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
        subtitle: Text(contact, style: TextStyle(color: Colors.redAccent, fontSize: 12.sp)),
        trailing: Text("10:30 AM >", style: TextStyle(fontSize: 9.sp, color: Colors.grey)),
      ),
    );
  }
}