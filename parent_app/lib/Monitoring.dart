import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'youtubeMonitoring.dart';
import 'AlertMonitoring.dart';
import 'chatMonitoring.dart';
import 'webMonitoring.dart';

class Monitoring extends StatefulWidget {
  final Map<String, dynamic>? childData;

  const Monitoring({super.key, this.childData});

  @override
  State<Monitoring> createState() => _MonitoringState();
}

class _MonitoringState extends State<Monitoring> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFC),
        title: Text(
          "Live Monitoring Page",
          style:
              TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),

            child: Column(
              children: [

                SizedBox(height: 20.h),

                /// PROFILE
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
                      Text("Hamza Ali",
                          style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold)),
                      Text("11 Years Old",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.sp)),
                    ],
                  ),
                ),

                SizedBox(height: 25.h),

                /// ROW 1
                Row(
                  children: [
                    Expanded(
                      child: _buildActivityCard(
                        title: "Screen Time",
                        headerColor: const Color(0xFFE8FADC),
                        iconPath: "assets/watch.png",
                        iconColor: Colors.green,
                        mainValue: "2h 30m",
                        subValue: "+1h 30m used",
                        buttonText: "Set Limit",
                        buttonColor: const Color(0xFF8BC34A),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const Youtube ()));
                        },
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildActivityCard(
                        title: "App Usage",
                        headerColor: const Color(0xFFFFD1A4),
                        iconPath: "assets/app.png",
                        iconColor: Colors.orange,
                        mainValue: "2h 30m",
                        subValue: "+1h 30m used",
                        buttonText: "View All »",
                        buttonColor: const Color(0xFFFB8C00),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const Youtube ()));
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                /// ROW 2
                Row(
                  children: [
                    Expanded(
                      child: _buildActivityCard(
                        title: "YouTube Activities",
                        headerColor: const Color(0xFFFFEBEE),
                        iconPath: "assets/youtube1.png",
                        iconColor: Colors.red,
                        mainValue: "2 videos watch",
                        subValue:
                            "Last watched:\nCompusx ML",
                        buttonText: "View All »",
                        buttonColor:
                            const Color(0xFFF44336),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const Youtube ()));
                        },
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildActivityCard(
                        title: "Web Activities",
                        headerColor: const Color(0xFFE3F2FD),
                        iconPath: "assets/web.png",
                        iconColor: Colors.blue,
                        mainValue: "6 blocked sites",
                        subValue:
                            "Most Recent:\nfreev.com",
                        buttonText: "View All »",
                        buttonColor:
                            const Color(0xFF03A9F4),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const Webmonitoring()));
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                /// ALERT BUTTON
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AlertScreen()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 15.h,
                        horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5CBA7),
                      borderRadius:
                          BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error,
                            color: Colors.red,
                            size: 28.r),
                        Expanded(
                          child: Center(
                            child: Text(
                              "View All Alerts",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                  fontWeight:
                                      FontWeight.bold),
                            ),
                          ),
                        ),
                        Icon(
                          Icons
                              .keyboard_double_arrow_right,
                          color: Colors.white,
                          size: 28.r,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ================= CARD =================
  Widget _buildActivityCard({
    required String title,
    required Color headerColor,
    required String iconPath,
    required Color iconColor,
    required String mainValue,
    required String subValue,
    required String buttonText,
    required Color buttonColor,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15.r,
            offset: Offset(0, 8.h),
          )
        ],
      ),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25.r),

        child: Column(
          children: [

            /// HEADER
            Container(
              padding:
                  EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius:
                    BorderRadius.vertical(
                        top:
                            Radius.circular(
                                25.r)),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 14.sp)),
                  Icon(
                    Icons.bar_chart_rounded,
                    color:
                        iconColor.withOpacity(
                            0.7),
                  )
                ],
              ),
            ),

            Padding(
              padding:
                  EdgeInsets.all(12.w),
              child: Row(
                children: [
                  Image.asset(
                    iconPath,
                    width: 45.w,
                    height: 45.h,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(mainValue,
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize:
                                    16.sp)),
                        Text(subValue,
                            style: TextStyle(
                                color:
                                    Colors.grey,
                                fontSize:
                                    11.sp)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Divider(),

            SizedBox(
              height: 32.h,
              child: ElevatedButton(
                onPressed: onTap,
                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      buttonColor,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            20.r),
                  ),
                ),
                child: Text(buttonText,
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight:
                            FontWeight.bold)),
              ),
            ),

            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}