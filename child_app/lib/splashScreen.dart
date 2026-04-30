import 'package:flutter/material.dart';
import 'codePage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat.dart';

class splashpage extends StatefulWidget {
  const splashpage({super.key});

  @override
  State<splashpage> createState() => _splashpageState();
}


class _splashpageState extends State<splashpage> {
  Future<void> checkChildSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  int? childId = prefs.getInt("child_id");
  int? screenLimit = prefs.getInt("screen_limit");

  if (childId != null && screenLimit != null) {
    // Already paired → direct WatcherScreen
    Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WatcherScreen(screen_limit:screenLimit, child_id: childId)),
        );
  } else {
    // Not paired → OTP screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => otp()),
    );
  }
}
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => otp()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xFFFBFBFC),
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'applog',
              child: Image.asset('assets/logo.png', width: 300.w, height: 300.h ),
            ),
          ],
        ),
      ),
    );
  }
}
