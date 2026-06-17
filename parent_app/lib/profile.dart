// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/editProfile.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'editProfile.dart';


// class profile extends StatefulWidget {
//   const profile({super.key});

//   @override
//   State<profile> createState() => _profileState();
// }

// class _profileState extends State<profile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFAFBFB),
//       appBar: AppBar(
//         title: Text(
//           "Profile",
//           style: TextStyle(fontSize: 30.sp, color: Colors.black),
//         ),
//         backgroundColor: Color(0xFFFBFBFC),
//         toolbarHeight: 120.h,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   Container(
//                     height: 200.h,
//                     width: double.infinity,
//                     color: Color(0xFFEB9974),
//                   ),
//                   Positioned(
//                     bottom: -50.h,
//                     left: 0,
//                     right: 0,
//                     child: Center(
//                       child: CircleAvatar(
//                         radius: 100.r,
//                         backgroundImage: AssetImage('assets/person.jpg'),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 50.h),
//               Text(
//                 "Ammara",
//                 style: TextStyle(fontSize: 29.sp, color: Colors.black),
//               ),
//               SizedBox(height: 30.h),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Phone",
//                             style: TextStyle(
//                                 fontSize: 20.sp, color: Color(0xFFACABAB))),
//                         Text('+92303-8761832',
//                             style:
//                                 TextStyle(fontSize: 20.sp, color: Colors.black)),
//                       ],
//                     ),
//                     SizedBox(height: 5.h),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Email",
//                             style: TextStyle(
//                                 fontSize: 20.sp, color: Color(0xFFACABAB))),
//                         Text("ammaraakhtar93@Gmail.com",
//                             style:
//                                 TextStyle(fontSize: 20.sp, color: Colors.black)),
//                       ],
//                     ),
//                     SizedBox(height: 5.h),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Save Notes",
//                             style: TextStyle(
//                                 fontSize: 20.sp, color: Color(0xFFACABAB))),
//                         Text("200",
//                             style:
//                                 TextStyle(fontSize: 20.sp, color: Colors.black)),
//                       ],
//                     ),
//                     SizedBox(height: 5.h),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Account Created At",
//                             style: TextStyle(
//                                 fontSize: 20.sp, color: Color(0xFFACABAB))),
//                         Text("23-02-2020",
//                             style:
//                                 TextStyle(fontSize: 20.sp, color: Colors.black)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 40.h),

//               // Menu items
//               Container(
//                 height: 90.h,
//                 decoration: BoxDecoration(
//                   color: Color.fromARGB(255, 252, 250, 250),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         spreadRadius: 5,
//                         blurRadius: 3,
//                         offset: Offset(0, 1))
//                   ],
//                 ),
//                 child: Center(
//                   child: ListTile(
//                     leading: Icon(Icons.dark_mode_sharp, size: 40.sp),
//                     iconColor: Colors.black,
//                     trailing: Icon(Icons.toggle_on_sharp, size: 40.sp),
//                     title: Text("Dark Mode",
//                         style: TextStyle(
//                             fontSize: 20.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black)),
//                     onTap: () {},
//                   ),
//                 ),
//               ),

//               Container(
//                 height: 90.h,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         spreadRadius: 5,
//                         blurRadius: 3,
//                         offset: Offset(0, 1))
//                   ],
//                 ),
//                 child: Center(
//                   child: ListTile(
//                     leading: Icon(Icons.person_4_sharp, size: 40.sp),
//                     iconColor: Colors.black,
//                     title: Text("Edit Profile",
//                         style: TextStyle(
//                             fontSize: 20.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black)),
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>   Editprofile()));
//                     },
//                   ),
//                 ),
//               ),

//               Container(
//                 height: 90.h,
//                 decoration: BoxDecoration(
//                   color: Color.fromARGB(255, 252, 250, 250),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         spreadRadius: 5,
//                         blurRadius: 3,
//                         offset: Offset(0, 1))
//                   ],
//                 ),
//                 child: Center(
//                   child: ListTile(
//                     leading: Icon(Icons.settings, size: 40.sp),
//                     iconColor: Colors.black,
//                     title: Text("Settings",
//                         style: TextStyle(
//                             fontSize: 20.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black)),
//                     onTap: () {},
//                   ),
//                 ),
//               ),

//               Container(
//                 height: 90.h,
//                 decoration: BoxDecoration(
//                   color: Color.fromARGB(255, 252, 250, 250),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         spreadRadius: 5,
//                         blurRadius: 3,
//                         offset: Offset(0, 1))
//                   ],
//                 ),
//                 child: Center(
//                   child: ListTile(
//                     leading: Icon(Icons.logout_sharp,
//                         size: 40.sp, color: Colors.redAccent),
//                     iconColor: Colors.black,
//                     title: Text("Log out",
//                         style: TextStyle(
//                             fontSize: 20.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black)),
//                   ),
//                 ),
//               ),

