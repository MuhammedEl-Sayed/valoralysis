import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/consts/margins.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/models/player_stats.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/agent_utils.dart';
import 'package:valoralysis/utils/formatting_utils.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/utils/map_utils.dart';
import 'package:valoralysis/utils/time.dart';
import 'package:valoralysis/widgets/ui/agent_tag/agent_icon.dart';
import 'package:valoralysis/widgets/ui/history_list/expanded_history/expanded_history.dart';

class HistoryTile extends StatefulWidget {
  final MatchDto matchDetail;
  final bool fake;
  const HistoryTile({Key? key, required this.matchDetail, this.fake = false})
      : super(key: key);

  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    String puuid = userProvider.user.puuid;
    bool didWin;
    Widget roundsWon;
    Widget content;
    PlayerStats playerStats;

    if (widget.fake) {
      didWin = true;
      roundsWon = const SizedBox.shrink();
      content = const SizedBox.shrink();
    } else {
      didWin = HistoryUtils.didTeamWinByPUUID(widget.matchDetail, puuid);
      roundsWon =
          FormattingUtils.convertTeamWinMapToString(widget.matchDetail, puuid);
      playerStats = HistoryUtils.extractPlayerStat(
          widget.matchDetail, userProvider.user.puuid);
      content = Consumer<ContentProvider>(
        builder: (context, contentProvider, child) {
          return Row(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    AgentIcon(
                        iconUrl: HistoryUtils.getContentImageFromId(
                            AgentUtils.extractAgentIdByPUUID(
                                widget.matchDetail, puuid),
                            contentProvider.agents),
                        width: 45,
                        height: 45),
                    const Padding(padding: EdgeInsets.only(top: 2, left: 5)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            MapUtils.getMapNameFromPath(
                                    MapUtils.extractMapPath(widget.matchDetail),
                                    contentProvider.maps) ??
                                '',
                            style: Theme.of(context).textTheme.titleMedium),
                        Text(
                            TimeUtils.timeAgo(HistoryUtils.extractStartTime(
                                widget.matchDetail)),
                            style: Theme.of(context).textTheme.labelMedium)
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(children: [
                  const Spacer(),
                  roundsWon,
                  const Spacer(),
                ]),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('K/D/A', style: Theme.of(context).textTheme.labelMedium),
                  Text(
                      '${playerStats.kills}/${playerStats.deaths}/${playerStats.assists}',
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              Expanded(
                child: Row(children: [
                  const Spacer(),
                  Center(
                    child: IconButton(
                      icon: Icon(!opened
                          ? Icons.arrow_drop_down
                          : Icons.arrow_drop_up),
                      onPressed: () => setState(() {
                        opened = !opened;
                      }),
                    ),
                  )
                ]),
              ),
            ],
          );
        },
      );
    }

    double margin = getStandardMargins(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      child: Column(children: [
        GestureDetector(
          onTap: () {
            setState(() {
              opened = !opened;
            });
          },
          child: Container(
            margin: EdgeInsets.only(left: margin, right: margin),
            height: 65,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: opened
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5))
                    : const BorderRadius.all(Radius.circular(5)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ]),
            child: Stack(
              children: [
                Container(
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0, 0.6],
                      colors: <Color>[
                        didWin
                            ? const Color(0xff2BD900).withOpacity(0.3)
                            : const Color(0xff730000)
                                .withOpacity(0.3), // green color
                        Theme.of(context)
                            .canvasColor
                            .withOpacity(0) // transparent color
                      ],
                    ),
                    borderRadius: opened
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5))
                        : const BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                content,
              ],
            ),
          ),
        ),
        !widget.fake
            ? ExpandedHistory(
                matchDetail: widget.matchDetail,
                opened: opened,
                puuid: userProvider.user.puuid,
              )
            : const SizedBox.shrink()
      ]),
    );
  }
}
