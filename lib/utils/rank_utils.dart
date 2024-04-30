import 'package:valoralysis/models/rank.dart';

class RankUtils {
// Singular version
  static Rank getPlayerRank(
      Map<String, dynamic> match, List<Rank> ranks, String puuid) {
    Rank fallbackRank = ranks.firstWhere((rank) => rank.tier == 0);
    int compTier = match['players'].firstWhere(
        (player) => player['puuid'] == puuid,
        orElse: () => {"competitiveTier": 0})['competitiveTier'];
    return ranks.firstWhere(
      (rank) => rank.tier == compTier,
      orElse: () => fallbackRank,
    );
  }
}