//               SizedBox(height: 20.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }








// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'editProfile.dart';

// class profile extends StatefulWidget {
//   final String token;
//   final String email;
//   const profile({super.key, required this.token, required this.email});

//   @override
//   State<profile> createState() => _profileState();
// }

// class _profileState extends State<profile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFBFB),
//       appBar: AppBar(
//         title: Text(
//           "Profile",
//           style: TextStyle(fontSize: 30.sp, color: Colors.black),
//         ),
//         backgroundColor: const Color(0xFFFBFBFC),
//         toolbarHeight: 120.h,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   Container(
//                     height: 200.h,
//                     width: double.infinity,
//                     color: const Color(0xFFEB9974),
//                   ),
//                   Positioned(
//                     bottom: -50.h,
//                     left: 0,
//                     right: 0,
//                     child: Center(
//                       child: CircleAvatar(
//                         radius: 100.r,
//                         backgroundColor: Colors.grey.shade300,
//                         child: Icon(
//                           Icons.person,
//                           size: 80.r,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 50.h),
//               Text(
//                 widget.email,
//                 style: TextStyle(fontSize: 18.sp, color: Colors.grey),
//               ),
//               SizedBox(height: 30.h),

//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Email",
//                             style: TextStyle(
//                                 fontSize: 18.sp, color: const Color(0xFFACABAB))),
//                         Flexible(
//                           child: Text(
//                             widget.email,
//                             style: TextStyle(fontSize: 16.sp, color: Colors.black),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 40.h),



//               // Edit Profile
//               Container(
//                 height: 90.h,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         spreadRadius: 5,
//                         blurRadius: 3,
//                         offset: const Offset(0, 1))
//                   ],
//                 ),
//                 child: Center(
//                   child: ListTile(
//                     leading: Icon(Icons.person_4_sharp, size: 40.sp),
//                     iconColor: Colors.black,
//                     title: Text("Edit Profile",
//                         style: TextStyle(
//                             fontSize: 20.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black)),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => Editprofile(
//                             token: widget.token,
//                             email: widget.email,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),

 
//               // Logout
//               Container(
//                 height: 90.h,
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 252, 250, 250),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         spreadRadius: 5,
//                         blurRadius: 3,
//                         offset: const Offset(0, 1))
//                   ],
//                 ),
//                 child: Center(
//                   child: ListTile(
//                     leading: Icon(Icons.logout_sharp,
//                         size: 40.sp, color: Colors.redAccent),
//                     title: Text("Log out",
//                         style: TextStyle(
//                             fontSize: 20.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black)),
//                     onTap: () {},
//                   ),
//                 ),
//               ),

//               SizedBox(height: 20.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'editProfile.dart';

class profile extends StatefulWidget {
  final String token;
  final String email;
  const profile({super.key, required this.token, required this.email});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 22.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFFF5F6FA),
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 60.h,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header ──
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 160.h,
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
                    bottom: -55.h,
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
                          radius: 55.r,
                          backgroundColor: Colors.grey.shade200,
                          child: Icon(
                            Icons.person,
                            size: 55.r,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 70.h),

              // ── Name / Email ──
              Text(
                widget.email.split('@')[0], // email se pehla part naam ki tarah
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                widget.email,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade500,
                ),
              ),

              SizedBox(height: 24.h),

              // ── Info Card ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEB9974).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFFEB9974),
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          Text(
                            widget.email,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              // ── Menu Options ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    // Edit Profile tile
                    _menuTile(
                      icon: Icons.edit_outlined,
                      label: "Edit Profile",
                      iconBgColor: const Color(0xFFEB9974).withOpacity(0.15),
                      iconColor: const Color(0xFFEB9974),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Editprofile(
                              token: widget.token,
                              email: widget.email,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 12.h),

                    // Logout tile
                    _menuTile(
                      icon: Icons.logout_rounded,
                      label: "Log Out",
                      iconBgColor: Colors.red.shade50,
                      iconColor: Colors.red.shade400,
                      labelColor: Colors.red.shade400,
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  // ── Reusable menu tile ──
  Widget _menuTile({
    required IconData icon,
    required String label,
    required Color iconBgColor,
    required Color iconColor,
    Color? labelColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            SizedBox(width: 14.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: labelColor ?? Colors.black87,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  // ── Logout confirmation dialog ──
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          "Log Out",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to log out?",
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // logout logic yahan add karo
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              "Log Out",
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}