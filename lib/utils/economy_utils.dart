import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/utils/history_utils.dart';

enum BuyType { fullBuy, halfBuy, forceBuy, eco, bonus, unknown }

Map lossStreakMap = {
  0: 0,
  1: 1900,
  2: 2400,
  3: 2900,
};

Map buyTypeToStringMap = {
  BuyType.fullBuy: 'Full Buy',
  BuyType.forceBuy: 'Force Buy',
  BuyType.halfBuy: 'Half Buy',
  BuyType.eco: 'Eco',
  BuyType.bonus: 'Bonus',
  BuyType.unknown: 'Unknown',
};

class EconomyUtils {
  static int fullBuyValue = 3900;

  static int? getEconScoreFromRound(
      MatchDto matchDto, String puuid, int roundIndex) {
    try {
      List<DamageDto> damageDealtList =
          HistoryUtils.extractPlayerDamagePerRound(matchDto, puuid, roundIndex);
      if (damageDealtList.isEmpty) {
        return null;
      }
      int damageDealt = damageDealtList
          .map((e) => e.damage)
          .reduce((value, element) => value + element);
      if (damageDealt == 0) {
        return null;
      }
      int creditsSpent = getUserSpentMoney(matchDto, puuid, roundIndex);
      print(
          'Damage dealt: $damageDealt, Credits spent: $creditsSpent, Econ score: ${damageDealt ~/ (creditsSpent / 1000)}');
      print(
          'damageDealt ~/ (creditsSpent / 1000) = ${damageDealt ~/ (creditsSpent / 1000)}');
      return damageDealt ~/ (creditsSpent / 1000);
    } catch (e) {
      print('Failed to get econ score from round');
      return null;
    }
  }

  static Widget getBuyIconFromRound(
      MatchDto matchDto, String puuid, int roundIndex) {
    BuyType buyType = getBuyTypeFromRound(matchDto, puuid, roundIndex);
    return getBuyIconFromType(buyType);
  }

  static Widget getBuyIconFromMoney(
      int userSpentMoney, int userFutureMoney, int userLoadoutValue) {
    BuyType buyType =
        getBuyTypeFromMoney(userSpentMoney, userFutureMoney, userLoadoutValue);
    return getBuyIconFromType(buyType);
  }

