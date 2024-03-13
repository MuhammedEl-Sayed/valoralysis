class PlayerStats {
  int score;
  int roundsPlayed;
  int kills;
  int deaths;
  int assists;
  int playtimeMillis;
  double kda;

  PlayerStats(
      {required this.score,
      required this.roundsPlayed,
      required this.kills,
      required this.deaths,
      required this.assists,
      required this.playtimeMillis,
      required this.kda});

  factory PlayerStats.fromJsonWithKDA(dynamic json) {
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
        kda: (kills + assists) / deaths);
  }
}
