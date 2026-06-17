



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class Editprofile extends StatefulWidget {
//   final String token;
//   final String email;

//   const Editprofile({super.key, required this.token, required this.email});

//   @override
//   State<Editprofile> createState() => _EditprofileState();
// }

// class _EditprofileState extends State<Editprofile> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController    = TextEditingController();
//   final TextEditingController phoneController    = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   bool _isLoading   = false;
//   bool _obscurePass = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadProfile();
//   }

//   Future<void> _loadProfile() async {
//     setState(() => _isLoading = true);
//     try {
//       final url = Uri.parse('http://10.13.45.141:8000/getProfile/');
//       final res = await http.get(url, headers: {
//         'Authorization': 'Bearer ${widget.token}',
//         'Content-Type': 'application/json',
//       });

//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         usernameController.text = data['username'] ?? '';
//         emailController.text    = widget.email;
//         phoneController.text    = data['phone']    ?? '';
//       } else {
//         _showSnack("Failed to load profile", isError: true);
//       }
//     } catch (e) {
//       _showSnack("No internet connection. Please try again.", isError: true);
//     }
//     setState(() => _isLoading = false);
//   }

//   Future<void> _updateProfile() async {
//     if (usernameController.text.trim().isEmpty) {
//       _showSnack("Username cannot be empty", isError: true);
//       return;
//     }

//     setState(() => _isLoading = true);
//     try {
//       final url = Uri.parse('http://10.13.45.141:8000/updateProfile/');
//       final body = <String, dynamic>{
//         'username': usernameController.text.trim(),
//         'phone':    phoneController.text.trim(),
//       };
//       if (passwordController.text.isNotEmpty) {
//         body['password'] = passwordController.text;
//       }

//       final res = await http.post(
//         url,
//         headers: {
//           'Authorization': 'Bearer ${widget.token}',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(body),
//       );

//       if (res.statusCode == 200) {
//         _showSnack("Profile updated successfully!");
//         await Future.delayed(const Duration(seconds: 1));
//         if (mounted) Navigator.pop(context, true);
//       } else {
//         _showSnack("Update failed. Please try again.", isError: true);
//       }
//     } catch (e) {
//       _showSnack("No internet connection. Please try again.", isError: true);
//     }
//     setState(() => _isLoading = false);
//   }

//   void _showSnack(String msg, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(msg),
//       backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
//     ));
//   }

//   InputDecoration _inputDec(String hint, {Widget? suffix}) => InputDecoration(
//         hintText: hint,
//         hintStyle: TextStyle(
//           color: const Color.fromARGB(255, 173, 171, 171),
//           fontSize: 15.sp,
//         ),
//         contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
//         suffixIcon: suffix,
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.r),
//           borderSide: BorderSide(
//             color: const Color.fromARGB(255, 173, 171, 171),
//             width: 1.4,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.r),
//           borderSide: const BorderSide(color: Colors.blue, width: 2),
//         ),
//       );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFBFBFC),
//       appBar: AppBar(
//         title: Text(
//           "Edit Profile",
//           style: TextStyle(fontSize: 30.sp, color: Colors.black),
//         ),
//         backgroundColor: const Color(0xFFFBFBFC),
//         toolbarHeight: 120.h,
//         elevation: 0,
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(color: Color(0xFFEB9974)),
//             )
//           : SafeArea(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         Container(
//                           height: 200.h,
//                           width: double.infinity,
//                           color: const Color(0xFFEB9974),
//                         ),
//                         Positioned(
//                           bottom: -50.h,
//                           left: 0,
//                           right: 0,
//                           child: Center(
//                             child: CircleAvatar(
//                               radius: 100.r,
//                               backgroundColor: Colors.grey.shade300,
//                               child: Icon(
//                                 Icons.person,
//                                 size: 80.r,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 60.h),
//                     SizedBox(height: 30.h),

//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16.w),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("User Name",
//                               style: TextStyle(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.bold)),
//                           SizedBox(height: 2.h),
//                           SizedBox(
//                             width: 350.w,
//                             child: TextField(
//                               controller: usernameController,
//                               decoration: _inputDec("Enter User Name"),
//                             ),
//                           ),
//                           SizedBox(height: 20.h),

//                           Text("Email Address",
//                               style: TextStyle(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.bold)),
//                           SizedBox(height: 2.h),
//                           SizedBox(
//                             width: 350.w,
//                             child: TextField(
//                               controller: emailController,
//                               readOnly: true,
//                               style: TextStyle(
//                                   color: Colors.grey.shade500,
//                                   fontSize: 15.sp),
//                               decoration: _inputDec("Email Address").copyWith(
//                                 filled: true,
//                                 fillColor: Colors.grey.shade100,
//                                 suffixIcon: Icon(Icons.lock_outline,
//                                     color: Colors.grey.shade400,
//                                     size: 18.sp),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 4.h),
//                           Padding(
//                             padding: EdgeInsets.only(left: 4.w),
//                             child: Text(
//                               "Email cannot be changed",
//                               style: TextStyle(
//                                   fontSize: 11.sp,
//                                   color: Colors.grey.shade400),
//                             ),
//                           ),
//                           SizedBox(height: 16.h),

