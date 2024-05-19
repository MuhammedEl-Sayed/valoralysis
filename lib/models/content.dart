class ContentItem {
  String name;
  String uuid;
  String hash;
  String? iconUrl;
  String? assetUrl;

  ContentItem(this.name, this.uuid, this.hash, {this.iconUrl, this.assetUrl});

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

  factory ContentItem.fromJsonMap(Map<String, dynamic> json, String hash,
      {String? iconUrl}) {
    if (json['displayName'] == null || json['uuid'] == null) {
      throw ArgumentError('Invalid JSON: $json');
    }
    return ContentItem(
      json['displayName'] ?? 'Unknown',
      json['uuid'].toString().toLowerCase(),
      hash,
      iconUrl: iconUrl ?? json['iconUrl'],
      assetUrl: json['assetPath'],
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uuid': uuid,
      'iconUrl': iconUrl,
      'assetUrl': assetUrl,
      'hash': hash,
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
