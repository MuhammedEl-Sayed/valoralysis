import 'package:valoralysis/models/content.dart';

class AgentAnalysis {
  static findTopAgent(List<Map<String, dynamic>> matches, String puuid,
      List<ContentItem> agentContent) {
    try {
      //Need to find top agent
      //Go through matches, go through the player part, and then add to a map as a key/increment value
      //Decode only at end, dont need to earlier
      Map<String, int> agentFrequency = {};

      for (Map<String, dynamic> matchDetails in matches) {
        for (Map<String, dynamic> player in matchDetails['players']) {
          if (player['puuid'] == puuid) {
            agentFrequency.update(player['characterId'], (value) => value + 1,
                ifAbsent: () => 1);
          }
        }
      }
      String mostFrequentAgent = '';
      int mostFrequentValue = 0;

      agentFrequency.forEach((agent, value) {
        if (value > mostFrequentValue) {
          mostFrequentAgent = agent;
          mostFrequentValue = value;
        }
      });
      print(matches);
      return agentContent
          .firstWhere((agent) => agent.id.toLowerCase() == mostFrequentAgent)
          .name;
    } catch (e) {
      print('Error: $e');
      return 'Pheonix';
    }
  }
}
