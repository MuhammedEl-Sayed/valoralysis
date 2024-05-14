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
    return PlayerStats.fromJsonWithKD(matchDetail['players']
        .firstWhere((player) => player['puuid'] == puuid)['stats']);
  }

  static List<PlayerRoundStats> extractPlayerRoundStats(
      Map<String, dynamic> matchDetail, String puuid) {
    return matchDetail['roundResults']
        .where((roundResult) => roundResult['puuid'] == puuid)
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

  static Map<int, List<KillDto>> extractKilledPlayers(
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

  static Map<String, List<KillDto>> extractRoundDeaths(
      Map<String, dynamic> matchDetail, String puuid) {
        Map<String, List<KillDto>> puuidToKillListMap = {};
    List<String> enemyTeamPUUIDS = extractEnemyTeamPUUIDs(matchDetail, puuid);
    List<Map<String, dynamic>> roundResults = getRoundResults(matchDetail);


    for(var roundResult in roundResults){
      for(PlayerRoundStats playerStat in roundResult['playerStats']){
        if(enemyTeamPUUIDS.contains(playerStat.puuid)){
          for(KillDto kill in playerStat.kills){
            if(kill.victim == puuid){
              print('I killed you bitch: ${playerStat.puuid}');
                puuidToKillListMap[playerStat.puuid]!.add(kill);
            }
          }
        }

      }
    }

    return puuidToKillListMap;
    
  }

  static bool getPlayerTrades(Map<String, dynamic> matchDetail, String puuid){
    /*
      So to do this. We need to find a round with a dead teammate. 
      Then we check if KilledPlayers map has a list at index of that round with dead teammate.
      If so, check if any of them are the one who killed dead teammate. 
      Then check if the time was less than 3s. then return true
    */
  
    // ! Potential optimization, make plural version of extractRoundDeaths and make it a
    

  }

  static List<String> extractEnemyTeamPUUIDs(Map<String, dynamic> matchDetail, String puuid) {
    String userTeam = extractTeamIdFromPUUID(matchDetail, puuid);
    List<String> enemyTeamPUUIDs = [];
    for(var player in matchDetail['players']){
      if(player['teamId'] != userTeam) {
        enemyTeamPUUIDs.add(player['puuid']);
      }
    }
    return enemyTeamPUUIDs;
  }

    static List<String> extractPlayerTeamPUUIDs(  Map<String, dynamic> matchDetail, String puuid) {
     String userTeam = extractTeamIdFromPUUID(matchDetail, puuid);
    List<String> playerTeamPUUIDs = [];
    for(var player in matchDetail['players']){
      if(player['teamId'] == userTeam) {
        playerTeamPUUIDs.add(player['puuid']);
      }
    }
    return playerTeamPUUIDs;
  }


  // Methods related to extracting content details
  static getContentImageFromId(String puuid, List<ContentItem> content) {
    return content.firstWhere((item) => item.id == puuid).iconUrl;
  }

  static getContentImageFromName(String name, List<ContentItem> content) {
    return content.firstWhere((item) => item.name == name).iconUrl;
  }

  static getContentTextFromId(String puuid, List<ContentItem> content) {
    try {
      var result = content.firstWhere((item) => item.id == puuid);
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

  static

  // Methods related to extracting round results
  static List<Map<String, dynamic>> getRoundResults(
      Map<String, dynamic> matchDetail) {
    List<Map<String, dynamic>> roundResults = [];
    for (Map<String, dynamic> roundResult in matchDetail['roundResults']) {
      roundResults.add(roundResult);
    }
    return roundResults;
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

  // Method related to filtering match details
  static List<Map<String, dynamic>> filterMatchDetails(
      List<Map<String, dynamic>> matchDetails,
      String? puuid,
      Object filter,
      String filterType) {
    String id = '';
    if (filter is ContentItem) {
      id = filter.id;
    } else if (filter is WeaponItem) {
      id = filter.puuid;
    }
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
