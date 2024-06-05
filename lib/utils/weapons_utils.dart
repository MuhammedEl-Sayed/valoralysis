import 'dart:math';

import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/match_details.dart';

class WeaponsUtils {
  static List<dynamic> getPlayerStats(
      List<MatchDto> matches, String puuid, String statKey) {
    List<dynamic> playerStats = [];
    for (MatchDto matchDetails in matches) {
      for (RoundResultDto round in matchDetails.roundResults) {
        for (PlayerRoundStatsDto playerStat in round.playerStats) {
          //define statkey as a key of playerStat
          if (playerStat.puuid == puuid && playerStat.containsKey(statKey)) {
            playerStats.addAll(playerStat[statKey]);
          }
        }
      }
    }
    return playerStats;
  }

  static Map<String, double> weaponsHeadshotAccuracyAnaylsis(
      List<MatchDto> matchDetails, String puuid) {
    List<dynamic> playerDamage = getPlayerStats(matchDetails, puuid, 'damage');

    double totalHeadshots = 0;
    double totalBodyshots = 0;
    double totalLegshots = 0;

    for (Map<String, dynamic> pd in playerDamage) {
      if (!pd['headshots'].isNaN) {
        totalHeadshots += pd['headshots'];
      }

      if (!pd['bodyshots'].isNaN) {
        totalBodyshots += pd['bodyshots'];
      }

      if (!pd['legshots'].isNaN) {
        totalLegshots += pd['legshots'];
      }
    }

    double total = totalHeadshots + totalBodyshots + totalLegshots;
    return {
      'Headshot': totalHeadshots / max(total, 1),
      'Bodyshot': totalBodyshots / max(total, 1),
      'Legshot': totalLegshots / max(total, 1)
    };
  }

  static Map<String, double> getKDPerWeapon(
      List<MatchDto> matchDetails, String puuid, List<ContentItem> weapons) {
    List<dynamic> playerKills = getPlayerStats(matchDetails, puuid, 'kills');
    List<dynamic> finishingDamage = [];
    for (dynamic kill in playerKills) {
      if (kill['finishingDamage']) {
        finishingDamage.add(kill['finishingDamage']);
      }
    }
    Map<String, double> kdPerWeapon = {};
    for (ContentItem weapon in weapons) {
      double kd = 0;
      kd += finishingDamage
          .where((damage) => damage['damageItem'] == weapon.uuid)
          .toList()
          .length;
    }
    return {};
  }
}
