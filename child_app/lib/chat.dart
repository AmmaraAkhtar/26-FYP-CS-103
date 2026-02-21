import 'package:flutter/material.dart';
import 'status.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WatcherScreen extends StatefulWidget {
  @override
  _WatcherScreenState createState() => _WatcherScreenState();
}

class _WatcherScreenState extends State<WatcherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250.h), // AppBar ka height adjust
        child: AppBar(
           backgroundColor: Color(0xFFFBFBFC),
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: 50.h), // top space
            child: Hero(
              tag: 'applog',
              child: Image.asset('assets/logo.png',  height: 189.h),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0,10, 30),
          child: Column(
            children: [
               Text(
                    "Permissions",
                    style: TextStyle(
                      fontSize: 36.sp,
                      color: Color(0xFF699886),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
              Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5CD97),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/OneTimePassword.png",
                      width: 50.w,
                      height: 50.h,
                    ),
                    SizedBox(width: 12.w),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text(
                          "Usage Access",
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Color(0xFF8D7365),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Monitoring kids online",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Color(0xFFAF8067),
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    Switch(value: true, onChanged: null),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(bottom: 12.w),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5CD97),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/AccessibilityTools.png",
                      width: 50.w,
                      height: 50.h,
                    ),
                   SizedBox(width: 12.w),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text(
                          "Accessibility Services",
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Color(0xFF8D7365),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Foreground services",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Color(0xFFAF8067),
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    Switch(value: true, onChanged: null),
                  ],
                ),
              ),

              Container(
                margin:  EdgeInsets.only(bottom: 12.w),
                padding:  EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5CD97),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Image.asset("assets/Alarm.png", width: 50.w, height: 50.h),
                    SizedBox(width: 12.w),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text(
                          "Notification Access",
                          style: TextStyle(
                            color: Color(0xFF8D7365),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "To view all notifications",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Color(0xFFAF8067),
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    Switch(value: true, onChanged: null),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(bottom: 12.w),
                padding:  EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5CD97),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Image.asset("assets/UserShield.png", width: 50.w, height: 50.h),
                    SizedBox(width: 12.w),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Account Activity",
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Color(0xFF8D7365),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "To view account activity",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Color(0xFFAF8067),
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    Switch(value: true, onChanged: null),
                  ],
                ),
              ),

              SizedBox(height: 25.h),

              SizedBox(
                width: 285.w,
                height: 47.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => status()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEB9974),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
