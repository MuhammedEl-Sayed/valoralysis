import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/item.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/models/match_history.dart';
import 'package:valoralysis/models/player_round_stats.dart';
import 'package:valoralysis/models/player_stats.dart';

class HistoryUtils {
  // Methods related to extracting match details
  static String extractMatchID(MatchHistory matchDto) {
    return matchDto.matchID;
  }

  static List<String> extractMatchIDs(List<MatchHistory> matchDtos) {
    return matchDtos.map((matchDto) => extractMatchID(matchDto)).toList();
  }

  static int extractStartTime(MatchDto matchDto) {
    return matchDto.matchInfo.gameStartMillis;
  }

  // Methods related to extracting game mode details
  static Item extractGamemode(MatchDto matchDto, List<Item> modes) {
    try {
      return modes
          .firstWhere((mode) => mode.realValue == matchDto.matchInfo.queueId);
    } catch (e) {
      return Item('deathmatch', 'Deathmatch');
    }
  }

  // Methods related to extracting player details
  static PlayerStats extractPlayerStat(MatchDto matchDto, String puuid) {
    return PlayerStats.fromJsonWithKD(
        matchDto.players
            .firstWhere((player) => player.puuid == puuid)
            .stats
            .toJson(),
        getPlayerTrades(matchDto, puuid));
  }

  static List<PlayerRoundStats> extractPlayerRoundStats(
      MatchDto matchDto, String puuid) {
    return matchDto.roundResults
        .expand((roundResult) => roundResult.playerStats
            .where((playerStat) => playerStat.puuid == puuid)
            .map(
                (playerStat) => PlayerRoundStats.fromJson(playerStat.toJson())))
        .toList();
  }

  static List<PlayerStats> extractPlayerStats(
      List<MatchDto> matchDtos, String puuid) {
    return matchDtos.map((match) => extractPlayerStat(match, puuid)).toList();
  }

  static PlayerDto getPlayerByPUUID(MatchDto matchDto, String puuid) {
    for (var player in matchDto.players) {}
    return matchDto.players.firstWhere((player) => player.puuid == puuid);
  }

  static String extractPlayerNameByPUUID(MatchDto matchDto, String puuid) {
    PlayerDto player = getPlayerByPUUID(matchDto, puuid);
    return '${player.gameName}#${player.tagLine}';
  }

  static String getKillGunId(KillDto kill) {
    if (kill.finishingDamage.damageType == 'Melee') {
      return '2f59173c-4bed-b6c3-2191-dea9b58be9c7';
    }
    return kill.finishingDamage.damageItem;
  }

  static Map<int, List<DamageDto>> extractPlayerDamage(
      MatchDto matchDto, String puuid) {
    Map<int, List<DamageDto>> roundToPlayerDamage = {};
    List<PlayerRoundStats> playerRoundStats =
        extractPlayerRoundStats(matchDto, puuid);
    for (int index = 0; index < playerRoundStats.length; index++) {
      PlayerRoundStats playerRoundStat = playerRoundStats[index];
      roundToPlayerDamage[index] =
          playerRoundStat.damage.isNotEmpty ? playerRoundStat.damage : [];
    }

    return roundToPlayerDamage;
  }

  static List<DamageDto> extractPlayerDamagePerRound(
      MatchDto matchDto, String puuid, int roundIndex) {
    return extractPlayerDamage(matchDto, puuid)[roundIndex]!
        .where((damage) => damage.receiver != puuid)
        .toList();
  }

  static Map<int, List<KillDto>> extractPlayerKills(
      MatchDto matchDto, String puuid) {
    Map<int, List<KillDto>> roundToPlayerKills = {};
    List<PlayerRoundStats> playerRoundStats =
        extractPlayerRoundStats(matchDto, puuid);
    for (int index = 0; index < playerRoundStats.length; index++) {
      PlayerRoundStats playerRoundStat = playerRoundStats[index];
      // We need to check to see if the player killed themselves
      List<KillDto> kills = playerRoundStat.kills;

      List<KillDto> killsToRemove = [];
      for (KillDto kill in kills) {
        if (kill.victim == puuid) {
          killsToRemove.add(kill);
        }
      }
      kills.removeWhere((kill) => killsToRemove.contains(kill));
      roundToPlayerKills[index] = playerRoundStat.kills.isNotEmpty ? kills : [];
    }

    return roundToPlayerKills;
  }

