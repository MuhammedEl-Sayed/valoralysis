import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/consts/margins.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/agent_utils.dart';
import 'package:valoralysis/utils/formatting_utils.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/utils/map_utils.dart';
import 'package:valoralysis/utils/time.dart';
import 'package:valoralysis/widgets/ui/agent_tag/agent_icon.dart';
import 'package:valoralysis/widgets/ui/category_selector/category_selector.dart';
import 'package:valoralysis/widgets/ui/expandable_section/expandable_section.dart';
import 'package:valoralysis/widgets/ui/history_list/round_history/round_history.dart';
import 'package:valoralysis/widgets/ui/team_details_table/team_details_table.dart';

class ExpandedHistory extends StatefulWidget {
  final bool opened;
  final Map<String, dynamic> matchDetail;
  final String puuid;

  const ExpandedHistory(
      {Key? key,
      required this.matchDetail,
      required this.opened,
      required this.puuid})
      : super(key: key);

  @override
  State<ExpandedHistory> createState() => _ExpandedHistoryState();
}

class _ExpandedHistoryState extends State<ExpandedHistory> {
  @override
  Widget build(BuildContext context) {
    double margin = getStandardMargins(context);

    return ExpandableSection(
      expanded: widget.opened,
      child: Container(
        margin: EdgeInsets.only(left: margin, right: margin),
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant),
        child: Column(
          children: [
            Divider(
              color: Theme.of(context).colorScheme.surfaceVariant,
              height: 1,
            ),
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                color: Theme.of(context).canvasColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      CategoryTypeSelector(),
                    ],
                  ),
                ],
              ),
            ),
            RoundHistory(puuid: widget.puuid, matchDetail: widget.matchDetail),
            TeamDetailsTable(
                puuid: widget.puuid,
                matchDetail: widget.matchDetail,
                isUserTeam: true),
            TeamDetailsTable(
                puuid: widget.puuid,
                matchDetail: widget.matchDetail,
                isUserTeam: false)
          ],
        ),
      ),
    );
  }
}

class HistoryTile extends StatefulWidget {
  final Map<String, dynamic> matchDetail;

  const HistoryTile({Key? key, required this.matchDetail}) : super(key: key);

  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    String puuid = userProvider.user.puuid;
    bool didWin = HistoryUtils.didTeamWinByPUUID(widget.matchDetail, puuid);
    Widget roundsWon =
        FormattingUtils.convertTeamWinMapToString(widget.matchDetail, puuid);
    return Consumer<ContentProvider>(
        builder: (context, contentProvider, child) {
      double margin = getStandardMargins(context);

      return Padding(
          padding: const EdgeInsets.only(bottom: 5, top: 5),
          child: Column(children: [
            Container(
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(1, 1), // changes position of shadow
                    ),
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
                  Row(
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
                              small: true,
                            ),
                            const Padding(
                                padding: EdgeInsets.only(top: 2, left: 5)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  MapUtils.getMapNameFromPath(
                                          MapUtils.extractMapPath(
                                              widget.matchDetail),
                                          contentProvider.maps) ??
                                      '',
                                  style: const TextStyle(
                                      color: Color(0xffffffff), fontSize: 17),
                                ),
                                Text(
                                    TimeUtils.timeAgo(
                                        HistoryUtils.extractStartTime(
                                            widget.matchDetail)),
                                    style:
                                        Theme.of(context).textTheme.labelMedium)
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(children: [
                          const Spacer(),
                          roundsWon,
                          const Spacer()
                        ]),
                      ),
                      Expanded(
                        child: Row(children: [
                          const Spacer(),
                          Center(
                            child: IconButton(
                              icon: const Icon(Icons.arrow_drop_down),
                              onPressed: () => setState(() {
                                opened = !opened;
                              }),
                            ),
                          )
                        ]),
                      ),
                      // Stack widget with gradient color
                    ],
                  ),
                ],
              ),
            ),
            ExpandedHistory(
              matchDetail: widget.matchDetail,
              opened: opened,
              puuid: userProvider.user.puuid,
            )
          ]));
    });
  }
}
