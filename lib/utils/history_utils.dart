import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/item.dart';
import 'package:valoralysis/models/match_history.dart';
import 'package:valoralysis/models/player_round_stats.dart';
import 'package:valoralysis/models/player_stats.dart';

class HistoryUtils {
  // Methods related to extracting match details
  static String extractMatchID(MatchHistory matchHistory) {
    return matchHistory.matchID;
  }

  static List<String> extractMatchIDs(List<MatchHistory> matchHistories) {
    return matchHistories
        .map((matchHistory) => extractMatchID(matchHistory))
        .toList();
  }

  static int extractStartTime(Map<String, dynamic> matchDetails) {
    return matchDetails['matchInfo']['gameStartMillis'] as int;
  }

  // Methods related to extracting game mode details
  static Item extractGamemode(
      Map<String, dynamic> matchDetail, List<Item> modes) {
    try {
      return modes.firstWhere(
          (mode) => mode.realValue == matchDetail['matchInfo']['queueId']);
    } catch (e) {
      return Item('deathmatch', 'Deathmatch');
    }
  }

  // Methods related to extracting player details
  static PlayerStats extractPlayerStat(
      Map<String, dynamic> matchDetail, String puuid) {
    return PlayerStats.fromJsonWithKD(
        matchDetail['players']
            .firstWhere((player) => player['puuid'] == puuid)['stats'],
        getPlayerTrades(matchDetail, puuid));
  }

  static List<PlayerRoundStats> extractPlayerRoundStats(
      Map<String, dynamic> matchDetail, String puuid) {
    return getRoundResults(matchDetail)
        .expand((roundResult) => (roundResult['playerStats'] as List<dynamic>)
            .where((playerStat) => playerStat['puuid'] == puuid))
        .map((playerStat) => PlayerRoundStats.fromJson(playerStat))
        .toList();
  }

  static List<PlayerStats> extractPlayerStats(
      List<Map<String, dynamic>> matchDetail, String puuid) {
    return matchDetail.map((match) => extractPlayerStat(match, puuid)).toList();
  }

  static Map<String, dynamic> getPlayerByPUUID(
      Map<String, dynamic> matchDetail, String puuid) {
    if (matchDetail['players'] == null) {
      return {};
    }
    for (Map<String, dynamic> player in matchDetail['players']) {
      if (player['puuid'] == puuid) {
        return player;
      }
    }
    return {};
  }

  static String extractPlayerNameByPUUID(
      Map<String, dynamic> matchDetail, String puuid) {
    Map<String, dynamic> player = getPlayerByPUUID(matchDetail, puuid);
    return '${player['gameName']}#${player['tagLine']}';
  }

  static Map<int, List<DamageDto>> extractPlayerDamage(
      Map<String, dynamic> matchDetail, String puuid) {
    Map<int, List<DamageDto>> roundToPlayerDamage = {};
    List<PlayerRoundStats> playerRoundStats =
        extractPlayerRoundStats(matchDetail, puuid);
    for (int index = 0; index < playerRoundStats.length; index++) {
      PlayerRoundStats playerRoundStat = playerRoundStats[index];
      if (playerRoundStat.damage.isNotEmpty) {
        roundToPlayerDamage[index] = playerRoundStat.damage;
      } else {
        roundToPlayerDamage[index] = [];
      }
    }

    return roundToPlayerDamage;
  }

  static Map<int, List<KillDto>> extractPlayerKills(
      Map<String, dynamic> matchDetail, String puuid) {
    Map<int, List<KillDto>> roundToPlayerKills = {};
    List<PlayerRoundStats> playerRoundStats =
        extractPlayerRoundStats(matchDetail, puuid);
    for (int index = 0; index < playerRoundStats.length; index++) {
      PlayerRoundStats playerRoundStat = playerRoundStats[index];
      if (playerRoundStat.kills.isNotEmpty) {
        roundToPlayerKills[index] = playerRoundStat.kills;
      } else {
        roundToPlayerKills[index] = [];
      }
    }

    return roundToPlayerKills;
  }

  static Map<String, Map<int, List<KillDto>>> extractMultiplePlayerKills(
      Map<String, dynamic> matchDetail, List<String> puuids) {
    Map<String, Map<int, List<KillDto>>> puuidToRoundToPlayerKills = {};

    for (String puuid in puuids) {
      puuidToRoundToPlayerKills[puuid] = extractPlayerKills(matchDetail, puuid);
    }

    return puuidToRoundToPlayerKills;
  }

