import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/agent_utils.dart';
import 'package:valoralysis/utils/formatting.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/utils/map_utils.dart';
import 'package:valoralysis/utils/time.dart';
import 'package:valoralysis/widgets/ui/agent_tag/agent_icon.dart';

class HistoryTile extends StatefulWidget {
  final Map<String, dynamic> matchDetails;

  const HistoryTile({Key? key, required this.matchDetails}) : super(key: key);

  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    String puuid = userProvider.user.puuid;
    bool didWin = HistoryUtils.didTeamWinByPUUID(widget.matchDetails, puuid);
    Widget roundsWon =
        FormattingUtils.convertTeamWinMapToString(widget.matchDetails, puuid);
    return Consumer2<UserProvider, ContentProvider>(
        builder: (context, userProvider, contentProvider, child) {
      return Container(
        height: 65,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Stack(
          children: [
            Container(
              height: 65,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0, 0.6],
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
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      AgentIcon(
                        iconUrl: HistoryUtils.getContentImageFromId(
                            AgentUtils.extractAgentIconByPUUID(
                                widget.matchDetails, puuid),
                            contentProvider.agents),
                        small: true,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 2)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            MapUtils.getMapNameFromPath(
                                    MapUtils.extractMapPath(
                                        widget.matchDetails),
                                    contentProvider.maps) ??
                                '',
                            style: const TextStyle(
                                color: Color(0xffffffff), fontSize: 17),
                          ),
                          Text(
                              TimeUtils.timeAgo(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      HistoryUtils.extractStartTime(
                                          widget.matchDetails))),
                              style: Theme.of(context).textTheme.labelMedium)
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: roundsWon,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: roundsWon,
                  ),
                ),
                // Stack widget with gradient color
              ],
            ),
          ],
        ),
      );
    });
  }
}
