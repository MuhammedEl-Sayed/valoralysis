class ContentItem {
  String name;
  String uuid;
  String? iconUrl;
  String? assetUrl;
  String hash;

  ContentItem(this.name, this.uuid, this.hash, {this.iconUrl, this.assetUrl});

  factory ContentItem.fromJson(Map<String, dynamic> json, String hash,
      {String? iconUrl}) {
    return ContentItem(json['name'], json['id'].toString().toLowerCase(), hash,
        iconUrl: iconUrl ?? json['iconUrl']);
  }

  factory ContentItem.fromJsonMap(Map<String, dynamic> json, String hash,
      {String? iconUrl}) {
    return ContentItem(
        json['name'], json['uuid'].toString().toLowerCase(), hash,
        iconUrl: iconUrl ?? json['iconUrl'], assetUrl: json['assetPath']);
  }

  factory ContentItem.fromJsonRanks(Map<String, dynamic> json, String hash,
      {String? iconUrl}) {
    return ContentItem(json['tierName'], json['tier'].toString(), hash,
        iconUrl: iconUrl ?? json['smallIcon']);
  }

  factory ContentItem.fromJsonWeapon(Map<String, dynamic> json, String hash,
      {String? iconUrl}) {
    return ContentItem(
        json['displayName'], json['uuid'].toString().toLowerCase(), hash,
        iconUrl: iconUrl ?? json['displayIcon']);
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
}
