import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';
class welcome extends StatefulWidget {
  const welcome({super.key});

  @override
  State<welcome> createState() => _welcomeState();
}

class _welcomeState extends State<welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,

        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),

              Image.asset('assets/logo.jpg', height: 320),

              SizedBox(height: 30),

              // Hello Text
              // Text(
              //   'Hello',
              //   style: TextStyle(
              //     fontSize: 36,
              //     fontWeight: FontWeight.bold,
              //     color: Color(0xFF699886),
              //   ),
              // ),

              // SizedBox(height: 30),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: 25, color: Colors.grey[700]),
                  children: <TextSpan>[
                    TextSpan(text: 'Welcome to the '),
                    TextSpan(
                      text: 'The Watcher',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          ',\nwhere parents can monitor the\n activities of their off springs.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60),

              // Login Button
              SizedBox(
                width: 285,
                height: 47,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
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
              SizedBox(height: 40),

              SizedBox(
                width: 285,
                height: 47,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Color(0xFFEB9974), width: 3),
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
            ],
          ),
        ),
      ),
    );
  }
}
