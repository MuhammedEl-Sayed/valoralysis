class RankIcons {
  String smallIcon;
  String largeIcon;
  RankIcons({required this.smallIcon, required this.largeIcon});
}

class Rank {
  int tier;
  String tierName;
  RankIcons rankIcons;
  Rank({required this.tier, required this.tierName, required this.rankIcons});
  factory Rank.fromJson(dynamic tier) {
    return Rank(
        tier: tier['tier'] as int,
        tierName: tier['tierName'] as String,
        rankIcons: RankIcons(
            smallIcon: tier['smallIcon'], largeIcon: tier['largeIcon']));
  }
}
