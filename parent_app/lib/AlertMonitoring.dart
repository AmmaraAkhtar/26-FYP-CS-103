import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),

      /// ===== APPBAR =====
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFC),
        elevation: 0,
        title: Text(
          "Alert Monitoring Dashboard",
          style:
              TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),

      /// ===== BODY =====
      body: SafeArea(
        child: Column(
          children: [

            SizedBox(height: 25.h),

            /// ===== CHILD PROFILE =====
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
                        fontSize: 28.sp,
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

            SizedBox(height: 30.h),

            /// ===== ALERT HEADER =====
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Row(
                children: [
                  Text(
                    "Alerts",
                    style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    width: 35.w,
                    height: 35.h,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "!",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 20.h),

            /// ===== ALERT LIST =====
            Expanded(
              child: ListView(
                padding:
                    EdgeInsets.symmetric(horizontal: 25.w),
                children: [

                  _buildAlertCard(
                    title: "Toxic Language Detected",
                    subtitle:
                        "Bullying in Social Media Chat",
                    color: Colors.red,
                    icon: Icons.security,
                    time: "15 min ago",
                    buttons: [
                      _buildActionButton(
                          "Block Source", Colors.red)
                    ],
                  ),

                  _buildAlertCard(
                    title: "Late Night Usage",
                    subtitle:
                        "App Activity after Bedtime",
                    color: Colors.orange,
                    icon: Icons.person_off_rounded,
                    time: "15 min ago",
                    buttons: [
                      _buildActionButton(
                          "Extend Limit",
                          Colors.orange),
                      SizedBox(width: 10.w),
                      _buildActionButton(
                          "Lock Screen",
                          Colors.orange),
                    ],
                  ),

                  _buildAlertCard(
                    title: "Behavior",
                    subtitle:
                        "Signs of Anxiety Detected",
                    color: const Color(0xFF8B428D),
                    icon: Icons.psychology,
                    time: "15 min ago",
                    buttons: [
                      _buildActionButton(
                          "View Suggestions",
                          const Color(0xFF8B428D))
                    ],
                  ),

                  _buildAlertCard(
                    title: "Mood Analysis",
                    subtitle: "Signs of Happiness",
                    color: const Color(0xFFB8731D),
                    icon: Icons.lightbulb,
                    time: "15 min ago",
                    buttons: [
                      _buildActionButton(
                          "Extend Limit",
                          const Color(0xFFB8731D))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===== ALERT CARD =====
  Widget _buildAlertCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required String time,
    required List<Widget> buttons,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [

          Row(
            children: [
              Icon(icon, color: color, size: 35.r),
              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: color,
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 16.sp)),
                    Text(subtitle,
                        style: TextStyle(
                            color: color,
                            fontSize: 15.sp)),
                    SizedBox(height: 6.h),
                    Text(time,
                        style: TextStyle(
                            color: color
                                .withOpacity(0.8))),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: buttons,
          )
        ],
      ),
    );
  }

  /// ===== BUTTON =====
  Widget _buildActionButton(
      String label, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: 20.w, vertical: 6.h),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp),
      ),
    );
  }
}