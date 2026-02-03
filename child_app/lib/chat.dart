import 'package:flutter/material.dart';
import 'status.dart';

class WatcherScreen extends StatefulWidget {
  @override
  _WatcherScreenState createState() => _WatcherScreenState();
}

class _WatcherScreenState extends State<WatcherScreen> {
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
              child: Image.asset('assets/logo.jpg', width: 189, height: 189),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5CD97),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/OneTimePassword.png",
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Usage Access",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF8D7365),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Monitoring kids online",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFAF8067),
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    Switch(value: true, onChanged: null),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5CD97),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/AccessibilityTools.png",
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Accessibility Services",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF8D7365),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Foreground services",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFAF8067),
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    Switch(value: true, onChanged: null),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5CD97),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Image.asset("assets/Alarm.png", width: 50, height: 50),
                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Notification Access",
                          style: TextStyle(
                            color: Color(0xFF8D7365),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "To view all notifications",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFAF8067),
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    Switch(value: true, onChanged: null),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5CD97),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Image.asset("assets/UserShield.png", width: 50, height: 50),
                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Account Activity",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF8D7365),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "To view account activity",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFAF8067),
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    Switch(value: true, onChanged: null),
                  ],
                ),
              ),

              SizedBox(height: 25),

              SizedBox(
                width: 285,
                height: 47,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => status()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEB9974),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
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
