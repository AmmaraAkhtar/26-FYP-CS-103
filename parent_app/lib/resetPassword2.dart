import 'package:flutter/material.dart';
import 'dart:convert';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Resetpassword2 extends StatefulWidget {
  final String email;
  const Resetpassword2({super.key, required this.email});

  @override
  State<Resetpassword2> createState() => _Resetpassword2State();
}

class _Resetpassword2State extends State<Resetpassword2> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  String passwordError = "";
  String confirmPasswordError = "";
  String error_message = "";

  void validatePassword() {
    final value = _password.text.trim();
    setState(() {
      if (value.isEmpty) {
        passwordError = "Password required";
      } else if (value.length < 8) {
        passwordError = "Minimum 8 characters";
      } else {
        passwordError = "";
      }
    });
  }

  void validateConfirmPassword() {
    final pass = _password.text.trim();
    final confirm = _confirmPassword.text.trim();
    setState(() {
      if (confirm.isEmpty) {
        confirmPasswordError = "Please confirm password";
      } else if (pass.isEmpty) {
        confirmPasswordError = "Password field is empty";
      } else if (pass != confirm) {
        confirmPasswordError = "Passwords do not match";
      } else {
        confirmPasswordError = "";
      }
    });
  }

  Future<void> resetPasswordRequest(String email, String password) async {
    String link = 'http://127.0.0.1:8000/resetPassword/';
    final url = Uri.parse(link);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'new_password': password}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password reset successfully!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
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

  void resetButton() async {
    validatePassword();
    validateConfirmPassword();

    if (passwordError.isEmpty && confirmPasswordError.isEmpty) {
      await resetPasswordRequest(widget.email, _password.text.trim());
      _password.clear();
      _confirmPassword.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xFFFBFBFC),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(250.h),
          child: AppBar(
             backgroundColor: Color(0xFFFBFBFC),
            elevation: 0,
            centerTitle: true,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
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
                      "Reset Password",
                      style: TextStyle(
                        fontSize: 36.sp,
                        color: Color(0xFF699886),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Error message
                    Text(
                      error_message.isEmpty ? " " : error_message,
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                    SizedBox(height: 10.h),

                    // Password TextField
                    SizedBox(
                      width: 350.w,
                      child: TextField(
                        controller: _password,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Enter Your Password',
                          hintStyle: TextStyle(color: Color(0xFFbdbcbc), fontSize: 16.sp),
                          errorText: passwordError.isEmpty ? null : passwordError,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.r),
                            borderSide: BorderSide(color: Color(0xFFbdbcbc), width: 1.4.w),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Color(0xFF147CF4), width: 2.w),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: Colors.red, width: 2.w),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: Colors.red, width: 2.w),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Confirm Password TextField
                    SizedBox(
                      width: 350.w,
                      child: TextField(
                        controller: _confirmPassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Re-enter Your Password',
                          hintStyle: TextStyle(color: Color(0xFFbdbcbc), fontSize: 16.sp),
                          errorText: confirmPasswordError.isEmpty ? null : confirmPasswordError,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.r),
                            borderSide: BorderSide(color: Color(0xFFbdbcbc), width: 1.4.w),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Color(0xFF147CF4), width: 2.w),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: Colors.red, width: 2.w),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: Colors.red, width: 2.w),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 60.h),

                    // Reset Button
                    SizedBox(
                      width: 285.w,
                      height: 47.h,
                      child: ElevatedButton(
                        onPressed: resetButton,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEB9974),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                        ),
                        child: Text(
                          'Reset',
                          style: TextStyle(fontSize: 22.sp, color: Colors.white, fontWeight: FontWeight.bold),
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
