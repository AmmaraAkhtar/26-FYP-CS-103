import 'package:flutter/material.dart';
import 'dart:convert';
import 'login.dart';
import 'package:http/http.dart' as http;

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

  Future<void> signupRequest(String email, String password) async {
    //String link = 'http://127.0.0.1:8000/resetPassword/';
    String link = 'http://10.27.190.96:8000/resetPassword/';
    final url = Uri.parse(link);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'new_password': password}),
      );
      print(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Password reset successfully!")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => login()),
        );
      } else {
        // Handle signup error
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
      await signupRequest(widget.email, _password.text.trim());

      _password.clear();
      _confirmPassword.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFBFB),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250), // AppBar ka height adjust
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 50), // top space
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
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Reset Password",
                    style: TextStyle(
                      fontSize: 36,
                      color: Color(0xFF699886),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),

                  //TextField for email
                  SizedBox(
                    width: 350,
                    height: 46,
                    child: TextField(
                      controller: _password,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Password',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 189, 188, 188),
                          fontSize: 16,
                        ),
                        errorText: passwordError.isEmpty ? null : passwordError,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 189, 188, 188),
                            width: 1.4,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFF147CF4),
                            width: 2,
                          ),
                        ),

                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 206, 39, 28),
                            width: 2,
                          ),
                        ),

                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 206, 39, 28),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  SizedBox(
                    width: 350,
                    height: 46,
                    child: TextField(
                      controller: _confirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Re-enter Your Password',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 189, 188, 188),
                          fontSize: 16,
                        ),
                        errorText: confirmPasswordError.isEmpty
                            ? null
                            : confirmPasswordError,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 189, 188, 188),
                            width: 1.4,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFF147CF4),
                            width: 2,
                          ),
                        ),

                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 206, 39, 28),
                            width: 2,
                          ),
                        ),

                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 206, 39, 28),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 60),

                  SizedBox(
                    width: 285,
                    height: 47,
                    child: ElevatedButton(
                      onPressed: () {
                        print("Reset button pressed");
                        resetButton();
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEB9974),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),

                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
