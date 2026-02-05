import 'package:flutter/material.dart';
import 'login.dart';
import 'otpPage.dart';

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

  // error messages
  String usernameError = "";
  String emailError = "";
  String passwordError = "";
  String confirmPasswordError = "";
  String phoneError = "";



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

  void validatePhone() {
    final value = _phone.text.trim();
    final regex = RegExp(r'^[0-9]{11}$');

    setState(() {
      if (value.isEmpty) {
        phoneError = "Phone number required";
      } else if (!regex.hasMatch(value)) {
        phoneError = "Must be exactly 11 digits";
      } else {
        phoneError = "";
      }
    });
  }


  void submit() {
    validateUsername();
    validateEmail();
    validatePassword();
    validateConfirmPassword();
    validatePhone();

    if (usernameError.isEmpty &&
        emailError.isEmpty &&
        passwordError.isEmpty &&
        confirmPasswordError.isEmpty &&
        phoneError.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => otp()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Expanded(
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
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 36,
                      color: Color(0xFF699886),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),

                  SizedBox(
                    width: 350,
                    // height: 46,
                    child: TextField(
                      controller: _username,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Username',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(
                            255,
                            189,
                            188,
                            188,
                          ), // <-- updated color
                          fontSize: 16,
                        ),
                        errorText: usernameError.isEmpty ? null : usernameError,
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

                  //TextField for email
                  SizedBox(
                    width: 350,
                    // height: 46,
                    child: TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Email',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 189, 188, 188),
                          fontSize: 16,
                        ),
                        errorText: emailError.isEmpty ? null : emailError,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 189, 188, 188),
                            width: 1.4,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
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

                  //TextField for password
                  SizedBox(
                    width: 350,
                    // height: 46,
                    child: TextField(
                      obscureText: true,
                      controller: _password,
                      decoration: InputDecoration(
                        hintText: 'Enter  Password',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(
                            255,
                            189,
                            188,

                            188,
                          ), // <-- updated color
                          fontSize: 16,
                        ),
                       errorText:passwordError.isEmpty ? null : passwordError,
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

                  //TextField for Phone Number
                  SizedBox(
                    width: 350,
                    // height: 46,
                    child: TextField(
                      obscureText: true,
                      controller: _confirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 189, 188, 188),
                          fontSize: 16,
                        ),
                        errorText: confirmPasswordError.isEmpty ? null : confirmPasswordError,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 189, 188, 188),
                            width: 1.4,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
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
                    // height: 46,
                    child: TextField(
                      controller: _phone,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Phone Number',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 189, 188, 188),
                          fontSize: 16,
                        ),
                        errorText: phoneError.isEmpty ? null : phoneError,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 189, 188, 188),
                            width: 1.4,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
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

                  SizedBox(height: 40),

                  SizedBox(
                    width: 285,
                    height: 47,
                    child: ElevatedButton(
                      onPressed: () {
                        
                         submit();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Color(0xFFEB9974), width: 2),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFFE59885),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),

                  // Don't have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 21, 21, 21),
                          decorationThickness: 1.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => login()),
                          );
                        },
                        style: ButtonStyle(
                          padding: WidgetStatePropertyAll(EdgeInsets.all(4)),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF3383D6),
                            decorationThickness: 1.5,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Sign up button
                  SizedBox(height: 25),
                  SizedBox(
                    width: 285,
                    height: 47,
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
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

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
