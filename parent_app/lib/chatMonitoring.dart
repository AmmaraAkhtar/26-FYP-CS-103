import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFC),
        elevation: 0,
        title: Text(
          "Chat Monitoring Dashboard",
          style:
              TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Column(
            children: [

              /// PROFILE
              CircleAvatar(
                radius: 60.r,
                backgroundImage: const NetworkImage(
                  "https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png",
                ),
              ),

              SizedBox(height: 10.h),

              Text(
                "Hamza Ali",
                style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold),
              ),

              Text(
                "11 Years Old",
                style:
                    TextStyle(color: Colors.grey, fontSize: 16.sp),
              ),

              SizedBox(height: 30.h),

              /// USAGE
              Text(
                "Usage",
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10.h),

              Image.asset(
                "assets/chat.png",
                height: 150.h,
              ),

              SizedBox(height: 20.h),

              /// RISK CARDS
              riskCard("High Risk", Colors.red, "Ammara"),
              riskCard("Moderate Risk", Colors.orange, "Ammara"),
              riskCard("No Risk", Colors.green, "Ammara"),

              SizedBox(height: 20.h),

              /// ALERT TITLE
              Row(
                children: [
                  Text(
                    "Alerts",
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5.w),
                  Icon(Icons.error,
                      color: Colors.red, size: 20.r),
                ],
              ),

              SizedBox(height: 10.h),

              alertBox("Violent Message Detected"),
              alertBox("Abusive Language Detected"),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= RISK CARD =================
  Widget riskCard(
      String riskLevel, Color riskColor, String contactName) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [

          /// Avatar
          CircleAvatar(
            radius: 25.r,
            backgroundImage: const NetworkImage(
              "https://static.vecteezy.com/system/resources/previews/022/416/248/non_2x/avatar-of-girl-with-pigtails-colored-icon-vector.jpg",
            ),
          ),

          SizedBox(width: 15.w),

          /// CHAT TEXT
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact: $contactName",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14.sp),
                ),
                Text(
                  "Tumhe maar dunga...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    decoration:
                        TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),

          /// RISK SCORE
          Column(
            children: [
              Text(
                "Risk\nScore",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp),
              ),
              SizedBox(height: 5.h),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h),
                decoration: BoxDecoration(
                  color: riskColor,
                  borderRadius:
                      BorderRadius.circular(10.r),
                ),
                child: Text(
                  riskLevel,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight:
                          FontWeight.bold),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  /// ================= ALERT BOX =================
  Widget alertBox(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding:
          EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Icon(Icons.error,
              color: Colors.red, size: 22.r),

          SizedBox(width: 15.w),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 14.sp)),
                Text("10:30 AM",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
