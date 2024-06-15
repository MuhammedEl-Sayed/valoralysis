class Ability {
  String name;
  String description;
  String iconUrl;

  Ability(
      {required this.name, required this.description, required this.iconUrl});
  // This is used for pulling from API
  factory Ability.fromJson(Map<String, dynamic> json, String? iconUrl) {
    return Ability(
      name: json['displayName'] ?? '',
      description: json['description'],
      iconUrl: iconUrl ?? json['displayIcon'],
    );
  }
}

class Abilities {
  Ability ability1;
  Ability ability2;
  Ability gernade;
  Ability ultimate;

  Abilities(
      {required this.ability1,
      required this.ability2,
      required this.gernade,
      required this.ultimate});
  // This is used for pulling from cache JSON
  factory Abilities.fromJson(Map<String, dynamic> json) {
    return Abilities(
      ability1: Ability(
          name: json['ability1']['name'],
          description: json['ability1']['description'],
          iconUrl: json['ability1']['iconUrl']),
      ability2: Ability(
          name: json['ability2']['name'],
          description: json['ability2']['description'],
          iconUrl: json['ability2']['iconUrl']),
      gernade: Ability(
          name: json['grenade']['name'],
          description: json['grenade']['description'],
          iconUrl: json['grenade']['iconUrl']),
      ultimate: Ability(
          name: json['ultimate']['name'],
          description: json['ultimate']['description'],
          iconUrl: json['ultimate']['iconUrl']),
    );
  }
}
