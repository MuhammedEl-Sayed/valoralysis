import 'package:valoralysis/models/content.dart';

class AgentUtils {
  static getImageFromId(String uuid, List<ContentItem> agents) {
    return agents.firstWhere((agent) => agent.id == uuid).iconUrl;
  }
}
