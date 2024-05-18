class User {
  String puuid = '';
  bool consentGiven = false;
  String name = '';
  Map<String, dynamic> matchDetails = {};

  User({
    required this.puuid,
    required this.consentGiven,
    required this.name,
    required this.matchDetails,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      puuid: json['puuid'] as String,
      consentGiven: json['consentGiven'] as bool,
      name: json['name'] as String,
      matchDetails: json['matchDetails'] as Map<String, dynamic>,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'puuid': puuid,
      'consentGiven': consentGiven,
      'name': name,
      'matchDetails': matchDetails,
    };
  }
}
