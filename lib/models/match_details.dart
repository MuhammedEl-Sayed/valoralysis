class MatchDetails {
  MatchInfo matchInfo = MatchInfo();
  List<Player> players = [];

  List<Team> teams = [];
  List<RoundResult> roundResults = [];
  List<Kill> kills = [];

  MatchDetails();
  factory MatchDetails.fromJson(Map<String, dynamic> json) {
    return MatchDetails()
      ..matchInfo = MatchInfo.fromJson(json['matchInfo'])
      ..players =
          (json['players'] as List).map((i) => Player.fromJson(i)).toList()
      ..teams = (json['teams'] as List).map((i) => Team.fromJson(i)).toList()
      ..roundResults = (json['roundResults'] as List)
          .map((i) => RoundResult.fromJson(i))
          .toList()
      ..kills = (json['kills'] as List).map((i) => Kill.fromJson(i)).toList();
  }
}

class MatchInfo {
  String matchId = '';
  String mapId = '';
  String gamePodId = '';
  String gameLoopZone = '';
  String gameServerAddress = '';
  String gameVersion = '';
  int gameStartMillis = 0;
  String provisioningFlowID = '';
  bool isCompleted = false;
  String customGameName = '';
  bool forcePostProcessing = false;
  String queueID = '';
  String gameMode = '';
  bool isRanked = false;
  bool isMatchSampled = false;
  String seasonId = '';
  String completionState = '';
  String platformType = '';
  Map<String, dynamic> premierMatchInfo = {};
  bool shouldMatchDisablePenalties = false;

  MatchInfo();

  factory MatchInfo.fromJson(Map<String, dynamic> json) {
    return MatchInfo()
      ..matchId = json['matchId']
      ..mapId = json['mapId']
      ..gamePodId = json['gamePodId']
      ..gameLoopZone = json['gameLoopZone']
      ..gameServerAddress = json['gameServerAddress']
      ..gameVersion = json['gameVersion']
      ..gameStartMillis = json['gameStartMillis']
      ..provisioningFlowID = json['provisioningFlowID']
      ..isCompleted = json['isCompleted']
      ..customGameName = json['customGameName']
      ..forcePostProcessing = json['forcePostProcessing']
      ..queueID = json['queueID']
      ..gameMode = json['gameMode']
      ..isRanked = json['isRanked']
      ..isMatchSampled = json['isMatchSampled']
      ..seasonId = json['seasonId']
      ..completionState = json['completionState']
      ..platformType = json['platformType']
      ..premierMatchInfo = json['premierMatchInfo']
      ..shouldMatchDisablePenalties = json['shouldMatchDisablePenalties'];
  }
}

class Player {
  String subject = '';
  String gameName = '';
  String tagLine = '';
  PlatformInfo platformInfo = PlatformInfo();
  String teamId = '';
  String partyId = '';
  String characterId = '';
  Stats? stats = Stats();
  List<RoundDamage> roundDamage = [];
  int competitiveTier = 0;
  bool isObserver = false;
  String playerCard = '';
  String playerTitle = '';
  String? preferredLevelBorder = '';
  int accountLevel = 0;
  int? sessionPlaytimeMinutes = 0;
  List<XPModification>? xpModifications = [];
  BehaviorFactors? behaviorFactors = BehaviorFactors();
  NewPlayerExperienceDetails newPlayerExperienceDetails =
      NewPlayerExperienceDetails();
  Player();
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player()
      ..subject = json['subject']
      ..gameName = json['gameName']
      ..tagLine = json['tagLine']
      ..platformInfo = PlatformInfo.fromJson(json['platformInfo'])
      ..teamId = json['teamId']
      ..partyId = json['partyId']
      ..characterId = json['characterId']
      ..stats = Stats.fromJson(json['stats'] ?? Stats())
      ..roundDamage = (json['roundDamage'] as List)
          .map((i) => RoundDamage.fromJson(i))
          .toList()
      ..competitiveTier = json['competitiveTier']
      ..isObserver = json['isObserver']
      ..playerCard = json['playerCard']
      ..playerTitle = json['playerTitle']
      ..preferredLevelBorder = json['preferredLevelBorder'] ?? ''
      ..accountLevel = json['accountLevel']
      ..sessionPlaytimeMinutes = json['sessionPlaytimeMinutes'] ?? 0
      ..xpModifications = (json['xpModifications'] as List)
          .map((i) => XPModification.fromJson(i))
          .toList()
      ..behaviorFactors = BehaviorFactors.fromJson(json['behaviorFactors'])
      ..newPlayerExperienceDetails = NewPlayerExperienceDetails.fromJson(
          json['newPlayerExperienceDetails']);
  }
}

