import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login.dart';

class otp extends StatefulWidget {
  final String email;
  final String username;
  final String password;
  const otp({super.key, required this.email, required this.username, required this.password});

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  final TextEditingController _num1 = TextEditingController();
  final TextEditingController _num2 = TextEditingController();
  final TextEditingController _num3 = TextEditingController();
  final TextEditingController _num4 = TextEditingController();

  // Error message
  String error = "";
  bool _isLoading  = false;

 // Consistent SnackBar logic (Jaisa baqi screens mein tha)
  void _showCustomSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(15),
      ),
    );
  }
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
      }});
 }
//   Future<void> verifyotp(String num1,String num2,String num3,String num4,String email,String username,String password) async {
//     String otp = num1 + num2 + num3 + num4;
//     String link = 'http://127.0.0.1:8000/verifyOtp/';
//     final url = Uri.parse(link);
//     print("Sending OTP verification request with OTP: $otp, Email: $email, Username: $username");
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'otp': otp, 'email': email, 'username': username, 'password': password}),
//       );

//       if (response.statusCode == 200) {
        
//         print('Verification successful');
//       } else {
//         // Handle login error
//         var data = jsonDecode(response.body);
//         setState(() {
//           if (data is Map) {
//             error_message = data.values.join("\n");
//           } else {
//             error_message = data.toString();
//           }
//         });
//       }
//     } catch (e) {
//       setState(() {
//         error_message = "Network error: $e";
//       });
//     }
//   }

//   void loginbutton() async {
//     validateOTP();
//     if (error.isEmpty) {
//       print("Hello");
//       print(widget.email);
// print(widget.username);
// print(widget.password);
//       await verifyotp(
//         _num1.text.trim(),
//         _num2.text.trim(),
//         _num3.text.trim(),
//         _num4.text.trim(),
//         widget.email,
//         widget.username,
//         widget.password
//       );
//     }
//     if (error_message.isNotEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(error_message)),
//       );
//     }
//     else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Sign Up successful!")),
//       );
//       Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
//     }
    
//   }


Future<void> verifyotp() async {
    setState(() => _isLoading = true);
    
    String fullOtp = _num1.text + _num2.text + _num3.text + _num4.text;
    String link = 'http://127.0.0.1:8000/verifyOtp/';
    final url = Uri.parse(link);
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'otp': fullOtp, 
          'email': widget.email, 
          'username': widget.username, 
          'password': widget.password
        }),
      );

      if (response.statusCode == 200) {
        _showCustomSnackBar("Sign Up successful!", isError: false);
        
        // Navigation consistent with other screens
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(builder: (context) => const login()),
              (route) => false
            );
          }
        });
      } else {
        var data = jsonDecode(response.body);
        String msg = data is Map ? data.values.join("\n") : data.toString();
        _showCustomSnackBar(msg);
      }
    } catch (e) {
      _showCustomSnackBar("Network error: Please check your connection");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void loginbutton() async {
    validateOTP();
    if (error.isEmpty) {
      await verifyotp();
    } else {
      _showCustomSnackBar(error);
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
                    "OTP",
                    style: TextStyle(
                      fontSize: 36,
                      color: Color(0xFF699886),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),

                  const Text(
                    "We have sent OTP on Your number",
                    style: TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 55,
                        height: 55,
                        child: TextField(
                          controller: _num1,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Color(0xFFF1A37A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 55,
                        height: 55,
                        child: TextField(
                          controller: _num2,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Color(0xFFF1A37A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 55,
                        height: 55,
                        child: TextField(
                          controller: _num3,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Color(0xFFF1A37A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 55,
                        height: 55,
                        child: TextField(
                          controller: _num4,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Color(0xFFF1A37A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  error.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : SizedBox.shrink(),

                  // Text(error.isEmpty?"":error,

                  // style: TextStyle(
                  //     color: Colors.red,
                  //     fontSize: 16,
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Didn’t receive a OTP? ",
                        style: TextStyle(fontSize: 18),
                      ),
                      TextButton(
                        onPressed: null,
                        style: ButtonStyle(
                          padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                        ),
                        child: Text(
                          "Resend OTP",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  // SizedBox(
                  //   width: 285,
                  //   height: 47,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       loginbutton();
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.white,
                  //       side: BorderSide(color: Color(0xFFEB9974), width: 2),

                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(40),
                  //       ),
                  //     ),
                  //     child: Text(
                  //       'Verify OTP',
                  //       style: TextStyle(
                  //         fontSize: 22,
                  //         color: Color(0xFFE59885),
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                   // Action Button with Spinner
                SizedBox(
                  width: 285,
                  height: 47,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : loginbutton,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFEB9974), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: _isLoading 
                      ? const SizedBox(
                          height: 20, 
                          width: 20, 
                          child: CircularProgressIndicator(color: Color(0xFFEB9974), strokeWidth: 2)
                        )
                      : const Text(
                          'Verify OTP',
                          style: TextStyle(
                            fontSize: 22,
                            color: Color(0xFFE59885),
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
