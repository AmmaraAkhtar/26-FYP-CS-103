import 'package:flutter/material.dart';
import 'welcome.dart';

class splashpage extends StatefulWidget {
  const splashpage({super.key});

  @override
  State<splashpage> createState() => _splashpageState();
}

class _splashpageState extends State<splashpage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 6), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => welcome()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFBFB),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'applog',
                child: Image.asset('assets/logo.png', width: 300, height: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
