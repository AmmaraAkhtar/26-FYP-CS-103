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
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 30.sp, color: Colors.black),
        ),
        backgroundColor: const Color(0xFFFBFBFC),
        toolbarHeight: 120.h,
        elevation: 0,
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
                    color: const Color(0xFFEB9974),
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
                        Text("ammaraakhtar93@gmail.com", style: TextStyle(fontSize: 20.sp, color: Colors.black)),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Saved Notes", style: TextStyle(fontSize: 20.sp, color: Color(0xFFACABAB))),
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
              profileMenuItem(
                icon: Icons.dark_mode_sharp,
                iconColor: Colors.black,
                title: "Dark Mode",
                trailing: Icon(Icons.toggle_on_sharp, size: 40.sp),
                onTap: () {},
              ),
              profileMenuItem(
                icon: Icons.person_4_sharp,
                iconColor: Colors.black,
                title: "Edit Profile",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Editprofile()));
                },
              ),
              profileMenuItem(
                icon: Icons.settings,
                iconColor: Colors.black,
                title: "Settings",
                onTap: () {},
              ),
              profileMenuItem(
                icon: Icons.logout_sharp,
                iconColor: Colors.redAccent,
                title: "Log out",
                onTap: () {},
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileMenuItem({
    required IconData icon,
    required String title,
    Color iconColor = Colors.black,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 3, offset: Offset(0, 1))],
      ),
      child: Center(
        child: ListTile(
          leading: Icon(icon, size: 40.sp, color: iconColor),
          title: Text(title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black)),
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }
}