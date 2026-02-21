import 'package:flutter/material.dart';
import 'welcome.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class splashpage extends StatefulWidget {
  const splashpage({super.key});

  @override
  State<splashpage> createState() => _splashpageState();
}

class _splashpageState extends State<splashpage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 6), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => welcome()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFC),
      body: SafeArea(child:  
      
       SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'applog',
              child: Image.asset('assets/logo.png', width: 300.w, height: 300.h),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
