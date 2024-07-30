import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:valoralysis/consts/theme.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/utils/economy_utils.dart';

enum RoundEconomyChartType { player, team, enemy }

class RoundEconomyChart extends StatelessWidget {
  final MatchDto matchDetail;
  final String puuid;
  final int roundIndex;
  final RoundEconomyChartType type;

  const RoundEconomyChart({
    Key? key,
    required this.matchDetail,
    required this.puuid,
    required this.roundIndex,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Colors.red;
    String labelText = '';
    int spentMoney = 0;
    int totalMoney = 0;
    Widget endIcon;
    bool drawDivider = false;
    switch (type) {
      case RoundEconomyChartType.player:
        color = Theme.of(context).colorScheme.primary;
        labelText = 'You';
        spentMoney =
            EconomyUtils.getUserSpentMoney(matchDetail, puuid, roundIndex);

        totalMoney =
            EconomyUtils.getUserRemainingMoney(matchDetail, puuid, roundIndex) +
                spentMoney;
        endIcon =
            EconomyUtils.getBuyIconFromRound(matchDetail, puuid, roundIndex);
        drawDivider = true;
        break;
      case RoundEconomyChartType.team:
        color = ThemeColors().green.withOpacity(0.5);
        labelText = 'Team';
        spentMoney =
            EconomyUtils.getTeamSpentMoney(matchDetail, puuid, roundIndex);

        totalMoney =
            EconomyUtils.getTeamRemainingMoney(matchDetail, puuid, roundIndex) +
                spentMoney;
        endIcon = EconomyUtils.getBuyIconFromType(
            EconomyUtils.getTeamBuyTypeFromRound(
                matchDetail, puuid, roundIndex));
        break;
      case RoundEconomyChartType.enemy:
        color = ThemeColors().red.withOpacity(0.5);
        labelText = 'Enemy';
        spentMoney =
            EconomyUtils.getEnemySpentMoney(matchDetail, puuid, roundIndex);

        totalMoney = EconomyUtils.getEnemyRemainingMoney(
                matchDetail, puuid, roundIndex) +
            spentMoney;
        endIcon = EconomyUtils.getBuyIconFromType(
            EconomyUtils.getEnemyBuyTypeFromRound(
                matchDetail, puuid, roundIndex));
        break;
    }

    return Column(children: [
      Container(
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: 50,
        ),
        child: RotatedBox(
          quarterTurns: 1,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: totalMoney.toDouble(),
              minY: 0,
              groupsSpace: 10,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 55,
                    getTitlesWidget: (value, meta) {
                      return RotatedBox(
                        quarterTurns: -1,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Text(
                              labelText,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    showTitles: true,
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text(
                    '${spentMoney.toString()}/${totalMoney.toString()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  sideTitles: const SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: endIcon,
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: totalMoney.toDouble(),
                      color: color.withOpacity(0.3),
                      rodStackItems: [
                        BarChartRodStackItem(0, spentMoney.toDouble(), color),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      drawDivider
          ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Divider(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1,
              ))
          : Container(),
    ]);
  }
}
