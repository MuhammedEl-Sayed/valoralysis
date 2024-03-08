import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/models/item.dart';
import 'package:valoralysis/providers/mode_provider.dart';

class ModeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ModeProvider modeProvider = Provider.of<ModeProvider>(context);
    List<Item> modes = modeProvider.modes;

    BorderRadius getBorderRadius(int index) {
      if (index == 0) {
        return const BorderRadius.only(
            topLeft: Radius.circular(4), bottomLeft: Radius.circular(4));
      }
      if (index == modes.length - 1) {
        return const BorderRadius.only(
            topRight: Radius.circular(4), bottomRight: Radius.circular(4));
      }
      return const BorderRadius.all(Radius.circular(2));
    }

    return Consumer<ModeProvider>(
      builder: (context, modeSelector, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: modes.asMap().entries.map<Widget>((entry) {
            final mode = entry.value;
            final index = entry.key;

            final isSelected = modeProvider.selectedMode == mode.realValue;
            return GestureDetector(
              onTap: () => modeProvider.selectMode(mode.realValue),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Row(children: [
                    SizedBox(
                      height: 40,
                      width: 120,
                      child: Container(
                        decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onSecondary
                                : Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: getBorderRadius(index)),
                        child: Center(
                            child: Text(
                          mode.displayValue,
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.background
                                : Theme.of(context).colorScheme.onPrimary,
                          ),
                        )),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 3))
                  ]);
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
