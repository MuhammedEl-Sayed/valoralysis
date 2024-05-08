class User {
  String puuid = '';
  bool consentGiven = false;
  String name = '';
  Map<String, dynamic> matchHistory = {};
  User(
      {required this.puuid,
      required this.consentGiven,
      required this.name,
      required this.matchHistory});
}