  static Map<int, List<KillDto>> extractPlayerAssists(
      Map<String, dynamic> matchDetail,
      List<String> alliedPUUIDs,
      String playerPUUID) {
    Map<String, Map<int, List<KillDto>>> roundToPlayerKills =
        extractMultiplePlayerKills(matchDetail, alliedPUUIDs);
    Map<int, List<KillDto>> killsPlayerAssistedOn = {};

    for (Map<int, List<KillDto>> alliedKillsMap in roundToPlayerKills.values) {
      for (int round in alliedKillsMap.keys) {
        killsPlayerAssistedOn[round] = [];
        for (KillDto alliedKill in alliedKillsMap[round]!) {
          if (alliedKill.assistants.contains(playerPUUID)) {
            killsPlayerAssistedOn[round]!.add(alliedKill);
          }
        }
      }
    }
    return killsPlayerAssistedOn;
  }

  static Map<int, List<KillDto>> extractRoundDeathsByPUUID(
      Map<String, dynamic> matchDetail, String puuid) {
    Map<int, List<KillDto>> roundToDeathListMap = {};
    List<String> enemyTeamPUUIDS = extractEnemyTeamPUUIDs(matchDetail, puuid);
    List<Map<String, dynamic>> roundResults = getRoundResults(matchDetail);

    for (int roundIndex = 0; roundIndex < roundResults.length; roundIndex++) {
      roundToDeathListMap[roundIndex] =
          []; // Initialize an empty list for each round
      var roundResult = roundResults[roundIndex];
      for (var playerStatMap in roundResult['playerStats']) {
        PlayerRoundStats playerStat = PlayerRoundStats.fromJson(playerStatMap);
        if (enemyTeamPUUIDS.contains(playerStat.puuid)) {
          for (KillDto kill in playerStat.kills) {
            if (kill.victim == puuid) {
              roundToDeathListMap[roundIndex]!.add(kill);
            }
          }
        }
      }
    }

    return roundToDeathListMap;
  }

  static Map<String, Map<int, List<KillDto>>> extractRoundDeathsByPUUIDs(
      Map<String, dynamic> matchDetail, List<String> puuids) {
    Map<String, Map<int, List<KillDto>>> puuidsToKillListMap = {};
    List<String> enemyTeamPUUIDS =
        extractEnemyTeamPUUIDs(matchDetail, puuids[0]);
    List<Map<String, dynamic>> roundResults = getRoundResults(matchDetail);

    for (String puuid in puuids) {
      puuidsToKillListMap[puuid] = {};
      for (int roundIndex = 0; roundIndex < roundResults.length; roundIndex++) {
        puuidsToKillListMap[puuid]![roundIndex] =
            []; // Initialize an empty list for each round
        var roundResult = roundResults[roundIndex];
        for (PlayerRoundStats playerStat in roundResult['playerStats']) {
          if (enemyTeamPUUIDS.contains(playerStat.puuid)) {
            for (KillDto kill in playerStat.kills) {
              if (kill.victim == puuid) {
                puuidsToKillListMap[puuid]![roundIndex]!.add(kill);
              }
            }
          }
        }
      }
    }

    return puuidsToKillListMap;
  }

  // TODO: REFACTORRR THIS IS BAD
  static Map<int, List<KillDto>> getPlayerTrades(
      Map<String, dynamic> matchDetail, String puuid) {
    List<String> playerteamPUUIDs = extractPlayerTeamPUUIDs(matchDetail, puuid);
    Map<int, List<KillDto>> playerDeaths =
        extractRoundDeathsByPUUID(matchDetail, puuid);
    Map<String, Map<int, List<KillDto>>> alliedPlayersKills =
        extractMultiplePlayerKills(matchDetail, playerteamPUUIDs);

    Map<int, List<KillDto>> trades = {};

    for (int round in playerDeaths.keys) {
      trades[round] = [];
      for (KillDto playerDeath in playerDeaths[round]!) {
        for (Map<int, List<KillDto>> alliedPlayerKills
            in alliedPlayersKills.values) {
          if (alliedPlayerKills[round] != null) {
            for (KillDto alliedKill in alliedPlayerKills[round]!) {
              if (alliedKill.victim != playerDeath.killer) continue;
              int timeDiff = (playerDeath.timeSinceRoundStartMillis -
                      alliedKill.timeSinceRoundStartMillis)
                  .abs();

              if (timeDiff <= 10000) {
                trades[round]!.add(alliedKill);
              }
            }
          }
        }
      }
    }

    return trades;
  }

  static List<String> extractEnemyTeamPUUIDs(
      Map<String, dynamic> matchDetail, String puuid) {
    String userTeam = extractTeamIdFromPUUID(matchDetail, puuid);
    List<String> enemyTeamPUUIDs = [];
    for (var player in matchDetail['players']) {
      if (player['teamId'] != userTeam) {
        enemyTeamPUUIDs.add(player['puuid']);
      }
    }
    return enemyTeamPUUIDs;
  }

