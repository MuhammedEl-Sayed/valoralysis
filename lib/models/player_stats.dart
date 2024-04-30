class PlayerStats {
  int score;
  int roundsPlayed;
  int kills;
  int deaths;
  int assists;
  int playtimeMillis;
  double kd;

  PlayerStats(
      {required this.score,
      required this.roundsPlayed,
      required this.kills,
      required this.deaths,
      required this.assists,
      required this.playtimeMillis,
      required this.kd});

  factory PlayerStats.fromJsonWithKD(dynamic json) {
    int kills = json['kills'] as int;
    int deaths = json['deaths'] as int;
    int assists = json['assists'] as int;
    return PlayerStats(
        score: json['score'] as int,
        roundsPlayed: json['roundsPlayed'] as int,
        kills: kills,
        deaths: deaths,
        assists: assists,
        playtimeMillis: json['playtimeMillis'] as int,
        kd: double.parse(((kills) / deaths).toStringAsFixed(2)));
  }
}
