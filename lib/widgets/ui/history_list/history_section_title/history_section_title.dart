import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/consts/margins.dart';
import 'package:valoralysis/models/item.dart';
import 'package:valoralysis/providers/mode_provider.dart';
import 'package:valoralysis/widgets/ui/mode_dropdown/mode_dropdown.dart';

class HistorySectionTitle extends StatelessWidget {
  final int numOfMatches;
  final String dateTitle;
  final bool hasDropdown;
  final Item selectedMode;
  final Function(Item) onModeSelected;
  const HistorySectionTitle(
      {Key? key,
      required this.numOfMatches,
      required this.dateTitle,
      required this.hasDropdown,
      required this.selectedMode,
      required this.onModeSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double margin = getStandardMargins(context);
    ModeProvider modeProvider =
        Provider.of<ModeProvider>(context, listen: true);
    return Padding(
        padding:
            EdgeInsets.only(left: margin, right: margin, bottom: margin / 2),
        child: Row(
          children: [
            Text(
              dateTitle,
              style: const TextStyle(fontSize: 17),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 20, minHeight: 16),
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.all(Radius.circular(2))),
              child: Center(
                  child: Text(
                numOfMatches.toString(),
                style: const TextStyle(fontSize: 15),
              )),
            ),
            const Spacer(),
            hasDropdown
                ? ModeDropdown(
                    key: UniqueKey(),
                    selectedMode: selectedMode,
                    onModeSelected: onModeSelected,
                    modes: modeProvider.modes,
                  )
                : const SizedBox.shrink()
          ],
        ));
  }
}
