import 'package:valoralysis/models/player_stats.dart';
import 'package:valoralysis/utils/history_utils.dart';

class MatchAnalysis {
  static String findKAST(Map<String, dynamic> matchDetail, String puuid) {
    Map<String, dynamic> player =
        HistoryUtils.getPlayerByPUUID(matchDetail, puuid);
    if (player == {} || player['characterId'] == null) {
      return '0';
    }
    PlayerStats stats = HistoryUtils.extractPlayerStat(matchDetail, puuid);

    // KAST = (Kills + Assists + Survived + Traded) / (Total Rounds)
    int kills = stats.kills;
    int assists = stats.assists;
    int survived = stats.roundsPlayed - stats.deaths;
  }
}
