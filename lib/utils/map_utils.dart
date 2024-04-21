import 'package:valoralysis/models/content.dart';

class MapUtils {
  static String extractMapPath(Map<String, dynamic> matchDetails) {
    return matchDetails['matchInfo']['mapId'] as String;
  }

  static String getMapNameFromPath(String path, List<ContentItem> maps) {
    return maps.firstWhere((map) => map.assetUrl == path).name;
  }
}