class PlatformInfo {
  String platformType = '';
  String platformOS = '';
  String platformOSVersion = '';
  String platformChipset = '';
  PlatformInfo();
  factory PlatformInfo.fromJson(Map<String, dynamic> json) {
    return PlatformInfo()
      ..platformType = json['platformType']
      ..platformOS = json['platformOS']
      ..platformOSVersion = json['platformOSVersion']
      ..platformChipset = json['platformChipset'];
  }
}

class Stats {
  int score = 0;
  int roundsPlayed = 0;
  int kills = 0;
  int deaths = 0;
  int assists = 0;
  int playtimeMillis = 0;
  AbilityCasts abilityCasts = AbilityCasts();
  Stats();
  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats()
      ..score = json['score']
      ..roundsPlayed = json['roundsPlayed']
      ..kills = json['kills']
      ..deaths = json['deaths']
      ..assists = json['assists']
      ..playtimeMillis = json['playtimeMillis']
      ..abilityCasts = AbilityCasts.fromJson(json['abilityCasts']);
  }
}

class AbilityCasts {
  int grenadeCasts = 0;
  int ability1Casts = 0;
  int ability2Casts = 0;
  int? ultimateCasts = 0;
  AbilityCasts();
  factory AbilityCasts.fromJson(Map<String, dynamic> json) {
    return AbilityCasts()
      ..grenadeCasts = json['grenadeCasts']
      ..ability1Casts = json['ability1Casts']
      ..ability2Casts = json['ability2Casts']
      ..ultimateCasts = json['ultimateCasts'] ?? 0;
  }
}

class RoundDamage {
  int round = 0;
  String receiver = '';
  int damage = 0;
  RoundDamage();
  factory RoundDamage.fromJson(Map<String, dynamic> json) {
    return RoundDamage()
      ..round = json['round']
      ..receiver = json['receiver']
      ..damage = json['damage'];
  }
}

class XPModification {
  int value = 0;
  String id = '';
  XPModification();
  factory XPModification.fromJson(Map<String, dynamic> json) {
    return XPModification()
      ..value = json['value']
      ..id = json['id'];
  }
}

class BehaviorFactors {
  int afkRounds = 0;
  int collisions = 0;
  int commsRatingRecovery = 0;
  int damageParticipationOutgoing = 0;
  int friendlyFireIncoming = 0;
  int friendlyFireOutgoing = 0;
  int mouseMovement = 0;
  int stayedInSpawnRounds = 0;

  BehaviorFactors();

  factory BehaviorFactors.fromJson(Map<String, dynamic> json) {
    return BehaviorFactors()
      ..afkRounds = json['afkRounds']
      ..collisions = json['collisions']
      ..commsRatingRecovery = json['commsRatingRecovery']
      ..damageParticipationOutgoing = json['damageParticipationOutgoing']
      ..friendlyFireIncoming = json['friendlyFireIncoming']
      ..friendlyFireOutgoing = json['friendlyFireOutgoing']
      ..mouseMovement = json['mouseMovement']
      ..stayedInSpawnRounds = json['stayedInSpawnRounds'];
  }
}

