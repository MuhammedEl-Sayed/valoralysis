import 'package:valoralysis/api/services/agent_service.dart';
import 'package:valoralysis/models/agent.dart';

class ContentItem {
  String name;
  String id;
  String? iconUrl;
  ContentItem(this.name, this.id, {this.iconUrl});
  factory ContentItem.fromJson(Map<String, dynamic> json, {String? iconUrl}) {
    return ContentItem(
      json['name'],
      json['id'],
      iconUrl: iconUrl ?? json['iconUrl'],
    );
  }
}

class Content {
  List<ContentItem> maps;
  List<ContentItem> agents;
  List<ContentItem> equips;
  List<ContentItem> gameModes;
  List<ContentItem> acts;

  Content(
      {required this.maps,
      required this.agents,
      required this.equips,
      required this.gameModes,
      required this.acts});

  static Future<Content> fromJson(Map<String, dynamic> json,
      {required List<AgentIconMap> agentIcons}) async {
    return Content(
        maps:
            (json['maps'] as List).map((i) => ContentItem.fromJson(i)).toList(),
        agents: (json['characters'] as List).map((i) {
          var icon = agentIcons.firstWhere(
              (icon) => icon.uuid == i['id'].toString().toLowerCase(),
              orElse: () => AgentIconMap('', ''));
          return ContentItem.fromJson(i, iconUrl: icon.url);
        }).toList(),
        equips: (json['equips'] as List)
            .map((i) => ContentItem.fromJson(i))
            .toList(),
        gameModes: (json['gameModes'] as List)
            .map((i) => ContentItem.fromJson(i))
            .toList(),
        acts: (json['acts'] as List)
            .map((i) => ContentItem.fromJson(i))
            .toList());
  }
}
