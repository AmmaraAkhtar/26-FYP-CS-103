import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Webmonitoring(),
  ));
}

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
        elevation: 0,
        title: const Text("Chat Monitoring Dashboard",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header Section ---
              Center(
                child: Column(
                  children: const [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          "https://static.vecteezy.com/system/resources/thumbnails/053/537/859/small/cartoon-boy-with-green-shirt-on-transparent-background-free-png.png"),
                    ),
                    SizedBox(height: 8),
                    Text("Hamza Ali",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    Text("11 Years Old",
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- Tab Buttons ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTab("Today", isSelected: true),
                  _buildTab("This Week"),
                  _buildTab("This Month"),
                ],
              ),
              const SizedBox(height: 25),

              // --- Table Headers (Perfectly Aligned with Rows) ---
              Row(
                children: [
                  Expanded(flex: 3, child: _buildSmallLabel("Title")),
                  const SizedBox(width: 8),
                  Expanded(flex: 2, child: _buildSmallLabel("Time Spend")),
                  const SizedBox(width: 8),
                  Expanded(flex: 2, child: _buildSmallLabel("Category")),
                  const SizedBox(width: 8),
                  Expanded(flex: 1, child: _buildSmallLabel("Block")),
                ],
              ),
              const SizedBox(height: 12),

              // --- History List ---
              _buildHistoryRow("youtube.com", "1h10min", "Violence", Colors.red),
              _buildHistoryRow("youtube.com", "1h10min", "Educational", Colors.blueAccent),
              _buildHistoryRow("youtube.com", "1h10min", "Violence", Colors.red),
              _buildHistoryRow("youtube.com", "1h10min", "Gaming", Colors.green),
              _buildHistoryRow("youtube.com", "1h10min", "Educational", Colors.blueAccent),
              _buildHistoryRow("youtube.com", "1h10min", "Gaming", Colors.green),

              const SizedBox(height: 30),

              // --- Alerts Section ---
              const Row(
                children: [
                  Text("Alerts", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(width: 5),
                  Icon(Icons.error, color: Colors.red, size: 22),
                ],
              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF92B4C8) : const Color(0xFFE89B7D),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4))
          ]),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildSmallLabel(String text) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE89B7D),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildHistoryRow(String title, String time, String category, Color catColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2A684),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Title
          Expanded(
            flex: 3,
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500, fontSize: 11)),
          ),
          // Time Spend
          Expanded(
            flex: 2,
            child: Center(
              child: Text(time,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ),
          // Category
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                    color: catColor, borderRadius: BorderRadius.circular(20)),
                child: Text(category,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
            ),
          ),
          // Block Button
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(5)),
              child: const Text("Yes",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                  textAlign: TextAlign.center),
            ),
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
          const Icon(Icons.error, color: Colors.red, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(msg,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF635D5D))),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.error, color: Colors.red, size: 30),
        ],
      ),
    );
  }
}