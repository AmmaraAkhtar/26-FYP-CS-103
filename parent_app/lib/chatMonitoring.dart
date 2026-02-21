import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class chat extends StatefulWidget {
  const chat({super.key});

  @override
  State<chat> createState() => _chatState();
}

class _chatState extends State<chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: const Color(0xFFFBFBFC),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFBFBFC),
          title: Text(
            "Chat Monitoring Dashboard",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Section
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60.r,
                        backgroundImage: NetworkImage(
                            "https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png"),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Hamza Ali",
                        style: TextStyle(
                            fontSize: 30.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "11 Years Old",
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                // Usage Section Title
                Text("Usage",
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.h),
                // Placeholder for Graph
                Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/chat.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // Chat Risk Cards
                riskCard("High Risk", Colors.red, "Ammara"),
                riskCard("Moderate Risk", Colors.orange, "Ammara"),
                riskCard("No Risk", Colors.green, "Ammara"),
                riskCard("Moderate Risk", Colors.orange, "Ammara"),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(
                      "Alerts",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.w),
                    Icon(Icons.error, color: Colors.red, size: 20.r),
                  ],
                ),
                SizedBox(height: 10.h),
                // Alert Boxes
                alertBox("Violent Message Detected"),
                alertBox("Violent Video Detected"),
              ],
            ),
          ),
        ),

      backgroundColor: Color(0xFFFAFBFB),
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: const Text(
          "Chat Monitoring Dashboard",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
              ),
              const SizedBox(height: 30),

              // Usage Section Title
              const Text(
                "Usage",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Placeholder for Graph (Using a Container to mimic the chart)
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/chat.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Chat Risk Cards
              riskCard("High Risk", Colors.red, "Ammara"),
              riskCard("Moderate Risk", Colors.orange, "Ammara"),
              riskCard("No Risk", Colors.green, "Ammara"),
              riskCard("Moderate Risk", Colors.orange, "Ammara"),

              const SizedBox(height: 10),
              Row(
                children: const [
                  Text(
                    "Alerts",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.error, color: Colors.red, size: 20),
                ],
              ),
              const SizedBox(height: 10),

              // Alert Boxes
              alertBox("Violent Message Detected"),
              alertBox("Violent Video Detected"),
            ],
          ),
        ),
      ),
    );
  }

  // Risk Card Widget
  Widget riskCard(String riskLevel, Color riskColor, String contactName) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.orange.shade200,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5.r,
              offset: Offset(0, 3.h))

        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),

        ],
      ),
      child: Row(
        children: [

          CircleAvatar(
            radius: 25.r,
            backgroundImage: NetworkImage(
                'https://static.vecteezy.com/system/resources/previews/022/416/248/non_2x/avatar-of-girl-with-pigtails-colored-icon-vector.jpg'),

          const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              'https://static.vecteezy.com/system/resources/previews/022/416/248/non_2x/avatar-of-girl-with-pigtails-colored-icon-vector.jpg',
            ), // Avatar image

          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact Name: $contactName",

                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14.sp),
                ),
                Text(
                  "Tumha mana mar dana hy, mar dana hy",
                  style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      fontSize: 12.sp),

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Tumha mana mar dana hy, mar dana hy",
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontSize: 12,
                  ),

              ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Text(
                "Risk\nScore",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 10.sp),
              ),
              SizedBox(height: 5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),

              const Text(
                "Risk\nScore",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: riskColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),

                child: Text(riskLevel,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold)),

                child: Text(
                  riskLevel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
            ],
          ),
        ],
      ),
    );
  }

  // Alert Box Widget
  Widget alertBox(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red, size: 20.r),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 14.sp)),
                Text("10:30 AM",
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp)),

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  "10:30 AM",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),

              ],
            ),
          ),
          Icon(Icons.error, color: Colors.red, size: 20.r),
        ],
      ),
    );
  }
}
