import 'package:valoralysis/api/services/weapons_service.dart';

class WeaponsAnalysis {
  static Map<String, String>? weaponMap;

  static Future<Map<String, double>> weaponsHeadshotAccuracyAnaylsis(
      List<Map<String, dynamic>> matches, String puuid) async {
    weaponMap ??= await WeaponsService.fetchWeaponData();
    List<dynamic> playerDamage = [];
    //located in matches[x]['roundResults'][y]['playerStats'][z]['damage'] and each might be null
    for (Map<String, dynamic> matchDetails in matches) {
      if (matchDetails['roundResults'] != null) {
        for (Map<String, dynamic> round in matchDetails['roundResults']) {
          if (round['playerStats'] != null) {
            for (Map<String, dynamic> playerStat in round['playerStats']) {
              if (playerStat['subject'] == puuid &&
                  playerStat['damage'] != null) {
                playerDamage.addAll(playerStat['damage']);
              }
            }
          }
        }
      }
    }

    double totalHeadshots = 0;
    double totalBodyshots = 0;
    double totalLegshots = 0;

    for (Map<String, dynamic> pd in playerDamage) {
      totalHeadshots += pd['headshots'];
      totalBodyshots += pd['bodyshots'];
      totalLegshots += pd['legshots'];
    }

    double total = totalHeadshots + totalBodyshots + totalLegshots;
    return {
      'Headshot': totalHeadshots / total,
      'Bodyshot': totalBodyshots / total,
      'Legshot': totalLegshots / total
    };
  }

  static Future<Map<String, int>> weaponsKillsFrequencyAnalysis(
      List<Map<String, dynamic>> matches, String puuid) async {
    weaponMap ??= await WeaponsService.fetchWeaponData();

    List<dynamic> playerKills = [];
    for (Map<String, dynamic> matchDetails in matches) {
      if (matchDetails['roundResults'] != null) {
        for (Map<String, dynamic> round in matchDetails['roundResults']) {
          if (round['playerStats'] != null) {
            for (Map<String, dynamic> playerStat in round['playerStats']) {
              if (playerStat['subject'] == puuid &&
                  playerStat['kills'] != null) {
                playerKills.addAll(playerStat['kills']);
              }
            }
          }
        }
      }
    }
    Map<String, int> weaponFrequency = {};
    for (Map<String, dynamic> kill in playerKills) {
      if (kill['finishingDamage']['damageType'] == 'Weapon' &&
          kill['finishingDamage']['damageItem'].isNotEmpty) {
        String? weapon = weaponMap?[
            kill['finishingDamage']['damageItem'].toString().toLowerCase()];
        if (weapon != null) {
          weaponFrequency[weapon] = (weaponFrequency[weapon] ?? 0) + 1;
        }
      }
    }
    return weaponFrequency;
  }
}
