import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/utils/round_utils.dart';

class RoundKillFeed extends StatefulWidget {
  final String puuid;
  final List<KillDto> kills;
  final List<KillDto> deaths;
  final int roundNumber;
  final MatchDto matchDetail;
  const RoundKillFeed(
      {Key? key,
      required this.puuid,
      required this.kills,
      required this.deaths,
      required this.roundNumber,
      required this.matchDetail})
      : super(key: key);

  @override
  _RoundKillFeedState createState() => _RoundKillFeedState();
}

class _RoundKillFeedState extends State<RoundKillFeed> {
  @override
  Widget build(BuildContext context) {
    //So what I need to get back is
    // 1. list ordered by timeSinceRoundStartMillis
    // 2. player agent icon + player name  red/green gun icon + enemy name + enemy agent icon
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: false);
    return RoundUtils.buildRoundKillFeed(
        context,
        widget.puuid,
        widget.kills,
        widget.deaths,
        widget.matchDetail,
        contentProvider.weapons,
        contentProvider.agents,
        widget.roundNumber);
  }
}
