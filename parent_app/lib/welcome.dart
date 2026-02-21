import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class welcome extends StatefulWidget {
  const welcome({super.key});

  @override
  State<welcome> createState() => _welcomeState();
}

class _welcomeState extends State<welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFC),
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,

        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),

              Image.asset('assets/logo.png', height: 320.h  , width:320.w),

              SizedBox(height: 30.h),

              // Hello Text
              // Text(
              //   'Hello',
              //   style: TextStyle(
              //     fontSize: 36,
              //     fontWeight: FontWeight.bold,
              //     color: Color(0xFF699886),
              //   ),
              // ),

              // SizedBox(height: 30),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: 25.sp, color: Colors.grey[700]),
                  children: <TextSpan>[
                    TextSpan(text: 'Welcome to the '),
                    TextSpan(
                      text: 'The Watcher',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          ',\nwhere parents can monitor the\n activities of their off springs.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60.h),

              // Login Button
              SizedBox(
                width: 285.w,
                height: 47.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => login()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEB9974),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),

              SizedBox(
                width: 285.w,
                height: 47.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Color(0xFFEB9974), width: 3.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: Color(0xFFE59885),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
