import 'package:flutter/material.dart';
import 'Monitoring.dart';
import "ChildRegister.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  final String email;

  const Home({super.key, required this.email});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> children = [];
  List<Map<String, dynamic>> filteredChildren = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChildren();
    searchController.addListener(_filterChildren);
  }

  /// SEARCH FILTER
  void _filterChildren() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredChildren = children.where((child) {
        return child['name']
            .toString()
            .toLowerCase()
            .contains(query);
      }).toList();
    });
  }

  /// API FETCH
  Future<void> fetchChildren() async {
    final url = Uri.parse(
        'http://10.27.190.96:8000/fetchChildren/?parent_email=${widget.email}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        setState(() {
          children = data.map((child) {
            return {
              "name":
                  "${child['firstname']} ${child['lastname']}",
              "age": child['age'],
              "status":
                  (child['is_paired'] ?? false)
                      ? "Online"
                      : "Offline",
              "lastAlert": "Just Now",
              "image":
                  "https://img.favpng.com/22/11/14/3d-boy-avatar-cartoon-boy-with-glasses-in-3d-style-biFKVkT6_t.jpg",
            };
          }).toList();

          filteredChildren = List.from(children);
          isLoading = false;
        });
      } else {
        isLoading = false;
      }
    } catch (e) {
      print(e);
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      body: SafeArea(
        child: Column(
          children: [

            /// TOP PROFILE SECTION
            Container(
              width: 1.sw,
              height: 294.h,
              padding: EdgeInsets.all(20.w),
              color: const Color(0xFFEB9974),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 70.r,
                    backgroundImage: const NetworkImage(
                        "https://thumbs.dreamstime.com/b/d-cartoon-illustration-smiling-woman-short-brown-hair-wearing-red-mom-t-shirt-keywords-mother-demeanor-showing-female-417653140.jpg"),
                  ),
                  SizedBox(height: 10.h),

                  Text(
                    "User",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp),
                  ),

                  SizedBox(height: 20.h),

                  /// SEARCH BAR
                  SizedBox(
                    width: 303.w,
                    height: 50.h,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search",
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon:
                            const Icon(Icons.search),
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  40.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// HEADER
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 15.h),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Child List",
                    style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            const Color(0xFF6B9888)),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              Profile(
                                  email:  widget.email),
                        ),
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                              0xFFEB9974),
                    ),
                    child: const Text(
                      "Add +",
                      style: TextStyle(
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ),

            /// CHILD LIST
            Expanded(
              child: isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator())
                  : ListView.builder(
                      itemCount:
                          filteredChildren.length,
                      itemBuilder:
                          (context, index) {
                        final child =
                            filteredChildren[index];

                        return Padding(
                          padding:
                              EdgeInsets.symmetric(
                                  horizontal:
                                      20.w,
                                  vertical:
                                      8.h),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      Monitoring(
                                    childData:
                                        child,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding:
                                  EdgeInsets.all(
                                      12.w),
                              decoration:
                                  BoxDecoration(
                                color:
                                    Colors.white,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            15.r),
                              ),
                              child: Row(
                                children: [

                                  /// IMAGE
                                  CircleAvatar(
                                    radius:
                                        45.r,
                                    backgroundImage:
                                        NetworkImage(
                                            child[
                                                'image']),
                                  ),

                                  SizedBox(
                                      width:
                                          15.w),

                                  /// DETAILS
                                  Expanded(
                                    child:
                                        Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          child[
                                              'name'],
                                          style:
                                              TextStyle(
                                            fontSize:
                                                18.sp,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),

                                        SizedBox(
                                            height:
                                                5.h),

                                        Text(
                                          "${child['age']} Years Old",
                                          style:
                                              TextStyle(
                                            color: Colors
                                                .grey[700],
                                          ),
                                        ),

                                        SizedBox(
                                            height:
                                                5.h),

                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .circle,
                                              size:
                                                  10.w,
                                              color: child['status'] ==
                                                      "Online"
                                                  ? Colors
                                                      .green
                                                  : Colors
                                                      .grey,
                                            ),
                                            SizedBox(
                                                width:
                                                    5.w),
                                            Text(
                                              child[
                                                  'status'],
                                            ),
                                          ],
                                        ),

                                        SizedBox(
                                            height:
                                                5.h),

                                        Text(
                                          "Last Alert: ${child['lastAlert']}",
                                          style:
                                              TextStyle(
                                            fontSize:
                                                12.sp,
                                            color:
                                                const Color(
                                                    0xFF7D7D7D),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// ALERT ICON
                                  Icon(
                                    Icons
                                        .notifications,
                                    color:
                                        Colors.red,
                                    size: 30.w,
                                  )
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