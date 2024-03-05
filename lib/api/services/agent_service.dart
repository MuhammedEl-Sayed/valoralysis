import 'package:dio/dio.dart';
import 'package:valoralysis/models/agent.dart';
import 'package:valoralysis/models/content.dart';

class AgentService {
  static Future<List<AgentIconMap>> getAgentIcons() async {
    Dio dio = Dio();
    try {
      var response = await dio.get('https://valorant-api.com/v1/agents');
      List<AgentIconMap> agentIcons = [];
      for (var agent in response.data['data']) {
        agentIcons.add(AgentIconMap(agent['uuid'], agent['displayIcon']));
      }
      print(agentIcons);
      return agentIcons;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
