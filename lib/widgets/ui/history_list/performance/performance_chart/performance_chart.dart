import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/utils/round_utils.dart';

class PerformanceChart extends StatefulWidget {
  final String puuid;
  final MatchDto matchDetail;
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
    List<RoundResultDto> roundResults =
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
            child: Stack(children: [
              Container(
                  width: 45,
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: widget.selectedRound == index
                        ? LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              HistoryUtils.didPlayerWinRound(
                                      widget.matchDetail, widget.puuid, index)
                                  ? Colors.green[300]!
                                  : Colors.red[300]!,
                              Theme.of(context).canvasColor,
                              Theme.of(context).canvasColor,
                            ],
                          )
                        : null,
                    border: widget.selectedRound == index
                        ? Border.all(
                            color: HistoryUtils.didPlayerWinRound(
                                    widget.matchDetail, widget.puuid, index)
                                ? Colors.green
                                : Colors.red,
                            width: 2,
                          )
                        : null,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: Theme.of(context).canvasColor,
                  ),
                  child: PerformanceChartSection(
                    playerKillAndDeaths: barGroups[index],
                    roundNumber: index + 1,
                    resultImage: RoundUtils.resultToImageMap(
                      HistoryUtils.didPlayerWinRound(
                          widget.matchDetail, widget.puuid, index),
                      roundResults[index].roundResult,
                      context,
                    ),
                  )),
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      widget.onSelectedRoundChanged(index);
                    }); // Ensure the state is updated
                  },
                  child: const SizedBox(
                    width: 45,
                    height: 150,
                  )),
            ]),
          ),
        )));
  }
}

class PerformanceChartSection extends StatelessWidget {
  final BarChartGroupData playerKillAndDeaths;
  final int roundNumber;
  final Widget resultImage;

  const PerformanceChartSection({
    super.key,
    required this.playerKillAndDeaths,
    required this.roundNumber,
    required this.resultImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
            top: 10, bottom: 10), // Ensure this padding is appropriate
        child: BarChart(
          BarChartData(
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
                      }))),
        ));
  }
}
