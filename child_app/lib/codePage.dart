import 'package:flutter/material.dart';
import 'chat.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:http/http.dart" as http;
import "dart:convert";

class otp extends StatefulWidget {
  const otp({super.key});

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  final TextEditingController _num1 = TextEditingController();
  final TextEditingController _num2 = TextEditingController();
  final TextEditingController _num3 = TextEditingController();
  final TextEditingController _num4 = TextEditingController();

  // Error message
  String error = "";
  String error_message = "";

  void validateOTP() {
    setState(() {
      error = "";
      List<TextEditingController> fields = [_num1, _num2, _num3, _num4];

      for (var f in fields) {
        String val = f.text.trim();
        if (val.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("All fields must be filled")));
          return; // Stop checking
        }
      }

      error = "";
    });
  }

  Future<void> verifyotp(
    String num1,
    String num2,
    String num3,
    String num4,
  ) async {
    String code = num1 + num2 + num3 + num4;
    String link = 'http://10.27.190.96:8000/pairDevice/';
    final url = Uri.parse(link);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'pairing_code': code}),
      );

      if (response.statusCode == 200) {
        print('Verification successful');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Pairing successful!")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WatcherScreen()),
        );
      } else {
        var data = jsonDecode(response.body);
        setState(() {
          if (data is Map) {
            error_message = data.values.join("\n");
          } else {
            error_message = data.toString();
          }
        });
      }
    } catch (e) {
      setState(() {
        error_message = "Network error: $e";
      });
    }
  }

  void handleSubmit() async {
    validateOTP();
    if (error.isEmpty) {
      await verifyotp(_num1.text, _num2.text, _num3.text, _num4.text);
      if (error_message.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error_message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250.h),
        child: AppBar(
          backgroundColor: Color(0xFFFBFBFC),
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: 50.h),
            child: Hero(
              tag: 'applog',
              child: Image.asset('assets/logo.png', height: 189.h),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 0),
            child: SizedBox(
              width: 1.sw,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Protecting Code",
                    style: TextStyle(
                      fontSize: 36.sp,
                      color: Color(0xFF699886),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Enter the 4-digit Code from the parent App",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 55.w,
                        height: 55.h,
                        child: TextField(
                          controller: _num1,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Color(0xFFF1A37A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 55.w,
                        height: 55.h,
                        child: TextField(
                          controller: _num2,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Color(0xFFF1A37A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 55.w,
                        height: 55.h,
                        child: TextField(
                          controller: _num3,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Color(0xFFF1A37A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 55.w,
                        height: 55.h,
                        child: TextField(
                          controller: _num4,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Color(0xFFF1A37A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 45.h),
                  SizedBox(
                    width: 285.w,
                    height: 47.h,
                    child: ElevatedButton(
                      onPressed: () {
                        handleSubmit();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEB9974),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                      ),
                      child: Text(
                        'Pair Now',
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
      ),
    );
  }
}