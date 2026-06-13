// import 'package:flutter/material.dart';
// import 'splashScreen.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'lockScreen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//      return  ScreenUtilInit(
//       designSize: const Size(393, 852),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//      return MaterialApp(
//       debugShowCheckedModeBanner: false,

//       home:splashpage(),
      
//     );
//   },
//   );
//   }
// }

import 'package:flutter/material.dart';
import 'splashScreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'lockScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String initialRoute =
        WidgetsBinding.instance.platformDispatcher.defaultRouteName;

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: initialRoute == '/lock'
              ? lockScreen()
              : splashpage(),
        );
      },
    );
  }
}