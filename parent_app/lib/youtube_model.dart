class YoutubeStats {
  final int videoCount;
  final int weeklyCount;
  final int searchCount;
  final int flaggedCount;
  final String? lastWatchedTitle;
  final List<YoutubeHistoryItem> history;
  final List<YoutubeAlert> alerts;

  YoutubeStats({
    required this.videoCount,
    required this.weeklyCount,
    required this.searchCount,
    required this.flaggedCount,
    this.lastWatchedTitle,
    required this.history,
    required this.alerts,
  });
}

class YoutubeHistoryItem {
  final String title;
  final String category;
  final String timeAgo;
  final bool isFlagged;

  YoutubeHistoryItem({
    required this.title,
    required this.category,
    required this.timeAgo,
    required this.isFlagged,
  });
}

class YoutubeAlert {
  final String title;
  final String source;
  final String time;

  YoutubeAlert({
    required this.title,
    required this.source,
    required this.time,
  });
}