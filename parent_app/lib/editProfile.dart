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

        backgroundColor: Color(0xFFFBFBFC),
        appBar: AppBar(
          title: Text(
            "Edit Profile",
            style: TextStyle(fontSize: 30.sp, color: Colors.black),
          ),
          backgroundColor: Color(0xFFFBFBFC),
          toolbarHeight: 120.h,

      backgroundColor: Color(0xFFFAFBFB),
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(fontSize: 30, color: Colors.black),

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
                          backgroundColor: Colors.pink.shade100,
                          backgroundImage: AssetImage('assets/person.jpg'),
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
                    color: Color.fromARGB(255, 0, 142, 224),
                  ),
                ),
                SizedBox(height: 30.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("User Name", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: 350.w,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter User Name",
                          hintStyle: TextStyle(color: Color.fromARGB(255, 173, 171, 171), fontSize: 15.sp),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Color.fromARGB(255, 173, 171, 171), width: 1.4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text("Email Address", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: 350.w,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter Email Address",
                          hintStyle: TextStyle(color: Color.fromARGB(255, 173, 171, 171), fontSize: 15.sp),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Color.fromARGB(255, 173, 171, 171), width: 1.4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text("Phone Number", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: 350.w,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter Phone Number",
                          hintStyle: TextStyle(color: Color.fromARGB(255, 173, 171, 171), fontSize: 15.sp),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Color.fromARGB(255, 173, 171, 171), width: 1.4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text("Password", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: 350.w,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter Password",
                          hintStyle: TextStyle(color: Color.fromARGB(255, 173, 171, 171), fontSize: 15.sp),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Color.fromARGB(255, 173, 171, 171), width: 1.4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
                SizedBox(
                  width: 285.w,
                  height: 47.h,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEB9974),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r)),
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(fontSize: 22.sp, color: Colors.white, fontWeight: FontWeight.bold),
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
}
