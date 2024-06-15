import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/utils/history_utils.dart';

class AgentUtils {
  static String? getImageFromId(
      MatchDto matchDetail, String puuid, List<ContentItem> agents) {
    return agents
        .firstWhere(
            (agent) => agent.uuid == extractAgentIdByPUUID(matchDetail, puuid))
        .iconUrl;
  }

  static String extractAgentIdByPUUID(MatchDto matchDetail, String puuid) {
    PlayerDto player = HistoryUtils.getPlayerByPUUID(matchDetail, puuid);
    return player.characterId;
  }

  static String? getImageFromAgentId(String agentId, List<ContentItem> agents) {
    return agents
        .firstWhere(
            (agent) => agent.uuid.toLowerCase() == agentId.toLowerCase())
        .iconUrl;
  }
}
