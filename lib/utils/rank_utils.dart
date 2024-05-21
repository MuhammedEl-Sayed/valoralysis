import 'package:valoralysis/models/content.dart';

class RankUtils {
// Singular version
  static ContentItem getPlayerRank(
      Map<String, dynamic> match, List<ContentItem> ranks, String puuid) {
    print('ranks: $ranks');
    ContentItem fallbackRank = ranks.firstWhere((rank) => rank.uuid == '0');
    int compTier = match['players'].firstWhere(
        (player) => player['puuid'] == puuid,
        orElse: () => {"competitiveTier": 0})['competitiveTier'];
    print(compTier);
    return ranks.firstWhere(
      (rank) => int.parse(rank.uuid) == compTier,
      orElse: () => fallbackRank,
    );
  }
}
