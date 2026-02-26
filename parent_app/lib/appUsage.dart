import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppUsageMonitoringScreen extends StatelessWidget {
  const AppUsageMonitoringScreen({super.key});

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
          "App Usage Monitoring",
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
            children: [
              // --- User Header Section ---
              Row(
                children: [
                  CircleAvatar(
                    radius: 35.r,
                    backgroundColor: Colors.green,
                    child: CircleAvatar(
                      radius: 32.r,
                      backgroundImage: const NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png'),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hamza Ali", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      Text("11 Years Old", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                    ],
                  )
                ],
              ),
              SizedBox(height: 30.h),
              Text("Time Spent", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 20.h),

              // --- App Usage Section (Wrap for Dynamic Heights) ---
              Wrap(
                spacing: 15.w, 
                runSpacing: 15.h, 
                children: [
                  // Logo Path aur Colors image ke mutabiq
                  _buildUsageCard("Whatsapp", "Spent 14 min", "Chatting", Colors.green, const Color(0xFFE8F5E9), "assets/whatsapp.png"),
                  _buildUsageCard("Instagram", "Spent 1 hour", "Entertainment", Colors.orange, const Color(0xFFFFF3E0), "assets/insta.png"),
                  _buildUsageCard("Roblox", "Played 35 min", "Gaming", Colors.red, const Color(0xFFFFEBEE), "assets/roblox.png"),
                  _buildUsageCard("Facebook", "Spent 24 min", "Entertainment", Colors.blue, const Color(0xFFE3F2FD), "assets/facebook.png"),
                ],
              ),

              SizedBox(height: 40.h),

              // --- Change Screen Limit Button ---
              SizedBox(
                width: 285.w,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB9974),
                    elevation: 5,
                    shadowColor: const Color(0xFFEB9974).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                  ),
                  child: Text(
                    'Change Screen Limit',
                    style: TextStyle(
                      fontSize: 18.sp, 
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h), // Bottom space
            ],
          ),
        ),
      ),
    );
  }

  // --- Card Builder with App Logo ---
  Widget _buildUsageCard(String title, String time, String tag, Color accentColor, Color headerBg, String logoPath) {
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
            offset: const Offset(0, 4)
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          // Header: Logo + Name
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r), 
                topRight: Radius.circular(15.r)
              ),
            ),
            child: Row(
              children: [
                // App Logo from Assets
                Image.asset(
                  logoPath,
                  width: 20.w,
                  height: 20.w,
                  fit: BoxFit.contain,
                    ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    title, 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)
                  )
                ),
              ],
            ),
          ),
          
          // Body: Usage Stats & Tag
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("26%", style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
                    Text(time, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11.sp)),
                  ],
                ),
                SizedBox(height: 8.h),
                const Divider(height: 1, thickness: 1.5),
                SizedBox(height: 12.h),
                
                // Tag Button (Chatting, Gaming, etc.)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.3), 
                        blurRadius: 4, 
                        offset: const Offset(0, 2)
                      )
                    ]
                  ),
                  child: Text(
                    tag, 
                    style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold)
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