  static List<String> extractPlayerTeamPUUIDs(
      Map<String, dynamic> matchDetail, String puuid) {
    String userTeam = extractTeamIdFromPUUID(matchDetail, puuid);
    List<String> playerTeamPUUIDs = [];
    for (var player in matchDetail['players']) {
      if (player['teamId'] == userTeam && player['puuid'] != puuid) {
        playerTeamPUUIDs.add(player['puuid']);
      }
    }
    return playerTeamPUUIDs;
  }

  // Methods related to extracting content details
  static getContentImageFromId(String puuid, List<ContentItem> content) {
    return content.firstWhere((item) => item.uuid == puuid).iconUrl;
  }

  static getContentImageFromName(String name, List<ContentItem> content) {
    return content.firstWhere((item) => item.name == name).iconUrl;
  }

  static getContentTextFromId(String puuid, List<ContentItem> content) {
    try {
      var result = content.firstWhere((item) => item.uuid == puuid);
      return result.name;
    } catch (e) {
      return null;
    }
  }

  // Methods related to extracting team details
  static Map<String, dynamic> extractTeamFromPUUID(
      Map<String, dynamic> matchDetail, String puuid) {
    return matchDetail['teams'].firstWhere((team) =>
        team['teamId'] ==
        matchDetail['players']
            .firstWhere((player) => player['puuid'] == puuid)['teamId']);
  }

  static String extractTeamIdFromPUUID(
      Map<String, dynamic> matchDetail, String puuid) {
    return extractTeamFromPUUID(matchDetail, puuid)['teamId'];
  }

  static bool didTeamWinByPUUID(
      Map<String, dynamic> matchDetail, String puuid) {
    return extractTeamFromPUUID(matchDetail, puuid)['won'] == true;
  }

  static Map<String, int> extractRoundWinsPerTeam(
      Map<String, dynamic> matchDetail) {
    Map<String, int> roundWinsPerTeam = {};
    for (Map<String, dynamic> team in matchDetail['teams']) {
      roundWinsPerTeam[team['teamId']] = team['roundsWon'];
    }
    return roundWinsPerTeam;
  }

  // Methods related to extracting round results
  static List<Map<String, dynamic>> getRoundResults(
      Map<String, dynamic> matchDetail) {
    List<Map<String, dynamic>> roundResults = [];
    for (Map<String, dynamic> roundResult in matchDetail['roundResults']) {
      roundResults.add(roundResult);
    }
    return roundResults;
  }

  static int getNumberOfRounds(Map<String, dynamic> matchDetail) {
    return getRoundResults(matchDetail).length;
  }

  static Map<String, dynamic> extractRoundResultPerTeam(
      Map<String, dynamic> matchDetail, String puuid) {
    Map<String, dynamic> roundResultsPerTeam = {
      "Your Team": [],
      "Enemy Team": []
    };

    String playerTeamId = extractTeamIdFromPUUID(matchDetail, puuid);

    for (Map<String, dynamic> roundResult in matchDetail['roundResults']) {
      if (roundResult['winningTeam'] == playerTeamId) {
        roundResultsPerTeam["Your Team"].add(roundResult);
      } else {
        roundResultsPerTeam["Enemy Team"].add(roundResult);
      }
    }

    return roundResultsPerTeam;
  }

  //add function to check if player won a round given the round index
  static bool didPlayerWinRound(
      Map<String, dynamic> matchDetail, String puuid, int roundIndex) {
    Map<String, dynamic> roundResult = getRoundResults(matchDetail)[roundIndex];
    String playerTeamId = extractTeamIdFromPUUID(matchDetail, puuid);
    return roundResult['winningTeam'] == playerTeamId;
  }

  // Method related to filtering match details
  static List<Map<String, dynamic>> filterMatchDetails(
      List<Map<String, dynamic>> matchDetails,
      String? puuid,
      ContentItem filter,
      String filterType) {
    String id = filter.uuid;

    if (id.isNotEmpty) {
      switch (filterType) {
        case 'maps':
          matchDetails = matchDetails.where((matchDetail) {
            return matchDetail['matchInfo']['mapId'] == id;
          }).toList();
          break;
        case 'agents':
          matchDetails = matchDetails
              .where((matchDetail) => matchDetail['players'].firstWhere(
                  (player) => player['puuid'] == puuid)['characterId'])
              .toList();
          break;
        case 'gameModes':
          matchDetails = matchDetails
              .where(
                  (matchDetail) => matchDetail['matchInfo']['gameMode'] == id)
              .toList();
          break;

        default:
          print('Unknown filter type');
      }
      return matchDetails; // return the filtered matchDetails
    }
    return [];
  }
}
