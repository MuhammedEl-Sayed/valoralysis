import 'package:valoralysis/models/agent.dart';
import 'package:valoralysis/models/rank.dart';

class ContentItem {
  String name;
  String id;
  String? iconUrl;
  String? assetUrl;
  ContentItem(this.name, this.id, {this.iconUrl, this.assetUrl});
  factory ContentItem.fromJson(Map<String, dynamic> json, {String? iconUrl}) {
    return ContentItem(json['name'], json['id'].toString().toLowerCase(),
        iconUrl: iconUrl ?? json['iconUrl']);
  }
  factory ContentItem.fromJsonWithMapUrl(Map<String, dynamic> json,
      {String? iconUrl}) {
    print(json);
    return ContentItem(json['name'], json['uuid'].toString().toLowerCase(),
        iconUrl: iconUrl ?? json['iconUrl'], assetUrl: json['assetPath']);
  }
}

class WeaponItem {
  String puuid;
  String name;
  String? iconUrl;
  WeaponItem(this.puuid, this.name, {this.iconUrl});
  factory WeaponItem.fromJson(Map<String, dynamic> json, {String? iconUrl}) {
    return WeaponItem(
      json['uuid'].toString().toLowerCase(),
      json['displayName'],
      iconUrl: iconUrl ?? json['displayIcon'],
    );
  }
}

class Content {
  List<ContentItem> maps;
  List<ContentItem> agents;
  List<ContentItem> equips;
  List<ContentItem> gameModes;
  List<ContentItem> acts;
  List<WeaponItem> weapons;
  List<Rank> ranks;

  Content(
      {required this.maps,
      required this.agents,
      required this.equips,
      required this.gameModes,
      required this.acts,
      required this.ranks,
      required this.weapons});

  static Future<Content> fromJson(Map<String, dynamic> json,
      {required List<AgentIconMap> agentIcons,
      required List<Rank> ranks,
      required List<WeaponItem> weapons}) async {
    return Content(
        maps: (json['maps'] as List)
            .map((i) => ContentItem.fromJsonWithMapUrl(i))
            .toList(),
        agents: (json['characters'] as List).map((i) {
          var icon = agentIcons.firstWhere(
              (icon) => icon.puuid == i['id'].toString().toLowerCase(),
              orElse: () => AgentIconMap('', ''));
          return ContentItem.fromJson(i, iconUrl: icon.url);
        }).toList(),
        equips: (json['equips'] as List)
            .map((i) => ContentItem.fromJson(i))
            .toList(),
        gameModes: (json['gameModes'] as List)
            .map((i) => ContentItem.fromJson(i))
            .toList(),
        acts:
            (json['acts'] as List).map((i) => ContentItem.fromJson(i)).toList(),
        weapons: weapons,
        ranks: ranks);
  }
}
