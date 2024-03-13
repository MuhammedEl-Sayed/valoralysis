import 'package:valoralysis/models/match_history.dart';
import 'package:valoralysis/models/player_stats.dart';

class HistoryUtils {
  static String extractMatchID(MatchHistory matchHistory) {
    return matchHistory.matchID;
  }

  static List<String> extractMatchIDs(List<MatchHistory> matchHistories) {
    return matchHistories
        .map((matchHistory) => extractMatchID(matchHistory))
        .toList();
  }

  static PlayerStats extractPlayerStat(
      Map<String, dynamic> matchDetail, String puuid) {
    return PlayerStats.fromJsonWithKDA(matchDetail['players']
        .firstWhere((player) => player['puuid'] == puuid)['stats']);
  }

  static List<PlayerStats> extractPlayerStats(
      List<Map<String, dynamic>> matchDetails, String puuid) {
    return matchDetails
        .map((matchDetail) => extractPlayerStat(matchDetail, puuid))
        .toList();
  }
}
