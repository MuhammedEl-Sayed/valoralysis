import 'package:flutter/material.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/utils/history_utils.dart';

enum BuyType { fullBuy, forceBuy, halfBuy, eco, unknown }

Map lossStreakMap = {
  0: 1900,
  1: 2400,
  2: 2900,
};

class EconomyUtils {
  static int fullBuyValue = 3900;
  /*
  * 1. Full Buy. Simple, check for the full buy value and return the result.
  * 2. Force Buy.  Check if we spent under 3900 and cant buy next round.
  * 3. Half Buy. Check if we spent under 3900 and can still buy next round.
  * 4. Eco. Check if we spent under 2000 and can still buy next round.

  * Therefore, we should take:
  * 1. user's own spent money

  * 2. user's total money
  */
  static Widget getBuyIconFromRound(
      MatchDto matchDto, String puuid, int roundIndex) {
    BuyType buyType = getBuyTypeFromRound(matchDto, puuid, roundIndex);
    return getBuyIconFromType(buyType);
  }

  static Widget getBuyIconFromType(BuyType buyType) {
    switch (buyType) {
      case BuyType.fullBuy:
        //use full_buy.svg in assets/images/misc
        return Image.asset('assets/images/misc/full_buy.svg');
      case BuyType.forceBuy:
        //For this one use same path but credits.svg
        return Image.asset('assets/images/misc/credits.svg');
      case BuyType.halfBuy:
        //return a donut made without image with a hole in the middle
        return Stack(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ],
        );
      case BuyType.eco:
        //just the inner circle
        return Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        );
      default:
        return Container();
    }
  }

  static BuyType getBuyTypeFromMoney(
    int userSpentMoney,
    int userTotalMoney,
  ) {
    if (userSpentMoney >= fullBuyValue) {
      return BuyType.fullBuy;
    } else if (userSpentMoney < fullBuyValue && userTotalMoney < fullBuyValue) {
      return BuyType.forceBuy;
    } else if (userSpentMoney < fullBuyValue &&
        userTotalMoney >= fullBuyValue) {
      return BuyType.halfBuy;
    } else if (userSpentMoney < 2000) {
      return BuyType.eco;
    } else {
      return BuyType.unknown;
    }
  }

  static int getLossStreakMoney(
      MatchDto matchDto, String puuid, int roundIndex) {
    int numLosses = 0;
    int currIndex = roundIndex;
    for (int i = 1; i < 4; i++) {
      // This modulus needs to change per game mode
      if (currIndex == 0 || currIndex % 13 == 0) break;
      currIndex--;
      if (HistoryUtils.didPlayerWinRound(matchDto, puuid, currIndex)) {
        numLosses++;
      }
    }
    return lossStreakMap[numLosses];
  }

  static BuyType getBuyTypeFromRound(
      MatchDto matchDto, String puuid, int roundIndex) {
    int userSpentMoney = 0;

    int userFutureMoney = getLossStreakMoney(matchDto, puuid, roundIndex) +
        matchDto.roundResults[roundIndex - 1].playerStats
            .firstWhere((element) => element.puuid == puuid)
            .economy
            .remaining;
    RoundResultDto roundDto = matchDto.roundResults[roundIndex - 1];
    userSpentMoney = roundDto.playerStats
        .firstWhere((element) => element.puuid == puuid)
        .economy
        .spent;

    return getBuyTypeFromMoney(userSpentMoney, userFutureMoney);
  }
}
