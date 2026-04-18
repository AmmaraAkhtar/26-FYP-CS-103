import 'package:flutter/material.dart';
import 'splashScreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'AlertMonitoring.dart';
import 'appUsage.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
          return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:AppUsageMonitoringScreen(),
      // AlertMonitoringDashboard(),
      // AppUsageMonitoringScreen(),
      // AlertMonitoringDashboard(),
      // YoutubeActivityScreen(),

      // splashpage(),
    );
    }
    
    ,);
  }
}
