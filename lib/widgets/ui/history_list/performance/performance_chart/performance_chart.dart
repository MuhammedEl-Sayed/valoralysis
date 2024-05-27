import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:valoralysis/models/player_round_stats.dart';
import 'package:valoralysis/utils/history_utils.dart';

class PerformanceChart extends StatefulWidget {
  final String puuid;
  final Map<String, dynamic> matchDetail;

  const PerformanceChart(
      {Key? key, required this.puuid, required this.matchDetail})
      : super(key: key);

  @override
  _PerformanceChartState createState() => _PerformanceChartState();
}

class _PerformanceChartState extends State<PerformanceChart> {
  @override
  Widget build(BuildContext context) {
    Map<int, List<KillDto>> playerKillsPerRound =
        HistoryUtils.extractPlayerKills(widget.matchDetail, widget.puuid);
    Map<int, List<KillDto>> playerDeathsPerRound =
        HistoryUtils.extractRoundDeathsByPUUID(
            widget.matchDetail, widget.puuid);
    Map<int, List<DamageDto>> playerDamagePerRound =
        HistoryUtils.extractPlayerDamage(widget.matchDetail, widget.puuid);

    int numRounds = HistoryUtils.getNumberOfRounds(widget.matchDetail);

    List<BarChartGroupData> barGroups = [];

    for (int round in playerKillsPerRound.keys) {
      int kills = playerKillsPerRound[round]?.length ?? 0;
      int deaths = playerDeathsPerRound[round]?.length ?? 0;

      barGroups.add(BarChartGroupData(x: round, barRods: [
        BarChartRodData(
          toY: kills.toDouble(),
          color: Colors.green,
        ),
        BarChartRodData(
          toY: deaths.toDouble(),
          color: Colors.red,
        ),
      ]));
    }
    print(barGroups);
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
            width: numRounds * 40.0,
            height: 250.0,
            child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: BarChart(BarChartData(
                  maxY: 5,
                  barGroups: barGroups,
                  titlesData: const FlTitlesData(
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                )))));
  }
}