class NewPlayerExperienceDetails {
  BasicMovement basicMovement = BasicMovement();
  BasicGunSkill basicGunSkill = BasicGunSkill();
  AdaptiveBots adaptiveBots = AdaptiveBots();
  Ability ability = Ability();
  BombPlant bombPlant = BombPlant();
  DefendBombSite defendBombSite = DefendBombSite();
  SettingStatus settingStatus = SettingStatus();
  String versionString = '';

  NewPlayerExperienceDetails();

  factory NewPlayerExperienceDetails.fromJson(Map<String, dynamic> json) {
    return NewPlayerExperienceDetails()
      ..basicMovement = BasicMovement.fromJson(json['basicMovement'])
      ..basicGunSkill = BasicGunSkill.fromJson(json['basicGunSkill'])
      ..adaptiveBots = AdaptiveBots.fromJson(json['adaptiveBots'])
      ..ability = Ability.fromJson(json['ability'])
      ..bombPlant = BombPlant.fromJson(json['bombPlant'])
      ..defendBombSite = DefendBombSite.fromJson(json['defendBombSite'])
      ..settingStatus = SettingStatus.fromJson(json['settingStatus'])
      ..versionString = json['versionString'];
  }
}

class BasicMovement {
  int idleTimeMillis = 0;
  int objectiveCompleteTimeMillis = 0;

  BasicMovement();

  factory BasicMovement.fromJson(Map<String, dynamic> json) {
    return BasicMovement()
      ..idleTimeMillis = json['idleTimeMillis']
      ..objectiveCompleteTimeMillis = json['objectiveCompleteTimeMillis'];
  }
}

class BasicGunSkill {
  int idleTimeMillis = 0;
  int objectiveCompleteTimeMillis = 0;

  BasicGunSkill();

  factory BasicGunSkill.fromJson(Map<String, dynamic> json) {
    return BasicGunSkill()
      ..idleTimeMillis = json['idleTimeMillis']
      ..objectiveCompleteTimeMillis = json['objectiveCompleteTimeMillis'];
  }
}

class AdaptiveBots {
  int adaptiveBotAverageDurationMillisAllAttempts = 0;
  int adaptiveBotAverageDurationMillisFirstAttempt = 0;
  dynamic killDetailsFirstAttempt;
  int idleTimeMillis = 0;
  int objectiveCompleteTimeMillis = 0;

  AdaptiveBots();

  factory AdaptiveBots.fromJson(Map<String, dynamic> json) {
    return AdaptiveBots()
      ..adaptiveBotAverageDurationMillisAllAttempts =
          json['adaptiveBotAverageDurationMillisAllAttempts']
      ..adaptiveBotAverageDurationMillisFirstAttempt =
          json['adaptiveBotAverageDurationMillisFirstAttempt']
      ..killDetailsFirstAttempt = json['killDetailsFirstAttempt']
      ..idleTimeMillis = json['idleTimeMillis']
      ..objectiveCompleteTimeMillis = json['objectiveCompleteTimeMillis'];
  }
}

class Ability {
  int idleTimeMillis = 0;
  int objectiveCompleteTimeMillis = 0;

  Ability();

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability()
      ..idleTimeMillis = json['idleTimeMillis']
      ..objectiveCompleteTimeMillis = json['objectiveCompleteTimeMillis'];
  }
}

class BombPlant {
  int idleTimeMillis = 0;
  int objectiveCompleteTimeMillis = 0;

  BombPlant();

  factory BombPlant.fromJson(Map<String, dynamic> json) {
    return BombPlant()
      ..idleTimeMillis = json['idleTimeMillis']
      ..objectiveCompleteTimeMillis = json['objectiveCompleteTimeMillis'];
  }
}

class DefendBombSite {
  bool success = false;
  int idleTimeMillis = 0;
  int objectiveCompleteTimeMillis = 0;

  DefendBombSite();