//                           Text("Phone Number",
//                               style: TextStyle(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.bold)),
//                           SizedBox(height: 2.h),
//                           SizedBox(
//                             width: 350.w,
//                             child: TextField(
//                               controller: phoneController,
//                               keyboardType: TextInputType.phone,
//                               decoration: _inputDec("Enter Phone Number"),
//                             ),
//                           ),
//                           SizedBox(height: 20.h),

//                           Text("New Password",
//                               style: TextStyle(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.bold)),
//                           SizedBox(height: 2.h),
//                           SizedBox(
//                             width: 350.w,
//                             child: TextField(
//                               controller: passwordController,
//                               obscureText: _obscurePass,
//                               decoration: _inputDec(
//                                 "Leave blank to keep current password",
//                                 suffix: IconButton(
//                                   icon: Icon(
//                                     _obscurePass
//                                         ? Icons.visibility_off
//                                         : Icons.visibility,
//                                     color: Colors.grey,
//                                     size: 20.sp,
//                                   ),
//                                   onPressed: () => setState(
//                                       () => _obscurePass = !_obscurePass),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 40.h),

//                           Center(
//                             child: SizedBox(
//                               width: 285.w,
//                               height: 47.h,
//                               child: ElevatedButton(
//                                 onPressed: _isLoading ? null : _updateProfile,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xFFEB9974),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(40.r),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   'Update',
//                                   style: TextStyle(
//                                     fontSize: 22.sp,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 50.h),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
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

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final url = Uri.parse('https://the-watcher-backend.onrender.com/getProfile/');
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
      _showSnack("No internet connection. Please try again.", isError: true);
    }
    setState(() => _isLoading = false);
  }

  Future<void> _updateProfile() async {
    if (usernameController.text.trim().isEmpty) {
      _showSnack("Username cannot be empty", isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final url = Uri.parse('https://the-watcher-backend.onrender.com/updateProfile/');
      final body = <String, dynamic>{
        'username': usernameController.text.trim(),
        'phone':    phoneController.text.trim(),
      };
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
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Navigator.pop(context, true);
      } else {
        _showSnack("Update failed. Please try again.", isError: true);
      }
    } catch (e) {
      _showSnack("No internet connection. Please try again.", isError: true);
    }
    setState(() => _isLoading = false);
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  // ── Reusable field widget ──
  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
    Widget? suffixIcon,
    String? subText,
    Color? fillColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 0.4,
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          readOnly: readOnly,
          obscureText: obscure,
          keyboardType: keyboard,
          style: TextStyle(
            fontSize: 15.sp,
            color: readOnly ? Colors.grey.shade500 : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14.sp,
            ),
            filled: fillColor != null || readOnly,
            fillColor: readOnly ? Colors.grey.shade100 : fillColor,
            suffixIcon: suffixIcon,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFFEB9974),
                width: 2,
              ),
            ),
          ),
        ),
        if (subText != null) ...[
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Text(
              subText,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFFF5F6FA),
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 60.h,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
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
                          height: 150.h,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEB9974),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -50.h,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 50.r,
                                backgroundColor: Colors.grey.shade200,
                                child: Icon(
                                  Icons.person,
                                  size: 50.r,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 70.h),

                    // ── Form Card ──
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 24.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Username
                            _buildField(
                              label: "USERNAME",
                              controller: usernameController,
                              hint: "Enter username",
                            ),
                            SizedBox(height: 20.h),

                            // Email
                            _buildField(
                              label: "EMAIL ADDRESS",
                              controller: emailController,
                              hint: "Email",
                              readOnly: true,
                              subText: "Email cannot be changed",
                              suffixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.grey.shade400,
                                size: 18,
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Phone
                            _buildField(
                              label: "PHONE NUMBER",
                              controller: phoneController,
                              hint: "Enter phone number",
                              keyboard: TextInputType.phone,
                            ),
                            SizedBox(height: 20.h),

                            // Password
                            _buildField(
                              label: "NEW PASSWORD",
                              controller: passwordController,
                              hint: "Leave blank to keep current",
                              obscure: _obscurePass,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePass
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                                onPressed: () => setState(
                                    () => _obscurePass = !_obscurePass),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),

                    // ── Update Button ──
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _updateProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEB9974),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
}


