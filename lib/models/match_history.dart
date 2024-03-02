class MatchHistory {
  String matchID;
  int gameStartTime;
  String queueID;
  MatchHistory(
      {required this.matchID,
      required this.gameStartTime,
      required this.queueID});
  factory MatchHistory.fromJson(Map<String, dynamic> json) {
    return MatchHistory(
      matchID: json['matchId'] as String,
      gameStartTime: json['gameStartTimeMillis'] as int,
      queueID: json['queueId'] as String,
    );
  }
}
