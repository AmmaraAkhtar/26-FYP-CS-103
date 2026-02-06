import 'package:flutter/material.dart';
import 'login.dart';
import 'otpPage.dart';
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
  final TextEditingController _phone = TextEditingController();

  String usernameError = "";
  String emailError = "";
  String passwordError = "";
  String confirmPasswordError = "";
  String phoneError = "";
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
      } else if (pass != confirm) {
        confirmPasswordError = "Passwords do not match";
      } else {
        confirmPasswordError = "";
      }
    });
  }

  Future<void> signupRequest(
      String username, String email, String password) async {
    const String link = 'http://127.0.0.1:8000/signup/';
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
            builder: (context) =>
                otp(username: username, email: email, password: password),
          ),
        );
      } else {
        var data = jsonDecode(response.body);
        setState(() {
          error_message = data.toString();
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
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(250),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 36,
                  color: Color(0xFF699886),
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),
              Text(error_message, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),

              buildField(_username, "Enter Username", usernameError),
              buildField(_email, "Enter Email", emailError),
              buildField(_password, "Enter Password", passwordError,
                  obscure: true),
              buildField(_confirmPassword, "Confirm Password",
                  confirmPasswordError,
                  obscure: true),
              buildField(_phone, "Phone Number", phoneError),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: submit,
                child: const Text("Sign Up"),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const login()));
                },
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(TextEditingController controller, String hint, String error,
      {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          errorText: error.isEmpty ? null : error,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
