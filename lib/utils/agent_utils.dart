import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/utils/history_utils.dart';

class AgentUtils {
  static getImageFromId(String uuid, List<ContentItem> agents) {
    return agents.firstWhere((agent) => agent.id == uuid).iconUrl;
  }

  static String extractAgentIconByPUUID(
      Map<String, dynamic> matchDetails, String puuid) {
    Map<String, dynamic> player =
        HistoryUtils.getPlayerByPUUID(matchDetails, puuid);
    return player != {} ? player['characterId'] : null;
  }
}
