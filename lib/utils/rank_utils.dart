import 'package:valoralysis/models/rank.dart';

class RankUtils {
  static Rank getPlayerRank(
      List<Map<String, dynamic>> matches, List<Rank> ranks, String puuid) {
    return ranks.firstWhere((rank) =>
        rank.tier ==
        matches
            .firstWhere(
                (match) => match['matchInfo']['isRanked'] == true)['players']
            .firstWhere(
                (player) => player['puuid'] == puuid)['competitiveTier']);
  }
}
