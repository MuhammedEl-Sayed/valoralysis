import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/player_stats.dart';
import 'package:valoralysis/utils/analysis/winrate_analysis.dart';
import 'package:valoralysis/utils/history_utils.dart';

class MapAnalysis {
  static Map<String, double> getKDAPerMap(
      List<Map<String, dynamic>> matchDetails,
      String puuid,
      List<ContentItem> maps) {
    Map<String, double> kdaPerMap = {};
    for (ContentItem map in maps) {
      List<PlayerStats> stats = HistoryUtils.extractPlayerStats(
          HistoryUtils.filterMatchDetails(matchDetails, puuid, map, 'maps'),
          puuid);
      if (stats.isNotEmpty) {
        double totalKDA = stats.fold(0, (prev, element) => prev + element.kda);
        kdaPerMap[map.name] = totalKDA / stats.length;
      } else {
        kdaPerMap[map.name] = 0;
      }
    }
    return kdaPerMap;
  }

  static Map<String, double> getWRPerMap(
      List<Map<String, dynamic>> matchDetails,
      String puuid,
      List<ContentItem> maps) {
    Map<String, double> wrPerMap = {};

    for (ContentItem map in maps) {
      print(map.name);
      double stats = WinrateAnalysis.getWR(
          HistoryUtils.filterMatchDetails(matchDetails, puuid, map, 'maps'),
          puuid);

      wrPerMap[map.name] = stats;
    }
    return wrPerMap;
  }
}
