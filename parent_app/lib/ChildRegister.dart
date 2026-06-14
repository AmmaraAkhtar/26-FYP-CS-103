// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_screenutil/flutter_screenutil.dart'; // added for responsiveness

// class profile extends StatefulWidget {
//   String email;
//   String token;
//   profile({super.key, required this.email, required this.token});

//   @override
//   State<profile> createState() => _EditprofileState();
// }

// class _EditprofileState extends State<profile> {
//   String error = '';
//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController screenTimeController = TextEditingController();

  
//   Future<void> registerChild() async {
//     String link = 'http://192.168.18.163:8000/createChild/';
//     final url = Uri.parse(link);

//     final response = await http.post(
//       url,
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Bearer ${widget.token}',
//       },
//       body: jsonEncode({
//         'firstname': firstNameController.text,
//         'lastname': lastNameController.text,
//         'age': int.tryParse(ageController.text) ?? 0,
//         'screen_time_limit': int.tryParse(screenTimeController.text) ?? 60,
//         'parent_email': widget.email,
//       }),
//     );

//     if (response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Pairing Code is sent to your email")),
//       );Navigator.pop(context); // home pe wapas jao
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to register child")),
//       );
//     }
//   }

//   void register() async {
//     if (firstNameController.text.isEmpty ||
//         lastNameController.text.isEmpty ||
//         ageController.text.isEmpty ||
//         screenTimeController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all the fields")),
//       );
//     } else {
//       await registerChild();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFBFBFC),
//       appBar: AppBar(
//         title: Text(
//           "Register Child",
//           style: TextStyle(fontSize: 30.sp, color: Colors.black),
//         ),
//         backgroundColor: const Color(0xFFFBFBFC),
//         toolbarHeight: 120.h,
//       ),
//       body: SafeArea(
//         child: Builder(
//           builder: (context) => SingleChildScrollView(
//             child: Column(
//               children: [
//                 Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Container(
//                       height: 200.h,
//                       width: 1.sw,
//                       color: const Color(0xFFEB9974),
//                     ),
//                     Positioned(
//                       bottom: -50.h,
//                       left: 0,
//                       right: 0,
//                       child: Center(
//                         child: CircleAvatar(
//                           radius: 100.r,
//                           backgroundColor: Colors.pink.shade100,
//                           backgroundImage: const AssetImage('assets/person.jpg'),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 60.h),
//                 Text(
//                   "Change Picture",
//                   style: TextStyle(
//                     fontSize: 15.sp,
//                     color: const Color.fromARGB(255, 0, 142, 224),
//                   ),
//                 ),
//                 SizedBox(height: 30.h),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // First Name
//                       Text(
//                         "First Name",
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 2.h),
//                       SizedBox(
//                         width: 350.w,
//                         child: TextField(
//                           controller: firstNameController,
//                           decoration: InputDecoration(
//                             hintText: "Enter First Name",
//                             hintStyle: TextStyle(
//                               color: const Color.fromARGB(255, 173, 171, 171),
//                               fontSize: 15.sp,
//                             ),
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 10.w,
//                               vertical: 15.h,
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.r),
//                               borderSide: BorderSide(
//                                 color: const Color.fromARGB(255, 173, 171, 171),
//                                 width: 1.4.w,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.r),
//                               borderSide: BorderSide(
//                                 color: Colors.blue,
//                                 width: 2.w,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20.h),

//                       // Last Name
//                       Text(
//                         "Last Name",
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 2.h),
//                       SizedBox(
//                         width: 350.w,
//                         child: TextField(
//                           controller: lastNameController,
//                           decoration: InputDecoration(
//                             hintText: "Enter Last Name",
//                             hintStyle: TextStyle(
//                               color: const Color.fromARGB(255, 173, 171, 171),
//                               fontSize: 15.sp,
//                             ),
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 12.w,
//                               vertical: 15.h,
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.r),
//                               borderSide: BorderSide(
//                                 color: const Color.fromARGB(255, 173, 171, 171),
//                                 width: 1.4.w,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.r),
//                               borderSide: BorderSide(
//                                 color: Colors.blue,
//                                 width: 2.w,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20.h),

//                       // Age
//                       Text(
//                         "Age",
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 2.h),
//                       SizedBox(
//                         width: 350.w,
//                         child: TextField(
//                           controller: ageController,
//                           decoration: InputDecoration(
//                             hintText: "Enter Age",
//                             hintStyle: TextStyle(
//                               color: const Color.fromARGB(255, 173, 171, 171),
//                               fontSize: 15.sp,
//                             ),
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 12.w,
//                               vertical: 15.h,
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.r),
//                               borderSide: BorderSide(
//                                 color: const Color.fromARGB(255, 173, 171, 171),
//                                 width: 1.4.w,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.r),
//                               borderSide: BorderSide(
//                                 color: Colors.blue,
//                                 width: 2.w,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20.h),

//                       // Screen Time
//                       Text(
//                         "Screen Time",
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 2.h),
//                       SizedBox(
//                         width: 350.w,
//                         child: TextField(
//                           controller: screenTimeController,
//                           decoration: InputDecoration(
//                             hintText: "Enter Screen Time",
//                             hintStyle: TextStyle(
//                               color: const Color.fromARGB(255, 173, 171, 171),
//                               fontSize: 15.sp,
//                             ),
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 12.w,
//                               vertical: 15.h,
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.r),
//                               borderSide: BorderSide(
//                                 color: const Color.fromARGB(255, 173, 171, 171),
//                                 width: 1.4.w,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.r),
//                               borderSide: BorderSide(
//                                 color: Colors.blue,
//                                 width: 2.w,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 40.h),

