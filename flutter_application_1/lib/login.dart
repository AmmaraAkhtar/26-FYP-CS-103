import 'package:flutter/material.dart';

class login extends StatefulWidget {

  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
       backgroundColor: Colors.white,
      appBar:  PreferredSize(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 35,
                    color: Color(0xFF699886),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),

                //TextField for email
                SizedBox(
                  width: 378,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email Address',
                     hintStyle: TextStyle(
        color: Color(0xFF7D7D7D), // <-- updated color
        fontWeight: FontWeight.w700,
      ),

                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 20,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 173, 171, 171),
                          width: 1.4,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 27),

            //TextField for password
                SizedBox(
                  width: 378,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Your Password',
                      hintStyle: TextStyle(
        color: Color(0xFF7D7D7D), // <-- updated color
        fontWeight: FontWeight.w700,
      ),

                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 20,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 173, 171, 171),
                          width: 1.4,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                ),

              
                SizedBox(height: 5),

                //Text Forgot Password
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      
                    },
                    style: ButtonStyle(
                      backgroundColor: Theme.of(
                        context,
                      ).textButtonTheme.style?.backgroundColor,
                    ),
                    child: Text(
                      "Forgot Passoword",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3383D6),
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFF3383D6),
                        decorationThickness: 1.5,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                  SizedBox(
                width: 274,
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
              SizedBox(height: 25),
                // Don't have an account

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                        Text(
                    "Dont’s have an account?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 21, 21, 21),
                      decorationThickness: 1.5,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3383D6),
                        decorationColor: Color(0xFF3383D6),
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
                width: 274,
                height: 47,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Color(0xFFEB9974,), width:2),
                    
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
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
