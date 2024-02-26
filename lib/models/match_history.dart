// ignore_for_file: non_constant_identifier_names
import 'dart:ffi';

class MatchHistory {
  String MatchID;
  int GameStartTime;
  String QueueID;
  MatchHistory(
      {required this.MatchID,
      required this.GameStartTime,
      required this.QueueID});
  factory MatchHistory.fromJson(Map<String, dynamic> json) {
    return MatchHistory(
      MatchID: json['MatchID'] as String,
      GameStartTime: json['GameStartTime'] as int,
      QueueID: json['QueueID'] as String,
    );
  }
}
