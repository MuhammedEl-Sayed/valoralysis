import 'package:valoralysis/models/player_round_stats.dart';
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
    // This needs to be completely reworked. KAST is per round if anything of those things happen.
    // So for each round we need to see if:
    // player has KillDto in map, value is 100
    // player is listed as an assist in teammates KillDto, value is 100
    // player did not get a kill or assist but survived, value is 100
    // player got traded, value is 100

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
        .toStringAsFixed(1);
  }
}
