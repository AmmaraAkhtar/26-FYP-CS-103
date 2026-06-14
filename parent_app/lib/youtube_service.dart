import 'package:http/http.dart' as http;
import 'dart:convert';

class YoutubeService {
  static const String baseUrl = "http://192.168.18.163:8000";

  static Future<Map<String, dynamic>?> getYoutubeSummary(int childId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/dashboard-summary/?child_id=$childId"),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("YouTube fetch error: $e");
    }
    return null;
  }

  static Future<List<dynamic>> getYoutubeAlerts(int childId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/fetch-alerts/?child_id=$childId"),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final allAlerts = data['alerts'] as List;
        // Sirf YouTube se related alerts filter karo
        return allAlerts.where((a) =>
          a['source'] == 'youtube' || 
          (a['message'] as String).toLowerCase().contains('youtube')
        ).toList();
      }
    } catch (e) {
      print("Alerts fetch error: $e");
    }
    return [];
  }
}