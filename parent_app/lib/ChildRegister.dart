import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart'; // added for responsiveness

class profile extends StatefulWidget {
  String email;
  profile({super.key, required this.email});

  @override
  State<profile> createState() => _EditprofileState();
}

class _EditprofileState extends State<profile> {
  String error = '';
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController screenTimeController = TextEditingController();

  Future<void> registerChild() async {
    //String link = 'http://127.0.0.1:8000/createChild/';
    //String link = 'http://10.13.19.146:8000/createChild/';
    String link = 'http://10.27.190.96:8000/createChild/';
    final url = Uri.parse(link);

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'firstname': firstNameController.text,
        'lastname': lastNameController.text,
        'age': int.tryParse(ageController.text) ?? 0,
        'screen_time_limit': int.tryParse(screenTimeController.text) ?? 60,
        'parent_email': widget.email,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pairing CCode is sent to your email")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to register child")));
    }
  }

  void register() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        ageController.text.isEmpty ||
        screenTimeController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all the fields")));
    } else {
      await registerChild();
    }
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
        backgroundColor: Color(0xFFFBFBFC),
        appBar: AppBar(
          title: Text(
            "Edit Profile",
            style: TextStyle(fontSize: 30.sp, color: Colors.black),
          ),
          backgroundColor: Color(0xFFFBFBFC),
          toolbarHeight: 120.h,

    return Scaffold(
      backgroundColor: Color(0xFFFAFBFB),
      appBar: AppBar(
        title: Text(
          "Register Child",
          style: TextStyle(fontSize: 30, color: Colors.black),

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
                        height: 200.h,
                        width: 1.sw,
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
                      Text(
                        "First Name",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: 350.w,
                        child: TextField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            hintText: "Enter First Name",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 173, 171, 171),
                              fontSize: 15.sp,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 15.h,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 173, 171, 171),
                                width: 1.4.w,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.w,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      Text(
                        "Last Name",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: 350.w,
                        child: TextField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            hintText: "Enter Last Name",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 173, 171, 171),
                              fontSize: 15.sp,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 15.h,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 173, 171, 171),
                                width: 1.4.w,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.w,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      Text(
                        "Age",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: 350.w,
                        child: TextField(
                          controller: ageController,
                          decoration: InputDecoration(
                            hintText: "Enter Age",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 173, 171, 171),
                              fontSize: 15.sp,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 15.h,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 173, 171, 171),
                                width: 1.4.w,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.w,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      Text(
                        "Screen Time",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: 350.w,
                        child: TextField(
                          controller: screenTimeController,
                          decoration: InputDecoration(
                            hintText: "Enter Screen Time",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 173, 171, 171),
                              fontSize: 15.sp,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 15.h,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 173, 171, 171),
                                width: 1.4.w,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.w,
                              ),
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
                      onPressed: () {
                        register();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEB9974),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                      ),
                      child: Text(
                        'Register',
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
        ),
      
    );
  }
}
