import 'package:flutter/material.dart';



class monitoringPage extends StatefulWidget {
  final Map<String, dynamic>? childData;
  const monitoringPage({super.key, this.childData});

  @override
  State<monitoringPage> createState() => _monitoringPageState();
}

class _monitoringPageState extends State<monitoringPage> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFFF2F0F6),
        title: const Text("Live Monitoring Data",style:TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
        
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

            /// Usage Card
            const Text("Usage",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
             

             Center(
              child: Column(
                children: [
            Image.asset("assets/daily.png"),
            Image.asset("assets/week.png"),],),),
            const SizedBox(height: 20),

            /// Alerts Section
            const Text("Alerts",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            /// Alert 1
            Card(
              color: Colors.red[50],
              child: ListTile(
                leading: const Icon(Icons.warning, color: Colors.red),
                title: const Text("Bullying Detected"),
                subtitle: const Text("Suspicious language detected"),
                trailing: ElevatedButton(
                  onPressed: () {},
                  style:ElevatedButton.styleFrom(
                    fixedSize: const Size(130,20),
                  ),
                  child: const Text("Take Action"),
                ),
              ),
            ),

            /// Alert 2
            Card(
              color: Colors.orange[50],
              child: ListTile(
                leading: const Icon(Icons.lock_clock, color: Colors.orange),
                title: const Text("Set Limit"),
                subtitle: const Text("WhatsApp at 10:45 AM"),
                trailing: ElevatedButton(
                  onPressed: () {},
                  style:ElevatedButton.styleFrom(
                    fixedSize: const Size(130,20),
                  ),
                  child: const Text("Set Limit"),
                ),
              ),
            ),

            /// Alert 3
            Card(
              color: Colors.green[50],
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text("Set Limit"),
                subtitle: const Text("Limit Applied Successfully"),
                trailing: ElevatedButton(
                  onPressed: () {},
                  style:ElevatedButton.styleFrom(
                    fixedSize: const Size(130,20),
                  ),
                  child: const Text("Review"),
                ),
              ),
            ),



          ],
 
        ),
      ),
    );
  }
}

