import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OTP extends StatefulWidget {
  final String email;
  const OTP({super.key, required this.email});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final TextEditingController _num1 = TextEditingController();
  final TextEditingController _num2 = TextEditingController();
  final TextEditingController _num3 = TextEditingController();
  final TextEditingController _num4 = TextEditingController();

  String error = "";
  String errorMessage = "";

  void validateOTP() {
    setState(() {
      error = "";
      List<TextEditingController> fields = [_num1, _num2, _num3, _num4];
      for (var f in fields) {
        if (f.text.trim().isEmpty) {
          error = "All fields are required";
          return;
        }
      }
    });
  }

  Future<void> verifyOTP() async {
    String otp = _num1.text + _num2.text + _num3.text + _num4.text;
    String link = 'http://10.27.190.96:8000/verifyOtp/';

    try {
      final response = await http.post(
        Uri.parse(link),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'otp': otp, 'email': widget.email}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verification successful!")),
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const login()));
      } else {
        var data = jsonDecode(response.body);
        setState(() {
          if (data is Map) {
            errorMessage = data.values.join("\n");
          } else {
            errorMessage = data.toString();
          }
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Network error: $e";
      });
    }
  }

  Future<void> resendOTP() async {
    String link = 'http://10.27.190.96:8000/resendOtp/';

    try {
      await http.post(
        Uri.parse(link),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email}),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP resent! Please check your email.")),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Network error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFB),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250.h),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Hero(
              tag: 'applog',
              child: Image.asset('assets/logo.png', width: 189, height: 189),
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
                SizedBox(height: 20.h),
                Text(
                  "OTP",
                  style: TextStyle(
                    fontSize: 36.sp,
                    color: const Color(0xFF699886),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  "We have sent OTP to your email",
                  style: TextStyle(fontSize: 18.sp),
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
                            color: Colors.white,
                          ),
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
                if (error.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 16.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn’t receive an OTP? ",
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    TextButton(
                      onPressed: resendOTP,
                      style: ButtonStyle(
                          padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.zero)),
                      child: Text(
                        "Resend OTP",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: 285.w,
                  height: 47.h,
                  child: ElevatedButton(
                    onPressed: () {
                      validateOTP();
                      if (error.isEmpty) verifyOTP();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: const Color(0xFFEB9974), width: 2.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                    ),
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: const Color(0xFFE59885),
                        fontWeight: FontWeight.bold,
                      ),
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