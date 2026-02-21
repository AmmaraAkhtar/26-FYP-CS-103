import 'package:flutter/material.dart';
import 'chat.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class otp extends StatefulWidget {
  const otp({super.key});

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  final TextEditingController _num1 = TextEditingController();
  final TextEditingController _num2 = TextEditingController();
  final TextEditingController _num3 = TextEditingController();
  final TextEditingController _num4 = TextEditingController();

  String error_message = "";

  void validateOTP() {
    List<TextEditingController> fields = [_num1, _num2, _num3, _num4];
    for (var f in fields) {
      if (f.text.trim().isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("All fields must be filled")));
        return;
      }
    }
    // All fields filled
    handleSubmit();
  }

  Future<void> verifyOTP(String code) async {
    String link = 'http://10.27.190.96:8000/pairDevice/';
    final url = Uri.parse(link);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'pairing_code': code}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Pairing successful!")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WatcherScreen()),
        );
      } else {
        var data = jsonDecode(response.body);
        setState(() {
          error_message = data is Map ? data.values.join("\n") : data.toString();
        });
        if (error_message.isNotEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error_message)));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Network error: $e")));
    }
  }

  void handleSubmit() {
    String code = _num1.text + _num2.text + _num3.text + _num4.text;
    verifyOTP(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250.h),
        child: AppBar(
          backgroundColor: const Color(0xFFFBFBFC),
          elevation: 0,
          centerTitle: true,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: 50.h),
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
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Protecting Code",
                  style: TextStyle(
                      fontSize: 36.sp,
                      color: const Color(0xFF699886),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Enter the 4-digit Code from the parent App",
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (var controller in [_num1, _num2, _num3, _num4])
                      SizedBox(
                        width: 55.w,
                        height: 55.h,
                        child: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: const Color(0xFFF1A37A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 45.h),
                SizedBox(
                  width: 285.w,
                  height: 47.h,
                  child: ElevatedButton(
                    onPressed: validateOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEB9974),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                    ),
                    child: Text(
                      'Pair Now',
                      style: TextStyle(
                          fontSize: 22.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}