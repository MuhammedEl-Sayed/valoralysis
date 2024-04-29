import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/utils/history_utils.dart';

class AgentUtils {
  static String? getImageFromId(Map<String, dynamic> matchDetails, String puuid,
      List<ContentItem> agents) {
    return agents
        .firstWhere(
            (agent) => agent.id == extractAgentIdByPUUID(matchDetails, puuid))
        .iconUrl;
  }

  static String extractAgentIdByPUUID(
      Map<String, dynamic> matchDetails, String puuid) {
    Map<String, dynamic> player =
        HistoryUtils.getPlayerByPUUID(matchDetails, puuid);
    return player != {} ? player['characterId'] : null;
  }
}
