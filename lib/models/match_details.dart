class MatchDto {
  MatchInfoDto matchInfo;
  List<PlayerDto> players;
  List<CoachDto> coaches;
  List<TeamDto> teams;
  List<RoundResultDto> roundResults;

  MatchDto({
    required this.matchInfo,
    required this.players,
    required this.coaches,
    required this.teams,
    required this.roundResults,
  });

  factory MatchDto.fromJson(Map<String, dynamic> json) => MatchDto(
        matchInfo: MatchInfoDto.fromJson(json['matchInfo'] ?? {}),
        players: List<PlayerDto>.from(
            (json['players']).map((x) => PlayerDto.fromJson(x))),
        coaches: List<CoachDto>.from(
            (json['coaches'] ?? []).map((x) => CoachDto.fromJson(x))),
        teams: List<TeamDto>.from(
            (json['teams'] ?? []).map((x) => TeamDto.fromJson(x))),
        roundResults: List<RoundResultDto>.from((json['roundResults'] ?? [])
            .map((x) => RoundResultDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'matchInfo': matchInfo.toJson(),
        'players': List<dynamic>.from(players.map((x) => x.toJson())),
        'coaches': List<dynamic>.from(coaches.map((x) => x.toJson())),
        'teams': List<dynamic>.from(teams.map((x) => x.toJson())),
        'roundResults': List<dynamic>.from(roundResults.map((x) => x.toJson())),
      };

  factory MatchDto.empty() => MatchDto(
        matchInfo: MatchInfoDto.empty(),
        players: [],
        coaches: [],
        teams: [],
        roundResults: [],
      );
}

class MatchInfoDto {
  String matchId;
  String mapId;
  int gameLengthMillis;
  int gameStartMillis;
  String provisioningFlowId;
  bool isCompleted;
  String customGameName;
  String queueId;
  String gameMode;
  bool isRanked;
  String seasonId;

  MatchInfoDto({
    required this.matchId,
    required this.mapId,
    required this.gameLengthMillis,
    required this.gameStartMillis,
    required this.provisioningFlowId,
    required this.isCompleted,
    required this.customGameName,
    required this.queueId,
    required this.gameMode,
    required this.isRanked,
    required this.seasonId,
  });

  factory MatchInfoDto.fromJson(Map<String, dynamic> json) => MatchInfoDto(
        matchId: json['matchId'] ?? '',
        mapId: json['mapId'] ?? '',
        gameLengthMillis: json['gameLengthMillis'] ?? 0,
        gameStartMillis: json['gameStartMillis'] ?? 0,
        provisioningFlowId: json['provisioningFlowId'] ?? '',
        isCompleted: json['isCompleted'] ?? false,
        customGameName: json['customGameName'] ?? '',
        queueId: json['queueId'] ?? '',
        gameMode: json['gameMode'] ?? '',
        isRanked: json['isRanked'] ?? false,
        seasonId: json['seasonId'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'matchId': matchId,
        'mapId': mapId,
        'gameLengthMillis': gameLengthMillis,
        'gameStartMillis': gameStartMillis,
        'provisioningFlowId': provisioningFlowId,
        'isCompleted': isCompleted,
        'customGameName': customGameName,
        'queueId': queueId,
        'gameMode': gameMode,
        'isRanked': isRanked,
        'seasonId': seasonId,
      };

  factory MatchInfoDto.empty() => MatchInfoDto(
        matchId: '',
        mapId: '',
        gameLengthMillis: 0,
        gameStartMillis: 0,
        provisioningFlowId: '',
        isCompleted: false,
        customGameName: '',
        queueId: '',
        gameMode: '',
        isRanked: false,
        seasonId: '',
      );
}

class PlayerDto {
  String puuid;
  String gameName;
  String tagLine;
  String teamId;
  String partyId;
  String characterId;
  PlayerStatsDto stats;
  int competitiveTier;
  String playerCard;
  String playerTitle;

  PlayerDto({
    required this.puuid,
    required this.gameName,
    required this.tagLine,
    required this.teamId,
    required this.partyId,
    required this.characterId,
    required this.stats,
    required this.competitiveTier,
    required this.playerCard,
    required this.playerTitle,
  });
  factory PlayerDto.fromJson(Map<String, dynamic> json) {
    PlayerDto player = PlayerDto(
      puuid: json['puuid'] ?? '',
      gameName: json['gameName'] ?? '',
      tagLine: json['tagLine'] ?? '',
      teamId: json['teamId'] ?? '',
      partyId: json['partyId'] ?? '',
      characterId: json['characterId'] ?? '',
      stats: PlayerStatsDto.fromJson(json['stats'] ?? {}),
      competitiveTier: json['competitiveTier'] ?? 0,
      playerCard: json['playerCard'] ?? '',
      playerTitle: json['playerTitle'] ?? '',
    );
    print(player); // print the player
    return player;
  }
  Map<String, dynamic> toJson() => {
        'puuid': puuid,
        'gameName': gameName,
        'tagLine': tagLine,
        'teamId': teamId,
        'partyId': partyId,
        'characterId': characterId,
        'stats': stats.toJson(),
        'competitiveTier': competitiveTier,
        'playerCard': playerCard,
        'playerTitle': playerTitle,
      };

  factory PlayerDto.empty() => PlayerDto(
        puuid: '',
        gameName: '',
        tagLine: '',
        teamId: '',
        partyId: '',
        characterId: '',
        stats: PlayerStatsDto.empty(),
        competitiveTier: 0,
        playerCard: '',
        playerTitle: '',
      );
}

class PlayerStatsDto {
  int score;
  int roundsPlayed;
  int kills;
  int deaths;
  int assists;
  int playtimeMillis;
  AbilityCastsDto abilityCasts;

  PlayerStatsDto({
    required this.score,
    required this.roundsPlayed,
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.playtimeMillis,
    required this.abilityCasts,
  });

  factory PlayerStatsDto.fromJson(Map<String, dynamic> json) => PlayerStatsDto(
        score: json['score'] ?? 0,
        roundsPlayed: json['roundsPlayed'] ?? 0,
        kills: json['kills'] ?? 0,
        deaths: json['deaths'] ?? 0,
        assists: json['assists'] ?? 0,
        playtimeMillis: json['playtimeMillis'] ?? 0,
        abilityCasts: AbilityCastsDto.fromJson(json['abilityCasts'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'score': score,
        'roundsPlayed': roundsPlayed,
        'kills': kills,
        'deaths': deaths,
        'assists': assists,
        'playtimeMillis': playtimeMillis,
        'abilityCasts': abilityCasts.toJson(),
      };

  factory PlayerStatsDto.empty() => PlayerStatsDto(
        score: 0,
        roundsPlayed: 0,
        kills: 0,
        deaths: 0,
        assists: 0,
        playtimeMillis: 0,
        abilityCasts: AbilityCastsDto.empty(),
      );
}

class AbilityCastsDto {
  int grenadeCasts;
  int ability1Casts;
  int ability2Casts;
  int ultimateCasts;

  AbilityCastsDto({
    required this.grenadeCasts,
    required this.ability1Casts,
    required this.ability2Casts,
    required this.ultimateCasts,
  });

  factory AbilityCastsDto.fromJson(Map<String, dynamic> json) =>
      AbilityCastsDto(
        grenadeCasts: json['grenadeCasts'] ?? 0,
        ability1Casts: json['ability1Casts'] ?? 0,
        ability2Casts: json['ability2Casts'] ?? 0,
        ultimateCasts: json['ultimateCasts'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'grenadeCasts': grenadeCasts,
        'ability1Casts': ability1Casts,
        'ability2Casts': ability2Casts,
        'ultimateCasts': ultimateCasts,
      };

  factory AbilityCastsDto.empty() => AbilityCastsDto(
        grenadeCasts: 0,
        ability1Casts: 0,
        ability2Casts: 0,
        ultimateCasts: 0,
      );
}

class CoachDto {
  String puuid;
  String teamId;

  CoachDto({
    required this.puuid,
    required this.teamId,
  });

  factory CoachDto.fromJson(Map<String, dynamic> json) => CoachDto(
        puuid: json['puuid'] ?? '',
        teamId: json['teamId'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'puuid': puuid,
        'teamId': teamId,
      };

  factory CoachDto.empty() => CoachDto(
        puuid: '',
        teamId: '',
      );
}

class TeamDto {
  String teamId;
  bool won;
  int roundsPlayed;
  int roundsWon;
  int numPoints;

  TeamDto({
    required this.teamId,
    required this.won,
    required this.roundsPlayed,
    required this.roundsWon,
    required this.numPoints,
  });

  factory TeamDto.fromJson(Map<String, dynamic> json) => TeamDto(
        teamId: json['teamId'] ?? '',
        won: json['won'] ?? false,
        roundsPlayed: json['roundsPlayed'] ?? 0,
        roundsWon: json['roundsWon'] ?? 0,
        numPoints: json['numPoints'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'teamId': teamId,
        'won': won,
        'roundsPlayed': roundsPlayed,
        'roundsWon': roundsWon,
        'numPoints': numPoints,
      };

  factory TeamDto.empty() => TeamDto(
        teamId: '',
        won: false,
        roundsPlayed: 0,
        roundsWon: 0,
        numPoints: 0,
      );
}

class RoundResultDto {
  int roundNum;
  String roundResult;
  String roundCeremony;
  String winningTeam;
  String bombPlanter;
  String bombDefuser;
  int plantRoundTime;
  List<PlayerLocationsDto> plantPlayerLocations;
  LocationDto plantLocation;
  String plantSite;
  int defuseRoundTime;
  List<PlayerLocationsDto> defusePlayerLocations;
  LocationDto defuseLocation;
  List<PlayerRoundStatsDto> playerStats;
  String roundResultCode;

  RoundResultDto({
    required this.roundNum,
    required this.roundResult,
    required this.roundCeremony,
    required this.winningTeam,
    required this.bombPlanter,
    required this.bombDefuser,
    required this.plantRoundTime,
    required this.plantPlayerLocations,
    required this.plantLocation,
    required this.plantSite,
    required this.defuseRoundTime,
    required this.defusePlayerLocations,
    required this.defuseLocation,
    required this.playerStats,
    required this.roundResultCode,
  });

  factory RoundResultDto.fromJson(Map<String, dynamic> json) => RoundResultDto(
        roundNum: json['roundNum'] ?? 0,
        roundResult: json['roundResult'] ?? '',
        roundCeremony: json['roundCeremony'] ?? '',
        winningTeam: json['winningTeam'] ?? '',
        bombPlanter: json['bombPlanter'] ?? '',
        bombDefuser: json['bombDefuser'] ?? '',
        plantRoundTime: json['plantRoundTime'] ?? 0,
        plantPlayerLocations: json['plantPlayerLocations'] != null
            ? List<PlayerLocationsDto>.from(json['plantPlayerLocations']
                .map((x) => PlayerLocationsDto.fromJson(x)))
            : [],
        plantLocation: json['plantLocation'] != null
            ? LocationDto.fromJson(json['plantLocation'])
            : LocationDto.empty(),
        plantSite: json['plantSite'] ?? '',
        defuseRoundTime: json['defuseRoundTime'] ?? 0,
        defusePlayerLocations: json['defusePlayerLocations'] != null
            ? List<PlayerLocationsDto>.from(json['defusePlayerLocations']
                .map((x) => PlayerLocationsDto.fromJson(x)))
            : [],
        defuseLocation: json['defuseLocation'] != null
            ? LocationDto.fromJson(json['defuseLocation'])
            : LocationDto.empty(),
        playerStats: json['playerStats'] != null
            ? List<PlayerRoundStatsDto>.from(
                json['playerStats'].map((x) => PlayerRoundStatsDto.fromJson(x)))
            : [],
        roundResultCode: json['roundResultCode'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'roundNum': roundNum,
        'roundResult': roundResult,
        'roundCeremony': roundCeremony,
        'winningTeam': winningTeam,
        'bombPlanter': bombPlanter,
        'bombDefuser': bombDefuser,
        'plantRoundTime': plantRoundTime,
        'plantPlayerLocations':
            List<dynamic>.from(plantPlayerLocations.map((x) => x.toJson())),
        'plantLocation': plantLocation.toJson(),
        'plantSite': plantSite,
        'defuseRoundTime': defuseRoundTime,
        'defusePlayerLocations':
            List<dynamic>.from(defusePlayerLocations.map((x) => x.toJson())),
        'defuseLocation': defuseLocation.toJson(),
        'playerStats': List<dynamic>.from(playerStats.map((x) => x.toJson())),
        'roundResultCode': roundResultCode,
      };

  factory RoundResultDto.empty() => RoundResultDto(
        roundNum: 0,
        roundResult: '',
        roundCeremony: '',
        winningTeam: '',
        bombPlanter: '',
        bombDefuser: '',
        plantRoundTime: 0,
        plantPlayerLocations: [],
        plantLocation: LocationDto.empty(),
        plantSite: '',
        defuseRoundTime: 0,
        defusePlayerLocations: [],
        defuseLocation: LocationDto.empty(),
        playerStats: [],
        roundResultCode: '',
      );
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

  factory PlayerLocationsDto.fromJson(Map<String, dynamic> json) =>
      PlayerLocationsDto(
        puuid: json['puuid'] ?? '',
        viewRadians: json['viewRadians'].toDouble() ?? 0.0,
        location: LocationDto.fromJson(json['location']) ?? LocationDto.empty(),
      );

  Map<String, dynamic> toJson() => {
        'puuid': puuid,
        'viewRadians': viewRadians,
        'location': location.toJson(),
      };

  factory PlayerLocationsDto.empty() => PlayerLocationsDto(
        puuid: '',
        viewRadians: 0.0,
        location: LocationDto.empty(),
      );
}

class LocationDto {
  int x;
  int y;

  LocationDto({
    required this.x,
    required this.y,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) => LocationDto(
        x: json['x'] ?? 0,
        y: json['y'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
      };

  factory LocationDto.empty() => LocationDto(
        x: 0,
        y: 0,
      );
}

class PlayerRoundStatsDto {
  String puuid;
  List<KillDto> kills;
  List<DamageDto> damage;
  int score;
  EconomyDto economy;
  AbilityDto ability;

  PlayerRoundStatsDto({
    required this.puuid,
    required this.kills,
    required this.damage,
    required this.score,
    required this.economy,
    required this.ability,
  });

  factory PlayerRoundStatsDto.fromJson(Map<String, dynamic> json) =>
      PlayerRoundStatsDto(
        puuid: json['puuid'] ?? '',
        kills:
            List<KillDto>.from(json['kills'].map((x) => KillDto.fromJson(x))) ??
                [],
        damage: List<DamageDto>.from(
                json['damage'].map((x) => DamageDto.fromJson(x))) ??
            [],
        score: json['score'] ?? 0,
        economy: EconomyDto.fromJson(json['economy']) ?? EconomyDto.empty(),
        ability: AbilityDto.fromJson(json['ability']) ?? AbilityDto.empty(),
      );

  Map<String, dynamic> toJson() => {
        'puuid': puuid,
        'kills': List<dynamic>.from(kills.map((x) => x.toJson())),
        'damage': List<dynamic>.from(damage.map((x) => x.toJson())),
        'score': score,
        'economy': economy.toJson(),
        'ability': ability.toJson(),
      };
  //containsKey
  bool containsKey(String key) {
    return key == 'kills' ||
        key == 'damage' ||
        key == 'score' ||
        key == 'economy' ||
        key == 'ability';
  }

  // []
  dynamic operator [](String key) {
    if (key == 'kills') {
      return kills;
    } else if (key == 'damage') {
      return damage;
    } else if (key == 'score') {
      return score;
    } else if (key == 'economy') {
      return economy;
    } else if (key == 'ability') {
      return ability;
    }
  }

  factory PlayerRoundStatsDto.empty() => PlayerRoundStatsDto(
        puuid: '',
        kills: [],
        damage: [],
        score: 0,
        economy: EconomyDto.empty(),
        ability: AbilityDto.empty(),
      );
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

  factory KillDto.fromJson(Map<String, dynamic> json) => KillDto(
        timeSinceGameStartMillis: json['timeSinceGameStartMillis'] ?? 0,
        timeSinceRoundStartMillis: json['timeSinceRoundStartMillis'] ?? 0,
        killer: json['killer'] ?? '',
        victim: json['victim'] ?? '',
        victimLocation:
            LocationDto.fromJson(json['victimLocation']) ?? LocationDto.empty(),
        assistants: List<String>.from(json['assistants'].map((x) => x)) ?? [],
        playerLocations: List<PlayerLocationsDto>.from(json['playerLocations']
                .map((x) => PlayerLocationsDto.fromJson(x))) ??
            [],
        finishingDamage: FinishingDamageDto.fromJson(json['finishingDamage']) ??
            FinishingDamageDto.empty(),
      );

  Map<String, dynamic> toJson() => {
        'timeSinceGameStartMillis': timeSinceGameStartMillis,
        'timeSinceRoundStartMillis': timeSinceRoundStartMillis,
        'killer': killer,
        'victim': victim,
        'victimLocation': victimLocation.toJson(),
        'assistants': List<dynamic>.from(assistants.map((x) => x)),
        'playerLocations':
            List<dynamic>.from(playerLocations.map((x) => x.toJson())),
        'finishingDamage': finishingDamage.toJson(),
      };

  factory KillDto.empty() => KillDto(
        timeSinceGameStartMillis: 0,
        timeSinceRoundStartMillis: 0,
        killer: '',
        victim: '',
        victimLocation: LocationDto.empty(),
        assistants: [],
        playerLocations: [],
        finishingDamage: FinishingDamageDto.empty(),
      );
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

  factory FinishingDamageDto.fromJson(Map<String, dynamic> json) =>
      FinishingDamageDto(
        damageType: json['damageType'] ?? '',
        damageItem: json['damageItem'] ?? '',
        isSecondaryFireMode: json['isSecondaryFireMode'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'damageType': damageType,
        'damageItem': damageItem,
        'isSecondaryFireMode': isSecondaryFireMode,
      };

  factory FinishingDamageDto.empty() => FinishingDamageDto(
        damageType: '',
        damageItem: '',
        isSecondaryFireMode: false,
      );
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

  factory DamageDto.fromJson(Map<String, dynamic> json) => DamageDto(
        receiver: json['receiver'] ?? '',
        damage: json['damage'] ?? 0,
        legshots: json['legshots'] ?? 0,
        bodyshots: json['bodyshots'] ?? 0,
        headshots: json['headshots'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'receiver': receiver,
        'damage': damage,
        'legshots': legshots,
        'bodyshots': bodyshots,
        'headshots': headshots,
      };

  factory DamageDto.empty() => DamageDto(
        receiver: '',
        damage: 0,
        legshots: 0,
        bodyshots: 0,
        headshots: 0,
      );
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

  factory EconomyDto.fromJson(Map<String, dynamic> json) => EconomyDto(
        loadoutValue: json['loadoutValue'] ?? 0,
        weapon: json['weapon'] ?? '',
        armor: json['armor'] ?? '',
        remaining: json['remaining'] ?? 0,
        spent: json['spent'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'loadoutValue': loadoutValue,
        'weapon': weapon,
        'armor': armor,
        'remaining': remaining,
        'spent': spent,
      };

  factory EconomyDto.empty() => EconomyDto(
        loadoutValue: 0,
        weapon: '',
        armor: '',
        remaining: 0,
        spent: 0,
      );
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

  factory AbilityDto.fromJson(Map<String, dynamic> json) => AbilityDto(
        grenadeEffects: json['grenadeEffects'] ?? '',
        ability1Effects: json['ability1Effects'] ?? '',
        ability2Effects: json['ability2Effects'] ?? '',
        ultimateEffects: json['ultimateEffects'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'grenadeEffects': grenadeEffects,
        'ability1Effects': ability1Effects,
        'ability2Effects': ability2Effects,
        'ultimateEffects': ultimateEffects,
      };

  factory AbilityDto.empty() => AbilityDto(
        grenadeEffects: '',
        ability1Effects: '',
        ability2Effects: '',
        ultimateEffects: '',
      );
}
