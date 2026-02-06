import 'package:flutter/material.dart';

class Webmonitoring extends StatefulWidget {
  const Webmonitoring({super.key});

  @override
  State<Webmonitoring> createState() => _WebmonitoringState();
}

class _WebmonitoringState extends State<Webmonitoring> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: const Text("Chat Monitoring Dashboard",style:TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
        
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
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
              const SizedBox(height: 30),

              // Tab Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTab("Today", isSelected: true),
                  _buildTab("This Week"),
                  _buildTab("This Month"),
                ],
              ),
              const SizedBox(height: 25),

              // Table Headers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSmallLabel("Title"),
                  _buildSmallLabel("Time Spend"),
                  _buildSmallLabel("Category"),
                  _buildSmallLabel("Block"),
                ],
              ),
              const SizedBox(height: 10),

              // History List
              _buildHistoryRow("youtube.com", "1h10min", "Violence", Colors.red),
              _buildHistoryRow("youtube.com", "1h10min", "Educational", Colors.blueAccent),
              _buildHistoryRow("youtube.com", "1h10min", "Violence", Colors.red),
              _buildHistoryRow("youtube.com", "1h10min", "Gaming", Colors.green),
              _buildHistoryRow("youtube.com", "1h10min", "Educational", Colors.blueAccent),
              _buildHistoryRow("youtube.com", "1h10min", "Gaming", Colors.green),

              const SizedBox(height: 30),

              // Alerts Section
              Text("Alerts ❗", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildAlertTile("Violent Massage Detected", "10:30 AM"),
              const SizedBox(height: 10),
              _buildAlertTile("Violent Video Detected", "10:30 AM"),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Helper Methods ---

  Widget _buildTab(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF92B4C8) : const Color(0xFFE89B7D),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 4))]
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _buildSmallLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE89B7D).withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _buildHistoryRow(String title, String time, String category, Color catColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2A684).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          Text(time, style: const TextStyle(color: Colors.white)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: catColor, borderRadius: BorderRadius.circular(20)),
            child: Text(category, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
            child: const Text("Yes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertTile(String msg, String time) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFCCB3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red, size: 35),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(msg, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF635D5D))),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.error, color: Colors.red, size: 35),
        ],
      ),
    );
  }
}
