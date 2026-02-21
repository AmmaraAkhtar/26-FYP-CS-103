import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatefulWidget {
  final String email;

  const Profile({super.key, required this.email});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController screenTimeController = TextEditingController();

  /// ================= REGISTER CHILD API =================
  Future<void> registerChild() async {

    String link = 'http://10.27.190.96:8000/createChild/';
    final url = Uri.parse(link);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "firstname": firstNameController.text,
        "lastname": lastNameController.text,
        "age": int.tryParse(ageController.text) ?? 0,
        "screen_time_limit":
            int.tryParse(screenTimeController.text) ?? 60,
        "parent_email": widget.email,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Pairing Code sent to Email")),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Failed to register child")),
      );
    }
  }

  /// ================= VALIDATION =================
  void register() {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        ageController.text.isEmpty ||
        screenTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill all fields")),
      );
      return;
    }

    registerChild();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),

      /// ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFC),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Register Child",
          style:
              TextStyle(fontSize: 24.sp, color: Colors.black),
        ),
      ),

      /// ================= BODY =================
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// HEADER
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 180.h,
                    width: 1.sw,
                    color: const Color(0xFFEB9974),
                  ),

                  Positioned(
                    bottom: -50,
                    left: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 70.r,
                      backgroundImage:
                          const AssetImage("assets/person.jpg"),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 70.h),

              Text(
                "Change Picture",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14.sp),
              ),

              SizedBox(height: 30.h),

              buildField("First Name", firstNameController),
              buildField("Last Name", lastNameController),
              buildField("Age", ageController),
              buildField(
                  "Screen Time (minutes)",
                  screenTimeController),

              SizedBox(height: 30.h),

              /// REGISTER BUTTON
              SizedBox(
                width: 280.w,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFEB9974),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(40.r),
                    ),
                  ),
                  child: Text(
                    "Register",
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= TEXT FIELD WIDGET =================
  Widget buildField(
      String title, TextEditingController controller) {

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 5.h),

          TextField(
            controller: controller,
            keyboardType:
                TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter $title",
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(10.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}