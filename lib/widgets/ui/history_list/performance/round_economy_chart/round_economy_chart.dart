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
  final Map<String, bool> selectionState;

  const RoundEconomyChart({
    Key? key,
    required this.matchDetail,
    required this.puuid,
    required this.roundIndex,
    required this.type,
    required this.selectionState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Colors.red;
    String labelText = '';
    int spentMoney = 0;
    int loadoutValue = 0;
    int totalMoney = 0;
    Widget endIcon;
    switch (type) {
      case RoundEconomyChartType.player:
        color = Theme.of(context).colorScheme.primary;
        labelText = 'You';
        spentMoney =
            EconomyUtils.getUserSpentMoney(matchDetail, puuid, roundIndex);
        loadoutValue =
            EconomyUtils.getUserLoadoutValue(matchDetail, puuid, roundIndex);
        totalMoney =
            EconomyUtils.getUserRemainingMoney(matchDetail, puuid, roundIndex) +
                spentMoney;
        endIcon =
            EconomyUtils.getBuyIconFromRound(matchDetail, puuid, roundIndex);
        break;
      case RoundEconomyChartType.team:
        color = ThemeColors().green.withOpacity(0.5);
        labelText = 'Team';
        spentMoney =
            EconomyUtils.getTeamSpentMoney(matchDetail, puuid, roundIndex);
        loadoutValue =
            EconomyUtils.getTeamLoadoutValue(matchDetail, puuid, roundIndex);
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
        loadoutValue =
            EconomyUtils.getEnemyLoadoutValue(matchDetail, puuid, roundIndex);
        totalMoney = EconomyUtils.getEnemyRemainingMoney(
                matchDetail, puuid, roundIndex) +
            spentMoney;
        endIcon = EconomyUtils.getBuyIconFromType(
            EconomyUtils.getEnemyBuyTypeFromRound(
                matchDetail, puuid, roundIndex));
        break;
    }

    // Calculate bar values based on selection state
    List<double> values = [];
    List<Color> colors = [];
    String comparisonText = '';

    if (selectionState['totalCredits'] == true) {
      values.add(totalMoney.toDouble());
      colors.add(color.withOpacity(0.1));
      comparisonText = 'Total';
    }
    if (selectionState['loadoutValue'] == true) {
      values.add(loadoutValue.toDouble());
      colors.add(color.withOpacity(0.5));
      comparisonText =
          comparisonText.isEmpty ? 'Loadout' : '$comparisonText vs Loadout';
    }
    if (selectionState['spentCredits'] == true) {
      values.add(spentMoney.toDouble());
      colors.add(color);
      comparisonText =
          comparisonText.isEmpty ? 'Spent' : '$comparisonText vs Spent';
    }

    // If none are selected, show all
    if (values.isEmpty) {
      values = [
        totalMoney.toDouble(),
        loadoutValue.toDouble(),
        spentMoney.toDouble()
      ];
      colors = [color.withOpacity(0.1), color.withOpacity(0.5), color];
      comparisonText = 'Total vs Loadout vs Spent';
    }

    double bar1Value = values[0];
    double bar2Value = values.length > 1 ? values[1] : 0;
    double bar3Value = values.length > 2 ? values[2] : 0;

    Color bar1Color = colors[0];
    Color bar2Color = colors.length > 1 ? colors[1] : color.withOpacity(0.1);
    Color bar3Color = colors.length > 2 ? colors[2] : color.withOpacity(0.1);

    if (bar2Value > bar1Value) {
      double tempValue = bar1Value;
      Color tempColor = bar1Color;
      bar1Value = bar2Value;
      bar1Color = bar2Color;
      bar2Value = tempValue;
      bar2Color = tempColor;
    }

    double maxValue = bar1Value;

    String topText = '$spentMoney/${maxValue.toInt()}';
    if (loadoutValue > totalMoney && roundIndex != 0 && roundIndex != 12) {
      topText = 'Bonus, $topText';
    }

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: 50,
      ),
      child: RotatedBox(
        quarterTurns: 1,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxValue,
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
                  topText,
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
                    toY: bar1Value,
                    color: bar1Color,
                    rodStackItems: [
                      if (bar2Value > 0)
                        BarChartRodStackItem(0, bar2Value, bar2Color),
                      if (bar3Value > 0)
                        BarChartRodStackItem(0, bar3Value, bar3Color),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
