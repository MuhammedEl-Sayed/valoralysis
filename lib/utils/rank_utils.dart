import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/match_details.dart';

class RankUtils {
// Singular version
  static ContentItem getPlayerRank(
      MatchDto matchDetail, List<ContentItem> ranks, String puuid) {
    ContentItem fallbackRank = ranks.firstWhere((rank) => rank.uuid == '0');
    int compTier = matchDetail.players
        .firstWhere((player) => player.puuid == puuid,
            orElse: () => PlayerDto.empty())
        .competitiveTier;
    return ranks.firstWhere(
      (rank) => int.parse(rank.uuid) == compTier,
      orElse: () => fallbackRank,
    );
  }
}
