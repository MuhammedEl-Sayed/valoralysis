import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/player_stats.dart';
import 'package:valoralysis/utils/history_utils.dart';

class WeaponsAnalysis {
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
      List<Map<String, dynamic>> matches,
      String puuid,
      List<WeaponItem> weapnList) async {
    List<dynamic> playerKills = getPlayerStats(matches, puuid, 'kills');

    Map<String, int> weaponFrequency = {};
    for (Map<String, dynamic> kill in playerKills) {
      if (kill['finishingDamage']['damageType'] == 'Weapon' &&
          kill['finishingDamage']['damageItem'].isNotEmpty) {
        String weaponInKill =
            kill['finishingDamage']['damageItem'].toString().toLowerCase();
        String? weapon =
            weapnList.firstWhere((weapon) => weapon.puuid == weaponInKill).name;

        weaponFrequency[weapon] = (weaponFrequency[weapon] ?? 0) + 1;
      }
    }
    return weaponFrequency;
  }

  static Map<String, double> getKDAPerWeapon(
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
    Map<String, double> kdaPerWeapon = {};
    for (WeaponItem weapon in weapons) {
      double kda = 0;
      kda += finishingDamage
          .where((damage) => damage['damageItem'] == weapon.puuid)
          .toList()
          .length;
    }
    return {};
  }
}
