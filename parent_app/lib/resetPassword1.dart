import 'package:flutter/material.dart';
import 'resetPassword2.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Resetpassword1 extends StatefulWidget {
  const Resetpassword1({super.key});

  @override
  State<Resetpassword1> createState() => _Resetpassword1State();
}

class _Resetpassword1State extends State<Resetpassword1> {
   String email_error = "";
   String error_message = "";
  TextEditingController _email = TextEditingController();


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

Future<void> emailcheckRequest(String email, String password) async {
    String link = 'http://127.0.0.1:8000/checkEmail/';
    final url = Uri.parse(link);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Resetpassword2(email: email)),
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
 
  void loginbutton() async {
    validate_email();
    if (email_error.isEmpty) {
      await emailcheckRequest(_email.text.trim(), '');
      _email.clear();
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
                    // height: 46,
                    child: TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Register Email',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 189, 188, 188),
                          fontSize: 16,
                        ),
                        errorText: email_error.isEmpty ? null : email_error,
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
                       loginbutton();
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
