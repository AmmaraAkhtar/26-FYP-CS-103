import 'package:flutter/material.dart';
import 'Monitoring.dart';
import "ChildRegister.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




class home extends StatefulWidget {
  String email;
  home({super.key, required this.email});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredChildren = []; 
  List<Map<String, dynamic>> children = []; // empty initially
  bool isLoading = true;
    //final List<Map<String, dynamic>> children = [
   /* {
      "name": "Hamza Ali",
      "age": 9,
      "status": "Online",
      "lastAlert": "Just Now",
      "image": "https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png"
    },
    {
      "name": "Ammara Khan",
      "age": 11,
      "status": "Offline",
      "lastAlert": "Just Now",
      "image": "https://static.vecteezy.com/system/resources/previews/022/416/248/non_2x/avatar-of-girl-with-pigtails-colored-icon-vector.jpg"
    },
    {
      "name": "Amna Ali",
      "age": 8,
      "status": "Offline",
      "lastAlert": "Just Now",
      "image": "https://img.favpng.com/22/11/14/3d-boy-avatar-cartoon-boy-with-glasses-in-3d-style-biFKVkT6_t.jpg"
    },
    {
      "name": "Babar Akhtar",
      "age": 13,
      "status": "Online",
      "lastAlert": "Just Now",
      "image": "https://img.freepik.com/free-vector/portrait-boy-with-brown-hair-brown-eyes_1308-146018.jpg"
    },
  ];*/

  @override
  void initState() {
    super.initState();
    fetchChildren();
    searchController.addListener(_filterChildren);
  }

  void _filterChildren() {
  final query = searchController.text.toLowerCase();
  setState(() {
    filteredChildren = children.where((child) {
      final name = child['name'].toString().toLowerCase();
      return name.contains(query);
    }).toList();
  });
}

  Future<void> fetchChildren() async {
    print("Fetching children for parent email: ${widget.email}");
    final url = Uri.parse(
        'http://127.0.0.1:8000/fetchChildren/?parent_email=${widget.email}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print("Fetched data: $data");

        setState(() {
          children = data.map((child) {
            return {
              "name": "${child['firstname']} ${child['lastname']}",
              "age": child['age'],
              "status": (child['is_paired'] ?? false) ? "Online" : "Offline",
              "lastAlert": "Just Now", 
              "image":
                  "https://img.favpng.com/22/11/14/3d-boy-avatar-cartoon-boy-with-glasses-in-3d-style-biFKVkT6_t.jpg" // placeholder
            };
          }).toList();
          filteredChildren = List.from(children); 
          isLoading = false;
        });
      } else {
        print("Error fetching children: ${response.body}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Exception: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Top section
              Container(
                width: 1.sw,
                height: 294.h,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Color(0xFFEB9974),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70.r,
                      backgroundImage: NetworkImage(
                          "https://thumbs.dreamstime.com/b/d-cartoon-illustration-smiling-woman-short-brown-hair-wearing-red-mom-t-shirt-keywords-mother-demeanor-showing-female-417653140.jpg"),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "User",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 19.h),
                    SizedBox(
                      width: 303.w,
                      height: 50.h,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 189, 188, 188),
                              fontSize: 16.sp),
                          prefixIcon: Image.asset("assets/Search.png"),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.r),
                            borderSide:
                                BorderSide(color: Color.fromARGB(255, 189, 188, 188), width: 1.w),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.r),
                            borderSide:
                                BorderSide(color: Color(0xFF147CF4), width: 1.w),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Child List Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Child List",
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF6B9888),
                      ),
                    ),
                    SizedBox(
                      width: 106.w,
                      height: 34.h,
                      child: ElevatedButton(
                        onPressed: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => profile(email: widget.email,),
                            ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEB9974),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          'Add +',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Child List
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: filteredChildren.length,
                        itemBuilder: (context, index) {
                          final child = filteredChildren[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15.r),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Monitoring(
                                      childData: child, 
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Row(
                                  children: [
                                    // Big Circle Image
                                    Container(
                                      width: 100.w,
                                      height: 100.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(child['image']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15.w),

                                    // Name, Age, Status
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            child['name'],
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            "${child['age']} Years Old",
                                            style: TextStyle(color: Colors.grey[700]),
                                          ),
                                          SizedBox(height: 5.h),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                size: 10.w,
                                                color: child['status'] == "Online"
                                                    ? Colors.green
                                                    : Colors.grey,
                                              ),
                                              SizedBox(width: 5.w),
                                              Text(
                                                child['status'],
                                                style: TextStyle(
                                                  color: child['status'] == "Online"
                                                      ? Colors.green
                                                      : Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "Last Alert: ${child['lastAlert']}",
                                            style: TextStyle(color: Color(0xFF7D7D7D), fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Notifications Icon
                                    Icon(
                                      Icons.notifications,
                                      color: Colors.red,
                                      size: 30.w,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      );   
  }
}
