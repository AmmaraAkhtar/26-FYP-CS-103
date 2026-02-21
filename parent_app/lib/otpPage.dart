import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class otp extends StatefulWidget {
  final String email;
  
  const otp({super.key, required this.email});

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  final TextEditingController _num1 = TextEditingController();
  final TextEditingController _num2 = TextEditingController();
  final TextEditingController _num3 = TextEditingController();
  final TextEditingController _num4 = TextEditingController();

  String error = "";
  String error_message = "";

  void validateOTP() {
    setState(() {
      error = "";
      List<TextEditingController> fields = [_num1, _num2, _num3, _num4];

      for (var f in fields) {
        String val = f.text.trim();
        if (val.isEmpty) {
          error = "All fields are required";
          return; // Stop checking
        }
      }

      error = "";
    });
  }

  Future<void> verifyotp(String num1,String num2,String num3,String num4,String email) async {
    String otp = num1 + num2 + num3 + num4;
    String link = 'http://127.0.0.1:8000/verifyOtp/';
    final url = Uri.parse(link);
    print("Sending OTP verification request with OTP: $otp, Email: $email");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'otp': otp, 'email': email, }),
      );

      if (response.statusCode == 200) {
        print('Verification successful');
      } else {
        var data = jsonDecode(response.body);
        setState(() {
          if (data is Map) {
            error_message = data.values.join("\n");
          } else {
            error_message = data.toString();
          }
        });
      }
    } catch (e) {
      setState(() {
        error_message = "Network error: $e";
      });
    }
  }

  Future<void> resendOtp(String email) async {
    String link = 'http://127.0.0.1:8000/resendOtp/';
    final url = Uri.parse(link);
    print("Sending resend OTP request with Email: $email");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        print('Resend OTP successful');
      } else {
        var data = jsonDecode(response.body);
        setState(() {
          if (data is Map) {
            error_message = data.values.join("\n");
          } else {
            error_message = data.toString();
          }
        });
      }
    } catch (e) {
      setState(() {
        error_message = "Network error: $e";
      });
    }
  }

  void loginbutton() async {
    validateOTP();
    if (error.isEmpty) {
      await verifyotp(
        _num1.text.trim(),
        _num2.text.trim(),
        _num3.text.trim(),
        _num4.text.trim(),
        widget.email,
      );
    }

    if (error_message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error_message)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign Up successful!")),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
    }
  }
  
  void resendOtpButton() async {
    await resendOtp(widget.email);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP resent! Please check your email.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Color(0xFFFBFBFC),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(250.h),
          child: AppBar(
            backgroundColor: Color(0xFFFBFBFC),
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
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
              child: SizedBox(
                width: 1.sw,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "OTP",
                      style: TextStyle(
                        fontSize: 36.sp,
                        color: Color(0xFF699886),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      "We have sent OTP on Your number",
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
                                fillColor: Color(0xFFF1A37A),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    if (error.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 16.sp),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn’t receive a OTP? ",
                          style: TextStyle(fontSize: 18.sp),
                        ),
                        TextButton(
                          onPressed: () => resendOtpButton(),
                          style: ButtonStyle(
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                          ),
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
                        onPressed: () => loginbutton(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Color(0xFFEB9974), width: 2.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                        ),
                        child: Text(
                          'Verify OTP',
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: Color(0xFFE59885),
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
        ),
    
    );
  }
}
