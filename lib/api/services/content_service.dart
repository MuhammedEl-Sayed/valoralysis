import 'package:dio/dio.dart';
import 'package:valoralysis/api/services/agent_service.dart';
import 'package:valoralysis/api/services/auth_service.dart';
import 'package:valoralysis/models/agent.dart';
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/utils/riot_api_builder.dart';

class ContentService {
  static Future<Content> fetchContent() async {
    try {
      Dio dio = AuthService.prepareDio(PlatformId.NA);
      var response = await dio.get('/val/content/v1/contents?locale=en-US');
      List<AgentIconMap> agentIcons = await AgentService.getAgentIcons();
      print(agentIcons[1].url);
      return await Content.fromJson(response.data, agentIcons: agentIcons);
    } catch (e) {
      print('Error fetching content: $e');
      throw e;
    }
  }
}
