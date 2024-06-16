import 'dart:io';

import 'package:valoralysis/models/abilities.dart';

class ContentItem {
  String name;
  String uuid;
  String hash;
  String? iconUrl;
  String? assetUrl;
  String? silhouetteUrl;
  Abilities? abilities;

  ContentItem(this.name, this.uuid, this.hash,
      {this.iconUrl, this.assetUrl, this.silhouetteUrl, this.abilities});

  factory ContentItem.fromJson(Map<String, dynamic> json, String hash,
      {String? iconUrl}) {
    if (json['displayName'] == null || json['uuid'] == null) {
      throw ArgumentError('Invalid JSON: $json');
    }
    return ContentItem(
      json['displayName'] ?? 'Unknown',
      json['uuid'].toString().toLowerCase(),
      hash,
      iconUrl: iconUrl ?? json['displayIcon'],
    );
  }

  factory ContentItem.fromJsonAgents(Map<String, dynamic> json, String hash,
      {String? iconUrl, Map<String, File?>? abilityImages}) {
    if (json['displayName'] == null || json['uuid'] == null) {
      throw ArgumentError('Invalid JSON: $json');
    }

    return ContentItem(
      json['displayName'] ?? 'Unknown',
      json['uuid'].toString().toLowerCase(),
      hash,
      iconUrl: iconUrl ?? json['displayIcon'],
      abilities: Abilities(
          ability1: Ability.fromJson(
              json['abilities']
                  .firstWhere((ability) => ability['slot'] == 'Ability1'),
              abilityImages!['Ability1']!.path),
          ability2: Ability.fromJson(
              json['abilities']
                  .firstWhere((ability) => ability['slot'] == 'Ability2'),
              abilityImages['Ability2']!.path),
          grenade: Ability.fromJson(
              json['abilities']
                  .firstWhere((ability) => ability['slot'] == 'Grenade'),
              abilityImages['Grenade']!.path),
          ultimate: Ability.fromJson(
              json['abilities']
                  .firstWhere((ability) => ability['slot'] == 'Ultimate'),
              abilityImages['Ultimate']!.path)),
    );
  }

  factory ContentItem.fromJsonMap(Map<String, dynamic> json, String hash,
      {String? iconUrl}) {
    return ContentItem(
      json['displayName'] ?? json['name'] ?? 'Unknown',
      json['uuid'].toString().toLowerCase(),
      hash,
      iconUrl: iconUrl ?? json['iconUrl'],
      assetUrl: json['mapUrl'],
    );
  }

  factory ContentItem.fromJsonRanks(Map<String, dynamic> json, String hash,
      {String? iconUrl}) {
    if (json['tierName'] == null || json['tier'] == null) {
      throw ArgumentError('Invalid JSON: $json');
    }
    return ContentItem(
      json['tierName'] ?? 'Unknown',
      json['tier'].toString(),
      hash,
      iconUrl: iconUrl ?? json['smallIcon'],
    );
  }

  factory ContentItem.fromJsonWeapon(Map<String, dynamic> json, String hash,
      {String? iconUrl, String? silhouetteUrl}) {
    if (json['displayName'] == null || json['uuid'] == null) {
      throw ArgumentError('Invalid JSON: $json');
    }
    return ContentItem(json['displayName'] ?? 'Unknown',
        json['uuid'].toString().toLowerCase(), hash,
        iconUrl: iconUrl ?? json['displayIcon'],
        silhouetteUrl: silhouetteUrl ?? json['killStreamIcon']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uuid': uuid,
      'iconUrl': iconUrl,
      'assetUrl': assetUrl,
      'hash': hash,
      'silhouetteUrl': silhouetteUrl,
      'abilities': abilities?.toJson(),
    };
  }
}

class Content {
  List<ContentItem> maps;
  List<ContentItem> agents;
  List<ContentItem> gameModes;
  List<ContentItem> acts;
  List<ContentItem> weapons;
  List<ContentItem> ranks;

  Content(
      {required this.maps,
      required this.agents,
      required this.gameModes,
      required this.acts,
      required this.ranks,
      required this.weapons});
  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      maps: (json['maps'] as List<dynamic>)
          .map((item) => ContentItem(
                item['name'],
                item['uuid'],
                item['hash'],
                iconUrl: item['iconUrl'] ?? '',
                assetUrl: item['assetUrl'] ?? '',
              ))
          .toList(),
      agents: (json['agents'] as List<dynamic>)
          .map((item) => ContentItem(
                item['name'],
                item['uuid'],
                item['hash'],
                iconUrl: item['iconUrl'] ?? '',
                assetUrl: item['assetUrl'] ?? '',
                abilities: Abilities.fromJson(item['abilities']),
              ))
          .toList(),
      gameModes: (json['gameModes'] as List<dynamic>)
          .map((item) => ContentItem(
                item['name'],
                item['uuid'],
                item['hash'],
                iconUrl: item['iconUrl'] ?? '',
                assetUrl: item['assetUrl'] ?? '',
              ))
          .toList(),
      acts: (json['acts'] as List<dynamic>)
          .map((item) => ContentItem(
                item['name'],
                item['uuid'],
                item['hash'],
                iconUrl: item['iconUrl'] ?? '',
                assetUrl: item['assetUrl'] ?? '',
              ))
          .toList(),
      ranks: (json['ranks'] as List<dynamic>)
          .map((item) => ContentItem(
                item['name'],
                item['uuid'],
                item['hash'],
                iconUrl: item['iconUrl'] ?? '',
                assetUrl: item['assetUrl'] ?? '',
              ))
          .toList(),
      weapons: (json['weapons'] as List<dynamic>)
          .map((item) => ContentItem(
                item['name'],
                item['uuid'],
                item['hash'],
                iconUrl: item['iconUrl'] ?? '',
                assetUrl: item['assetUrl'] ?? '',
                silhouetteUrl: item['silhouetteUrl'] ?? '',
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maps': maps.map((item) => item.toJson()).toList(),
      'agents': agents.map((item) => item.toJson()).toList(),
      'gameModes': gameModes.map((item) => item.toJson()).toList(),
      'acts': acts.map((item) => item.toJson()).toList(),
      'weapons': weapons.map((item) => item.toJson()).toList(),
      'ranks': ranks.map((item) => item.toJson()).toList(),
    };
  }
}
