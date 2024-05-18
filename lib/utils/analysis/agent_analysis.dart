import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/utils/analysis/winrate_analysis.dart';
import 'package:valoralysis/utils/formatting_utils.dart';
import 'package:valoralysis/utils/history_utils.dart';

class AgentAnalysis {
  static String findTopAgent(List<Map<String, dynamic>> matches, String puuid,
      List<ContentItem> agentContent) {
    Map<String, int> agentFrequency = {};

    for (Map<String, dynamic> matchDetails in matches) {
      Map<String, dynamic> player =
          HistoryUtils.getPlayerByPUUID(matchDetails, puuid);
      if (player == {} || player['characterId'] == null) {
        continue;
      }
      agentFrequency.update(player['characterId'], (value) => value + 1,
          ifAbsent: () => 1);
    }

    String mostFrequentAgent = '';
    int mostFrequentValue = 0;

    agentFrequency.forEach((agent, value) {
      if (value > mostFrequentValue) {
        mostFrequentAgent = agent;
        mostFrequentValue = value;
      }
    });
    return agentContent
        .firstWhere((agent) => agent.uuid.toLowerCase() == mostFrequentAgent)
        .name;
  }

  static Map<String, double> findAgentWR(List<Map<String, dynamic>> matches,
      String puuid, List<ContentItem> agentContent) {
    try {
      // So we want to find WR per agent. So we can use agentContent to map the matches to agents, then call the WR on them. Love the modularized approach!!
      Map<String, List<Map<String, dynamic>>> agentMatchMap = {};
      Map<String, double> agentWR = {};
      for (Map<String, dynamic> matchDetails in matches) {
        for (Map<String, dynamic> player in matchDetails['players']) {
          if (player['puuid'] == puuid) {
            agentMatchMap.update(
                FormattingUtils.convertContentIdToName(
                    agentContent, player['characterId']), (value) {
              value.add(matchDetails);
              return value;
            }, ifAbsent: () => [matchDetails]);
          }
        }
      }

      agentMatchMap.forEach((characterId, matches) {
        agentWR[characterId] = WinrateAnalysis.getWR(matches, puuid);
      });
      return agentWR;
    } catch (e) {
      print('Error: $e');
      return {};
    }
  }
}
