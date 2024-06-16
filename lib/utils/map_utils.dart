import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/match_details.dart';

class MapUtils {
  static String extractMapPath(MatchDto matchDetails) {
    try {
      return matchDetails.matchInfo.mapId;
    } catch (e) {
      return 'Unknown';
    }
  }

  static String getMapNameFromPath(String path, List<ContentItem> maps) {
    if (path == 'Unknown') return 'Unknown';
    try {
      return maps.firstWhere((map) => map.assetUrl == path).name;
    } catch (e) {
      return 'Unknown';
    }
  }
}
