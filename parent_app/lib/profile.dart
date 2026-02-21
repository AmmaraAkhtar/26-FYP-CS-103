import 'package:flutter/material.dart';
import 'package:flutter_application_1/editProfile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Color(0xFFFBFBFC),
        appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(fontSize: 30.sp, color: Colors.black),
          ),
          backgroundColor: Color(0xFFFBFBFC),
          toolbarHeight: 120.h,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 200.h,
                      width: double.infinity,
                      color: Color(0xFFEB9974),
                    ),
                    Positioned(
                      bottom: -50.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: CircleAvatar(
                          radius: 100.r,
                          backgroundImage: AssetImage('assets/person.jpg'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.h),
                Text(
                  "Ammara",
                  style: TextStyle(fontSize: 29.sp, color: Colors.black),
                ),
                SizedBox(height: 30.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Phone", style: TextStyle(fontSize: 20.sp, color: Color(0xFFACABAB))),
                          Text('+92303-8761832', style: TextStyle(fontSize: 20.sp, color: Colors.black)),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Email", style: TextStyle(fontSize: 20.sp, color: Color(0xFFACABAB))),
                          Text("ammaraakhtar93@Gmail.com", style: TextStyle(fontSize: 20.sp, color: Colors.black)),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Save Notes", style: TextStyle(fontSize: 20.sp, color: Color(0xFFACABAB))),
                          Text("200", style: TextStyle(fontSize: 20.sp, color: Colors.black)),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Account Created At", style: TextStyle(fontSize: 20.sp, color: Color(0xFFACABAB))),
                          Text("23-02-2020", style: TextStyle(fontSize: 20.sp, color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),

                // Menu items
                Container(
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 252, 250, 250),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 3, offset: Offset(0, 1))],
                  ),
                  child: Center(
                    child: ListTile(
                      leading: Icon(Icons.dark_mode_sharp, size: 40.sp),
                      iconColor: Colors.black,
                      trailing: Icon(Icons.toggle_on_sharp, size: 40.sp),
                      title: Text("Dark Mode", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                      onTap: () {},
                    ),
                  ),
                ),

                Container(
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 3, offset: Offset(0, 1))],
                  ),
                  child: Center(
                    child: ListTile(
                      leading: Icon(Icons.person_4_sharp, size: 40.sp),
                      iconColor: Colors.black,
                      title: Text("Edit Profile", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Editprofile()));
                      },
                    ),
                  ),
                ),

                Container(
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 252, 250, 250),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 3, offset: Offset(0, 1))],
                  ),
                  child: Center(
                    child: ListTile(
                      leading: Icon(Icons.settings, size: 40.sp),
                      iconColor: Colors.black,
                      title: Text("Settings", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                      onTap: () {},
                    ),
                  ),
                ),

                Container(
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 252, 250, 250),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 3, offset: Offset(0, 1))],
                  ),
                  child: Center(
                    child: ListTile(
                      leading: Icon(Icons.logout_sharp, size: 40.sp, color: Colors.redAccent),
                      iconColor: Colors.black,
                      title: Text("Log out", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
    );
  }
}
