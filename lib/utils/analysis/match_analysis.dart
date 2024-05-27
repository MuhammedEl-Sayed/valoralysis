import 'package:valoralysis/models/player_round_stats.dart';
import 'package:valoralysis/utils/history_utils.dart';

class MatchAnalysis {
  static String findKAST(Map<String, dynamic> matchDetail, String puuid) {
    Map<String, dynamic> player =
        HistoryUtils.getPlayerByPUUID(matchDetail, puuid);
    if (player == {} || player['characterId'] == null) {
      return '0';
    }

    Map<int, List<KillDto>> kills =
        HistoryUtils.extractPlayerKills(matchDetail, puuid);
    List<String> playerteamPUUIDs =
        HistoryUtils.extractPlayerTeamPUUIDs(matchDetail, puuid);
    Map<int, List<KillDto>> assists =
        HistoryUtils.extractPlayerAssists(matchDetail, playerteamPUUIDs, puuid);
    Map<int, List<KillDto>> roundsPlayerDied =
        HistoryUtils.extractRoundDeathsByPUUID(matchDetail, puuid);
    Map<int, List<KillDto>> trades =
        HistoryUtils.getPlayerTrades(matchDetail, puuid);

    int numOfRoundsPlayerFuckingSucked = 0;

    for (int round in kills.keys) {
      bool hasKill = kills[round]!.isNotEmpty;
      bool hasAssist = assists[round]!.isNotEmpty;
      bool didPlayerDieThisRound = roundsPlayerDied[round]!.isNotEmpty;
      bool didGetTraded = trades[round]!.isNotEmpty;

      if (hasKill || hasAssist || didGetTraded) continue;
      if (didPlayerDieThisRound) numOfRoundsPlayerFuckingSucked++;
    }
    return ((1 - (numOfRoundsPlayerFuckingSucked / kills.keys.length)) * 100)
        .toInt()
        .toString();
  }

  static int findADR(Map<String, dynamic> matchDetail, String puuid) {
    Map<String, dynamic> player =
        HistoryUtils.getPlayerByPUUID(matchDetail, puuid);
    if (player == {} || player['characterId'] == null) {
      return 0;
    }
    List<PlayerRoundStats> stats =
        HistoryUtils.extractPlayerRoundStats(matchDetail, puuid);
    int numRounds = HistoryUtils.getNumberOfRounds(matchDetail);
    return (stats.fold(
                0,
                (sum, roundStat) =>
                    sum +
                    roundStat.damage.fold(
                        0, (sum, enemyDamage) => sum + enemyDamage.damage)) /
            numRounds)
        .round();
  }
}
