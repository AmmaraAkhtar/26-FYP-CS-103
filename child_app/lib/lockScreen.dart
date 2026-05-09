// import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart  ';

// class lockScreen extends StatelessWidget {
//   const lockScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Text(
//           "Screen Time Limit Reached",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class lockScreen extends StatefulWidget {
  const lockScreen({super.key});

  @override
  State<lockScreen> createState() => _lockScreenState();
}

class _lockScreenState extends State<lockScreen> {

  @override
  void initState() {
    super.initState();

    // Disable back button
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(

      onWillPop: () async => false,

      child: Scaffold(

        backgroundColor: Colors.black,

        body: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Icon(
                Icons.lock,
                color: Colors.red,
                size: 120,
              ),

              SizedBox(height: 30),

              Text(
                "DEVICE LOCKED",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Waiting for Parent Approval",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}