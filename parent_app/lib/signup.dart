import 'package:flutter/material.dart';
import 'login.dart';
import 'otpPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  String usernameError = "";
  String emailError = "";
  String passwordError = "";
  String confirmPasswordError = "";
  String error_message = "";

  void validateUsername() {
    final value = _username.text.trim();
    final regex = RegExp(r'^[a-zA-Z0-9_]+$');

    setState(() {
      if (value.isEmpty) {
        usernameError = "Username required";
      } else if (!regex.hasMatch(value)) {
        usernameError = "Only letters, numbers & _ allowed";
      } else {
        usernameError = "";
      }
    });
  }

  void validateEmail() {
    final value = _email.text.trim();

    setState(() {
      if (value.isEmpty) {
        emailError = "Email required";
      } else if (!value.contains('@')) {
        emailError = "Invalid email";
      } else {
        emailError = "";
      }
    });
  }

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

  Future<void> signupRequest(
    String username,
    String email,
    String password,
  ) async {
    //String link = 'http://127.0.0.1:8000/signup/';
    String link = 'http://10.27.190.96:8000/signup/';
    final url = Uri.parse(link);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => otp(email: email),
          ),
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

  void submit() async {
    validateUsername();
    validateEmail();
    validatePassword();
    validateConfirmPassword();

    if (usernameError.isEmpty &&
        emailError.isEmpty &&
        passwordError.isEmpty &&
        confirmPasswordError.isEmpty) {
      await signupRequest(
        _username.text.trim(),
        _email.text.trim(),
        _password.text.trim(),
      );
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
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 36.sp,
                      color: Color(0xFF699886),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    error_message.isEmpty ? " " : error_message,
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                  ),
                  SizedBox(height: 10.h),

                  // Username
                  SizedBox(
                    width: 350.w,
                    child: TextField(
                      controller: _username,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Username',
                        hintStyle: TextStyle(
                          color: Color(0xFFbdbcbc),
                          fontSize: 16.sp,
                        ),
                        errorText: usernameError.isEmpty ? null : usernameError,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.r),
                          borderSide: BorderSide(
                            color: Color(0xFFbdbcbc),
                            width: 1.4.w,
                          ),
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

                  // Email
                  SizedBox(
                    width: 350.w,
                    child: TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Email',
                        hintStyle: TextStyle(color: Color(0xFFbdbcbc), fontSize: 16.sp),
                        errorText: emailError.isEmpty ? null : emailError,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: Color(0xFFbdbcbc), width: 1.4.w),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.r),
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

                  // Password
                  SizedBox(
                    width: 350.w,
                    child: TextField(
                      obscureText: true,
                      controller: _password,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
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

                  // Confirm Password
                  SizedBox(
                    width: 350.w,
                    child: TextField(
                      obscureText: true,
                      controller: _confirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(color: Color(0xFFbdbcbc), fontSize: 16.sp),
                        errorText: confirmPasswordError.isEmpty ? null : confirmPasswordError,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: Color(0xFFbdbcbc), width: 1.4.w),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.r),
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

                  SizedBox(height: 40.h),

                  // Sign Up Button
                  SizedBox(
                    width: 285.w,
                    height: 47.h,
                    child: ElevatedButton(
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Color(0xFFEB9974), width: 2.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 22.sp, color: Color(0xFFE59885), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 16.sp, color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => login()),
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 16.sp, color: Color(0xFF3383D6)),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 25.h),

                  // Login Button
                  SizedBox(
                    width: 285.w,
                    height: 47.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => login()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEB9974),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                      ),
                      child: Text(
                        'Login',
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
