import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/models/player_round_stats.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/utils/round_utils.dart';

class RoundKillFeed extends StatelessWidget {
  final String puuid;
  final List<KillDto> kills;
  final List<KillDto> deaths;
  final int roundNumber;
  final Map<String, dynamic> matchDetail;
  const RoundKillFeed(
      {Key? key,
      required this.puuid,
      required this.kills,
      required this.deaths,
      required this.roundNumber,
      required this.matchDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //So what I need to get back is
    // 1. list ordered by timeSinceRoundStartMillis
    // 2. player agent icon + player name  red/green gun icon + enemy name + enemy agent icon
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: false);
    return RoundUtils.buildRoundKillFeed(
    return RoundUtils.buildRoundKillFeed(puuid, kills, deaths, matchDetail,
        contentProvider.weapons, contentProvider.agents);
  }
}
