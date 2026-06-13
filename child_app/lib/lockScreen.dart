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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'lock_service.dart';
import 'chat.dart';

// class lockScreen extends StatefulWidget {
//   const lockScreen({super.key});

//   @override
//   State<lockScreen> createState() => _lockScreenState();
// }

// class _lockScreenState extends State<lockScreen> {

//   @override
//   void initState() {
//     super.initState();

//     // Disable back button
//     SystemChrome.setEnabledSystemUIMode(
//       SystemUiMode.manual,
//       overlays: [],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {

//     return WillPopScope(

//       onWillPop: () async => false,

//       child: Scaffold(

//         backgroundColor: Colors.black,

//         body: Center(

//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,

//             children: [

//               Icon(
//                 Icons.lock,
//                 color: Colors.red,
//                 size: 120,
//               ),

//               SizedBox(height: 30),

//               Text(
//                 "DEVICE LOCKED",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               SizedBox(height: 20),

//               Text(
//                 "Waiting for Parent Approval",
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 18,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class lockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<lockScreen> with WidgetsBindingObserver {
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startPolling();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(Duration(seconds: 15), (_) async {
      await _checkUnlock();
    });
  }

  Future<void> _checkUnlock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int childId = prefs.getInt("child_id") ?? -1;
    if (childId == -1) return;

    try {
      final res = await http.get(
        Uri.parse("http://192.168.18.163:8000/check-lock-status/?child_id=$childId"),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data["is_locked"] == false) {
          await LockService.unlockDevice();
          _pollTimer?.cancel();
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => WatcherScreen(screen_limit: 0, child_id: childId)),
              (route) => false,
            );
          }
        }
      }
    } catch (e) {
      print("Unlock check failed: $e");
    }
  }

  @override
  Future<bool> didPopRoute() async => true; // back button block

  @override
  void dispose() {
    _pollTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // back disable
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 80, color: Colors.red),
              SizedBox(height: 20),
              Text("Device Locked", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text("Parent ne is device ko lock kiya hai."),
            ],
          ),
        ),
      ),
    );
  }
}