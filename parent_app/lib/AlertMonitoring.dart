import 'package:flutter/material.dart';

class alert extends StatefulWidget {
  const alert({super.key});

  @override
  State<alert> createState() => _alertState();
}

class _alertState extends State<alert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFBFB),
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: const Text(
          "Alert Monitoring Dashboard",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 25),

            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      "https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png",
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Hamza Ali",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "11 Years Old",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            // Alerts Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Alerts ",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  // Stack ki jagah direct Container use kiya hai circular background ke liye
                  Container(
                    width: 35,
                    height: 35,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        "!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Alerts List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                children: [
                  _buildAlertCard(
                    title: "Toxic Language Detected:",
                    subtitle: "Bullying in Social Media Chat",
                    color: Colors.red,
                    icon: Icons.security,
                    time: "15min ago",
                    buttons: [_buildActionButton("Block Source", Colors.red)],
                  ),
                  _buildAlertCard(
                    title: "Late Night Usage:",
                    subtitle: "App Activity after Bedtime",
                    color: Colors.orange,
                    icon: Icons.person_off_rounded,
                    time: "15min ago",
                    buttons: [
                      _buildActionButton("Extend Limit", Colors.orange),
                      const SizedBox(width: 10),
                      _buildActionButton("Lock Screen", Colors.orange),
                    ],
                  ),
                  _buildAlertCard(
                    title: "Behavior:",
                    subtitle: "Signs of Anxiety Detected",
                    color: const Color(0xFF8B428D), // Purple
                    icon: Icons.psychology,
                    time: "15min ago",
                    buttons: [
                      _buildActionButton(
                        "View Sugestions",
                        const Color(0xFF8B428D),
                      ),
                    ],
                  ),
                  _buildAlertCard(
                    title: "Mood Analysis:",
                    subtitle: "Signs of happiness",
                    color: const Color(0xFFB8731D), // Brownish Orange
                    icon: Icons.lightbulb,
                    time: "15min ago",
                    buttons: [
                      _buildActionButton(
                        "Extend Limit",
                        const Color(0xFFB8731D),
                      ),
                    ],
                  ),
                  _buildAlertCard(
                    title: "Toxic Language Detected:",
                    subtitle: "Bullying in Social Media Chat",
                    color: Colors.red,
                    icon: Icons.security,
                    time: "15min ago",
                    buttons: [_buildActionButton("Block Source", Colors.red)],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build the Card
  Widget _buildAlertCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required String time,
    required List<Widget> buttons,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: color, width: 2.5),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 35),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: TextStyle(
                        color: color.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(icon, color: color, size: 35),
            ],
          ),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: buttons),
        ],
      ),
    );
  }

  // Helper function for the custom buttons with Shadow
  Widget _buildActionButton(String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0, // Shadow is handled by Container
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
