import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertMonitoringDashboard extends StatelessWidget {
  const AlertMonitoringDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
        title: Text(
          "Alert Monitoring Dashboard",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.notifications_none, color: Colors.black, size: 28.sp),
          ),
          Icon(Icons.settings_outlined, color: Colors.black, size: 24.sp),
          SizedBox(width: 15.w),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- User Header Section ---
              Row(
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: Colors.green,
                    child: CircleAvatar(
                      radius: 37.r,
                      backgroundImage: const NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png'),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hamza Ali", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      Text("11 Years Old", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
                    ],
                  )
                ],
              ),
              SizedBox(height: 30.h),
              Text("Alerts", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 15.h),

              // --- Alerts List ---
              _buildAlertCard(
                "Toxic Language Detected: Bullying in Social Media Chat",
                "15min ago",
                Colors.red,
                Icons.security, // Police hat icon replace
                ["Block Source"],
              ),
              _buildAlertCard(
                "Late Night Usage: App Activity after Bedtime",
                "15min ago",
                Colors.orange,
                Icons.person, // Bedtime/person icon
                ["Extend Limit", "Lock Screen"],
              ),
              _buildAlertCard(
                "Behavior: Signs of Anxiety Detected",
                "15min ago",
                Colors.purple,
                Icons.psychology, 
                ["View Suggestions"],
              ),
              _buildAlertCard(
                "Mood Analysis: Signs of happiness",
                "15min ago",
                const Color(0xFFB07F2E),
                Icons.lightbulb,
                ["Extend Limit"],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard(String title, String time, Color color, IconData icon, List<String> actions) {
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
            offset: const Offset(0, 4)
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
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.sp, 
                          fontWeight: FontWeight.bold, 
                          color: color,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        time,
                        style: TextStyle(color: Colors.redAccent, fontSize: 12.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Icon(icon, color: color, size: 35.sp),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1.5),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: Wrap( // Buttons ke liye wrap use kiya taake overflow na ho
              alignment: WrapAlignment.center,
              spacing: 10.w,
              children: actions.map((btnText) {
                return ElevatedButton(
                  onPressed: () {},
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
      ),
    );
  }
}