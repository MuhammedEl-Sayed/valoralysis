import 'package:valoralysis/models/match_details.dart';

class User {
  String puuid = '';
  bool consentGiven = false;
  String name = '';
  Map<String, MatchDto> matchDetailsMap = {};

  User({
    required this.puuid,
    required this.consentGiven,
    required this.name,
    required this.matchDetailsMap,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      puuid: json['puuid'] as String,
      consentGiven: json['consentGiven'] as bool,
      name: json['name'] as String,
      matchDetailsMap: (json['matchDetailsMap'] as Map<String, dynamic>).map(
        (key, value) =>
            MapEntry(key, MatchDto.fromJson(value as Map<String, dynamic>)),
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'puuid': puuid,
      'consentGiven': consentGiven,
      'name': name,
      'matchDetailsMap': matchDetailsMap,
    };
  }
}
