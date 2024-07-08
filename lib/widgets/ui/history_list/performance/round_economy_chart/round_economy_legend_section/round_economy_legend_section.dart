import 'package:flutter/material.dart';
import 'package:valoralysis/consts/theme.dart';
import 'package:valoralysis/utils/economy_utils.dart';
import 'package:valoralysis/widgets/ui/history_list/performance/round_economy_chart/round_economy_chart.dart';

class SelectableContainer extends StatelessWidget {
  final bool isSelected;
  final Widget child;
  final VoidCallback onTap;

  const SelectableContainer({
    Key? key,
    required this.isSelected,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: child,
        ),
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
              SelectableContainer(
                isSelected: selectionState['totalCredits'] ?? false,
                onTap: () => setSelected(
                    'totalCredits', !(selectionState['totalCredits'] ?? false)),
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
              SelectableContainer(
                isSelected: selectionState['loadoutValue'] ?? false,
                onTap: () => setSelected(
                    'loadoutValue', !(selectionState['loadoutValue'] ?? false)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: ShapeDecoration(
                        shape: const CircleBorder(),
                        color: baseColor.withOpacity(0.5),
                      ),
                    ),
                    const Text('Loadout Value', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              SelectableContainer(
                isSelected: selectionState['spentCredits'] ?? false,
                onTap: () => setSelected(
                    'spentCredits', !(selectionState['spentCredits'] ?? false)),
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
            ],
          ),
        ),
      ),
      SizedBox(
        height: 55,
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
                  mainAxisAlignment: MainAxisAlignment.end,
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
      ),
      const SizedBox(height: 10),
    ]);
  }
}