  factory DefendBombSite.fromJson(Map<String, dynamic> json) {
    return DefendBombSite()
      ..success = json['success']
      ..idleTimeMillis = json['idleTimeMillis']
      ..objectiveCompleteTimeMillis = json['objectiveCompleteTimeMillis'];
  }
}

class SettingStatus {
  bool isMouseSensitivityDefault = false;
  bool isCrosshairDefault = false;

  SettingStatus();

  factory SettingStatus.fromJson(Map<String, dynamic> json) {
    return SettingStatus()
      ..isMouseSensitivityDefault = json['isMouseSensitivityDefault']
      ..isCrosshairDefault = json['isCrosshairDefault'];
  }
}

class Coach {
  String subject = '';
  String teamId = '';

  Coach();

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach()
      ..subject = json['subject']
      ..teamId = json['teamId'];
  }
}

class Team {
  String teamId = '';
  bool won = false;
  int roundsPlayed = 0;
  int roundsWon = 0;
  int numPoints = 0;

  Team();

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team()
      ..teamId = json['teamId']
      ..won = json['won']
      ..roundsPlayed = json['roundsPlayed']
      ..roundsWon = json['roundsWon']
      ..numPoints = json['numPoints'];
  }
}

class RoundResult {
  int roundNum = 0;
  String roundResult = '';
  String roundCeremony = '';
  String winningTeam = '';
  String bombPlanter = '';
  String bombDefuser = '';
  int plantRoundTime = 0;
  List<PlayerLocation> plantPlayerLocations = [];
  Location plantLocation = Location();
  String plantSite = '';
  int defuseRoundTime = 0;
  List<PlayerLocation> defusePlayerLocations = [];
  Location defuseLocation = Location();
  List<PlayerStat> playerStats = [];
  String roundResultCode = '';
  List<PlayerEconomy> playerEconomies = [];
  List<PlayerScore> playerScores = [];

  RoundResult();

  factory RoundResult.fromJson(Map<String, dynamic> json) {
    return RoundResult()
      ..roundNum = json['roundNum']
      ..roundResult = json['roundResult']
      ..roundCeremony = json['roundCeremony']
      ..winningTeam = json['winningTeam']
      ..bombPlanter = json['bombPlanter']
      ..bombDefuser = json['bombDefuser']
      ..plantRoundTime = json['plantRoundTime']
      ..plantPlayerLocations = (json['plantPlayerLocations'] as List)
          .map((i) => PlayerLocation.fromJson(i))
          .toList()
      ..plantLocation = Location.fromJson(json['plantLocation'])
      ..plantSite = json['plantSite']
      ..defuseRoundTime = json['defuseRoundTime']
      ..defusePlayerLocations = (json['defusePlayerLocations'] as List)
          .map((i) => PlayerLocation.fromJson(i))
          .toList()
      ..defuseLocation = Location.fromJson(json['defuseLocation'])
      ..playerStats = (json['playerStats'] as List)
          .map((i) => PlayerStat.fromJson(i))
          .toList()
      ..roundResultCode = json['roundResultCode']
      ..playerEconomies = (json['playerEconomies'] as List)
          .map((i) => PlayerEconomy.fromJson(i))
          .toList()
      ..playerScores = (json['playerScores'] as List)
          .map((i) => PlayerScore.fromJson(i))
          .toList();
  }
}

class PlayerLocation {
  String subject = '';
  double viewRadians = 0.0;
  Location location = Location();

  PlayerLocation();

  factory PlayerLocation.fromJson(Map<String, dynamic> json) {
    return PlayerLocation()
      ..subject = json['subject']
      ..viewRadians = json['viewRadians']
      ..location = Location.fromJson(json['location']);
  }
}

class Location {
  int x = 0;
  int y = 0;

  Location();

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location()
      ..x = json['x']
      ..y = json['y'];
  }
}

