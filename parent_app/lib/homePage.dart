import 'package:flutter/material.dart';
import 'Monitoring.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
    final List<Map<String, dynamic>> children = [
    {
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
  ];

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            // Top section
            Container(
              width: double.infinity,
              height:294,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFEB9974),
                borderRadius: BorderRadius.only(
                 
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(
                        "https://thumbs.dreamstime.com/b/d-cartoon-illustration-smiling-woman-short-brown-hair-wearing-red-mom-t-shirt-keywords-mother-demeanor-showing-female-417653140.jpg"),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "User",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 19),
                  SizedBox(
                    width: 303,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 189, 188, 188),
                          fontSize: 16,
                        ),
                        prefixIcon: Image.asset("assets/Search.png"),
                        // prefixIcon: Icon(Icons.search,color:Color.fromARGB(255, 189, 188, 188),size:22),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 189, 188, 188),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(
                            color: Color(0xFF147CF4),
                            width: 1,
                          ),
                        ),
                      
                      ),
                    ),
                  ),
              
                ],
              ),
            ),

            // Child List Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Child List",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF6B9888),
                    ),
                  ),
                  SizedBox(
                    width: 106,
                    height: 34,
                    child: ElevatedButton(
                      onPressed: () {
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEB9974),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Add +',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          
                        ),
                      ),
                    ),
                  ),
                
                ],
              ),
            ),

      
                  Expanded(
                    child: ListView.builder(
                      itemCount: children.length,
                      itemBuilder: (context, index) {
                        final child = children[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: InkWell(
                          borderRadius: BorderRadius.circular(15),
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
                          child:Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                // Big Circle Image
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(child['image']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),

                                // Name, Age, Status
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        child['name'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "${child['age']} Years Old",
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 10,
                                            color: child['status'] == "Online"
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                          SizedBox(width: 5),
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
                                            style: TextStyle(color: Color(0xFF7D7D7D), fontSize: 12),
                                          ),
                                    ],
                                  ),
                                ),

                                  // Notifications Icon
                                  Icon(
                                    Icons.notifications,
                                    color: Colors.red,
                                    size: 30,
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