  static Widget getBuyIconFromType(BuyType buyType) {
    switch (buyType) {
      case BuyType.fullBuy:
        // Use full_buy.svg in assets/images/misc use flutter_svg to render
        return SizedBox(
          width: 20, // Smaller size
          height: 20, // Smaller size
          child: SvgPicture.asset(
            'assets/images/misc/full_buy.svg',
            color: const Color(0xFFFFEDEA), // Attempt to set color
          ),
        );
      case BuyType.halfBuy:
        // For this one use same path but credits.svg
        return SizedBox(
          width: 20, // Smaller size
          height: 20, // Smaller size
          child: SvgPicture.asset(
            'assets/images/misc/credits.svg',
            color: const Color(0xFFFFEDEA), // Attempt to set color
          ),
        );
      case BuyType.forceBuy:
        // Return a donut with a hole in the middle
        return const Icon(
          Icons.trip_origin,
          color: Color(0xFFFFEDEA),
          size: 20,
        );
      case BuyType.eco:
        // Just the inner circle
        return Container(
          width: 10, // Smaller size
          height: 10, // Smaller size
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFFEDEA), // Main color
          ),
        );
      //have bonus just be built in icon star
      case BuyType.bonus:
        return const Icon(
          Icons.star,
          color: Color(0xFFFFEDEA),
          size: 20,
        );
      default:
        return Container();
    }
  }

  static BuyType getBuyTypeFromMoney(
      int userSpentMoney, int userFutureMoney, int userLoadoutValue) {
    //Trying to see if we save (you can buy sheriff round 1 and bonus round 2), but also if you have a full loadout
    if ((userLoadoutValue > 1000 && userSpentMoney < 1000) ||
        (userLoadoutValue >= 3900 && userSpentMoney < 3900)) {
      return BuyType.bonus;
    } else if (userSpentMoney >= fullBuyValue) {
      return BuyType.fullBuy;
      // Checking if:
      // 1. User has not spent less than full buy value
      // 2. User will not have enough money for full buy next round
      // 3. User has a loadout value of at least 1500
    } else if (userSpentMoney < fullBuyValue &&
        userFutureMoney < fullBuyValue &&
        userLoadoutValue < fullBuyValue &&
        userLoadoutValue >= 1500) {
      return BuyType.forceBuy;
      // Checking if:
      // 1. User has not spent less than full buy value
      // 2. User will have enough money for full buy next round
      // 3. User has a loadout value of at least 1500
    } else if (userSpentMoney < fullBuyValue &&
        userFutureMoney >= fullBuyValue &&
        userLoadoutValue < fullBuyValue &&
        userLoadoutValue >= 1500) {
      return BuyType.halfBuy;
    } else if (userSpentMoney < 2000 && userLoadoutValue < 2000) {
      return BuyType.eco;
    } else {
      print('Failed to determine buy type ');
      return BuyType.unknown;
    }
  }

  static int getLossStreakMoney(
      MatchDto matchDto, String puuid, int roundIndex) {
    if (HistoryUtils.didPlayerWinRound(matchDto, puuid, roundIndex)) {
      return 3000;
    } else if (!HistoryUtils.didPlayerDieInRound(matchDto, puuid, roundIndex)) {
      return 1000;
    }
    int numLosses = 0;
    int currIndex = roundIndex;

    for (int i = 1; i <= 4; i++) {
      // This modulus needs to change per game mode
      if (currIndex == 0 || currIndex == 12 || numLosses == 3) {
        break;
      }
      currIndex--;
      if (!HistoryUtils.didPlayerWinRound(matchDto, puuid, currIndex)) {
        numLosses++;
      } else {
        break;
      }
    }
    return lossStreakMap[numLosses];
  }

  static int getUserLoadoutValue(
      MatchDto matchDto, String puuid, int roundIndex) {
    return matchDto.roundResults[roundIndex].playerStats
        .firstWhere((element) => element.puuid == puuid)
        .economy
        .loadoutValue;
  }

  static int getUserSpentMoney(
      MatchDto matchDto, String puuid, int roundIndex) {
    return matchDto.roundResults[roundIndex].playerStats
        .firstWhere((element) => element.puuid == puuid)
        .economy
        .spent;
  }

  static int getUserRemainingMoney(
      MatchDto matchDto, String puuid, int roundIndex) {
    return matchDto.roundResults[roundIndex].playerStats
        .firstWhere((element) => element.puuid == puuid)
        .economy
        .remaining;
  }
