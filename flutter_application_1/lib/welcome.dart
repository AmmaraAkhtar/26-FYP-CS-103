import 'package:flutter/material.dart';

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
         body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height:30),
              
              Image.asset(
                'assets/logo.jpg', 
                height: 320,
              
              ),

              SizedBox(height: 30),

              // Hello Text
              Text(
                'Hello',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),

              SizedBox(height: 30),

              RichText(
              textAlign: TextAlign.center,
               text: TextSpan(
               style: TextStyle(
               fontSize: 25,
               color: Colors.grey[700],
                ),
                children: <TextSpan>[
                TextSpan(text: 'Welcome to the '),
                 TextSpan(
                  text: 'The Watcher',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                   TextSpan(text: ',\nwhere parents can monitor the\n activities of their off springs.'),
                ],
                ),
                ),
              SizedBox(height: 60),

              // Login Button
              SizedBox(
                width: 320,
                height:55,
              child:ElevatedButton(
                onPressed: () {
                  // Navigate to Login Screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE59885), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    color:Colors.white,
                     fontWeight: FontWeight.bold),
                ),
              ),
              ),
              SizedBox(height: 40),

             
                SizedBox(
                width: 320,
                height:55,
              child:OutlinedButton(
                onPressed: () {
                 
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFFE59885)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFFE59885),
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),),
            ],
          ),
        ),
      ),
    
    );
  }
}