import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFB),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFC),
        toolbarHeight: 120.h,
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 30.sp,
            color: Colors.black,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// ===== Header + Profile Image =====
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
                        backgroundColor: Colors.pink.shade100,
                        backgroundImage:
                            const AssetImage('assets/person.jpg'),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 60.h),

              Text(
                "Change Picture",
                style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color.fromARGB(255, 0, 142, 224),
                ),
              ),

              SizedBox(height: 30.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Username
                    buildTextField("User Name", "Enter User Name"),

                    SizedBox(height: 20.h),

                    /// Email
                    buildTextField(
                        "Email Address", "Enter Email Address"),

                    SizedBox(height: 20.h),

                    /// Phone
                    buildTextField(
                        "Phone Number", "Enter Phone Number"),

                    SizedBox(height: 20.h),

                    /// Password
                    buildTextField("Password", "Enter Password",
                        obscure: true),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),

              /// ===== Update Button =====
              SizedBox(
                width: 285.w,
                height: 47.h,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB9974),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(40.r),
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  /// ===== Reusable TextField Widget =====
  Widget buildTextField(
      String label, String hint,
      {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.h),
        TextField(
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: const Color.fromARGB(
                  255, 173, 171, 171),
              fontSize: 15.sp,
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10.r),
              borderSide: const BorderSide(
                  color: Color.fromARGB(
                      255, 173, 171, 171)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10.r),
              borderSide:
                  const BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}