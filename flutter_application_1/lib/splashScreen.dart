import 'package:flutter/material.dart';


class splashpage extends StatefulWidget {
  const splashpage({super.key});

  @override
  State<splashpage> createState() => _splashpageState();
}

class _splashpageState extends State<splashpage> {

 



  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            const Spacer(),

            Center(
              child: Hero(
                tag: 'applog',
                child: Image.network(
                  'assets/logo1.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),

           
          ],
        ),
      ),
    );
  }
}