// Add these methods inside the same class that contains getBuyTypeFromRound

  static int getUserFutureMoney(
      MatchDto matchDto, String puuid, int roundIndex) {
    return getLossStreakMoney(matchDto, puuid, roundIndex) +
        getUserRemainingMoney(matchDto, puuid, roundIndex);
  }

  static getTeamSpentMoney(MatchDto matchDto, String puuid, int roundIndex) {
    List<String> teamPUUIDs =
        HistoryUtils.extractPlayerTeamPUUIDs(matchDto, puuid);
    //average the spent money of the team
    return teamPUUIDs
            .map((teamPUUID) =>
                getUserSpentMoney(matchDto, teamPUUID, roundIndex))
            .reduce((value, element) => value + element) ~/
        teamPUUIDs.length;
  }

  static getTeamLoadoutValue(MatchDto matchDto, String puuid, int roundIndex) {
    List<String> teamPUUIDs =
        HistoryUtils.extractPlayerTeamPUUIDs(matchDto, puuid);
    //average the loadout value of the team
    return teamPUUIDs
            .map((teamPUUID) =>
                getUserLoadoutValue(matchDto, teamPUUID, roundIndex))
            .reduce((value, element) => value + element) ~/
        teamPUUIDs.length;
  }

  static getTeamRemainingMoney(
      MatchDto matchDto, String puuid, int roundIndex) {
    List<String> teamPUUIDs =
        HistoryUtils.extractPlayerTeamPUUIDs(matchDto, puuid);
    //average the remaining money of the team
    return teamPUUIDs
            .map((teamPUUID) =>
                getUserRemainingMoney(matchDto, teamPUUID, roundIndex))
            .reduce((value, element) => value + element) ~/
        teamPUUIDs.length;
  }

  static getTeamFutureMoney(MatchDto matchDto, String puuid, int roundIndex) {
    List<String> teamPUUIDs =
        HistoryUtils.extractPlayerTeamPUUIDs(matchDto, puuid);
    //average the future money of the team
    return teamPUUIDs
            .map((teamPUUID) =>
                getUserFutureMoney(matchDto, teamPUUID, roundIndex))
            .reduce((value, element) => value + element) ~/
        teamPUUIDs.length;
  }

  static getTeamBuyTypeFromRound(
      MatchDto matchDto, String puuid, int roundIndex) {
    int teamSpentMoney = getTeamSpentMoney(matchDto, puuid, roundIndex);
    int teamFutureMoney = getTeamFutureMoney(matchDto, puuid, roundIndex);
    int teamLoadoutValue = getTeamLoadoutValue(matchDto, puuid, roundIndex);

    return getBuyTypeFromMoney(
        teamSpentMoney, teamFutureMoney, teamLoadoutValue);
  }

  static getEnemySpentMoney(MatchDto matchDto, String puuid, int roundIndex) {
    List<String> enemyPUUIDs =
        HistoryUtils.extractEnemyTeamPUUIDs(matchDto, puuid);
    //average the spent money of the enemy
    return enemyPUUIDs
            .map((enemyPUUID) =>
                getUserSpentMoney(matchDto, enemyPUUID, roundIndex))
            .reduce((value, element) => value + element) ~/
        enemyPUUIDs.length;
  }

  static getEnemyLoadoutValue(MatchDto matchDto, String puuid, int roundIndex) {
    List<String> enemyPUUIDs =
        HistoryUtils.extractEnemyTeamPUUIDs(matchDto, puuid);
    //average the loadout value of the enemy
    return enemyPUUIDs
            .map((enemyPUUID) =>
                getUserLoadoutValue(matchDto, enemyPUUID, roundIndex))
            .reduce((value, element) => value + element) ~/
        enemyPUUIDs.length;
  }

  static getEnemyRemainingMoney(
      MatchDto matchDto, String puuid, int roundIndex) {
    List<String> enemyPUUIDs =
        HistoryUtils.extractEnemyTeamPUUIDs(matchDto, puuid);
    //average the remaining money of the enemy
    return enemyPUUIDs
            .map((enemyPUUID) =>
                getUserRemainingMoney(matchDto, enemyPUUID, roundIndex))
            .reduce((value, element) => value + element) ~/
        enemyPUUIDs.length;
  }

  static getEnemyFutureMoney(MatchDto matchDto, String puuid, int roundIndex) {
    List<String> enemyPUUIDs =
        HistoryUtils.extractEnemyTeamPUUIDs(matchDto, puuid);
    //average the future money of the enemy
    return enemyPUUIDs
            .map((enemyPUUID) =>
                getUserFutureMoney(matchDto, enemyPUUID, roundIndex))
            .reduce((value, element) => value + element) ~/
        enemyPUUIDs.length;
  }

  static getEnemyBuyTypeFromRound(
      MatchDto matchDto, String puuid, int roundIndex) {
    int enemySpentMoney = getEnemySpentMoney(matchDto, puuid, roundIndex);
    int enemyFutureMoney = getEnemyFutureMoney(matchDto, puuid, roundIndex);
    int enemyLoadoutValue = getEnemyLoadoutValue(matchDto, puuid, roundIndex);

    return getBuyTypeFromMoney(
        enemySpentMoney, enemyFutureMoney, enemyLoadoutValue);
  }

// Refactor getBuyTypeFromRound to use the new methods
  static BuyType getBuyTypeFromRound(
      MatchDto matchDto, String puuid, int roundIndex) {
    int userSpentMoney = getUserSpentMoney(matchDto, puuid, roundIndex);
    int userFutureMoney = getUserFutureMoney(matchDto, puuid, roundIndex);
    int userLoadoutValue = getUserLoadoutValue(matchDto, puuid, roundIndex);

    // Handle first round of half cases
    if (roundIndex == 0 || roundIndex == 12) {
      if (userSpentMoney == 800) {
        return BuyType.fullBuy;
      }
      if (userSpentMoney >= 450 && userSpentMoney < 800) {
        return BuyType.forceBuy;
      }
      return BuyType.eco;
    }

    return getBuyTypeFromMoney(
        userSpentMoney, userFutureMoney, userLoadoutValue);
  }
}
