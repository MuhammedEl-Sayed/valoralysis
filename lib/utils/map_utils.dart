import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/match_details.dart';

class MapUtils {
  static String extractMapPath(MatchDto matchDetails) {
    return matchDetails.matchInfo.mapId;
  }

  static String getMapNameFromPath(String path, List<ContentItem> maps) {
    return maps.firstWhere((map) => map.assetUrl == path).name;
  }
}
