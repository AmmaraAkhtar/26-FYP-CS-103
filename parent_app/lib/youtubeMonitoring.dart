import 'package:flutter/material.dart';

class youtube extends StatefulWidget {
  const youtube({super.key});

  @override
  State<youtube> createState() => _youtubeState();
}

class _youtubeState extends State<youtube> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFFF2F0F6),
        title: const Text("YouTube Monitoring Dashboard",style:TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Profile Section
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage("https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png"),
                  ),
                  SizedBox(height: 8),
                  Text("Hamza Ali",
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold)),
                  Text("11 Years Old",
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const SizedBox(height: 20),

            // Usage Chart placeholder
            const Text(
              "Usage",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Center(
            child: Column(
            children: [
            Image.asset("assets/youtube.png"),
            ],),),
            const SizedBox(height: 20),

            // Content Cards
            contentCard(
                "Principle Component Analysis (PCA) | Part 2 | Problem Formulation and Step by Step Solution",
                "CampusX",
                "Educational",
                Colors.blue,
                "15min"),
            contentCard(
                "Principle Component Analysis (PCA) | Part 2 | Problem Formulation and Step by Step Solution",
                "CampusX",
                "Gaming",
                Colors.green,
                "15min"),
            contentCard(
                "Principle Component Analysis (PCA) | Part 2 | Problem Formulation and Step by Step Solution",
                "CampusX",
                "Violence",
                Colors.red,
                "15min"),

            const SizedBox(height: 20),

            // Alerts
            const Text(
              "Alerts",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            alertCard("Violent Content Detected", "10:30 AM"),
            alertCard("Violent Content Detected", "10:30 AM"),


          ],
 
        ),
      ),
    );
  }
}



  // Content card widget
  Widget contentCard(
      String title, String source, String category, Color color, String time) {
    return Card(
      color: Colors.orange[200],
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(source,
                    style: const TextStyle(
                        decoration: TextDecoration.underline)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Text(time),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Alert card widget
  Widget alertCard(String message, String time) {
    return Card(
      color: Colors.red[100],
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
            Text(time, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
