import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:valoralysis/models/player_round_stats.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/utils/round_utils.dart';

class PerformanceChart extends StatefulWidget {
  final String puuid;
  final Map<String, dynamic> matchDetail;
  final int selectedRound;
  final Function(int) onSelectedRoundChanged;

  const PerformanceChart(
      {Key? key,
      required this.puuid,
      required this.matchDetail,
      required this.selectedRound,
      required this.onSelectedRoundChanged})
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
    List<Map<String, dynamic>> roundResults =
        HistoryUtils.getRoundResults(widget.matchDetail);

    int numRounds = HistoryUtils.getNumberOfRounds(widget.matchDetail);

    List<BarChartGroupData> barGroups = [];

    for (int round in playerKillsPerRound.keys) {
      int kills = playerKillsPerRound[round]?.length ?? 0;
      int deaths = playerDeathsPerRound[round]?.length ?? 0;

      barGroups.add(
        BarChartGroupData(
          x: round,
          barRods: [
            BarChartRodData(
              toY: kills.toDouble(),
              color: Colors.green,
              width: 8,
            ),
            BarChartRodData(
              toY: deaths.toDouble(),
              color: Colors.red,
              width: 8,
            ),
          ],
          barsSpace: 10,
          showingTooltipIndicators: [0, 1],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          numRounds,
          (index) => Padding(
            padding: EdgeInsets.only(
                left: index == 0
                    ? 10
                    : index == numRounds - 1
                        ? 0
                        : 10,
                right: index >= numRounds - 2 ? 10 : 0),
            child: Container(
                width: 45,
                height: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: PerformanceChartSection(
                    onSelectedRoundChanged: () {
                      // Delay state change
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.onSelectedRoundChanged(index);
                      });
                    },
                    playerKillAndDeaths: barGroups[index],
                    roundNumber: index + 1,
                    resultImage: RoundUtils.resultToImageMap(
                      HistoryUtils.didPlayerWinRound(
                          widget.matchDetail, widget.puuid, index),
                      roundResults[index]['roundResult'],
                      context,
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

class PerformanceChartSection extends StatelessWidget {
  final BarChartGroupData playerKillAndDeaths;
  final int roundNumber;
  final Widget resultImage;
  final void Function() onSelectedRoundChanged;

  const PerformanceChartSection({
    super.key,
    required this.playerKillAndDeaths,
    required this.roundNumber,
    required this.resultImage,
    required this.onSelectedRoundChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onSelectedRoundChanged,
        child: BarChart(BarChartData(
            maxY: 5,
            barGroups: [playerKillAndDeaths],
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                axisNameWidget: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(roundNumber.toString())),
                axisNameSize: 20,
              ),
              topTitles: AxisTitles(axisNameWidget: resultImage),
              leftTitles: AxisTitles(axisNameWidget: Container()),
              rightTitles: AxisTitles(axisNameWidget: Container()),
            ),
            barTouchData: BarTouchData(
                touchCallback: (fl, barTouchResponse) {
                  onSelectedRoundChanged();
                },
                touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(0),
                    tooltipMargin: 0,
                    getTooltipColor: (group) => Colors.transparent,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return rod.toY.toInt() > 0
                          ? BarTooltipItem(
                              rod.toY.toInt().toString(),
                              const TextStyle(
                                color: Colors.white,
                              ))
                          : BarTooltipItem(
                              '',
                              const TextStyle(
                                color: Colors.white,
                              ));
                    })))));
  }
}
