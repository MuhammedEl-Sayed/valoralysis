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
}

class LocationDto {
  int x;
  int y;

  LocationDto({
    required this.x,
    required this.y,
  });
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
}

class AbilityDto {
  String grenadeEffects;
  String ability1Effects;
  String ability2Effects;
  String ultimateEffects;

  AbilityDto({
    required this.grenadeEffects,
    required this.ability1Effects,
    required this.ability2Effects,
    required this.ultimateEffects,
  });
}
