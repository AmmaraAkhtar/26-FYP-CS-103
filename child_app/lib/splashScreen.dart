// import 'package:flutter/material.dart';
// import 'codePage.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'chat.dart';

// class splashpage extends StatefulWidget {
//   const splashpage({super.key});

//   @override
//   State<splashpage> createState() => _splashpageState();
// }


// class _splashpageState extends State<splashpage> {
//   Future<void> checkChildSession() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   int? childId = prefs.getInt("child_id");
//   int? screenLimit = prefs.getInt("screen_limit");

//   if (childId != null && screenLimit != null) {
//     // Already paired → direct WatcherScreen
//     Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => WatcherScreen(screen_limit:screenLimit, child_id: childId)),
//         );
//   } else {
//     // Not paired → OTP screen
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => otp()),
//     );
//   }
// }
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Future.delayed(Duration(seconds: 2), () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => otp()),
//         );
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//        backgroundColor: Color(0xFFFBFBFC),
//       body: SizedBox(
//         width: 1.sw,
//         height: 1.sh,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Hero(
//               tag: 'applog',
//               child: Image.asset('assets/logo.png', width: 300.w, height: 300.h ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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

    print(" Stored child_id: $childId");
    print(" Stored screen_limit: $screenLimit");

    if (childId != null && screenLimit != null) {
      // Pehle se paired hai → WatcherScreen
      print("Already paired → Going to WatcherScreen");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WatcherScreen(
            screen_limit: screenLimit,
            child_id: childId,
          ),
        ),
      );
    } else {
      // Pehli baar → OTP screen
      print(" Not paired → Going to OTP");
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
        checkChildSession(); // Fix - seedha OTP nahi
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
              child: Image.asset(
                'assets/logo.png',
                width: 300.w,
                height: 300.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}