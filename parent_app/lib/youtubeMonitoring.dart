import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Youtube extends StatefulWidget {
  const Youtube({super.key});

  @override
  State<Youtube> createState() => _YoutubeState();
}

class _YoutubeState extends State<Youtube> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFC),
        elevation: 0,
        title: Text(
          "YouTube Monitoring Dashboard",
          style:
              TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Profile Section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60.r,
                      backgroundImage: const NetworkImage(
                        "https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png",
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Hamza Ali",
                      style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "11 Years Old",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.sp),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              /// Usage
              Text(
                "Usage",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp),
              ),

              SizedBox(height: 10.h),

              Center(
                child: Image.asset(
                  "assets/youtube.png",
                  width: 300.w,
                ),
              ),

              SizedBox(height: 20.h),

              /// Content Cards
              contentCard(
                  "PCA Step by Step Solution",
                  "CampusX",
                  "Educational",
                  Colors.blue,
                  "15min"),

              contentCard(
                  "Gaming Video",
                  "CampusX",
                  "Gaming",
                  Colors.green,
                  "15min"),

              contentCard(
                  "Violent Scene",
                  "CampusX",
                  "Violence",
                  Colors.red,
                  "15min"),

              SizedBox(height: 20.h),

              /// Alerts
              Text(
                "Alerts",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp),
              ),

              SizedBox(height: 10.h),

              alertCard("Violent Content Detected", "10:30 AM"),
              alertCard("Violent Content Detected", "11:00 AM"),
            ],
          ),
        ),
      ),
    );
  }

  /// Content Card
  Widget contentCard(String title, String source,
      String category, Color color, String time) {
    return Card(
      color: const Color(0xFFEB9974),
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp)),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(source,
                    style: TextStyle(
                        decoration:
                            TextDecoration.underline,
                        fontSize: 12.sp)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius:
                        BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp),
                  ),
                ),
                Text(time,
                    style:
                        TextStyle(fontSize: 12.sp)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Alert Card
  Widget alertCard(String message, String time) {
    return Card(
      color: Colors.red[100],
      margin: EdgeInsets.only(bottom: 8.h),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Icon(Icons.error,
                color: Colors.red,
                size: 30.r),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(message,
                  style:
                      TextStyle(fontSize: 14.sp)),
            ),
            Text(time,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12.sp)),
          ],
        ),
      ),
    );
  }
}