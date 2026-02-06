import 'package:flutter/material.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _EditprofileState();
}

class _EditprofileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 120,
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) => SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: Color(0xFFEB9974),
                    ),
                    Positioned(
                      bottom: -50,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.pink.shade100,
                          backgroundImage: AssetImage('assets/person.jpg'),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 60),
                Text(
                  "Change Picture",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 0, 142, 224),
                  ),
                ),
                SizedBox(height: 30),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "First Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    SizedBox(
                      width: 350,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter First Name",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 173, 171, 171),
                            fontSize: 15,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 173, 171, 171),
                              width: 1.4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      "Last Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    SizedBox(
                      width: 350,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter Last Name",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 173, 171, 171),
                            fontSize: 15,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 15,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 173, 171, 171),
                              width: 1.4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      "Age",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    SizedBox(
                      width: 350,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter Age",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 173, 171, 171),
                            fontSize: 15,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 15,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 173, 171, 171),
                              width: 1.4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      "Screen Time",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    SizedBox(
                      width: 350,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter Screen Time",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 173, 171, 171),
                            fontSize: 15,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 15,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 173, 171, 171),
                              width: 1.4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),

                SizedBox(
                  width: 285,
                  height: 47,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEB9974),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Text(
                      'Register',
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
    );
  }
}
