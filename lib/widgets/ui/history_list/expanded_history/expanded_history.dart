import 'dart:async';

import 'package:flutter/material.dart';
import 'package:valoralysis/consts/margins.dart';
import 'package:valoralysis/models/item.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/utils/agent_utils.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/widgets/ui/agent_carousel_selector/agent_carousel_selector.dart';
import 'package:valoralysis/widgets/ui/category_selector/category_selector.dart';
import 'package:valoralysis/widgets/ui/expandable_section/expandable_section.dart';
import 'package:valoralysis/widgets/ui/history_list/performance/performance_chart/performance_chart.dart';
import 'package:valoralysis/widgets/ui/history_list/performance/round_kill_feed/round_kill_feed.dart';
import 'package:valoralysis/widgets/ui/history_list/round_history/round_history.dart';
import 'package:valoralysis/widgets/ui/team_details_table/team_details_table.dart';

class ExpandedHistory extends StatefulWidget {
  final bool opened;
  final MatchDto matchDetail;
  final String puuid;

  const ExpandedHistory({
    Key? key,
    required this.matchDetail,
    required this.opened,
    required this.puuid,
  }) : super(key: key);

  @override
  State<ExpandedHistory> createState() => _ExpandedHistoryState();
}

class _ExpandedHistoryState extends State<ExpandedHistory> {
  bool visible = false;
  late Item selectedCategory;
  int selectedRound = 0;
  String selectedPUUID = '';

  @override
  void initState() {
    super.initState();
    selectedCategory = Item('Overview', 'overview');
    selectedPUUID = widget.puuid;
  }

  @override
  void didUpdateWidget(covariant ExpandedHistory oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.opened != oldWidget.opened) {
      if (widget.opened) {
        setState(() {
          visible = true;
        });
      } else {
        Timer(const Duration(milliseconds: 400), () {
          if (mounted) {
            setState(() {
              visible = false;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double margin = getStandardMargins(context);
    Map<String, String> playerTeamPUUIDToAgentUUID =
        Map<String, String>.fromEntries(
      HistoryUtils.extractPlayerTeamPUUIDs(widget.matchDetail, widget.puuid)
          .map(
            (puuid) => MapEntry(
              puuid,
              AgentUtils.extractAgentIdByPUUID(widget.matchDetail, puuid),
            ),
          )
          .toList()
        ..add(MapEntry(
            widget.puuid,
            AgentUtils.extractAgentIdByPUUID(
                widget.matchDetail, widget.puuid))),
    );

    Map<String, String> enemyTeamPUUIDToAgentUUID =
        Map<String, String>.fromEntries(
      HistoryUtils.extractEnemyTeamPUUIDs(widget.matchDetail, widget.puuid).map(
        (puuid) => MapEntry(
          puuid,
          AgentUtils.extractAgentIdByPUUID(widget.matchDetail, puuid),
        ),
      ),
    );
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
                      CategoryTypeSelector(
                        onSelectCategory: (Item selectedItem) {
                          setState(() {
                            selectedCategory = selectedItem;
                          });
                        },
                        selectedCategory: selectedCategory.realValue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
                visible: visible,
                maintainState: false,
                child: Column(
                  children: [
                    Visibility(
                        visible: visible,
                        child: selectedCategory.realValue != 'overview'
                            ? AgentCarouselSelector(
                                playerTeamPUUIDToAgentUUID:
                                    playerTeamPUUIDToAgentUUID,
                                enemyTeamPUUIDToAgentUUID:
                                    enemyTeamPUUIDToAgentUUID,
                                onPUUIDSelected: (String puuid) {
                                  setState(() {
                                    selectedPUUID = puuid;
                                  });
                                },
                                puuid: selectedPUUID,
                              )
                            : const SizedBox()),
                    RoundHistory(
                        puuid: widget.puuid, matchDetail: widget.matchDetail),
                  ],
                )),
            Visibility(
                visible: visible,
                maintainState: false,
                child: selectedCategory.realValue == 'overview'
                    ? Column(
                        children: [
                          TeamDetailsTable(
                              puuid: widget.puuid,
                              matchDetail: widget.matchDetail,
                              isUserTeam: true),
                          TeamDetailsTable(
                              puuid: widget.puuid,
                              matchDetail: widget.matchDetail,
                              isUserTeam: false),
                        ],
                      )
                    : Column(children: [
                        PerformanceChart(
                            puuid: selectedPUUID,
                            matchDetail: widget.matchDetail,
                            selectedRound: selectedRound,
                            onSelectedRoundChanged: (int round) {
                              setState(() {
                                selectedRound = round;
                              });
                            }), //
                        RoundKillFeed(
                            puuid: selectedPUUID,
                            kills: HistoryUtils.extractPlayerKills(
                                widget.matchDetail,
                                selectedPUUID)[selectedRound] as List<KillDto>,
                            deaths: HistoryUtils.extractRoundDeathsByPUUID(
                                widget.matchDetail,
                                selectedPUUID)[selectedRound] as List<KillDto>,
                            roundNumber: selectedRound,
                            matchDetail: widget.matchDetail)
                      ])),
          ],
        ),
      ),
    );
  }
}