  static Map<String, Map<int, List<KillDto>>> extractMultiplePlayerKills(
      MatchDto matchDto, List<String> puuids) {
    Map<String, Map<int, List<KillDto>>> puuidToRoundToPlayerKills = {};

    for (String puuid in puuids) {
      puuidToRoundToPlayerKills[puuid] = extractPlayerKills(matchDto, puuid);
    }

    return puuidToRoundToPlayerKills;
  }

  static Map<int, List<KillDto>> extractPlayerAssists(
      MatchDto matchDto, List<String> alliedPUUIDs, String playerPUUID) {
    Map<String, Map<int, List<KillDto>>> roundToPlayerKills =
        extractMultiplePlayerKills(matchDto, alliedPUUIDs);
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
      MatchDto matchDto, String puuid) {
    Map<int, List<KillDto>> roundToDeathListMap = {};
    List<String> enemyTeamPUUIDS = extractEnemyTeamPUUIDs(matchDto, puuid);
    List<RoundResultDto> roundResults = matchDto.roundResults;

    for (int roundIndex = 0; roundIndex < roundResults.length; roundIndex++) {
      roundToDeathListMap[roundIndex] = [];
      var roundResult = roundResults[roundIndex];
      for (var playerStat in roundResult.playerStats) {
        if (enemyTeamPUUIDS.contains(playerStat.puuid)) {
          for (KillDto kill in playerStat.kills) {
            if (kill.victim == puuid) {
              roundToDeathListMap[roundIndex]!.add(kill);
            }
          }
        }
        //check if player killed themselves

        if (playerStat.puuid == puuid) {
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
      MatchDto matchDto, List<String> puuids) {
    Map<String, Map<int, List<KillDto>>> puuidsToKillListMap = {};
    List<String> enemyTeamPUUIDS = extractEnemyTeamPUUIDs(matchDto, puuids[0]);

    List<RoundResultDto> roundResults = matchDto.roundResults;

    for (String puuid in puuids) {
      puuidsToKillListMap[puuid] = {};
      for (int roundIndex = 0; roundIndex < roundResults.length; roundIndex++) {
        puuidsToKillListMap[puuid]![roundIndex] = [];
        var roundResult = roundResults[roundIndex];
        for (PlayerRoundStatsDto playerStat in roundResult.playerStats) {
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

  //did playerDieInRound

  static bool didPlayerDieInRound(
      MatchDto matchDto, String puuid, int roundIndex) {
    List<KillDto> deaths =
        extractRoundDeathsByPUUID(matchDto, puuid)[roundIndex]!;
    return deaths.isNotEmpty;
  }

  static Map<int, List<KillDto>> getPlayerTrades(
      MatchDto matchDto, String puuid) {
    List<String> playerteamPUUIDs = extractPlayerTeamPUUIDs(matchDto, puuid);
    Map<int, List<KillDto>> playerDeaths =
        extractRoundDeathsByPUUID(matchDto, puuid);
    Map<String, Map<int, List<KillDto>>> alliedPlayersKills =
        extractMultiplePlayerKills(matchDto, playerteamPUUIDs);

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

  static List<String> extractEnemyTeamPUUIDs(MatchDto matchDto, String puuid) {
    String userTeam = extractTeamIdFromPUUID(matchDto, puuid);
    List<String> enemyTeamPUUIDs = [];
    for (var player in matchDto.players) {
      if (player.teamId != userTeam) {
        enemyTeamPUUIDs.add(player.puuid);
      }
    }
    return enemyTeamPUUIDs;
  }

  static List<String> extractPlayerTeamPUUIDs(MatchDto matchDto, String puuid) {
    String userTeam = extractTeamIdFromPUUID(matchDto, puuid);
    List<String> playerTeamPUUIDs = [];
    for (var player in matchDto.players) {
      if (player.teamId == userTeam && player.puuid != puuid) {
        playerTeamPUUIDs.add(player.puuid);
      }
    }
    return playerTeamPUUIDs;
  }

  // Methods related to extracting content details
  static String? getContentImageFromId(
      String puuid, List<ContentItem> content) {
    return content
        .firstWhere((item) => item.uuid.toLowerCase() == puuid.toLowerCase())
        .iconUrl;
  }

  static String? getAbilityImageFromSlotAndId(
      String slot, String puuid, List<ContentItem> content) {
    switch (slot) {
      case ('Ability1'):
        return content
            .firstWhere((item) => item.uuid == puuid.toLowerCase())
            .abilities!
            .ability1
            .iconUrl;
      case ('Ability2'):
        return content
            .firstWhere((item) => item.uuid == puuid.toLowerCase())
            .abilities!
            .ability2
            .iconUrl;
      case ('Grenade'):
        return content
            .firstWhere((item) => item.uuid == puuid.toLowerCase())
            .abilities!
            .grenade
            .iconUrl;
      case ('Ultimate'):
        return content
            .firstWhere((item) => item.uuid == puuid.toLowerCase())
            .abilities!
            .ultimate
            .iconUrl;
    }
    return null;
  }

  static String? getSilhouetteImageFromId(
      String uuid, List<ContentItem> content) {
    return content
        .firstWhere((item) => item.uuid.toLowerCase() == uuid.toLowerCase())
        .silhouetteUrl;
  }

  static String? getContentImageFromName(
      String name, List<ContentItem> content) {
    return content.firstWhere((item) => item.name == name).iconUrl;
  }

  static String? getContentTextFromId(String puuid, List<ContentItem> content) {
    try {
      var result = content.firstWhere((item) => item.uuid == puuid);
      return result.name;
    } catch (e) {
      return null;
    }
  }

  // Methods related to extracting team details
  static TeamDto extractTeamFromPUUID(MatchDto matchDto, String puuid) {
    return matchDto.teams.firstWhere((team) =>
        team.teamId ==
        matchDto.players.firstWhere((player) => player.puuid == puuid).teamId);
  }

  static String extractTeamIdFromPUUID(MatchDto matchDto, String puuid) {
    return extractTeamFromPUUID(matchDto, puuid).teamId;
  }

  static bool didTeamWinByPUUID(MatchDto matchDto, String puuid) {
    return extractTeamFromPUUID(matchDto, puuid).won;
  }

  static Map<String, int> extractRoundWinsPerTeam(MatchDto matchDto) {
    Map<String, int> roundWinsPerTeam = {};
    for (TeamDto team in matchDto.teams) {
      roundWinsPerTeam[team.teamId] = team.roundsWon;
    }
    return roundWinsPerTeam;
  }

  // Methods related to extracting round results
  static List<RoundResultDto> getRoundResults(MatchDto matchDto) {
    return matchDto.roundResults;
  }

  static int getNumberOfRounds(MatchDto matchDto) {
    return getRoundResults(matchDto).length;
  }

  static Map<String, List<RoundResultDto>> extractRoundResultPerTeam(
      MatchDto matchDto, String puuid) {
    Map<String, List<RoundResultDto>> roundResultsPerTeam = {
      "Your Team": [],
      "Enemy Team": []
    };

    String playerTeamId = extractTeamIdFromPUUID(matchDto, puuid);

    for (var roundResult in matchDto.roundResults) {
      //print typoof roundResult
      if (roundResult.winningTeam == playerTeamId) {
        roundResultsPerTeam["Your Team"]!.add(roundResult);
      } else {
        roundResultsPerTeam["Enemy Team"]!.add(roundResult);
      }
    }

    return roundResultsPerTeam;
  }

  static Map<String, MatchDto> sortMatchDetailsByStartTime(
      Map<String, MatchDto> matchDetails) {
    //sort by matchInfo.gameStartMillis
    return Map.fromEntries(matchDetails.entries.toList()
      ..sort((e1, e2) => e2.value.matchInfo.gameStartMillis
          .compareTo(e1.value.matchInfo.gameStartMillis)));
  }

  // Add function to check if player won a round given the round index
  static bool didPlayerWinRound(
      MatchDto matchDto, String puuid, int roundIndex) {
    RoundResultDto roundResult = getRoundResults(matchDto)[roundIndex];
    String playerTeamId = extractTeamIdFromPUUID(matchDto, puuid);

    return roundResult.winningTeam == playerTeamId;
  }

  // Method related to filtering match details
  static List<MatchDto> filterMatchDetails(List<MatchDto> matchDetails,
      String? puuid, ContentItem filter, String filterType) {
    String id = filter.uuid;

    if (id.isNotEmpty) {
      switch (filterType) {
        case 'maps':
          matchDetails = matchDetails.where((matchDetail) {
            return matchDetail.matchInfo.mapId == id;
          }).toList();
          break;
        case 'agents':
          matchDetails = matchDetails
              .where((matchDetail) =>
                  matchDetail.players
                      .firstWhere((player) => player.puuid == puuid)
                      .characterId ==
                  id)
              .toList();
          break;
        case 'gameModes':
          matchDetails = matchDetails
              .where((matchDetail) => matchDetail.matchInfo.gameMode == id)
              .toList();
          break;

        default:
          print('Unknown filter type');
      }
      return matchDetails;
    }
    return [];
  }
}
