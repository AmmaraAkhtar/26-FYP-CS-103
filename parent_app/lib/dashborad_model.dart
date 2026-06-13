class DashboardSummary {
  final int screenTimeSeconds;
  final int screenTimeLimit;
  final int appUsageSeconds;
  final int youtubeCount;
  final String? lastYoutube;
  final int blockedSitesCount;
  final String? lastBlockedUrl;
  final ChatAlert? latestChatAlert;

  DashboardSummary({
    required this.screenTimeSeconds,
    required this.screenTimeLimit,
    required this.appUsageSeconds,
    required this.youtubeCount,
    this.lastYoutube,
    required this.blockedSitesCount,
    this.lastBlockedUrl,
    this.latestChatAlert,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      screenTimeSeconds: json['screen_time_seconds'] ?? 0,
      screenTimeLimit: json['screen_time_limit'] ?? 0,
      appUsageSeconds: json['app_usage_seconds'] ?? 0,
      youtubeCount: json['youtube_count'] ?? 0,
      lastYoutube: json['last_youtube'],
      blockedSitesCount: json['blocked_sites_count'] ?? 0,
      lastBlockedUrl: json['last_blocked_url'],
      latestChatAlert: json['latest_chat_alert'] != null
          ? ChatAlert.fromJson(json['latest_chat_alert'])
          : null,
    );
  }
}

class ChatAlert {
  final String title;
  final String sender;
  final String message;
  final String category;
  final String time;

  ChatAlert({
    required this.title,
    required this.sender,
    required this.message,
    required this.category,
    required this.time,
  });

  factory ChatAlert.fromJson(Map<String, dynamic> json) {
    return ChatAlert(
      title: json['title'] ?? '',
      sender: json['sender'] ?? '',
      message: json['message'] ?? '',
      category: json['category'] ?? '',
      time: json['time'] ?? '',
    );
  }
}