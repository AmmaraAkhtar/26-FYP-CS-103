import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dashborad_model.dart';

class DashboardService {
  static const String baseUrl = "https://the-watcher-backend.onrender.com";

  static Future<DashboardSummary?> getSummary(int childId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/dashboard-summary/?child_id=$childId"),
    );

    if (response.statusCode == 200) {
      return DashboardSummary.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getBrowsingData(int childId, String filter) async {
    final response = await http.get(
      Uri.parse("$baseUrl/browsing-monitoring/?child_id=$childId&filter=$filter"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
}