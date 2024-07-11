import 'package:flutter/material.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/widgets/ui/history_list/performance/round_economy_chart/round_economy_chart.dart';
import 'package:valoralysis/widgets/ui/history_list/performance/round_economy_chart/round_economy_legend_section/round_economy_legend_section.dart';

class RoundEconomySection extends StatefulWidget {
  final MatchDto matchDetail;
  final String puuid;
  final int roundIndex;

  const RoundEconomySection({
    Key? key,
    required this.matchDetail,
    required this.puuid,
    required this.roundIndex,
  }) : super(key: key);

  @override
  _RoundEconomySectionState createState() => _RoundEconomySectionState();
}

class _RoundEconomySectionState extends State<RoundEconomySection> {
  Map<String, bool> selectionState = {
    'totalCredits': false,
    'loadoutValue': false,
    'spentCredits': false,
  };

  void setSelected(String key, bool value) {
    setState(() {
      selectionState[key] = value;
    });
    // sad
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RoundEconomyChart(
        matchDetail: widget.matchDetail,
        puuid: widget.puuid,
        roundIndex: widget.roundIndex,
        type: RoundEconomyChartType.player,
      ),
      RoundEconomyChart(
        matchDetail: widget.matchDetail,
        puuid: widget.puuid,
        roundIndex: widget.roundIndex,
        type: RoundEconomyChartType.team,
      ),
      RoundEconomyChart(
        matchDetail: widget.matchDetail,
        puuid: widget.puuid,
        roundIndex: widget.roundIndex,
        type: RoundEconomyChartType.enemy,
      ),
      RoundEconomyLegendSection(
        selectionState: selectionState,
        setSelected: setSelected,
      ),
    ]);
  }
}
