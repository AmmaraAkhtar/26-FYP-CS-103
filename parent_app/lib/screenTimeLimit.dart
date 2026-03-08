import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenTimeLimitScreen extends StatelessWidget {
  const ScreenTimeLimitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
        title: Text("Screen Time Limit", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp)),
        actions: [
          Icon(Icons.notifications_none, color: Colors.black, size: 28.sp),
          SizedBox(width: 10.w),
          Icon(Icons.settings_outlined, color: Colors.black, size: 24.sp),
          SizedBox(width: 15.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Profile Section ---
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


            SizedBox(height: 25.h),
            Text("Daily Screen Time", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.h),

            // --- Graph and Side Cards ---
            Row(
              children: [
                Expanded(flex: 5, child: Image.asset("assets/dailyLimit.png", fit: BoxFit.contain)),
                SizedBox(width: 15.w),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      _buildSimpleCard("Daily Limit", "2h 30m", Icons.add_circle_outline),
                      SizedBox(height: 10.h),
                      _buildSimpleCard("Bedtime Block", "9:00 PM - 7:00 AM", Icons.toggle_on),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 30.h),

            // --- App Category Section ---
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _categoryWithCircle("Social", "30 min", 0.4, Colors.pink),
                  SizedBox(height: 20.h),
                  _categoryWithCircle("Entertainment", "1 hour", 0.8, Colors.orange),
                  SizedBox(height: 20.h),
                  _categoryWithCircle("Gaming", "45 min", 0.6, Colors.green),
                ],
              ),
            ),

            SizedBox(height: 40.h),

            // --- Apply Button ---
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB9974),
                  minimumSize: Size(280.w, 50.h),
                  shape: const StadiumBorder(),
                  elevation: 5,
                ),
                child: Text("Apply Limits", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 20.h),
          ],),
      ),
    );
  }

  // --- Naya Simple function circles ke liye ---
  Widget _categoryWithCircle(String title, String time, double progress, Color col) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
            Text(time, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp)),
          ],
        ),
        SizedBox(height: 12.h),
        // LayoutBuilder use kiya hai taake humein line ki width pata chale
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none, // Taake circle line se bahar cut na ho
              children: [
                // 1. Background halki line
                Container(
                  height: 6.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: col.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                // 2. Colorful progress line
                Container(
                  height: 6.h,
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    color: col,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                // 3. Gol Circle (Thumb)
                Positioned(
                  left: (constraints.maxWidth * progress) - 8.w, // Center karne ke liye
                  child: Container(
                    height: 16.h,
                    width: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: col, width: 3),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
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

  Widget _buildSimpleCard(String title, String sub, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
          Text(sub, style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
          const Divider(),
          Align(alignment: Alignment.centerRight, child: Icon(icon, color: Colors.orange)),
        ],
      ),
    );
  }
}