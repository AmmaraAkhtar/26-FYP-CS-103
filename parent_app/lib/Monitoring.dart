import 'package:flutter/material.dart';
import 'youtubeMonitoring.dart';
import 'AlertMonitoring.dart';
import 'chatMonitoring.dart';
import 'webMonitoring.dart';



class Monitoring extends StatefulWidget {
    final Map<String, dynamic>? childData;
  const Monitoring({super.key, this.childData});

  @override
  State<Monitoring> createState() => _MonitoringState();
}

class _MonitoringState extends State<Monitoring> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: const Text("Live Monitoring Page",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Yahan 'child:' missing tha aur brackets ka masla tha
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Section
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                            "https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png"),
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

                const SizedBox(height: 25),

                // First Row (Screen Time & App Usage)
                 // First Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildActivityCard(
                          title: "Screen Time",
                          headerColor: const Color(0xFFE8FADC),
                          iconPath: "assets/watch.png", // Image Path
                          iconColor: Colors.green,
                          mainValue: "2h 30m",
                          subValue: "+1h 30m used",
                          buttonText: "Set Limit",
                          buttonColor: const Color(0xFF8BC34A),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const youtube()),
                            );
                          },
                      
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildActivityCard(
                          title: "App Usage",
                          headerColor: const Color(0xFFFFD1A4),
                          iconPath: "assets/app.png", // Image Path
                          iconColor: Colors.orange,
                          mainValue: "2h 30m",
                          subValue: "+1h 30m used",
                          buttonText: "View All »",
                          buttonColor: const Color(0xFFFB8C00),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const youtube()),
                            );
                          },
                        ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Second Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildActivityCard(
                          title: "YouTube Activities",
                          headerColor: const Color(0xFFFFEBEE),
                          iconPath: "assets/youtube1.png", // Image Path
                          iconColor: Colors.red,
                          mainValue: "2 videos watch",
                          subValue: "Last watched:\nCompusx ML",
                          buttonText: "View All »",
                          buttonColor: const Color(0xFFF44336),

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const youtube()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildActivityCard(
                          title: "Web Activities",
                          headerColor: const Color(0xFFE3F2FD),
                          iconPath: "assets/web.png", // Image Path
                          iconColor: Colors.blue,
                          mainValue: "6 blocked sites",
                          subValue: "Most Recent:\nfreev.com",
                          buttonText: "View All »",
                          buttonColor: const Color(0xFF03A9F4),


                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Webmonitoring()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                                  const SizedBox(height: 15),

                // --- Chat Activities Card ---
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Chat Activities",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> chat()));
                              },
                              child: const Text("View All >>",
                                  style: TextStyle(color: Colors.green)),
                            ),
                          ],
                        ),
                        const Divider(thickness: 1),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.warning_rounded,
                                color: Colors.orange, size: 30),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Suspicious Chat Detected",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      Text("Today At 5:30pm",
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12)),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "There's potentially inappropriate language in the chat with Abdullah",
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(thickness: 2, color: Colors.grey),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- Bottom Button (View All Alerts) ---
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> alert()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5CBA7),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 4))
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.error, color: Colors.red, size: 28),
                        Expanded(
                          child: Center(
                            child: Text(
                              "View All Alerts",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(color: Colors.black26, blurRadius: 2)
                                  ]),
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_double_arrow_right,
                            color: Colors.white, size: 28),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
  

Widget _buildActivityCard({
  required String title,
  required Color headerColor,
  required String iconPath,
  required Color iconColor,
  required String mainValue,
  required String subValue,
  required String buttonText,
  required Color buttonColor,
  VoidCallback? onTap, // Yeh parameter navigation ke liye hai
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: InkWell( // Isse poora card clickable ho jayega
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Icon(Icons.bar_chart_rounded, size: 22, color: iconColor.withOpacity(0.7)),
              ],
            ),
          ),
          
          // Card Body (Icon + Values)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Image.asset(
                  iconPath,
                  width: 45,
                  height: 45,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.image_not_supported, size: 45, color: Colors.grey),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mainValue,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        subValue,
                        style: const TextStyle(color: Colors.grey, fontSize: 11, height: 1.2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, thickness: 1.5, color: Color(0xFFEEEEEE), indent: 10, endIndent: 10),

          // Button Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: onTap, // <--- AB YEH BUTTON KAAM KAREGA
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}}