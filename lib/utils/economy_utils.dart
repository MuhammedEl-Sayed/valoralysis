enum BuyType { fullBuy, forceBuy, halfBuy, eco, unknown }

class EconomyUtils {
  static int fullBuyValue = 3900;
  /*
  * 1. Full Buy. Simple, check for the full buy value and return the result.
  * 2. Force Buy.  Check if we spent under 3900 and cant buy next round.
  * 3. Half Buy. Check if we spent under 3900 and can still buy next round.
  * 4. Eco. Check if we spent under 2000 and can still buy next round.

  * Therefore, we should take:
  1. user's own spent money
  2. user's team spent money
  3. user's total money*/

  static BuyType getBuyType(
    int userSpentMoney,
    int userTotalMoney,
    int userTeamSpentMoney,
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
}
