import 'dart:math';

import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/match_details.dart';

class WeaponsUtils {
  static Map<String, double> weaponsHeadshotAccuracyAnaylsis(
      List<MatchDto> matchDetails, String puuid) {
    List<DamageDto> playerDamage = [];
    for (MatchDto matchDetails in matchDetails) {
      for (RoundResultDto round in matchDetails.roundResults) {
        for (PlayerRoundStatsDto playerStat in round.playerStats) {
          //define statkey as a key of playerStat
          if (playerStat.puuid == puuid) {
            playerDamage.addAll(playerStat.damage);
          }
        }
      }
    }
    double totalHeadshots = 0;
    double totalBodyshots = 0;
    double totalLegshots = 0;

    for (DamageDto pd in playerDamage) {
      if (!pd.headshots.isNaN && pd.headshots > 0) {
        totalHeadshots += pd.headshots;
      }

      if (!pd.bodyshots.isNaN && pd.headshots > 0) {
        totalBodyshots += pd.bodyshots;
      }

      if (!pd.legshots.isNaN && pd.headshots > 0) {
        totalLegshots += pd.legshots;
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
    List<FinishingDamageDto> playerDamage = [];
    for (MatchDto matchDetails in matchDetails) {
      for (RoundResultDto round in matchDetails.roundResults) {
        for (PlayerRoundStatsDto playerStat in round.playerStats) {
          //define statkey as a key of playerStat
          if (playerStat.puuid == puuid) {
            playerDamage.addAll(playerStat.kills.map((e) => e.finishingDamage));
          }
        }
      }
    }
    Map<String, double> kdPerWeapon = {};
    for (ContentItem weapon in weapons) {
      double kd = 0;
      kd += playerDamage
          .where((damage) => damage.damageItem == weapon.uuid)
          .toList()
          .length;
    }
    return {};
  }
}
