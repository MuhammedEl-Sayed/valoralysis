class PlayerRoundStats {
  String puuid;
  List<KillDto> kills;
  List<DamageDto> damage;
  int score;
  EconomyDto economy;
  AbilityDto ability;

  PlayerRoundStats({
    required this.puuid,
    required this.kills,
    required this.damage,
    required this.score,
    required this.economy,
    required this.ability,
  });

  factory PlayerRoundStats.fromJson(Map<String, dynamic> json) {
    return PlayerRoundStats(
      puuid: json['puuid'],
      kills: (json['kills'] as List).map((e) => KillDto.fromJson(e)).toList(),
      damage:
          (json['damage'] as List).map((e) => DamageDto.fromJson(e)).toList(),
      score: json['score'],
      economy: EconomyDto.fromJson(json['economy']),
      ability: AbilityDto.fromJson(json['ability']),
    );
  }
}

class KillDto {
  int timeSinceGameStartMillis;
  int timeSinceRoundStartMillis;
  String killer;
  String victim;
  LocationDto victimLocation;
  List<String> assistants;
  List<PlayerLocationsDto> playerLocations;
  FinishingDamageDto finishingDamage;

  KillDto({
    required this.timeSinceGameStartMillis,
    required this.timeSinceRoundStartMillis,
    required this.killer,
    required this.victim,
    required this.victimLocation,
    required this.assistants,
    required this.playerLocations,
    required this.finishingDamage,
  });

  factory KillDto.fromJson(Map<String, dynamic> json) {
    return KillDto(
      timeSinceGameStartMillis: json['timeSinceGameStartMillis'],
      timeSinceRoundStartMillis: json['timeSinceRoundStartMillis'],
      killer: json['killer'],
      victim: json['victim'],
      victimLocation: LocationDto.fromJson(json['victimLocation']),
      assistants: List<String>.from(json['assistants']),
      playerLocations: (json['playerLocations'] as List)
          .map((e) => PlayerLocationsDto.fromJson(e))
          .toList(),
      finishingDamage: FinishingDamageDto.fromJson(json['finishingDamage']),
    );
  }
}

class EconomyDto {
  int loadoutValue;
  String weapon;
  String armor;
  int remaining;
  int spent;

  EconomyDto({
    required this.loadoutValue,
    required this.weapon,
    required this.armor,
    required this.remaining,
    required this.spent,
  });

  factory EconomyDto.fromJson(Map<String, dynamic> json) {
    return EconomyDto(
      loadoutValue: json['loadoutValue'],
      weapon: json['weapon'],
      armor: json['armor'],
      remaining: json['remaining'],
      spent: json['spent'],
    );
  }
}

class FinishingDamageDto {
  String damageType;
  String damageItem;
  bool isSecondaryFireMode;

  FinishingDamageDto({
    required this.damageType,
    required this.damageItem,
    required this.isSecondaryFireMode,
  });

  factory FinishingDamageDto.fromJson(Map<String, dynamic> json) {
    return FinishingDamageDto(
      damageType: json['damageType'],
      damageItem: json['damageItem'],
      isSecondaryFireMode: json['isSecondaryFireMode'],
    );
  }
}

class LocationDto {
  int x;
  int y;

  LocationDto({
    required this.x,
    required this.y,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) {
    return LocationDto(
      x: json['x'],
      y: json['y'],
    );
  }
}

class PlayerLocationsDto {
  String puuid;
  double viewRadians;
  LocationDto location;

  PlayerLocationsDto({
    required this.puuid,
    required this.viewRadians,
    required this.location,
  });

  factory PlayerLocationsDto.fromJson(Map<String, dynamic> json) {
    return PlayerLocationsDto(
      puuid: json['puuid'],
      viewRadians: json['viewRadians'] is int
          ? (json['viewRadians'] as int).toDouble()
          : json['viewRadians'],
      location: LocationDto.fromJson(json['location']),
    );
  }
}

class DamageDto {
  String receiver;
  int damage;
  int legshots;
  int bodyshots;
  int headshots;

  DamageDto({
    required this.receiver,
    required this.damage,
    required this.legshots,
    required this.bodyshots,
    required this.headshots,
  });

  factory DamageDto.fromJson(Map<String, dynamic> json) {
    return DamageDto(
      receiver: json['receiver'],
      damage: json['damage'],
      legshots: json['legshots'],
      bodyshots: json['bodyshots'],
      headshots: json['headshots'],
    );
  }
}

class AbilityDto {
  String? grenadeEffects;
  String? ability1Effects;
  String? ability2Effects;
  String? ultimateEffects;

  AbilityDto({
    this.grenadeEffects,
    this.ability1Effects,
    this.ability2Effects,
    this.ultimateEffects,
  });

  factory AbilityDto.fromJson(Map<String, dynamic> json) {
    return AbilityDto(
      grenadeEffects: json['grenadeEffects'] ?? '',
      ability1Effects: json['ability1Effects'] ?? '',
      ability2Effects: json['ability2Effects'] ?? '',
      ultimateEffects: json['ultimateEffects'] ?? '',
    );
  }
}
