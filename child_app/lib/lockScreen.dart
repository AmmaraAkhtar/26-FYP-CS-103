import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart  ';

class lockScreen extends StatelessWidget {
  const lockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "Screen Time Limit Reached",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}