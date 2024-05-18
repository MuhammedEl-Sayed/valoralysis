class ContentItem {
  String name;
  String uuid;
  String? iconUrl;
  String? assetUrl;
  String hash;
  ContentItem(this.name, this.uuid, this.hash, {this.iconUrl, this.assetUrl});
  factory ContentItem.fromJson(Map<String, dynamic> json, String hash,
      {String? iconUrl, bool isWeapon = false}) {
    return ContentItem(
        isWeapon ? json['displayName'] : json['name'],
        isWeapon
            ? json['uuid'].toString().toLowerCase()
            : json['id'].toString().toLowerCase(),
        hash,
        iconUrl: iconUrl ?? (isWeapon ? json['displayIcon'] : json['iconUrl']));
  }
  factory ContentItem.fromJsonWithMapUrl(Map<String, dynamic> json, String hash,
      {String? iconUrl}) {
    return ContentItem(
        json['name'], json['uuid'].toString().toLowerCase(), hash,
        iconUrl: iconUrl ?? json['iconUrl'], assetUrl: json['assetPath']);
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
