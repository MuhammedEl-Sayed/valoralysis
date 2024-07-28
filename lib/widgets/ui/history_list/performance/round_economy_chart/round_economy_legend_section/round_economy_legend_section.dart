import 'package:flutter/material.dart';
import 'package:valoralysis/consts/theme.dart';
import 'package:valoralysis/utils/economy_utils.dart';
import 'package:valoralysis/widgets/ui/history_list/performance/round_economy_chart/round_economy_chart.dart';

class LegendContainer extends StatelessWidget {
  final Widget child;
  const LegendContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Theme.of(context).colorScheme.surfaceVariant,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.4),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: child,
      ),
    );
  }
}

class RoundEconomyLegendSection extends StatelessWidget {
  final Map<String, bool> selectionState;
  final Function(String, bool) setSelected;

  const RoundEconomyLegendSection({
    Key? key,
    required this.selectionState,
    required this.setSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color baseColor;
    RoundEconomyChartType type = RoundEconomyChartType.player;
    switch (type) {
      case RoundEconomyChartType.player:
        baseColor = Theme.of(context).colorScheme.primary;
        break;
      case RoundEconomyChartType.team:
        baseColor = ThemeColors().green;
        break;
      case RoundEconomyChartType.enemy:
        baseColor = ThemeColors().red;
        break;
      default:
        baseColor = Colors.grey; // Fallback color
    }

    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(2),
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LegendContainer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: ShapeDecoration(
                        shape: const CircleBorder(),
                        color: baseColor,
                      ),
                    ),
                    const Text('Spent Credits', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              LegendContainer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: ShapeDecoration(
                        shape: const CircleBorder(),
                        color: baseColor.withOpacity(0.1),
                      ),
                    ),
                    const Text('Total Credits', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.surfaceVariant,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.4),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: BuyType.values.map((type) {
                if (type == BuyType.unknown) return const SizedBox.shrink();
                return Padding(
                    padding: const EdgeInsets.only(
                      right: 5,
                      left: 5,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30, // Set a fixed height for the icons
                          child: EconomyUtils.getBuyIconFromType(type),
                        ),
                        Text(
                          buyTypeToStringMap[type]!,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ));
              }).toList(),
            ),
          )),
      const SizedBox(height: 10),
    ]);
  }
}