class PlayerStat {
  String subject = '';
  List<Kill> kills = [];
  List<Damage> damage = [];
  int score = 0;
  Economy economy = Economy();
  Ability ability = Ability();
  bool wasAfk = false;
  bool wasPenalized = false;
  bool stayedInSpawn = false;

  PlayerStat();

  factory PlayerStat.fromJson(Map<String, dynamic> json) {
    return PlayerStat()
      ..subject = json['subject']
      ..kills = (json['kills'] as List).map((i) => Kill.fromJson(i)).toList()
      ..damage =
          (json['damage'] as List).map((i) => Damage.fromJson(i)).toList()
      ..score = json['score']
      ..economy = Economy.fromJson(json['economy'])
      ..ability = Ability.fromJson(json['ability'])
      ..wasAfk = json['wasAfk']
      ..wasPenalized = json['wasPenalized']
      ..stayedInSpawn = json['stayedInSpawn'];
  }
}

class Kill {
  int gameTime = 0;
  int roundTime = 0;
  String killer = '';
  String victim = '';
  Location victimLocation = Location();
  List<String> assistants = [];
  List<PlayerLocation> playerLocations = [];
  FinishingDamage finishingDamage = FinishingDamage();
  int round = 0;

  Kill();

  factory Kill.fromJson(Map<String, dynamic> json) {
    return Kill()
      ..gameTime = json['gameTime']
      ..roundTime = json['roundTime']
      ..killer = json['killer']
      ..victim = json['victim']
      ..victimLocation = Location.fromJson(json['victimLocation'])
      ..assistants =
          (json['assistants'] as List).map((i) => i as String).toList()
      ..playerLocations = (json['playerLocations'] as List)
          .map((i) => PlayerLocation.fromJson(i))
          .toList()
      ..finishingDamage = FinishingDamage.fromJson(json['finishingDamage'])
      ..round = json['round'];
  }
}

class Damage {
  String receiver = '';
  int damage = 0;
  int legshots = 0;
  int bodyshots = 0;
  int headshots = 0;

  Damage();

  factory Damage.fromJson(Map<String, dynamic> json) {
    return Damage()
      ..receiver = json['receiver']
      ..damage = json['damage']
      ..legshots = json['legshots']
      ..bodyshots = json['bodyshots']
      ..headshots = json['headshots'];
  }
}

class Economy {
  int loadoutValue = 0;
  String weapon = '';
  String armor = '';
  int remaining = 0;
  int spent = 0;

  Economy();

  factory Economy.fromJson(Map<String, dynamic> json) {
    return Economy()
      ..loadoutValue = json['loadoutValue']
      ..weapon = json['weapon']
      ..armor = json['armor']
      ..remaining = json['remaining']
      ..spent = json['spent'];
  }
}

class FinishingDamage {
  String damageType = '';
  String damageItem = '';
  bool isSecondaryFireMode = false;

  FinishingDamage();

  factory FinishingDamage.fromJson(Map<String, dynamic> json) {
    return FinishingDamage()
      ..damageType = json['damageType']
      ..damageItem = json['damageItem']
      ..isSecondaryFireMode = json['isSecondaryFireMode'];
  }
}

class PlayerEconomy {
  String subject = '';
  int loadoutValue = 0;
  String weapon = '';
  String armor = '';
  int remaining = 0;
  int spent = 0;

  PlayerEconomy();

  factory PlayerEconomy.fromJson(Map<String, dynamic> json) {
    return PlayerEconomy()
      ..subject = json['subject']
      ..loadoutValue = json['loadoutValue']
      ..weapon = json['weapon']
      ..armor = json['armor']
      ..remaining = json['remaining']
      ..spent = json['spent'];
  }
}

class PlayerScore {
  String subject = '';
  int score = 0;

  PlayerScore();

  factory PlayerScore.fromJson(Map<String, dynamic> json) {
    return PlayerScore()
      ..subject = json['subject']
      ..score = json['score'];
  }
}
