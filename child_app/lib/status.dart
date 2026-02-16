import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class status extends StatefulWidget {
  const status({super.key});

  @override
  State<status> createState() => _statusState();
}

class _statusState extends State<status> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
            padding: const EdgeInsets.only(top: 50), // top space
            child: Hero(
              tag: 'applog',
              child: Image.asset('assets/logo.png', height: 189.h),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 0),
            child: SizedBox(
              width: 1.sw,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Child Agent: Status",
                    style: TextStyle(
                      fontSize:36.sp,
                      color: Color(0xFF699886),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Image.asset("assets/SystemInformation.png", height:250.h, width:250.w),
                  SizedBox(height:80.h),
                  Text("All systems green.", style:TextStyle(fontSize:20.sp, color:Color(0xFF8D7365), fontWeight: FontWeight.bold)),
                   Text("Your child is protected.", style:TextStyle(fontSize:20.sp, color:Color(0xFF8D7365), fontWeight: FontWeight.bold)),
                    
                    SizedBox(height:20.h),
                     Text("Last Sync: Just now", style:TextStyle(fontSize:18.sp, color:Color(0xFF8D7365))),





                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}