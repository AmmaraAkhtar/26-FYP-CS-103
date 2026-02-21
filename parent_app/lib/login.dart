import 'package:flutter/material.dart';
import 'signup.dart';
import 'resetPassword1.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'homePage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String emailError = "";
  String passwordError = "";
  String errorMessage = "";

  final TextEditingController emailController =
      TextEditingController();
  final TextEditingController passwordController =
      TextEditingController();

  /// ================= LOGIN API =================
  Future<void> loginRequest(
      String email, String password) async {

    String link = 'http://10.27.190.96:8000/login/';
    final url = Uri.parse(link);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Home(email: email),
          ),
        );

      } else {
        var data = jsonDecode(response.body);

        setState(() {
          errorMessage =
              data is Map ? data.values.join("\n")
                          : data.toString();
        });
      }

    } catch (e) {
      setState(() {
        errorMessage = "Network Error";
      });
    }
  }

  /// ================= VALIDATION =================
  bool validate() {

    bool isValid = true;

    if (emailController.text.trim().isEmpty ||
        !emailController.text.contains('@')) {
      emailError = "Enter valid email";
      isValid = false;
    } else {
      emailError = "";
    }

    if (passwordController.text.length < 8) {
      passwordError =
          "Password must contain 8 characters";
      isValid = false;
    } else {
      passwordError = "";
    }

    setState(() {});
    return isValid;
  }

  /// ================= LOGIN BUTTON =================
  void loginButton() async {

    if (validate()) {
      await loginRequest(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    }
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),

      /// ===== APP LOGO =====
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(230.h),
        child: AppBar(
          backgroundColor:
              const Color(0xFFFBFBFC),
          elevation: 0,
          centerTitle: true,
          flexibleSpace: Padding(
            padding:
                EdgeInsets.only(top: 50.h),
            child: Hero(
              tag: 'applog',
              child: Image.asset(
                'assets/logo.png',
                height: 180.h,
              ),
            ),
          ),
        ),
      ),

      /// ===== BODY =====
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              children: [

                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 36.sp,
                    color: const Color(0xFF699886),
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10.h),

                if (errorMessage.isNotEmpty)
                  Text(errorMessage,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.sp)),

                SizedBox(height: 20.h),

                /// EMAIL
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Enter Email",
                    errorText: emailError.isEmpty
                        ? null
                        : emailError,
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10.r)),
                  ),
                ),

                SizedBox(height: 20.h),

                /// PASSWORD
                TextField(
                  controller:
                      passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText:
                        "Enter Password",
                    errorText:
                        passwordError.isEmpty
                            ? null
                            : passwordError,
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                10.r)),
                  ),
                ),

                /// FORGOT PASSWORD
                Align(
                  alignment:
                      Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              Resetpassword1(),
                        ),
                      );
                    },
                    child:
                        const Text("Forgot Password"),
                  ),
                ),

                SizedBox(height: 35.h),

                /// LOGIN BUTTON
                SizedBox(
                  width: 280.w,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: loginButton,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                              0xFFEB9974),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                                    40.r),
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight:
                              FontWeight.bold),
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                /// SIGNUP
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Text(
                        "Don't have account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  Signup()),
                        );
                      },
                      child:
                          const Text("Sign Up"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}