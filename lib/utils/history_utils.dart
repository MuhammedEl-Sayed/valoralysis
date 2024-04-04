import 'package:valoralysis/models/content.dart';
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

  static List<Map<String, dynamic>> filterMatchDetails(
      List<Map<String, dynamic>> matchDetails,
      String? puuid,
      Object filter,
      String filterType) {
    String id = '';
    if (filter is ContentItem) {
      id = filter.id;
    } else if (filter is WeaponItem) {
      id = filter.uuid;
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
