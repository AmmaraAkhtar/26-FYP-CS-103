import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: Webmonitoring()),
  );
}

class Webmonitoring extends StatefulWidget {
  const Webmonitoring({super.key});

  @override
  State<Webmonitoring> createState() => _WebmonitoringState();
}

class _WebmonitoringState extends State<Webmonitoring> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: const Color(0xFFFBFBFC),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFBFBFC),
          elevation: 0,
          title: Text(
            "Chat Monitoring Dashboard",
            style: TextStyle(
                fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header Section ---
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60.r,
                        backgroundImage: const NetworkImage(
                            "https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png"),
                      ),
                      SizedBox(height: 8.h),
                      Text("Hamza Ali",
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.bold)),
                      Text("11 Years Old",
                          style: TextStyle(color: Colors.grey, fontSize: 16.sp)),
                    ],
                  ),

      backgroundColor: Color(0xFFFAFBFB),
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: const Text(
          "Chat Monitoring Dashboard",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header Section ---
              Center(
                child: Column(
                  children: const [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        "https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png",
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Hamza Ali",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "11 Years Old",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],

                ),
                SizedBox(height: 30.h),

                // --- Tab Buttons ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTab("Today", isSelected: true),
                    _buildTab("This Week"),
                    _buildTab("This Month"),
                  ],
                ),
                SizedBox(height: 25.h),

                // --- Table Headers ---
                Row(
                  children: [
                    Expanded(flex: 3, child: _buildSmallLabel("Title")),
                    SizedBox(width: 8.w),
                    Expanded(flex: 2, child: _buildSmallLabel("Time Spend")),
                    SizedBox(width: 8.w),
                    Expanded(flex: 2, child: _buildSmallLabel("Category")),
                    SizedBox(width: 8.w),
                    Expanded(flex: 1, child: _buildSmallLabel("Block")),
                  ],
                ),
                SizedBox(height: 12.h),


                // --- History List ---
                _buildHistoryRow("youtube.com", "1h10min", "Violence", Colors.red),
                _buildHistoryRow("youtube.com", "1h10min", "Educational", Colors.blueAccent),
                _buildHistoryRow("youtube.com", "1h10min", "Violence", Colors.red),
                _buildHistoryRow("youtube.com", "1h10min", "Gaming", Colors.green),
                _buildHistoryRow("youtube.com", "1h10min", "Educational", Colors.blueAccent),
                _buildHistoryRow("youtube.com", "1h10min", "Gaming", Colors.green),

              // --- History List ---
              _buildHistoryRow(
                "youtube.com",
                "1h10min",
                "Violence",
                Colors.red,
              ),
              _buildHistoryRow(
                "youtube.com",
                "1h10min",
                "Educational",
                Colors.blueAccent,
              ),
              _buildHistoryRow(
                "youtube.com",
                "1h10min",
                "Violence",
                Colors.red,
              ),
              _buildHistoryRow(
                "youtube.com",
                "1h10min",
                "Gaming",
                Colors.green,
              ),
              _buildHistoryRow(
                "youtube.com",
                "1h10min",
                "Educational",
                Colors.blueAccent,
              ),
              _buildHistoryRow(
                "youtube.com",
                "1h10min",
                "Gaming",
                Colors.green,
              ),

                SizedBox(height: 30.h),


                // --- Alerts Section ---
                Row(
                  children: [
                    Text("Alerts",
                        style:
                            TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                    SizedBox(width: 5.w),
                    Icon(Icons.error, color: Colors.red, size: 22.r),
                  ],
                ),
                SizedBox(height: 15.h),
                _buildAlertTile("Violent Massage Detected", "10:30 AM"),
                SizedBox(height: 10.h),
                _buildAlertTile("Violent Video Detected", "10:30 AM"),
              ],
            ),

              // --- Alerts Section ---
              const Row(
                children: [
                  Text(
                    "Alerts",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.error, color: Colors.red, size: 22),
                ],
              ),
              const SizedBox(height: 15),
              _buildAlertTile("Violent Massage Detected", "10:30 AM"),
              const SizedBox(height: 10),
              _buildAlertTile("Violent Video Detected", "10:30 AM"),
            ],

          ),
        ),
    );
  }

  // --- UI Helper Methods ---

  Widget _buildTab(String label, {bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(

          color: isSelected ? const Color(0xFF92B4C8) : const Color(0xFFE89B7D),
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4))
          ]),
      child: Text(label,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),

        color: isSelected ? const Color(0xFF92B4C8) : const Color(0xFFE89B7D),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4)),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),

    );
  }

  Widget _buildSmallLabel(String text) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE89B7D),
        borderRadius: BorderRadius.circular(10.r),
      ),

      child: Text(text,
          style: TextStyle(
              color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold)),

      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),

    );
  }

  Widget _buildHistoryRow(
    String title,
    String time,
    String category,
    Color catColor,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF2A684),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,

            child: Text(title,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500, fontSize: 11.sp)),

            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),

          ),
          Expanded(
            flex: 2,
            child: Center(

              child: Text(time,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11.sp)),

              child: Text(
                time,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),

            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                decoration: BoxDecoration(

                    color: catColor, borderRadius: BorderRadius.circular(20.r)),
                child: Text(category,
                    style: TextStyle(
                        color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),

                  color: catColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              decoration: BoxDecoration(

                  color: Colors.red, borderRadius: BorderRadius.circular(5.r)),
              child: Text("Yes",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.sp),
                  textAlign: TextAlign.center),

                color: Colors.red,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),

            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertTile(String msg, String time) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFCCB3),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red, size: 30.r),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(msg,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: const Color(0xFF635D5D))),
                Text(time, style: TextStyle(color: Colors.grey, fontSize: 11.sp)),

                Text(
                  msg,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF635D5D),
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),

              ],
            ),
          ),
          Icon(Icons.error, color: Colors.red, size: 30.r),
        ],
      ),
    );
  }
}
