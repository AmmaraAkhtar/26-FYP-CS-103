import 'package:flutter/material.dart';
import 'signup.dart';
import 'resetPassword1.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'homePage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  String email_error = "";
  String password_error = "";
  String error_message = "";
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  Future<void> loginRequest(String email, String password) async {
    //String link = 'http://127.0.0.1:8000/login/';
    String link = 'http://10.27.190.96:8000/login/';
    final url = Uri.parse(link);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        print('Login successful');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => home(email: email,)),
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

  void validate_email() {
    String email = _email.text.trim();
    if (email.isEmpty) {
      setState(() {
        email_error = "Must enter the email";
      });
    } else if (!email.contains('@')) {
      setState(() {
        email_error = "Please enter a valid email";
      });
    } else {
      setState(() {
        email_error = "";
      });
    }
  }

  void validate_password() {
    String password = _password.text.trim();
    if (password.isEmpty) {
      setState(() {
        password_error = "Must enter the Password";
      });
    } else if (password.length < 8) {
      setState(() {
        password_error = "password mut contain atleast 8 characters";
      });
    } else {
      setState(() {
        password_error = "";
      });
    }
  }

  void loginbutton() async {
    validate_email();
    validate_password();
    await loginRequest(_email.text.trim(), _password.text.trim());

    if (email_error.isEmpty && password_error.isEmpty) {
      _email.clear();
      _password.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFC),
           appBar: PreferredSize(
          preferredSize: Size.fromHeight(250.h),
          child: AppBar(
            backgroundColor:Color(0xFFFBFBFC) ,

             // ⭐ IMPORTANT — scroll par color change band
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,

            elevation: 0,
            centerTitle: true,
            flexibleSpace: Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Hero(
                tag: 'applog',
                child: Image.asset('assets/logo.png',  height: 189.h),
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
                    "Login",
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

                  // Email TextField
                  SizedBox(
                    width: 350.w,
                    child: TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Email',
                        errorText: email_error.isEmpty ? null : email_error,
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 189, 188, 188),
                          fontSize: 16.sp,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.r),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 189, 188, 188),
                            width: 1.4.w,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(
                            color: Color(0xFF147CF4),
                            width: 2.w,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 206, 39, 28),
                            width: 2.w,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 206, 39, 28),
                            width: 2.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Password TextField
                  SizedBox(
                    width: 350.w,
                    child: TextField(
                      controller: _password,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Password',
                        errorText: password_error.isEmpty ? null : password_error,
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 189, 188, 188),
                          fontSize: 16.sp,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 189, 188, 188),
                            width: 1.4.w,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 206, 39, 28),
                            width: 2.w,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 206, 39, 28),
                            width: 2.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),

                  // Forgot Password
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Resetpassword1()),
                        );
                      },
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Color(0xFF3383D6),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Login Button
                  SizedBox(
                    width: 285.w,
                    height: 47.h,
                    child: ElevatedButton(
                      onPressed: loginbutton,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEB9974),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 22.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),

                  // Don't have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Dont’s have an account?",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Color(0xFF3383D6),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 25.h),

                  // Sign Up Button
                  SizedBox(
                    width: 285.w,
                    height: 47.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Color(0xFFEB9974), width: 2.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                      ),
                      child: Text(
                        'Sign Up',
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
