import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/player_stats.dart';
import 'package:valoralysis/utils/analysis/winrate_analysis.dart';
import 'package:valoralysis/utils/history_utils.dart';

class MapAnalysis {
  static Map<String, double> getKDPerMap(
      List<Map<String, dynamic>> matchDetails,
      String puuid,
      List<ContentItem> maps) {
    Map<String, double> kdPerMap = {};
    for (ContentItem map in maps) {
      List<PlayerStats> stats = HistoryUtils.extractPlayerStats(
          HistoryUtils.filterMatchDetails(matchDetails, puuid, map, 'maps'),
          puuid);
      if (stats.isNotEmpty) {
        double totalKD = stats.fold(0, (prev, element) => prev + element.kd);
        kdPerMap[map.name] = totalKD / stats.length;
      } else {
        kdPerMap[map.name] = 0;
      }
    }
    return kdPerMap;
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
