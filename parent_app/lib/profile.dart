import 'package:flutter/material.dart';
import 'package:flutter_application_1/editProfile.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFBFB),
      appBar: AppBar(
        title: Text(
          "Profile",
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
                    //Big Green Box
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: Color(0xFFEB9974),
                    ),

                    // Avatar (half inside, half outside)
                    Positioned(
                      bottom: -50,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: CircleAvatar(
                          radius: 100,
                          // backgroundColor: Color(0xFF699886),
                          backgroundImage: AssetImage('assets/person.jpg'),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 50),
                Text(
                  "Ammara",
                  style: TextStyle(fontSize: 29, color: Colors.black),
                ),
                SizedBox(height: 30),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Phone",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFFACABAB),
                            ),
                          ),
                          Text(
                            '+92303-8761832',
                            style: TextStyle(
                              fontSize: 20,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFFACABAB),
                            ),
                          ),
                          Text(
                            "ammaraakhtar93@Gmail.com",
                            style: TextStyle(
                              fontSize: 20,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Save Notes",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFFACABAB),
                            ),
                          ),
                          Text(
                            "200",
                            style: TextStyle(
                              fontSize: 20,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Account Created At",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFFACABAB),
                            ),
                          ),
                          Text(
                            "23-02-2020",
                            style: TextStyle(
                              fontSize: 20,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 252, 250, 250),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),

                  child: Center(
                    child: ListTile(
                      leading: Icon(Icons.dark_mode_sharp, size: 40),
                      iconColor: Colors.black,
                      trailing: Icon(Icons.toggle_on_sharp, size: 40),
                      title: Text(
                        "Dark Mode",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        // setState(() {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => Setting()),
                        //   );
                        // });
                      },
                    ),
                  ),
                ),

                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),

                  child: Center(
                    child: ListTile(
                      leading: Icon(Icons.person_4_sharp, size: 40),
                      iconColor: Colors.black,
                      title: Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Editprofile(),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 252, 250, 250),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),

                  child: Center(
                    child: ListTile(
                      leading: Icon(Icons.settings, size: 40),
                      iconColor: Colors.black,
                      title: Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => Setting()),
                        //   );
                      },
                    ),
                  ),
                ),

                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 252, 250, 250),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),

                  child: Center(
                    child: ListTile(
                      leading: Icon(
                        Icons.logout_sharp,
                        size: 40,
                        color: Colors.redAccent,
                      ),
                      iconColor: Colors.black,
                      title: Text(
                        "Log out",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
