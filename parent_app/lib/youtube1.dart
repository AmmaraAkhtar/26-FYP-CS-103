import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YoutubeActivityScreen extends StatelessWidget {
  const YoutubeActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        
        title: Text(
          "YouTube Activity",
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
                  child: Text("3", style: TextStyle(fontSize: 10.sp, color: Colors.white)),
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
              // --- Header Section ---
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
                      Text("YouTube Activity", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                      Text("Monitoring Hamza's YouTube usage", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
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
                      _buildStatItem(Icons.play_circle_fill, Colors.red, "Video Watched", "25", "Today", "120", "This Week"),
                      _buildVerticalDivider(),
                      _buildStatItem(Icons.access_time_filled, Colors.blue, "Time Spent", "2h 15m", "Today", "120", "This Week"),
                      _buildVerticalDivider(),
                      _buildStatItem(Icons.search, Colors.grey, "Searches Made", "8", "Today", "35", "This Week"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25.h),

              Text("Viewing History", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 15.h),

              _buildHistoryCard("Fortnite Batyle Gameplay!", "Gaming", Colors.blueAccent, "20 mins ago", 'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=200&q=80'),
              _buildHistoryCard("Funny Animal Videos Compilation", "Entertainment", Colors.indigoAccent, "1 hour ago", 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=200&q=80'),
              // _buildHistoryCard("Scary Ghost Stories", "Horror", Colors.red, "2 hour ago", 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYfJM-FPMXCzKRSQReogsEPPeh8XbyZuCOMQ&s'),

              SizedBox(height: 25.h),
              Text("Active Overview", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 15.h),

              // --- Charts Section replaced with Images ---
               Image.asset("assets/charts.png", height: 150.h, width: double.infinity, fit: BoxFit.contain),

              SizedBox(height: 25.h),
              Text("Safety Alerts", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 15.h),
              _buildAlertTile("Ammara"),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for Chart Images
  Widget _buildImageCard(String title, String imageUrl) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12.r), 
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              imageUrl, 
              height: 100.h, 
              width: double.infinity, 
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.bar_chart, size: 50.sp, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // Stats Item
  Widget _buildStatItem(IconData icon, Color color, String label, String mainVal, String mainSub, String secVal, String secSub) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 14.sp),
              SizedBox(width: 4.w),
              Text(label, style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 8.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: mainVal, style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                TextSpan(text: " $mainSub", style: TextStyle(color: Colors.grey, fontSize: 8.sp)),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: secVal, style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w500)),
                TextSpan(text: " $secSub", style: TextStyle(color: Colors.grey, fontSize: 8.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() => Container(height: 40.h, width: 1.w, color: Colors.grey[300]);

  Widget _buildHistoryCard(String title, String cat, Color catColor, String time, String imgUrl) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(imgUrl, width: 80.w, height: 50.h, fit: BoxFit.cover),
                ),
                Icon(Icons.play_circle_fill, color: Colors.red, size: 24.sp),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(title, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      Text(time, style: TextStyle(fontSize: 8.sp, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
                    decoration: BoxDecoration(color: catColor, borderRadius: BorderRadius.circular(15.r)),
                    child: Text(cat, style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertTile(String contact) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: ListTile(
        leading: Icon(Icons.error, color: Colors.red, size: 35.sp),
        title: Text("Violence Message Detected", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
        subtitle: Text(contact, style: TextStyle(color: Colors.redAccent, fontSize: 12.sp)),
        trailing: Text("10:30 AM >", style: TextStyle(fontSize: 9.sp, color: Colors.grey)),
      ),
    );
  }
}