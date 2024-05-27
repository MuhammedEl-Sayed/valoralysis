import 'package:valoralysis/models/player_round_stats.dart';

class PlayerStats {
  int score;
  int roundsPlayed;
  int kills;
  int deaths;
  int assists;
  int playtimeMillis;
  double kd;
  Map<int, List<KillDto>> trades;
  String? kast;
  int? adr;

  PlayerStats(
      {required this.score,
      required this.roundsPlayed,
      required this.kills,
      required this.deaths,
      required this.assists,
      required this.playtimeMillis,
      required this.kd,
      this.kast,
      this.adr,
      required this.trades});

  factory PlayerStats.fromJsonWithKD(
      dynamic json, Map<int, List<KillDto>> trades) {
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
      kd: double.parse(((kills) / deaths).toStringAsFixed(2)),
      trades: trades,
    );
  }
}
