// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class Editprofile extends StatefulWidget {
//   const Editprofile({super.key});

//   @override
//   State<Editprofile> createState() => _EditprofileState();
// }

// class _EditprofileState extends State<Editprofile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//         backgroundColor: Color(0xFFFBFBFC),
//         appBar: AppBar(
//           title: Text(
//             "Edit Profile",
//             style: TextStyle(fontSize: 30.sp, color: Colors.black),
//           ),
//           backgroundColor: Color(0xFFFBFBFC),
//           toolbarHeight: 120.h,
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Container(
//                       height: 200.h,
//                       width: double.infinity,
//                       color: Color(0xFFEB9974),
//                     ),
//                     Positioned(
//                       bottom: -50.h,
//                       left: 0,
//                       right: 0,
//                       child: Center(
//                         child: CircleAvatar(
//                           radius: 100.r,
//                           backgroundColor: Colors.pink.shade100,
//                           backgroundImage: AssetImage('assets/person.jpg'),
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
//                     color: Color.fromARGB(255, 0, 142, 224),
//                   ),
//                 ),
//                 SizedBox(height: 30.h),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("User Name", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 2.h),
//                     SizedBox(
//                       width: 350.w,
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: "Enter User Name",
//                           hintStyle: TextStyle(color: Color.fromARGB(255, 173, 171, 171), fontSize: 15.sp),
//                           contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10.r),
//                             borderSide: BorderSide(color: Color.fromARGB(255, 173, 171, 171), width: 1.4),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10.r),
//                             borderSide: BorderSide(color: Colors.blue, width: 2),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20.h),
//                     Text("Email Address", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 2.h),
//                     SizedBox(
//                       width: 350.w,
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: "Enter Email Address",
//                           hintStyle: TextStyle(color: Color.fromARGB(255, 173, 171, 171), fontSize: 15.sp),
//                           contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10.r),
//                             borderSide: BorderSide(color: Color.fromARGB(255, 173, 171, 171), width: 1.4),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10.r),
//                             borderSide: BorderSide(color: Colors.blue, width: 2),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20.h),
//                     Text("Phone Number", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 2.h),
//                     SizedBox(
//                       width: 350.w,
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: "Enter Phone Number",
//                           hintStyle: TextStyle(color: Color.fromARGB(255, 173, 171, 171), fontSize: 15.sp),
//                           contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10.r),
//                             borderSide: BorderSide(color: Color.fromARGB(255, 173, 171, 171), width: 1.4),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10.r),
//                             borderSide: BorderSide(color: Colors.blue, width: 2),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20.h),
//                     Text("Password", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 2.h),
//                     SizedBox(
//                       width: 350.w,
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: "Enter Password",
//                           hintStyle: TextStyle(color: Color.fromARGB(255, 173, 171, 171), fontSize: 15.sp),
//                           contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10.r),
//                             borderSide: BorderSide(color: Color.fromARGB(255, 173, 171, 171), width: 1.4),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10.r),
//                             borderSide: BorderSide(color: Colors.blue, width: 2),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 40.h),
//                   ],
//                 ),
//                 SizedBox(
//                   width: 285.w,
//                   height: 47.h,
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFFEB9974),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r)),
//                     ),
//                     child: Text(
//                       'Update',
//                       style: TextStyle(fontSize: 22.sp, color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 50.h),
//               ],
//             ),
//           ),
//         ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Editprofile extends StatefulWidget {
  final String token;
  final String email;

  const Editprofile({super.key, required this.token, required this.email});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController    = TextEditingController();
  final TextEditingController phoneController    = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading   = false;
  bool _obscurePass = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ── GET profile from backend ──
  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final url = Uri.parse('http://192.168.18.163:8000/getProfile/');
      final res = await http.get(url, headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      });

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        usernameController.text = data['username'] ?? '';
        emailController.text    = widget.email;
        phoneController.text    = data['phone']    ?? '';
      } else {
        _showSnack("Failed to load profile", isError: true);
      }
    } catch (e) {
      _showSnack("Network error: $e", isError: true);
    }
    setState(() => _isLoading = false);
  }

  // ── POST update profile ──
  Future<void> _updateProfile() async {
    if (usernameController.text.trim().isEmpty) {
      _showSnack("Username cannot be empty", isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final url = Uri.parse('http://192.168.18.163:8000/updateProfile/');
      final body = <String, dynamic>{
        'username': usernameController.text.trim(),
        'phone':    phoneController.text.trim(),
      };
      // Password sirf tab bhejo jab user ne fill kiya ho
      if (passwordController.text.isNotEmpty) {
        body['password'] = passwordController.text;
      }

      final res = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        _showSnack("Profile updated successfully!");
        // Optional: thodi der baad wapas jao
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Navigator.pop(context, true);
      } else {
        final err = jsonDecode(res.body);
        _showSnack(err['error'] ?? "Update failed", isError: true);
      }
    } catch (e) {
      _showSnack("Network error: $e", isError: true);
    }
    setState(() => _isLoading = false);
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
    ));
  }

  // ── Reusable input decoration ──
  InputDecoration _inputDec(String hint, {Widget? suffix}) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: const Color.fromARGB(255, 173, 171, 171),
          fontSize: 15.sp,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
        suffixIcon: suffix,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 173, 171, 171),
            width: 1.4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(fontSize: 30.sp, color: Colors.black),
        ),
        backgroundColor: const Color(0xFFFBFBFC),
        toolbarHeight: 120.h,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFEB9974)),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ── Header ──
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

                    // ── Form fields ──
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Username
                          Text("User Name",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: 350.w,
                            child: TextField(
                              controller: usernameController,
                              decoration: _inputDec("Enter User Name"),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Email (read-only)
                          Text("Email Address",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: 350.w,
                            child: TextField(
                              controller: emailController,
                              readOnly: true,
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 15.sp),
                              decoration: _inputDec("Email Address").copyWith(
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                suffixIcon: Icon(Icons.lock_outline,
                                    color: Colors.grey.shade400,
                                    size: 18.sp),
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Padding(
                            padding: EdgeInsets.only(left: 4.w),
                            child: Text(
                              "Email cannot be changed",
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey.shade400),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Phone Number
                          Text("Phone Number",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: 350.w,
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: _inputDec("Enter Phone Number"),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Password
                          Text("New Password",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: 350.w,
                            child: TextField(
                              controller: passwordController,
                              obscureText: _obscurePass,
                              decoration: _inputDec(
                                "Leave blank to keep current password",
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscurePass
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                    size: 20.sp,
                                  ),
                                  onPressed: () => setState(
                                      () => _obscurePass = !_obscurePass),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),

                          // Update Button
                          Center(
                            child: SizedBox(
                              width: 285.w,
                              height: 47.h,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _updateProfile,
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
                          ),
                          SizedBox(height: 50.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