//                       // Register Button
//                       Center(
//                         child: SizedBox(
//                           width: 285.w,
//                           height: 47.h,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               register();
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFFEB9974),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(40.r),
//                               ),
//                             ),
//                             child: Text(
//                               'Register',
//                               style: TextStyle(
//                                 fontSize: 22.sp,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 50.h),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class profile extends StatefulWidget {
  String email;
  String token;
  profile({super.key, required this.email, required this.token});

  @override
  State<profile> createState() => _EditprofileState();
}

class _EditprofileState extends State<profile> {
  String error = '';

  // Existing controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController screenTimeController = TextEditingController();

  // Bedtime controllers
  TextEditingController bedtimeStartController =
      TextEditingController(text: "21:00");
  TextEditingController bedtimeEndController =
      TextEditingController(text: "07:00");
  bool bedtimeEnabled = true;

  Future<void> registerChild() async {
    String link = 'http://192.168.18.163:8000/createChild/';
    final url = Uri.parse(link);

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({
        'firstname': firstNameController.text,
        'lastname': lastNameController.text,
        'age': int.tryParse(ageController.text) ?? 0,
        'screen_time_limit': int.tryParse(screenTimeController.text) ?? 60,
        'parent_email': widget.email,
        'bedtime_start': bedtimeStartController.text,
        'bedtime_end': bedtimeEndController.text,
        'bedtime_enabled': bedtimeEnabled,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pairing Code is sent to your email")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to register child")),
      );
    }
  }

  void register() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        ageController.text.isEmpty ||
        screenTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the fields")),
      );
    } else {
      await registerChild();
    }
  }

  // Helper to open time picker and update a controller
  Future<void> _pickTime(
      BuildContext context, TextEditingController controller,
      {required int defaultHour, required int defaultMinute}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: defaultHour, minute: defaultMinute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFEB9974),
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  // Reusable input decoration
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: const Color.fromARGB(255, 173, 171, 171),
        fontSize: 15.sp,
      ),
      contentPadding:
          EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(
          color: const Color.fromARGB(255, 173, 171, 171),
          width: 1.4.w,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: Colors.blue, width: 2.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: AppBar(
        title: Text(
          "Register Child",
          style: TextStyle(fontSize: 30.sp, color: Colors.black),
        ),
        backgroundColor: const Color(0xFFFBFBFC),
        toolbarHeight: 120.h,
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) => SingleChildScrollView(
            child: Column(
              children: [
                //  Header image section
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 200.h,
                      width: 1.sw,
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── First Name ──
                      Text("First Name",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: 350.w,
                        child: TextField(
                          controller: firstNameController,
                          decoration:
                              _inputDecoration("Enter First Name"),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // ── Last Name ──
                      Text("Last Name",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: 350.w,
                        child: TextField(
                          controller: lastNameController,
                          decoration:
                              _inputDecoration("Enter Last Name"),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // ── Age ──
                      Text("Age",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: 350.w,
                        child: TextField(
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration("Enter Age"),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // ── Screen Time ──
                      Text("Screen Time (minutes)",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: 350.w,
                        child: TextField(
                          controller: screenTimeController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration(
                              "Enter Screen Time in minutes"),
                        ),
                      ),
                      SizedBox(height: 28.h),

                      // ── Bedtime Section Divider ──
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              "Bedtime Settings",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // ── Bedtime Toggle ──
                      Container(
                        width: 350.w,
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3EE),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: const Color(0xFFEB9974)
                                  .withOpacity(0.4),
                              width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.bedtime_outlined,
                                    color: const Color(0xFFEB9974),
                                    size: 20.sp),
                                SizedBox(width: 8.w),
                                Text(
                                  "Enable Bedtime Lock",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: bedtimeEnabled,
                              activeColor: const Color(0xFFEB9974),
                              onChanged: (val) =>
                                  setState(() => bedtimeEnabled = val),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // ── Bedtime Start & End (visible only when enabled) ──
                      if (bedtimeEnabled) ...[
                        // Bedtime Start
                        Text("Bedtime Start",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 2.h),
                        SizedBox(
                          width: 350.w,
                          child: TextField(
                            controller: bedtimeStartController,
                            readOnly: true,
                            onTap: () => _pickTime(
                              context,
                              bedtimeStartController,
                              defaultHour: 21,
                              defaultMinute: 0,
                            ),
                            decoration: _inputDecoration(
                                    "Select Bedtime Start")
                                .copyWith(
                              suffixIcon: Icon(Icons.access_time,
                                  color: const Color(0xFFEB9974),
                                  size: 20.sp),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Bedtime End
                        Text("Bedtime End",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 2.h),
                        SizedBox(
                          width: 350.w,
                          child: TextField(
                            controller: bedtimeEndController,
                            readOnly: true,
                            onTap: () => _pickTime(
                              context,
                              bedtimeEndController,
                              defaultHour: 7,
                              defaultMinute: 0,
                            ),
                            decoration: _inputDecoration(
                                    "Select Bedtime End")
                                .copyWith(
                              suffixIcon: Icon(Icons.access_time,
                                  color: const Color(0xFFEB9974),
                                  size: 20.sp),
                            ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Info hint
                        Container(
                          width: 350.w,
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: Colors.blue.shade400,
                                  size: 16.sp),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  "Device will be locked automatically during bedtime hours.",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],

                      SizedBox(height: 20.h),

                      // ── Register Button ──
                      Center(
                        child: SizedBox(
                          width: 285.w,
                          height: 47.h,
                          child: ElevatedButton(
                            onPressed: register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEB9974),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(40.r),
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
                      ),
                      SizedBox(height: 50.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}