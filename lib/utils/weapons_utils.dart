import 'package:valoralysis/models/content.dart';
import 'dart:math';

class WeaponsUtils {
  static List<dynamic> getPlayerStats(
      List<Map<String, dynamic>> matches, String puuid, String statKey) {
    List<dynamic> playerStats = [];
    for (Map<String, dynamic> matchDetails in matches) {
      if (matchDetails['roundResults'] != null) {
        for (Map<String, dynamic> round in matchDetails['roundResults']) {
          if (round['playerStats'] != null) {
            for (Map<String, dynamic> playerStat in round['playerStats']) {
              if (playerStat['puuid'] == puuid && playerStat[statKey] != null) {
                playerStats.addAll(playerStat[statKey]);
              }
            }
          }
        }
      }
    }
    return playerStats;
  }

  static Map<String, double> weaponsHeadshotAccuracyAnaylsis(
      List<Map<String, dynamic>> matches, String puuid) {
    List<dynamic> playerDamage = getPlayerStats(matches, puuid, 'damage');

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
      List<Map<String, dynamic>> matchDetails,
      String puuid,
      List<WeaponItem> weapons) {
    List<dynamic> playerKills = getPlayerStats(matchDetails, puuid, 'kills');
    List<dynamic> finishingDamage = [];
    for (dynamic kill in playerKills) {
      if (kill['finishingDamage']) {
        finishingDamage.add(kill['finishingDamage']);
      }
    }
    Map<String, double> kdPerWeapon = {};
    for (WeaponItem weapon in weapons) {
      double kd = 0;
      kd += finishingDamage
          .where((damage) => damage['damageItem'] == weapon.puuid)
          .toList()
          .length;
    }
    return {};
  }
}
